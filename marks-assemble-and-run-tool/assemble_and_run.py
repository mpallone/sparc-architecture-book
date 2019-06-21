#!/usr/bin/env python
#
# This program is a copy/paste of sample_python.py from
# the unicorn-engine repository, but modified to use
# sparc-elf-gcc to assemble a .s file and then parse
# out the sparc_code.
#
# Old file header:
#   Sample code for SPARC of Unicorn. Nguyen Anh Quynh <aquynh@gmail.com>
#   Python sample ported by Loi Anh Tuan <loianhtuan@gmail.com>

from __future__ import print_function
from unicorn import *
from unicorn.sparc_const import *

import argparse
import subprocess


# code to be emulated
#SPARC_CODE = b"\x86\x00\x40\x02" # add %g1, %g2, %g3;
SPARC_CODE = None
# memory address where emulation starts
ADDRESS    = 0x10000
MEM_SIZE   = (2 * 1024 * 1024)


# callback for tracing basic blocks
def hook_block(uc, address, size, user_data):
    print("Tracing basic block at 0x%x, block size = 0x%x" %(address, size))


# callback for tracing instructions
def hook_code(uc, address, size, user_data):
    print("Tracing instruction at 0x%x, instruction size = 0x%x" %(address, size))

def num_2_twos_complement_str(num):
    if not (num & 0x80000000):
        return str(num)
    num = ((~num) & 0xFFFFFFFF)
    num += 1
    return "-" + str(num)

# Test SPARC
def test_sparc():
    print("Emulate SPARC code")
    try:
        # Initialize emulator in SPARC EB mode
        mu = Uc(UC_ARCH_SPARC, UC_MODE_SPARC32|UC_MODE_BIG_ENDIAN)

        # map 2MB memory for this emulation
        mu.mem_map(ADDRESS, MEM_SIZE)

        # write machine code to be emulated to memory
        mu.mem_write(ADDRESS, SPARC_CODE)

        # initialize machine registers
        #mu.reg_write(UC_SPARC_REG_G1, 0x1230)
        #mu.reg_write(UC_SPARC_REG_G2, 0x6789)
        #mu.reg_write(UC_SPARC_REG_G3, 0x5555)

        # tracing all basic blocks with customized callback
        mu.hook_add(UC_HOOK_BLOCK, hook_block)

        # tracing all instructions with customized callback
        mu.hook_add(UC_HOOK_CODE, hook_code)

        # emulate machine code in infinite time
        try:
            mu.emu_start(ADDRESS, ADDRESS + len(SPARC_CODE))
        except UcError as e:
            print("\n\n****** mu.emu_start caused exception:", e)
            print("\n")

        # now print out some registers
        print()
        print(">>> Emulation done. Below is the CPU context")
        print()

        g0 = mu.reg_read(UC_SPARC_REG_G0)
        g1 = mu.reg_read(UC_SPARC_REG_G1)
        g2 = mu.reg_read(UC_SPARC_REG_G2)
        g3 = mu.reg_read(UC_SPARC_REG_G3)
        g4 = mu.reg_read(UC_SPARC_REG_G4)
        g5 = mu.reg_read(UC_SPARC_REG_G5)
        g6 = mu.reg_read(UC_SPARC_REG_G6)
        g7 = mu.reg_read(UC_SPARC_REG_G7)
        print("G0 = 0x%08x = %-6s" % (g0, num_2_twos_complement_str(g0)), end="   ")
        print("G1 = 0x%08x = %-6s" % (g1, num_2_twos_complement_str(g1)), end="   ")
        print("G2 = 0x%08x = %-6s" % (g2, num_2_twos_complement_str(g2)), end="   ")
        print("G3 = 0x%08x = %-6s" % (g3, num_2_twos_complement_str(g3)), end="   ")
        print()
        print("G4 = 0x%08x = %-6s" % (g4, num_2_twos_complement_str(g4)), end="   ")
        print("G5 = 0x%08x = %-6s" % (g5, num_2_twos_complement_str(g5)), end="   ")
        print("G6 = 0x%08x = %-6s" % (g6, num_2_twos_complement_str(g6)), end="   ")
        print("G7 = 0x%08x = %-6s" % (g7, num_2_twos_complement_str(g7)), end="   ")
        print()
        print()

        o0 = mu.reg_read(UC_SPARC_REG_O0)
        o1 = mu.reg_read(UC_SPARC_REG_O1)
        o2 = mu.reg_read(UC_SPARC_REG_O2)
        o3 = mu.reg_read(UC_SPARC_REG_O3)
        o4 = mu.reg_read(UC_SPARC_REG_O4)
        o5 = mu.reg_read(UC_SPARC_REG_O5)
        o6 = mu.reg_read(UC_SPARC_REG_O6)
        o7 = mu.reg_read(UC_SPARC_REG_O7)
        print("O0 = 0x%08x = %-6s" % (o0, num_2_twos_complement_str(o0)), end="   ")
        print("O1 = 0x%08x = %-6s" % (o1, num_2_twos_complement_str(o1)), end="   ")
        print("O2 = 0x%08x = %-6s" % (o2, num_2_twos_complement_str(o2)), end="   ")
        print("O3 = 0x%08x = %-6s" % (o3, num_2_twos_complement_str(o3)), end="   ")
        print()
        print("O4 = 0x%08x = %-6s" % (o4, num_2_twos_complement_str(o4)), end="   ")
        print("O5 = 0x%08x = %-6s" % (o5, num_2_twos_complement_str(o5)), end="   ")
        print("O6 = 0x%08x = %-6s" % (o6, num_2_twos_complement_str(o6)), end="   ")
        print("O7 = 0x%08x = %-6s" % (o7, num_2_twos_complement_str(o7)), end="   ")
        print()
        print()

        l0 = mu.reg_read(UC_SPARC_REG_L0)
        l1 = mu.reg_read(UC_SPARC_REG_L1)
        l2 = mu.reg_read(UC_SPARC_REG_L2)
        l3 = mu.reg_read(UC_SPARC_REG_L3)
        l4 = mu.reg_read(UC_SPARC_REG_L4)
        l5 = mu.reg_read(UC_SPARC_REG_L5)
        l6 = mu.reg_read(UC_SPARC_REG_L6)
        l7 = mu.reg_read(UC_SPARC_REG_L7)
        print("L0 = 0x%08x = %-6s" % (l0, num_2_twos_complement_str(l0)), end="   ")
        print("L1 = 0x%08x = %-6s" % (l1, num_2_twos_complement_str(l1)), end="   ")
        print("L2 = 0x%08x = %-6s" % (l2, num_2_twos_complement_str(l2)), end="   ")
        print("L3 = 0x%08x = %-6s" % (l3, num_2_twos_complement_str(l3)), end="   ")
        print()
        print("L4 = 0x%08x = %-6s" % (l4, num_2_twos_complement_str(l4)), end="   ")
        print("L5 = 0x%08x = %-6s" % (l5, num_2_twos_complement_str(l5)), end="   ")
        print("L6 = 0x%08x = %-6s" % (l6, num_2_twos_complement_str(l6)), end="   ")
        print("L7 = 0x%08x = %-6s" % (l7, num_2_twos_complement_str(l7)), end="   ")
        print()
        print()

        i0 = mu.reg_read(UC_SPARC_REG_I0)
        i1 = mu.reg_read(UC_SPARC_REG_I1)
        i2 = mu.reg_read(UC_SPARC_REG_I2)
        i3 = mu.reg_read(UC_SPARC_REG_I3)
        i4 = mu.reg_read(UC_SPARC_REG_I4)
        i5 = mu.reg_read(UC_SPARC_REG_I5)
        i6 = mu.reg_read(UC_SPARC_REG_I6)
        i7 = mu.reg_read(UC_SPARC_REG_I7)
        print("I0 = 0x%08x = %-6s" % (i0, num_2_twos_complement_str(i0)), end="   ")
        print("I1 = 0x%08x = %-6s" % (i1, num_2_twos_complement_str(i1)), end="   ")
        print("I2 = 0x%08x = %-6s" % (i2, num_2_twos_complement_str(i2)), end="   ")
        print("I3 = 0x%08x = %-6s" % (i3, num_2_twos_complement_str(i3)), end="   ")
        print()
        print("I4 = 0x%08x = %-6s" % (i4, num_2_twos_complement_str(i4)), end="   ")
        print("I5 = 0x%08x = %-6s" % (i5, num_2_twos_complement_str(i5)), end="   ")
        print("I6 = 0x%08x = %-6s" % (i6, num_2_twos_complement_str(i6)), end="   ")
        print("I7 = 0x%08x = %-6s" % (i7, num_2_twos_complement_str(i7)), end="   ")
        print()
        print()

        print("Memory:")
        top_of_memory = ADDRESS + 0x10000
        bytes_to_show = 240  
        memory = mu.mem_read(top_of_memory - bytes_to_show, bytes_to_show + 1)


