	#!/usr/bin/env bash

	function main(){
		#DATABASE PARAMETRES
		DATABASE="iresbox"
		USERNAME="mbuala"
		HOsTNAME="localhost"
		PORT="5432"
		export PGPASSWORD=pg_db_password
	}

	selectData(){
			arg1=$1
			psql -t -U $USERNAME -d $DATABASE -c "$arg1"
	}
	updateData(){
		arg1=$1
	}
	deletedata(){
		arg1=$1

	}
