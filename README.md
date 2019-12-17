# sparc-architecture-book
Exercises from the SPARC Architecture, Assembly Language Programming, and C textbook (second edition).  Textbook written by Richard P. Paul, ISBN: 0-13-025596-3.

NASA's PACE satellite's onboard computers use Gaisler Research's GR712RC CPUs, which use the SPARCv8 architecture.  My work on this satellite required me to update its flight software's CPU exception handler, debug many low-level issues, and occasionally write custom assembly, but I found that (unsurprisingly) no one in the flight software branch was familiar with the SPARCv8 architecture, so I had to teach myself. Unfortunately, there are few resources online for learning SPARCv8, as it is not a widely used architecture.

So, to become familiar with SPARCv8 so that I could do this work, I bought a SPARCv8 book for $12 from Amazon and learned enough SPARCv8 ASM to get by. The exercises I completed are in this repository. 

I ran these exercises in the CPU emulator Unicorn. The mechanism I came up with for assembling and running SPARCv8 ASM is a bit wonky. The code in marks-ridiculous-assembler/assemble-and-run.py will:

* Run Gaisler's sparc-elf-gcc program to compile the instructions
* Run Gaisler's sparc-elf-objdump to disassemble the compiled code, and print the disassembly
* Parse the disassembly to get the machine code
* Write the machine code to a binary file
* Execute this binary file in the Unicorn CPU emulator
* Display CPU registers and memory.

I went this route because I had trouble with SPARCv8 compilers, whereas Gaisler's SPARCv8 suite worked well. However, Gaisler's tools output files that are to be run on the actual CPUs they manufacture (i.e., the binaries contain more than the instructions I wrote for the exercises), so I had to write Python that would extract only the machine code that came from my .s files. 

Here's an example of executing exercise [5-5.2, which sorts a list in memory.](https://github.com/mpallone/sparc-architecture-book/blob/master/ch5/5-5.s)