#        for i in range(len(memory)):
#            address = top_of_memory - bytes_to_show + i
#            print(i, hex(address), hex(memory[i]))
        
        strings_to_print = []
        string_to_print = ""
        for i in range(len(memory)):
            address = top_of_memory - bytes_to_show + i
            
            if (i == 0) or ((address % 16) == 0):
                strings_to_print.append(string_to_print)
                # start over
                string_to_print = "0x%08X:    " % address
                if (i == 0):
                    string_to_print += "  " * (address % 16)

            if (address % 4) == 0 and (address % 16) != 0:
                string_to_print += " "

            string_to_print += "%02X" % memory[i]
            

        if string_to_print:
            strings_to_print.append(string_to_print)

        for i in range(len(strings_to_print) - 1, -1, -1):
            print(strings_to_print[i])
                
                
           

        
                
        
        

    except UcError as e:
        print("ERROR: %s" % e)

def main():
    parser = argparse.ArgumentParser(description="Assemble and run a SPARC .s file.")
    parser.add_argument("assembly_file", help=".s file to assemble and run")
    args = parser.parse_args()
    print("args.assembly_file:", args.assembly_file)

    cmd = "python3 /home/mpallone/Desktop/sparc-architecture-book/marks-assemble-and-run-tool/ridiculous_assembler.py %s" % args.assembly_file
    print("Executing:\n    ", cmd)
    subprocess.check_call(cmd.split())

    # ridiculous_assembler.py should have written its output to tempUnicornFile
    infile = open("tempUnicornFile", "rb")
    global SPARC_CODE
    SPARC_CODE = infile.read()

    # Now that the binary data is loaded into SPARC_CODE, run the simulator.
    test_sparc()


if __name__ == '__main__':
    #test_sparc()
    main()
