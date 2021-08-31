#!/usr/bin/expect
source_host=vps-e9aee6f1.vps.ovh.net
PORT=22
sftp_user=ubuntu
sftp_pass=x9nuZ7pD84vM

day=$(date +%d);
month=$(date +%m);
year=$(date +%Y);
dateRep="$(date +%d_%m_%Y)";
local_directory=/home/ubuntu/pdf #REPERTOIRE DU SERVERUR FTP
source_folder="/home/mbuala/file/" #REPERTOIRE IRESBOX
inotifywait -m -r -e create --format '%w%f' "${source_folder}" | while read NEWFILE
#${NEWFILE} has been created
do
source_directory=${NEWFILE}
timeout 10s expect <<EOD >output.log
# Connect to the SFTP server
spawn /usr/bin/sftp -o Port=$PORT  $sftp_user@$source_host
expect "password:"
send "$sftp_pass\r"
expect "sftp>"
send "put -r $source_directory $local_directory\r"
expect "sftp>"
send "bye\r"
interact
EOD
done


