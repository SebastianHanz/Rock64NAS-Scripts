#!/usr/bin/python
import smbus
import time
import os
import subprocess

bus = smbus.SMBus(1)
address = 0x04  # Adresse des Arduino Nano


def writeNumber(value):
    bus.write_byte(address, value)
    return -1


def readNumber():
    number = bus.read_byte(address)
    return number


def readBlock(address, offset, bytes):
    block = bus.read_i2c_block_data(address, offset, bytes)
    return block


def writeBlock(address, offset, daten):
    bus.write_i2c_block_data(address, offset, daten)
    return -1


while True:
    try:
        # CPU-Temperatur ermitteln
        tempCPUraw = open('/sys/class/thermal/thermal_zone0/temp')
        tempCPU = float(tempCPUraw.read())
        tempCPU = tempCPU/1000  # Da in milli-grad-Celsius angegeben
        tempCPU = round(tempCPU)
        data = int(tempCPU)
        print("Sende Temp ueber i2c")
        writeNumber(data)  # Sende CPU Temperatur an USV
        print("Temp uebergeben!")
        # Gebe Temperatur in Console aus
        print("CPU-Temperatur= {0}C".format(tempCPU))

        # Lese 4Byte an Daten von USV in read-Array ein
        read = readBlock(address, 0, 4)
        # Oeffne die Txt-Datei in die die USV-Daten geschrieben werden sollen
        w = open('/media/ramdisk/USV.txt', 'w')

        # Schreibe empfangene daten von USV in Txt-Datei, nach angegebener Struktur
        w.write('{0}\n{1}\n{2}\n{3}\n{4}'.format(data, float(
            read[0]), float(read[1]), float(read[2]), read[3]))
        w.close()

        # Schreibe empfangene Daten in Console, nur fuer Debugging notwendig
        #print("Eingangsspannung= {0}V".format(float(read[0])/10))
        #print("Spannung 12V-Kreis= {0}V".format(float(read[1])/10))
        #print("Batterie-Spannung= {0}V".format(float(read[2])/10))

        # Erkennung USV-Zustand anhand empfangener Daten
        if read[3] == 100:
            print("Status=Normalbetrieb")
        if read[3] == 101:
            print("Status=Batteriebetrieb")
        if read[3] == 102:
            print("Status=Batteriespannung kritisch!")
        if read[3] == 103:
            print("Status=Shutdown")
            # Leite Shutdown ein
            subprocess.call(['sudo poweroff'], shell=True)

        time.sleep(1)
    except:
        tempCPUraw.close()
        time.sleep(1)
        exit
