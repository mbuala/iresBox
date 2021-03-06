 		#!/usr/bin/env 
		. ./DataBaseParameters.sh --source-only
		. ./envoifichierftp.sh --source-only
		function main(){
		#DATABASE PARAMETRES
		DATABASE="iresbox"
        USERNAME="adminslk"
        HOsTNAME="vps-e9aee6f1.vps.ovh.net"
        PORT="5432"
		export PGPASSWORD=pg_db_password


		#DOSSIERS 
		dirIn="IN";
		dirWork="WORK";
		dirErreur="ERREURS"
		dirErreur1="ERREURS/ERREUR1";
		dirErreur2="ERREURS/ERREUR2";
		dirErreur3="ERREURS/ERREUR3";
		dirErreur4="ERREURS/ERREUR4";
		dirErreur5="ERREURS/ERREUR5";
		dirArchives="ARCHIVES";
		dirConserves="CONSERVES";
		dirRunning="RUNNING"
		dirXml="DOCXML";
		dirLogs="LOGS";
		dirCalques="CALQUES";###########
		dirEnvoie="ENVOIS";	
		dirFait="FAIT";
		dirEnAttente="ENATTENTE"
		dateFIle="$(date +%Y%m%d)";
		day=$(date +%d);
		month=$(date +%m);
		year=$(date +%Y);

		#récupération des parametres dans la base de donnée
		calqueEntete=$(selectData "SELECT path FROM entetepage;");
		calquePiedPage=$(selectData  "SELECT path FROM piedpage;");
		calqueSignature=$(selectData  "SELECT path FROM signature;");

		dateProg="$(date +%d-%m-%Y' '%H:%M:%S)";
		dateRep="$(date +%d_%m_%Y)";
		nomFileLog="LOG_"$nomSource"_"$(date +%d_%m_%Y);
		pile=10; #Nombre de fichiers a traiter par passage
		dateInsrt="$(date +%Y-%m-%d)";	

		#Fichiers PDF
		nbFileIn=`find $dirIn -type f -iname "*.pdf" | wc -l`;
		nbFileWork=`find $dirWork -type f -iname "*.pdf" | wc -l`;


		#Argument pour verifier si calque inserer
		verifInsertCalque=false;
		verifInsertSIgnature=false
		verifInsertPiedPage=false
		verifRepertoire=false
		#Generation fichier log
		creatLogFile;
		generateentetexml;
		generateOtherFolder;
		#runningZip
		nbPage=""
		nomPatient="";
		adressePatient="":
		sexe="";
		dateDeNaissance="";
		emailPatient="";
		emailMedecin="";
		medecin="";
		bioValideur="";
			
		if 	[ $nbFileWork != 0 ]; then 
		echo ""
		elif [ $nbFileIn != 0 ]; then

			traitementPdf;	
			
		else
			runningZip;
		fi;


		function traitementPdf(){
		    #Recuperation des fichiers pdf
		    echo "traitementPdf"
		    if [ $nbFileIn != 0 ]; then

		    	fichiers=`ls $dirIn/*.pdf | head -n$pile`;
		    	for file in $fichiers; do
		    		mv $file $dirWork;
		    	done;
		    	filesWork=`ls $dirWork/*.pdf`;
		    	nbFileIn=`find $dirIn -type f -iname "*.pdf" | wc -l`;
		    	for file in $filesWork; do
		    		extractionData ;  
		    	done;
		    	if [ $nbFileIn != 0 ]; then
		    		traitementPdf;
		    	fi;	
		    else
		    	statutApp="Répertoire IN vide";
		    	verifRepertoire=true;
		    	echo $statutApp;
		    	echo $dateProg": "$statutApp >> $dirLogs/$year/$month/$dateRep/$nomFileLog.txt;
		    	
		    	#sleep 10s exit;
		    fi;

		}

		function extractionData(){
			echo "extractionData"
			nameFile=$(basename $file .${file##*.});
			

			#Conversion pdftotext		
			pdftotext $dirWork/$nameFile.pdf

			#-e $nomfichier Vérifie si le fichier existe.
			#-n $chaine Vérifie si la chaîne est non vide.
			if [ -e $dirWork/$nameFile.txt ]; then
				#extraire les données
				numeroDossier=$(grep -E -m 1 "^Dossier N°" $dirWork/$nameFile.txt | awk {'print $3'});
				nbPage=$(pdfinfo  $dirWork/$nameFile.pdf | grep Pages | awk '{print $2}');	
				#PATIENT
				nomPatient=$(grep -E -m 1 "^Mme|^Mr|^Mlle|^-Mme|^-Mlle|^-Mr" $dirWork/$nameFile.txt | awk {'print  $2" "$3 '});
				nom=$(grep -E -m 1 "^Mme|^Mr|^Mlle|^-Mme|^-Mlle|^-Mr" $dirWork/$nameFile.txt | awk {'print  $2 '});
				prenom=$(grep -E -m 1 "^Mme|^Mr|^Mlle|^-Mme|^-Mlle|^-Mr" $dirWork/$nameFile.txt | awk {'print  $3 '});
				sexe=$(grep -E -m 1 "^Sexe" $dirWork/$nameFile.txt | awk {'print $2'});
				dateDeNaissance=$(grep -E -m 1 "né\(e\) le" $dirWork/$nameFile.txt | awk {'print  $4'});
				adressePatient="marrakech" 	
				emailPatient="test@test.com" 

				#MEDECIN
				emailMedecin="medecin@test.com"
				medecin="medecin" 
				nommedecin="ahmed";
				prenommedecin="boutouli"
				bioValideur="alfonso "
				datecreation="$dateFIle";		
				dateedition="$dateFIle"	
				

				if [ -n "$numeroDossier" ] && [ -n "$nomPatient" ]; then  #Si les champs importants sont renseignés

				if [ -n "$calqueEntete" ] && [ -e $dirWork/$nameFile.pdf ];then
					verifInsertCalque=true
					ajoutCalque "$calqueEntete";
				fi;

				if [ -n "$calquePiedPage" ] && [ -e $dirWork/$nameFile.pdf ];then
					verifInsertPiedPage=true
					ajoutCalque "$calquePiedPage";					

				fi;

				if [ -n "$calqueSignature" ] && [ -e $dirWork/$nameFile.pdf ];then
					verifInsertSIgnature=true
					ajoutCalque "$calqueSignature";					

				fi;

				if [ -e $dirWork/$nameFile.pdf ];then

					if [ -n "$calqueEntete" ] || [ -n "$calqueSignature" ] || [ -n "$calquePiedPage" ]; then
						controlDir "$dirConserves";
						mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirConserves/$year/$month/$dateRep
						insertionData  "
						INSERT INTO compterendubox(
						path,dateedition,biologistevalidateur,nbrpage,disponible,piedpage,signature,entetepage,certificat,patient,
						numerodossier,sexe,adresse,medecin,nom,prenom,email,datenaissance,prenommedecin,emailmedecin,datecreation,etat)
						VALUES
						('$dirArchives/$year/$month/$dateRep/$nameFile.pdf','$dateInsrt','$bioValideur','$nbPage',true,$verifInsertPiedPage,$verifInsertSIgnature,$verifInsertCalque,false,'$nomPatient',
						'$numeroDossier','$sexe','$adressePatient','$medecin','$nom','$prenom','$emailPatient','$dateInsrt','$medecin','$medecin','$dateInsrt','traité');"
						convertDataToXml
						
					else
						controlDir "$dirArchives";
						controlDir "$dirConserves";
						cp $dirWork/$nameFile.pdf $dirArchives/$year/$month/$dateRep;	
						mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt  $dirConserves/$year/$month/$dateRep;	
						insertionData  "INSERT INTO compterendubox(
						path,dateedition,biologistevalidateur,nbrpage,disponible,piedpage,signature,entetepage,certificat,patient,
						numerodossier,sexe,adresse,medecin,nom,prenom,email,datenaissance,prenommedecin,emailmedecin,datecreation,etat)
						VALUES
						('$dirArchives/$dateRep/$year/$month/$nameFile.pdf','$dateInsrt','$bioValideur','$nbPage',false,false,false,false,false,'$nomPatient',
						'$numeroDossier','$sexe','$adressePatient','$medecin','$nom','$prenom','$emailPatient','$dateInsrt','$medecin','$medecin','$dateInsrt','traité');"
						convertDataToXml	
					fi;				 

				fi;
			else 
					#ERREUR2
					#Deplacement des fichiers dans le dossier Erreur2 qui n'ont pas le numero dossier et nomPatient
					controleDir $dirErreur2;
					mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirErreur2/$year/$month/$dateRep;
					#ecriture dans le fichier log du jour
					statut=$nameFile.pdf"-> Erreur les champs importants ne sont renseignés numeroDossier et nomPatient";
					echo $dateProg": "$statut >> $dirLogs/$year/$month$dateRep/$nomFileLog.txt		

					#Ruperation du type d'erreur et insertion erreur
					Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR2';")		
					if [ -n "$Typerreur" ]; then
						insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
						echo "Erreur les champs importants ne sont renseignés numeroDossier et nomPatient"
					fi;			
				fi;
			else
				#ERREUR1
				#Deplacement des fichiers dans le dossier Erreur de Conversion pdftotext	
				echo "Erreur fichier non compatible"
				controlDir "$dirErreur1";
				mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirErreur1/$year/$month/$dateRep;

				#ecriture dans le fichier log du jour
				statut=$nameFile.pdf"-> Erreur fichier non compatible Erreur de Conversion pdftotext";
				echo $dateProg": "$statut >> $dirLogs/$year/$month/$dateRep/$nomFileLog.txt

				#Recuperation du type d'erreur et insertion erreur
				Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR1';")		
				if [ -n "$Typerreur" ]; then
					insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
					
				fi;	
			fi;
		}
		#function des selections des données dans la base de donnée
		
		function insertionData(){
			#rqt sql
			arg1=$1
			rq_insert=$(psql -t -U $USERNAME -d $DATABASE -c "$arg1")
			if [ "$rq_insert" = "INSERT 0 1" ]; then
				echo "insertion avec succès"
				
			else

				#ERREUR5

				#Deplacement des fichiers dans le dossier Erreur5	
				controlDir "$dirErreur5";
				mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt  $dirArchives/$year/$month/$dateRep/$nameFile.pdf $dirErreur5;

				#ecriture dans le fichier log du jour
				statut=$nameFile.pdf"-> Erreur insertion données";
				echo $dateProg": "$statut >> $dirLogs/$year/$month/$dateRep/$nomFileLog.txt

				#Recuperation du type d'erreur et insertion erreur
				Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR5';")		
				if [ -n "$Typerreur" ]; then
					insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
					echo "Erreur fichier non compatible"
				fi;	
			fi;
		}
		#-n $chaine Vérifie si la chaîne est non vide.
		function ajoutCalque(){		
			#pdftk
			arg1=$1 #$1 represente first argument
			if [ -n "$arg1" ]; then #si calque bien ajouter	
			controlDir "$dirArchives";

			pdftk $dirWork/$nameFile.pdf stamp  $arg1 output $dirArchives/$year/$month/$dateRep/$nameFile.pdf;
			echo "calque bien ajouter"
		else
				#ERREUR3
				controlDir "$dirErreur3";
				statut=$nameFile.pdf"-> Erreur insertion de calques";
				echo $dateProg": "$statut >> $dirLogs/$year/$month/$dateRep/$nomFileLog.txt
				rm $dirWork/$nameFile.pdf $dirWork/$nameFile.txt 
				mv $dirWork/$nameFile.pdf $dirErreur3/$year/$month/$dateRep
				Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR3';")		
				if [ -n "$Typerreur" ]; then
					insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
				fi
			fi;
		}


		function creatLogFile(){
			#Verifier/creation si fichier LOG du jour exist
			
			if [ ! -d $dirLogs ];then
				mkdir $dirLogs;
				
			fi;
			#createDirectory;
			controlDir "$dirLogs";

			if [ ! -e "$dirLogs/$year/$month/$dateRep/$nomFileLog.txt" ];then
				echo "---------- Traitement CRR ----------" >> $dirLogs/$year/$month/$dateRep/$nomFileLog.txt;
			fi;
			
		}
		function controlDir(){
			if [ ! -d $1 ] ; then
				mkdir $1;
			fi
			if [ ! -d "$1/$year" ]; then
				mkdir $1/$year;
			fi;
			if [ ! -d "$1/$year" ]; then
				mkdir $1/$year;
			fi;
			if [ ! -d "$1/$year/$month" ]; then
				mkdir $1/$year/$month;
			fi;
			if [ ! -d $1/$year/$month/$dateRep ];then
				mkdir $1/$year/$month/$dateRep;
			fi;
			
		}
		function generateOtherFolder(){
			if [ ! -d $dirEnvoie ];then
				mkdir $dirEnvoie;	

			fi;
			if [ ! -d $dirIn ];then
				mkdir $dirIn;	

			fi;
			if [ ! -d $dirWork ];then
				mkdir $dirWork;	

			fi;
			if [ ! -d $dirCalques ];then
				mkdir $dirCalques;	

			fi;
			controlDir "$dirEnvoie/$dirFait"
			controlDir "$dirEnvoie/$dirEnAttente"
		}
		
		function runningZip(){

			if [ ! -d "$dateFIle" ]; then
				mkdir $dateFIle;
				
			fi			
			if [ ! -d "$dirRunning" ]; then
				mkdir $dirRunning;
				
			fi

			if [ ! -e "$dirRunning/$dateFIle" ]; then
				echo "run script">>$dirRunning/$dateFIle.txt
			fi

			fileRunningScript="$dirRunning/$dateFIle.txt";
			if [ ! -e "$fileRunningScript" ];then
				sleep 5s; 
				rm $dirRunning/$dateFIle.txt;
				main;
			else 
								
			   	#SI LE FICHIER ZIP EXISTE ET XML ON LE SUPPRIME	
			   	verifvalue="$dirEnvoie/$dirFait/$year/$month/$dateRep/$dateFIle.zip"
			   	if [ -e "$verifvalue" ]; then
			   		verifvalue="$dirXml/$dateFIle.xml" 
			   		if [ -e "$verifvalue" ]; then
			   			rm -rf  $dirXml/$dateFIle.xml
			   			rm -rf  $dateFIle/*.pdf;
			   			rm -rf  $dateFIle/$dateFIle.xml 
			   		else
			   			
			   			exit;
			   		fi
			   	else
			   		#VERIFICATION SIL Y A DES FICHIERS EN ATTENTE OU PAS
					#TODO


						
							controlDir "$dirArchives";
					   		cp $dirXml/$dateFIle.xml $dateFIle
					   		cp $dirArchives/$year/$month/$dateRep/*.pdf $dateFIle;			   		
					   		sleep 3s; 
					   		#GENERATION DE ZIP
					   		zip -r -D $dateFIle.zip $dateFIle/*
					   		
							#envoie ftp
							# si l'envoie se passe bien on deplace les fichiers vers le dossier envoie/fait/...
							#on change le status dans la base de donnée en envoie
							cp $dateFIle.zip "/home/ubuntu/file";
							sendzipinftp;
							sleep 3s
							mv $dateFIle.zip $dirEnvoie/$dirFait/$year/$month/$dateRep
							#INSERTION ET GENERATION DANS LE FICHIER XML
						   	selectData "SELECT idcoompterendu from compterendubox WHERE datecreation='$dateInsrt' AND etat='traité' LIMIT 10"| while read idcompterendu; 
						   	do
								updateData "$idcompterendu"
							
							done;
												
						
						
					fi;		
			fi;
				
			
			traitementPdf;
		}

		generateentetexml(){
			if [ ! -d "$dirXml" ]; then
				mkdir $dirXml;
			fi

			if [ ! -e $dirXml/$dateFIle.xml ];then
				echo "<?xml version="1.0" encoding="utf-8"?>">>$dirXml/$dateFIle.xml
			fi;
		}
		function convertDataToXml(){
			echo "			
			<crr nom="$dateRep" numeroDossier="$numeroDossier"  numPage="$nbPage">
			<patient>
			<NomCompletPatient>$nomPatient</NomCompletPatient>
			<Nom>$nom</Nom>
			<Prenom>$prenom</Prenom>
			<Sexe>$sexe</Sexe>
			<DateNaissance>$dateDeNaissance</DateNaissance>
			<AdressePatient>$adressePatient</AdressePatient>
			<mailPatient>$emailPatient</mailPatient>
			</patient>
			<medecin>
			<NomCompletMedecin>$medecin</NomCompletMedecin>
			<NomMedecin>$nommedecin</NomMedecin>
			<PrenomMedecin>$prenommedecin</PrenomMedecin>
			<EmailMedecin>$emailMedecin</EmailMedecin>
			</medecin>
			<labo>
			<BioValidateur>$bioValideur</BioValidateur>
			<DateEdition>$datecreation</DateEdition>		
			</labo>
			</crr>">>$dirXml/$dateFIle.xml

		}
		main;

	}

	main;