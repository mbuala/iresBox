#!/usr/bin/env bash


function main(){
	dirIn="IN";
	dirWork="WORK";
	dirErreur1="";
	dirErreur2="";
	dirErreur3="";
	dirErreur4="";
	dirErreur5="";
	dirArchives="";
	dirConserves="";
	dirLogs="LOGS";
	dirCalques="CALQUES";

	
	DATABASE="iresbox"
	USERNAME="mbuala"
	HOsTNAME="localhost"
	PORT="5432"
	export PGPASSWORD=pg_db_password


	#récupération des parametres dans la base de donnée

	calqueEntete=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT path FROM entetepage;") 
	 echo $calqueEntete
	calquePiedPage=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT path FROM piedpage;") 
	 echo $calquePiedPage
	calqueSignature=$(psql -t -U $USERNAME -d $DATABASE -c "SELECT path FROM signature;") 
	 echo $calqueSignature
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
			echo $dateProg": "$statutApp >> $dirLogs/$dateRep/$nomFileLog.txt;
		fi;

	}

	function extractionData(){
        nameFile=$(basename $file .${file##*.});
		nbPage=$(pdfinfo  $dirWork/$nameFile.pdf | grep Pages | awk '{print $2}');
		nomPatient="";
		adressePatient="":
		sexe="";
		dateDeNaissance="";
		emailPatient="";
		emailMedecin="";
		medecin="";
		bioValideur="";

		#Conversion pdftotext
		echo "extractionData"
		pdftotext $dirWork/$nameFile.pdf
		if [ -e $dirWork/$nameFile.txt ]; then
			#extraire les données
			#utilisé les commande d'extraction grep -E
			nomPatient="test" #extractPatient; 
			adressePatient= extractAdressePatient;
			sexe= extractSexePatient;
			dateDeNaissance= extractDateDeNaissance;
			emailPatient= extractEmailPatient;
			emailMedecin= extractEmailMedecin;
			medecin= extractMedecin;
			bioValideur= extractBioValideur;
			numeroDossier="12" #extractNumDossier;
			if [ -z $numeroDossier ] && [ -e $nomPatient ] ; then  #Si les champs importants sont renseignés

				if [ -z "$"calqueEntete"" ] && [ -e $dirWork/$nameFile.pdf ];then
					ajoutCalque calqueEntete;
					echo "calqueEntete"
				fi;

				if [ -z "$"calquePiedPage"" ] && [ -e $dirWork/$nameFile.pdf ];then
					ajoutCalque calquePiedPage;					
					echo "calquePiedPage"
				fi;

				if [ -z "$"calqueSignature"" ] && [ -e $dirWork/$nameFile.pdf ];then
					ajoutCalque calqueSignature;					
					echo "calqueSignature"
				fi;

				if [ -e $dirWork/$nameFile.pdf ];then
					#insertionData;
					echo "insertionData"
				fi;

			else
				#ERREUR2
				echo "ERREUR2"
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
	#1
	function ajoutCalque(){
		#pdftk
		arg1=$1 #$1 represente first argument
		if [ -z $arg1 ]; then #si calque bien ajouter
			echo "----"$arg1
		else
			#ERREUR3
			echo "ERREUR3"
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