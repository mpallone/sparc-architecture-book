#!/usr/bin/env python3

"""
Transform SPARC assembly into a SPARC machine code binary by:
    - Using Gaisler's sparc-elf-gcc to compile the code
    - Using Gaisler's sparc-elf-objdump to disassemble the code
    - Parsing the disassembly to get the machine code
    - writing the machine code to a binary file.
This script exists so that Python 2 programs can run SPARC .s
files in Unicorn.

Note that we can't use the result of that first compilation
step, because the only thing we want to feed into Unicorn is
a one-to-one translation of assembly lines to machine code.
The initial compilation creates an ELF file, which contains
a lot more binary data than just the compiled instructions
(headers, symbol table stuff, etc.).

And yes, this is the world's shittiest assembler.

Author: Mark Pallone 
Email:  mark.c.pallone@nasa.gov
Date:   July 13, 2018
"""

import subprocess
import argparse

def main():
    parser = argparse.ArgumentParser(description="Assemble a SPARC .s file.")
    parser.add_argument("assemblyFile", help=".s file to assemble and run")
    args = parser.parse_args()
    print("args.assemblyFile:", args.assemblyFile)

    # Assemble, but do not link, the .s file.
    tempCompiledFile = "%s.temp" % args.assemblyFile
    cmd = "sparc-elf-gcc %s -o %s -c" % (args.assemblyFile, tempCompiledFile)
    print("Executing:\n    ", cmd)
    subprocess.check_call(cmd.split())

    # Disassemble to get just the instruction machine code.
    tempDisassemblyFile = "%s_dis.temp" % args.assemblyFile
    cmd = "sparc-elf-objdump --disassemble %s" % tempCompiledFile
    print("Executing:\n    ", cmd)
    disassembly = subprocess.check_output(cmd.split(), universal_newlines=True)
    print("disassembly:")
    splitDisassembly = str(disassembly).splitlines()
    linesToParse = []
    startCollectingLines = False
    machineCode = bytearray()
    for line in splitDisassembly:
        if "00000000 <" in line:
            startCollectingLines = True
        
        # Only collect lines containing machine code
        elif startCollectingLines and len(line.split()) > 2:
            print("-->   ", line)
            splitLine = line.split()
            machineCode.append(int(splitLine[1], 16))
            machineCode.append(int(splitLine[2], 16))
            machineCode.append(int(splitLine[3], 16))
            machineCode.append(int(splitLine[4], 16))

    outputFilename = "tempUnicornFile" 
    with open(outputFilename, "wb") as outfile:
        outfile.write(machineCode)

    print("Wrote the following to", outputFilename)
    for i in range(0, len(machineCode), 4):
        print("%02x %02x %02x %02x" % (machineCode[i], 
                                       machineCode[i+1], 
                                       machineCode[i+2], 
                                       machineCode[i+3]))
    
  
if __name__ == '__main__':
    main()
