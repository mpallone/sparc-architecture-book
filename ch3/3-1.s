! l0: the number 1365, in ASCII.
! l1: l0, but in binary.

        .global main

main:
        
         ! Put ASCII 1365 into a register. 
         mov    0x31,  %l0 
         sll     %l0,    8,  %l0
         or      %l0, 0x33,  %l0
         sll     %l0,    8,  %l0
         or      %l0, 0x36,  %l0
         sll     %l0,    8,  %l0
         or      %l0, 0x35,  %l0

         ! Accumulate the number into %l1.
         and     %l0, 0xFF,  %l1     ! Put the first digit into %l1
         sub     %l1, 0x30,  %l1

         srl     %l0,    8,  %l2     ! Put the second digit into %l1
         and     %l2, 0xFF,  %l2
         sub     %l2, 0x30,  %l2
         smul    %l2,   10,  %l2
         add     %l2,  %l1,  %l1
         
         srl     %l0,   16,  %l2     ! Put the third digit into %l1
         and     %l2, 0xFF,  %l2
         sub     %l2, 0x30,  %l2
         smul    %l2,  100,  %l2
         add     %l2,  %l1,  %l1

         srl     %l0,   24,  %l2     ! Put the fourth digit into %l1
         and     %l2, 0xFF,  %l2
         sub     %l2, 0x30,  %l2
         smul    %l2, 1000,  %l2
         add     %l2,  %l1,  %l1



        nop
