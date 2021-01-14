#!/usr/bin/python
import smbus
import time
import os
import subprocess

bus=smbus.SMBus(1)
address=0x04
rebootMessage=126

def writeNumber(value):
    bus.write_byte(address, value)
    return -1

writeNumber(rebootMessage)
time.sleep(1)
writeNumber(rebootMessage)
time.sleep(1)
writeNumber(rebootMessage)
time.sleep(1)
print("Reboot-Information wurde an USV gesendet")
