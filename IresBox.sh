#!/usr/bin/env bash


function main(){
	dirIn="";
	dirWork="";
	dirErreur1="";
	dirErreur2="";
	dirErreur3="";
	dirErreur4="";
	dirErreur5="";
	dirArchives="";
	dirConserves="";
	dirLogs="";
	dirCalques="";
	calqueEntete="": #récupérer de la bdd
	calquePiedPage="";
	calqueSignature="";
	dateProg="$(date +%d-%m-%Y' '%H:%M:%S)";
	nomFileLog="LOG_"$nomSource"_"$(date +%d_%m_%Y);
    pile=10; #Nombre de fichiers a traiter par passage

	#Fichiers PDF
	nbFileIn=`find $dirIn -type f -iname "*.pdf" | wc -l`;
	nbFileWork=`find $dirWork -type f -iname "*.pdf" | wc -l`;

	#Generation fichier log
	creatLogFile;


	if [ $nbFileWork != 0 ]; then

        #TO DO
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
			    

 

			    ;
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
		if [ -e $dirWork/$nameFile.txt ]; then
			#extraire les données
			nomPatient= extractPatient; #utilisé les commande d'extraction grep -E
			adressePatient= extractAdressePatient:
			sexe= extractSexePatient;
			dateDeNaissance= extractDateDeNaissance;
			emailPatient= extractEmailPatient;
			emailMedecin= extractEmailMedecin;
			medecin= extractMedecin;
			bioValideur= extractBioValideur;

			if [ ];then  #Si les champs importants sont renseignés

				if [ -z "$calqueEntete" ] && [ -e $dirWork/$nameFile.pdf ];then
					ajoutCalque($calqueEntete):

				fi;

				if [ -z "$calquePiedPage" ] && [ -e $dirWork/$nameFile.pdf ];then
					ajoutCalque($calquePiedPage):					

				fi;

				if [ -z "$calqueSignature" ] && [ -e $dirWork/$nameFile.pdf ];then
					ajoutCalque($calqueSignature):					

				fi;

				if [ -e $dirWork/$nameFile.pdf ];then
					insertionData;
				fi;

			else
				#ERREUR2
			fi;

		else 
			#ERREUR1

		fi;


	}

	function insertionData(){
		#rqt sql
		rq_insertCRR=$(psql iresbox -c "INSERT INTO ")
		if [ "$rq_insertCRR" = "INSERT 0 1" ]; then

		else
			statut=$nameFile"-> Erreur insertion données";
			echo $dateProg": "$statut >> $dirLogs/$dateRep/$nomFileLog.txt
		fi;
	}

	function ajoutCalque(calque){
		#pdftk
		if [ ]; then #si calque bien ajouter

		else
			#ERREUR3
		fi;
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
		mkdir $dirLogs;
	fi;
	if [ ! -d $dirLogs/$dateRep ];then
		mkdir $dirLogs/$dateRep;
	fi;
	if [ ! -e "$dirLogs/$dateRep/$nomFileLog.txt" ];then
		echo "---------- Traitement CRR ----------" >> $dirLogs/$dateRep/$nomFileLog.txt;
	fi;
}


main;

}




main;