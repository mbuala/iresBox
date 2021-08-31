	#!/usr/bin/env bash

	function main(){
		#DATABASE PARAMETRES
		DATABASE="iresbox"
        USERNAME="adminslk"
        HOsTNAME="vps-e9aee6f1.vps.ovh.net"
        PORT="5432"
		export PGPASSWORD=pg_db_password
	}

	selectData(){
			arg1=$1
			psql -t -U $USERNAME -d $DATABASE -c "$arg1"
	}
	updateData(){
		arg1=$1
			if [ -n "$arg1" ]; then
				
				rq_insert=$(psql -t -U $USERNAME -d $DATABASE -c "UPDATE compterendubox SET etat='envoie' WHERE idcoompterendu=$arg1")
				if [ "$rq_insert" = "UPDATE 1" ]; then
					echo "update  avec succès"
				else
					exit 
				fi
			else
				exit

			fi			
	}
	deletedata(){
		arg1=$1
		echo "arg1 "$arg1
	}


