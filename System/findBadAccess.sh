#!/bin/bash
dir=/var/log
saveDir=/home/scripts/System

echo -e "\n Durchsuche Log-Dateien nach fehlerhaften Loginversuchen!"
egrep -w "Failed password" $dir/auth.log >>$saveDir/Failed-SSH-Logins.log
egrep -w "Accepted password" $dir/auth.log >>$saveDir/Accepted-SSH-Logins.log
egrep -w "Unauthorized login" $dir/auth.log >>$saveDir/Failed-WEB-GUI-Logins.log
egrep -w "Authorized login" $dir/auth.log >>$saveDir/Accepted-WEB-GUI-Logins.log

cd $dir
FileCount=0
FileCount=$(ls -l | grep auth. | wc -l)
echo -e "\n Es wurden $FileCount Log-Dateien gefunden."
echo -e "\n Entpacke gefundene Archive.\n Das dauert einen Moment."

cp $dir/auth.log $saveDir/auth.log >/dev/null 2>&1
cp $dir/auth.log.1 $saveDir/auth1.log >/dev/null 2>&1

for ((i = 2; i < $FileCount; i++)); do
  gunzip $dir/auth.log.$i.gz >/dev/null 2>&1
  cp $dir/auth.log.$i $saveDir/auth$i.log
done

for ((i = 1; i < $FileCount; i++)); do
  echo -e "Durchsuche jetzt auth$i.log!\n"
  egrep -w "Failed password" $saveDir/auth$i.log >>$saveDir/Failed-SSH-Logins.log
  egrep -w "Accepted password" $saveDir/auth$i.log >>$saveDir/Accepted-SSH-Logins.log
  egrep -w "Unauthorized login" $saveDir/auth$i.log >>$saveDir/Failed-WEB-GUI-Logins.log
  egrep -w "Authorized login" $saveDir/auth$i.log >>$saveDir/Accepted-WEB-GUI-Logins.log
done

cd $saveDir
rm ./auth.* >/dev/null 2>&1

echo -e "\n Das wars! Die Ergebnisse liegen unter $saveDir/Failed-SSH-Logins.log und $saveDir/Failed-WEB-GUI-Logins.log ab. \n"
FailedSSHLogins=$(wc -l $saveDir/Failed-SSH-Logins.log)
FailedSSHLogins=${FailedSSHLogins%%/*}
FailedWEBLogins=$(wc -l $saveDir/Failed-WEB-GUI-Logins.log)
FailedWEBLogins=${FailedWEBLogins%%/*}
echo -e "\n Es wurden $FailedSSHLogins fehlgeschlagene SSH-Logins und $FailedWEBLogins fehlgeschlagene OMV-Web-GUI-Logins festgestellt!\n"
cd /
echo Finish!
exit