```
mpallone@localhost (master) ch5 $ ../marks-assemble-and-run-tool/assemble_and_run.py 5-5.s
args.assembly_file: 5-5.s
Executing:
     python3 /home/mpallone/Desktop/sparc-architecture-book/marks-assemble-and-run-tool/ridiculous_assembler.py 5-5.s
args.assemblyFile: 5-5.s
Executing:
     sparc-elf-gcc 5-5.s -o 5-5.s.temp -c
Executing:
     sparc-elf-objdump --disassemble 5-5.s.temp
disassembly:
-->       0:    1d 00 00 80     sethi  %hi(0x20000), %sp
-->       4:    9d e3 bf 88     save  %sp, -120, %sp
-->       8:    a0 10 20 03     mov  3, %l0
-->       c:    e0 27 bf e8     st  %l0, [ %fp + -24 ]
-->      10:    a0 10 20 04     mov  4, %l0
-->      14:    e0 27 bf ec     st  %l0, [ %fp + -20 ]
-->      18:    a0 10 3f fb     mov  -5, %l0
-->      1c:    e0 27 bf f0     st  %l0, [ %fp + -16 ]
-->      20:    a0 10 20 06     mov  6, %l0
-->      24:    e0 27 bf f4     st  %l0, [ %fp + -12 ]
-->      28:    a0 10 20 02     mov  2, %l0
-->      2c:    e0 27 bf f8     st  %l0, [ %fp + -8 ]
-->      30:    a0 10 20 00     clr  %l0
-->      34:    e0 27 bf fc     st  %l0, [ %fp + -4 ]
-->      38:    a0 27 a0 04     sub  %fp, 4, %l0
-->      3c:    a2 27 a0 18     sub  %fp, 0x18, %l1
-->      40:    80 a4 40 10     cmp  %l1, %l0
-->      44:    16 80 00 14     bge  94 <done>
-->      48:    01 00 00 00     nop 
-->      4c:    a4 10 00 11     mov  %l1, %l2
-->      50:    a6 10 00 11     mov  %l1, %l3
-->      54:    e8 04 80 00     ld  [ %l2 ], %l4
-->      58:    ea 04 c0 00     ld  [ %l3 ], %l5
-->      5c:    80 a5 00 15     cmp  %l4, %l5
-->      60:    04 80 00 03     ble  6c <end_of_innerloop>
-->      64:    01 00 00 00     nop 
-->      68:    a4 10 00 13     mov  %l3, %l2
-->      6c:    a6 04 e0 04     add  %l3, 4, %l3
-->      70:    80 a4 c0 10     cmp  %l3, %l0
-->      74:    04 bf ff f8     ble  54 <innerloop>
-->      78:    01 00 00 00     nop 
-->      7c:    e8 04 40 00     ld  [ %l1 ], %l4
-->      80:    ea 04 80 00     ld  [ %l2 ], %l5
-->      84:    ea 24 40 00     st  %l5, [ %l1 ]
-->      88:    e8 24 80 00     st  %l4, [ %l2 ]
-->      8c:    a2 04 60 04     add  %l1, 4, %l1
-->      90:    10 bf ff ec     b  40 <outerloop>
-->      94:    01 00 00 00     nop 
Wrote the following to tempUnicornFile
1d 00 00 80
9d e3 bf 88
a0 10 20 03
e0 27 bf e8
a0 10 20 04
e0 27 bf ec
a0 10 3f fb
e0 27 bf f0
a0 10 20 06
e0 27 bf f4
a0 10 20 02
e0 27 bf f8
a0 10 20 00
e0 27 bf fc
a0 27 a0 04
a2 27 a0 18
80 a4 40 10
16 80 00 14
01 00 00 00
a4 10 00 11
a6 10 00 11
e8 04 80 00
ea 04 c0 00
80 a5 00 15
04 80 00 03
01 00 00 00
a4 10 00 13
a6 04 e0 04
80 a4 c0 10
04 bf ff f8
01 00 00 00
e8 04 40 00
ea 04 80 00
ea 24 40 00
e8 24 80 00
a2 04 60 04
10 bf ff ec
01 00 00 00

Emulate SPARC code

>>> Emulation done. Below is the CPU context

G0 = 0x00000000 = 0        G1 = 0x00000000 = 0        G2 = 0x00000000 = 0        G3 = 0x00000000 = 0        
G4 = 0x00000000 = 0        G5 = 0x00000000 = 0        G6 = 0x00000000 = 0        G7 = 0x00000000 = 0        

O0 = 0x00000000 = 0        O1 = 0x00000000 = 0        O2 = 0x00000000 = 0        O3 = 0x00000000 = 0        
O4 = 0x00000000 = 0        O5 = 0x00000000 = 0        O6 = 0x0001ff88 = 130952   O7 = 0x00000000 = 0        

L0 = 0x0001fffc = 131068   L1 = 0x0001fffc = 131068   L2 = 0x0001fffc = 131068   L3 = 0x00020000 = 131072   
L4 = 0x00000006 = 6        L5 = 0x00000004 = 4        L6 = 0x00000000 = 0        L7 = 0x00000000 = 0        

I0 = 0x00000000 = 0        I1 = 0x00000000 = 0        I2 = 0x00000000 = 0        I3 = 0x00000000 = 0        
I4 = 0x00000000 = 0        I5 = 0x00000000 = 0        I6 = 0x00020000 = 131072   I7 = 0x00000000 = 0        

Memory:
0x00020000:    00
0x0001FFF0:    00000002 00000003 00000004 00000006
0x0001FFE0:    00000000 00000000 FFFFFFFB 00000000
0x0001FFD0:    00000000 00000000 00000000 00000000
0x0001FFC0:    00000000 00000000 00000000 00000000
0x0001FFB0:    00000000 00000000 00000000 00000000
0x0001FFA0:    00000000 00000000 00000000 00000000
0x0001FF90:    00000000 00000000 00000000 00000000
0x0001FF80:    00000000 00000000 00000000 00000000
0x0001FF70:    00000000 00000000 00000000 00000000
0x0001FF60:    00000000 00000000 00000000 00000000
0x0001FF50:    00000000 00000000 00000000 00000000
0x0001FF40:    00000000 00000000 00000000 00000000
0x0001FF30:    00000000 00000000 00000000 00000000
0x0001FF20:    00000000 00000000 00000000 00000000
0x0001FF10:    00000000 00000000 00000000 00000000

```


