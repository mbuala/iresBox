#!/usr/bin/env bash


function main(){
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

	
	DATABASE="iresbox"
	USERNAME="mbuala"
	HOsTNAME="localhost"
	PORT="5432"
	export PGPASSWORD=pg_db_password


	#récupération des parametres dans la base de donnée

	calqueEntete=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT path FROM entetepage;") 
	calquePiedPage=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT path FROM piedpage;") 
	calqueSignature=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT path FROM signature;") 
	dateProg="$(date +%d-%m-%Y' '%H:%M:%S)";
	nomFileLog="LOG_"$nomSource"_"$(date +%d_%m_%Y);
    pile=10; #Nombre de fichiers a traiter par passage

	#Fichiers PDF
	nbFileIn=`find $dirIn -type f -iname "*.pdf" | wc -l`;
	nbFileWork=`find $dirWork -type f -iname "*.pdf" | wc -l`;

	#Generation fichier log
	#creatLogFile;


	if [ $nbFileWork != 0 ]; then

      echo "work"
	elif [ $nbFileIn != 0 ]; then
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
		echo "extractionData"
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
			nomPatient="" #extractPatient; 
			adressePatient= extractAdressePatient;
			sexe= extractSexePatient;
			dateDeNaissance= extractDateDeNaissance;
			emailPatient= extractEmailPatient;
			emailMedecin= extractEmailMedecin;
			medecin= extractMedecin;
			bioValideur= extractBioValideur;
			numeroDossier="" #extractNumDossier;
			nbPage=$(pdfinfo  $dirWork/$nameFile.pdf | grep Pages | awk '{print $2}');
			if [ -n "$numeroDossier" ] && [ -n "$nomPatient!" ] ; then  #Si les champs importants sont renseignés

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
					#insertionData;
					echo "insertionData"
				fi;

			else
				#ERREUR2
				dateErreur="$(date +%Y-%m-%d' '%H:%M:%S)";
				mv $dirWork/$nameFile.pdf $dirWork/$nameFile.txt $dirErreur2;
				statut=$nameFile.pdf"-> Erreur les champs importants ne sont renseignés numeroDossier et nomPatient";
				echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt
				Typerreur=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR2';")
				if [ -n $Typerreur ]; then
					psql -t -U $USERNAME -d $DATABASE -c "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,$(date +%Y-%m-%d' '%H:%M:%S));"

				fi
				echo "Erreur les champs importants ne sont renseignés numeroDossier et nomPatient"
			fi;

		else 
			#ERREUR1
			echo "ERREUR1"
		fi;


	}

	function insertionData(){
		#rqt sql
		rq_insertCRR=$(psql iresbox -U "mbuala" -c "INSERT INTO ")
		if [ "$rq_insertCRR" = "INSERT 0 1" ]; then
			echo "insertion avec succès"
		else
			statut=$nameFile"-> Erreur insertion données";
			echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt
		fi;
	}
	#-n $chaine Vérifie si la chaîne est non vide.
	function ajoutCalque(){		
		#pdftk
		arg1=$1 #$1 represente first argument
		if [ -n $arg1 ]; then #si calque bien ajouter			
		pdftk $dirWork/$nameFile.pdf stamp $arg1  output $dirConserves/$nameFile.pdf;
		echo "calque bien ajouter"
		else
			#ERREUR3
			statut=$nameFile"-> Erreur insertion de calques";
			echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt
			Typerreur=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT idtypeerreur FROM typeerreur WHERE typeerreur='ERREUR3';")
			if [ -n $Typerreur ]; then
					psql -t -U $USERNAME -d $DATABASE -c "INSERT INTO erreur(typeerreurid,date) VALUES($Typerreur,$dateProg);"

			fi
			echo "Erreur insertion de calques"
		fi;
	}
	extractNumDossier(){
		echo ""
	}
	function extractPatient(){
		resultat=""
		echo "$resultat"
	}

	function extractAdressePatient(){
		resultat=""
		echo "$resultat"
	}

	function extractSexePatient(){
		resultat=""
		echo "$resultat"
		#resultat="" #$(grep -E "^Sexe" test.txt | awk {'print $2'})
		#echo "$resultat"
	}
	function extractDateDeNaissance(){
		resultat=""
		echo "$resultat"
	}
	function extractEmailPatient(){
		resultat=""
		echo "$resultat"
	}
	function extractEmailMedecin(){
		resultat=""
		echo "$resultat"
	}
	function extractMedecin(){
		resultat=""
		echo "$resultat"
	}
	function extractBioValideur(){
		resultat=""
		echo "$resultat"
	}	
	#-d $nomfichier Vérifie si le fichier est un répertoire.
	function creatLogFile(){
		#Verifier/creation si fichier LOG du jour exist
		if [ ! -d $dirLogs ];then
			chmod -R 777 mkdir $dirLogs;
		fi;
		if [ ! -d $dirLogs/$dateRep ];then
			chmod -R 777 mkdir $dirLogs/$dateRep;
		fi;
		if [ ! -e "$dirLogs/$dateRep/$nomFileLog.txt" ];then
			echo "---------- Traitement CRR ----------" >> $dirLogs/$dateRep/$nomFileLog.txt;
		fi;
		
	}


main;

}




main;