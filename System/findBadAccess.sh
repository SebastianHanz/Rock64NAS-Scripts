#!/bin/bash
dir=/var/log

echo -e "\n Durchsuche Log-Dateien nach fehlerhaften Loginversuchen!\n"
egrep -w "Failed password" $dir/auth.log >> /home/Failed-SSH-Logins.txt
egrep -w "Accepted password" $dir/auth.log >> /home/Accepted-SSH-Logins.txt
egrep -w "Unauthorized login" $dir/auth.log >> /home/Failed-WEB-GUI-Logins.txt
egrep -w "Authorized login" $dir/auth.log >> /home/Accepted-WEB-GUI-Logins.txt

cd $dir
FileCount=0
FileCount=$(ls -l | grep auth. | wc -l )
echo -e "\n Es wurden $FileCount Log-Dateien gefunden.\n"
echo -e "\n Entpacke gefundene Archive.\n Das dauert einen Moment. \n"

cp $dir/auth.log /home/auth.log
cp $dir/auth.log.1 /home/auth1.log

for ((i=2; i < $FileCount; i++)) ; do
  gunzip $dir/auth.log.$i.gz > /dev/null 2>&1
  cp $dir/auth.log.$i /home/auth$i.log  
done

for ((i=1; i < $FileCount; i++)) ; do
echo -e "\n Durchsuche jetzt auth$i.log!\n"
egrep -w "Failed password" /home/auth$i.log >> /home/Failed-SSH-Logins.txt
egrep -w "Accepted password" /home/auth$i.log  >> /home/Accepted-SSH-Logins.txt
egrep -w "Unauthorized login" /home/auth$i.log  >> /home/Failed-WEB-GUI-Logins.txt
egrep -w "Authorized login" /home/auth$i.log  >> /home/Accepted-WEB-GUI-Logins.txt
done

echo -e "\n Das wars! \n"
FailedSSHLogins=$(wc -l /home/Failed-SSH-Logins.txt )
FailedSSHLogins=${FailedSSHLogins%%/*}
FailedWEBLogins=$(wc -l /home/Failed-WEB-GUI-Logins.txt )
FailedWEBLogins=${FailedWEBLogins%%/*}
echo -e "\n Es wurden $FailedSSHLogins fehlgeschlagene SSH-Logins und $FailedWEBLogins fehlgeschlagene OMV-Web-GUI-Logins festgestellt!\n"
cd /
exit

