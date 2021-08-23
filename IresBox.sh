		#!/usr/bin/env bash


		function main(){
		#DATABASE PARAMETRES
		DATABASE="iresbox"
		USERNAME="mbuala"
		HOsTNAME="localhost"
		PORT="5432"
		export PGPASSWORD=pg_db_password


		#DOSSIERS 
		dirIn="IN";
		dirWork="WORK";
		dirErreur1="ERREURS/ERREUR1";
		dirErreur2="ERREURS/ERREUR2";
		dirErreur3="ERREURS/ERREUR3";
		dirErreur4="ERREURS/ERREUR4";
		dirErreur5="ERREURS/ERREUR5";
		dirArchives="ARCHIVES";
		dirConserves="CONSERVES";
		dirLogs="LOGS";
		dirCalques="CALQUES";

		#récupération des parametres dans la base de donnée

		calqueEntete=$(selectData "SELECT path FROM entetepage;")
		calquePiedPage=$(selectData  "SELECT path FROM piedpage;") 
		calqueSignature=$(selectData  "SELECT path FROM signature;") 

		dateProg="$(date +%d-%m-%Y' '%H:%M:%S)";
		dateRep="$(date +%d-%m-%Y)";
		nomFileLog="LOG_"$nomSource"_"$(date +%d_%m_%Y);
		pile=10; #Nombre de fichiers a traiter par passage
		dateInsrt="$(date +%Y-%m-%d' '%H:%M:%S)";	

		#Fichiers PDF
		nbFileIn=`find $dirIn -type f -iname "*.pdf" | wc -l`;
		nbFileWork=`find $dirWork -type f -iname "*.pdf" | wc -l`;

		#Generation fichier log
		creatLogFile;


		if [ $nbFileWork != 0 ]; then

			echo "work"
		elif [ $nbFileIn != 0 ]; then
			traitementPdf;
		else
			traitementPdf;
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
		    	echo $statutApp
		    	echo $dateProg": "$statutApp >> $dirLogs/$dateRep/$nomFileLog.txt;
		    fi;

		}

		function extractionData(){
			nameFile=$(basename $file .${file##*.});
			nbPage=""
			nomPatient="";
			adressePatient="":
			sexe="";
			dateDeNaissance="";
			emailPatient="";
			emailMedecin="";
			medecin="";
			bioValideur="";

			#Conversion pdftotext		
			pdftotext $dirWork/$nameFile.pdf
			#-e $nomfichier Vérifie si le fichier existe.
			#-n $chaine Vérifie si la chaîne est non vide.
			if [ -e $dirWork/$nameFile.txt ]; then
				#extraire les données
				#utilisé les commande d'extraction grep -E
				#EXTRACTION DES DONNÉES DANS LE FICHIER TXT
				numeroDossier=$(grep -E "^Dossier N°" $dirWork/$nameFile.txt | awk {'print $3'})
				nomPatient=$(grep -E "^Mme" $dirWork/$nameFile.txt | awk {'print  $2" "$3 '})
				sexe=$(grep -E "^Sexe" $dirWork/$nameFile.txt | awk {'print $2'})
				nbPage=$(pdfinfo  $dirWork/$nameFile.pdf | grep Pages | awk '{print $2}');

				adressePatient="marrakech" 				
				dateDeNaissance="1992-08-11" 
				emailPatient="test@test.com" 
				emailMedecin="medecin@test.com"
				medecin="medecin" 
				bioValideur="bio"
				datecreation=""
				
				if [ -n "$numeroDossier" ] && [ -n "$nomPatient" ] ; then  #Si les champs importants sont renseignés

					if [ -n "$calqueEntete" ] && [ -e $dirWork/$nameFile.pdf ];then
						ajoutCalque "$calqueEntete";
					fi;

					if [ -n "$calquePiedPage" ] && [ -e $dirWork/$nameFile.pdf ];then
						ajoutCalque "$calquePiedPage";					

					fi;

					if [ -n "$calqueSignature" ] && [ -e $dirWork/$nameFile.pdf ];then
						ajoutCalque "$calqueSignature";					

					fi;

					if [ -e $dirWork/$nameFile.pdf ];then

								if [ -n "$calqueEntete" ] || [ -n "$calqueSignature" ] || [ -n "$calquePiedPage" ]; then
									
									mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirConserves/$dateRep
									
									insertionData  "INSERT INTO compterendubox(path,datecreation,biologistevalidateur,nbrpage,disponible,piedpage,signature,entetepage,certificat,nompatient,numerodossier,sexe,adresse,medecin,email)VALUES
									('$dirArchives/$dateRep/$nameFile.pdf','$dateInsrt','$bioValideur','$nbPage',true,false,false,true,false,'$nomPatient','$numeroDossier','$sexe','$adressePatient','$medecin','$emailPatient');"
								else
									echo "pas de calques"
									cp $dirWork/$nameFile.pdf $dirArchives/$dateRep;	
									mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt  $dirConserves/$dateRep;	

									
									insertionData  "INSERT INTO compterendubox(path,datecreation,biologistevalidateur,nbrpage,disponible,piedpage,signature,entetepage,certificat,nompatient,numerodossier,sexe,adresse,medecin,email)VALUES
									('$dirArchives/$dateRep/$nameFile.pdf','$dateInsrt','$bioValideur','$nbPage',false,false,false,false,false,'$nomPatient','$numeroDossier','$sexe','$adressePatient','$medecin','$emailPatient');"
								fi;				
									
					fi;

				else 
					#ERREUR2
						#Deplacement des fichiers dans le dossier Erreur2 qui n'ont pas le numero dossier et nomPatient
						mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirErreur2;
						#ecriture dans le fichier log du jour
						statut=$nameFile.pdf"-> Erreur les champs importants ne sont renseignés numeroDossier et nomPatient";
						echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt		

						#Ruperation du type d'erreur et insertion erreur
						Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR2';")		
						if [ -n "$Typerreur" ]; then
							insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
							echo "Erreur les champs importants ne sont renseignés numeroDossier et nomPatient"
						fi;			
				fi;
			else
				#ERREUR1
				#Deplacement des fichiers dans le dossier Erreur1 qui ne sont pas des comptes rendus
				mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirErreur1;

				#ecriture dans le fichier log du jour
				statut=$nameFile.pdf"-> Erreur fichier non compatible";
				echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt

				#Recuperation du type d'erreur et insertion erreur
				Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR1';")		
				if [ -n "$Typerreur" ]; then
					insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
					echo "Erreur fichier non compatible"
				fi;	
			fi;
		}
		#function des selections des données dans la base de donnée
		selectData(){
			arg1=$1
			psql -t -U $USERNAME -d $DATABASE -c "$arg1"
		}

		function insertionData(){
			#rqt sql
			arg1=$1
			rq_insert=$(psql -t -U $USERNAME -d $DATABASE -c "$arg1")
			if [ "$rq_insert" = "INSERT 0 1" ]; then
				echo "insertion avec succès"
			else
				#ERREUR5
				#ecriture dans le fichier log du jour
				statut=$nameFile.pdf"-> Erreur insertion données";
				echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt

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
				pdftk $dirWork/$nameFile.pdf stamp  $arg1 output $dirArchives/$dateRep/$nameFile.pdf;
				echo "calque bien ajouter"
		    else
				#ERREUR3
				statut=$nameFile.pdf"-> Erreur insertion de calques";
				echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt
				rm $dirWork/$nameFile.pdf $dirWork/$nameFile.txt 
				mv $dirWork/$nameFile.pdf $dirErreur3
				Typerreur=$(selectData "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR3';")		
				if [ -n "$Typerreur" ]; then
					insertionData "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,'$dateInsrt');"
				fi

			fi;
		}

		#-d $nomfichier Vérifie si le fichier est un répertoire.
		function creatLogFile(){
			#Verifier/creation si fichier LOG du jour exist
			if [ ! -d $dirLogs ];then
				mkdir $dirLogs;
				mkdir $dirArchives;
				mkdir $dirConserves;
			fi;
			if [ ! -d $dirLogs/$dateRep ];then
				mkdir $dirLogs/$dateRep;
				mkdir $dirConserves/$dateRep;
				mkdir $dirArchives/$dateRep ;
			fi;
			if [ ! -e "$dirLogs/$dateRep/$nomFileLog.txt" ];then
				echo "---------- Traitement CRR ----------" >> $dirLogs/$dateRep/$nomFileLog.txt;
			fi;
			
		}





		
		

		main;

		}




		main;