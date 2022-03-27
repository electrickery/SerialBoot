#!/bin/python

# serialService.py - implements the host part of the TRS-80 Model 4P
#                    serial boot option. The protocol is described in the 
#                    Technical Manual, Service manual and the 
#                    SerialLoader.txt document.

import sys
import serial
import time
import struct

port        = '/dev/ttyUSB0'
baudRate    = 9600
interval    = 0.1
load_interval = 0.00001

baudRateMsg = 'Found Baud Rate'
loadingMsg  = 'Loading'
errorMsg    = 'Error'
CR          = struct.pack('B', 0x0d)
LF          = struct.pack('B', 0x0a)
syncChar    = struct.pack('B', 0xff)

if len(sys.argv) == 1:
   print("Usage: python3 serialService.py <hexFile> [<ttyPort>]")
   exit()
if len(sys.argv) > 1:
    hexFile = sys.argv[1]
if len(sys.argv) > 2:
    port = sys.argv[2]

ser = serial.Serial(port, baudRate, timeout=interval, parity=serial.PARITY_ODD)  # open serial port

char = 'U'
while(True):
    ser.write(char.encode())
    print("> " + char)
    response = ser.readline().strip().decode()
    if (response != ''):
        print("< '" + response + "'")
        if (response == baudRateMsg):
            print("baud rate is found")
            break

time.sleep(interval * 5) 
  

while(True):
    ser.write(syncChar)
    print("> 0xff")     
    time.sleep(interval * 5) 
    response = ser.readline().strip().decode()
    if (response != ''):
        print("< " + response)
        if (response == loadingMsg):
            print("sync char is found, start loading")
            break


file = open(hexFile, 'r')
lines = file.readlines()
file.close()
            
ser.timeout = load_interval

for line in lines:
    lineStrip = line.strip()
    if (lineStrip):
        print(lineStrip)
        partLineStrip = lineStrip
        while(partLineStrip):
            hexChar = partLineStrip[0:2]
#            print('  ' + hexChar + '  ' + str(int(hexChar,16)))
            ser.write(struct.pack('B', int(hexChar,16)))
            partLineStrip = partLineStrip[2:]
            response = ser.read().decode()
            time.sleep(interval) 
            if (response != ''):
                print("< " + response)
                break

time.sleep(interval * 5) 
ser.write(char.encode())
#ser.write(CR)
