#!/usr/bin/python3
#

# inthex2lmf.py - converts Hex-Intel records to LMF (Load Module Format).
#                 only records of type 00 are converted to LMF type 01.
#                 The closing 02 type record has to be edited manually.
#                 Hex-intel is for loading data in Eprom programmers and
#                 has no option for entry points. The default is the 
#                 first address of the program. 
#                 Note that the entry-point must be specified with the 
#                 least significant byte first.
# usage : python3 inthex2lmf.py <hex-intel-file> [<entryPoint>}

import sys

entryPoint = 'llhh'

fileName = sys.argv[1]
if len(sys.argv) > 1:
    entryPoint = sys.argv[2]
file = open(fileName, "r") 
lines = file.readlines()

for line in lines:
    lineStrip = line.strip()
    if (lineStrip):
#        print(lineStrip)
        startChar = lineStrip[0]
        byteCount = lineStrip[1:3]
        startAddrMSB = lineStrip[3:5]
        startAddrLSB = lineStrip[5:7]
        recType   = lineStrip[7:9]
        byteStr   = lineStrip[9:-2].upper()
        chkSum    = lineStrip[-2:]
        lmfLen = int(byteCount, 16) + 2
        lmfLenStr = '{:02X}'.format(lmfLen)
        if (entryPoint == 'llhh'):
            entryPoint = startAddrLSB + startAddrMSB
        if (byteCount != '00'):
            print('01' + lmfLenStr + startAddrLSB + startAddrMSB + byteStr)

print('02' + entryPoint)
