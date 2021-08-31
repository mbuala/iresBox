#!/usr/bin/env 
	. ./DataBaseParameters.sh --source-only

main(){
	idcrr=""
	dirXml="DOCXML";
	dateFIle="$(date +%Y%m%d)";
}
getCrrindataBase(){
		crrdata=$(selectData "SELECT COUNT(idcoompterendu) from compterendubox WHERE etat='enattente'")
		document=$(selectData "SELECT idcoompterendu,patient from compterendubox WHERE etat='enattente' LIMIT 10")
		idDocument=$(echo "${document}" | awk -F\| '{print $1}');
        idetatdoc=$(echo "${document}" | awk -F\| '{print $2}');
		echo -e $idetatdoc;
}	
createxml(){
	echo "<NomCompletPatient>$idcrr</NomCompletPatient>"

}


