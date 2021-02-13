#!/usr/bin/python
import smbus
import time
import os
import subprocess

bus=smbus.SMBus(1)
address=0x04
shutdownMessage=127

def writeNumber(value):
    bus.write_byte(address, value)
    return -1

writeNumber(shutdownMessage)
time.sleep(1)
#writeNumber(shutdownMessage)
#time.sleep(1)
#writeNumber(shutdownMessage)
#time.sleep(1)
print("Shutdown-Befehl wurde an USV gesendet")
