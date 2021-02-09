#!/bin/bash
SRC_SETTINGS="/home/scripts/Settings.txt"

if [ ! -f "$SRC_SETTINGS" ]; then
    echo Konnte $SRC_SETTINGS nicht finden!
    echo Programm wird geschlossen
    echo Finish!
    exit
fi

##Data-Root
DIR_DATA_ROOT=$(egrep -w "DIR_DATA_ROOT" $SRC_SETTINGS)
DIR_DATA_ROOT=${DIR_DATA_ROOT##*=}

FILE=$DIR_DATA_ROOT/Timestamp.txt

date >>$FILE
exit
