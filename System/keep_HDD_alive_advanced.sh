#!/bin/bash
#rm /srv/dev-disk-by-label-WDRed1TB/Timestamp.txt
day=$(date +%w) 
currenttime=$(date +%H:%M)

#Zeiten Arbeitstage
starttime="14:50"
endtime="20:30"

#Zeiten Wochenende
starttime_we="10:00"
endtime_we="23:30"

#Wochenschaltung Mo-Fr
if [[ "$day" -ge "1" ]] && [[ "$day" -le "5" ]]; then
   if [[ "$currenttime" > "$starttime" ]] && [[ "$currenttime" < "$endtime" ]]; then
     date >> /srv/dev-disk-by-label-WDRed_4TB_RAID/Timestamp.txt
	 #echo Passt! Woche
   #else
     #echo Passt nicht! Woche
   fi
      date >> /srv/dev-disk-by-label-WDRed_4TB_RAID/Timestamp.txt
exit  
#Wochenschaltung Sa+So
else [[ "$day" -gt "5" ]] && [[ "$day" -le "7" ]]; 
	if [[ "$currenttime" > "$starttime" ]] && [[ "$currenttime" < "$endtime" ]]; then
     date >> /srv/dev-disk-by-label-WDRed_4TB_RAID/Timestamp.txt
	 #echo Passt! Wochenende
   #else
     #echo Passt nicht! Wochenende
   fi
        date >> /srv/dev-disk-by-label-WDRed_4TB_RAID/Timestamp.txt
exit
fi
