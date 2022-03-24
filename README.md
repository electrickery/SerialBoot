Serial fun with a Model 4P

The Model 4P has an option to boot from the serial port. The feature appears to be implemented to help testing boards at the factory. It is described in both the Technical Manual and the Service Manual. It it somewhat terse, but with some experimenting it is doable to create a program to make it work.

The option to initiate the serial boot is pressing Right-Shift during reset. What is not in the manual is that a floppy must be present in drive 0. 

The format used to transfer data over the serial port is "TRS-DOS Load Module Format (LMF)". This is also used for executable files, so if you extract a program from a disk and feed it to the serial boot service, it would run, assuming it doesn't require parts of DOS.

LMF uses two types of records, data records and control records. The data records transfer the data and may be up to 255 bytes long. The control record is used to pass the execution address, which is directly implemented. Therefore it is the last record of a transfer.

The current implementation is in Python 3. This is quite portable, and easy to understand. A real native executable is probably faster.

There are two programs:

inthex2lmf.py - converts hex-intel records to a hex presentation of LMF on stdout

Usage:
  python3 inthex2lmf.py <inputFile.hex> [<entryPoint>] >  <outputFile.lmf.txt
  
  The default entry point is the first address of the program.

serialService.py - initiates the serial transfer and sends the binary presentation of the hexFile to the Model 4P

Usage: 
  python3 serialService.py <lmfFile> [<ttyPort>]


A version of serialService that uses real LMF is planned.
