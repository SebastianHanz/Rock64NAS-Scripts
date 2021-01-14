#!/bin/bash
echo
echo Halte ioBroker an
echo
iobroker stop
echo

echo Aktualisiere Paketdatenbank
echo
iobroker update
echo

echo Update ioBroker selbst
echo
iobroker upgrade self
echo

echo Update Adapter
echo
iobroker upgrade
echo

echo Starte ioBroker wieder
echo
iobroker start
echo

echo Aktualisierung abgeschlossen!
echo Finish!
exit