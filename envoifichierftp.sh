#!/usr/bin/env 
sendzipinftp(){
  if [ "$(ls -A /home/mbuala/file/)" ] #REPERTOIRE FTP 
   then
   timeout 10s sh /var/www/html/iresBox/auth.sh
     if [ $? -eq 0 ]; then
      echo "fichier envoyé avec succès"
      echo "\nfichier envoyé avec succès" > output.log
    else
      for i in {1..3}; do
       timeout 10s sh /var/www/html/iresBox/auth.sh
        if [ $? -eq 0 ]; then
          echo "\nfichier envoyé" > output.log
        else
          sleep 5;
        fi
      done;
      echo "fichier non envoyé"
      echo "\ntransmission echoué, nom d'utilisateur ou mot de passe invalide" > output.log
      cat output.log | mail -s "Échec du transfert du script" myoka.silogik@gmail.com
    fi
  else
    echo "le dossier est vide pour le moment"
    echo "le dossier est vide" >> output.log
   fi
}
