! Write a program in assembly language to generate each of the 16 possible
! states shown in the table on page 108, using one or two machine
! instructions, each with operands 0011 and 0101.

.global main

main:

        mov     3,   %o1      ! 0011 
        mov     5,   %o2      ! 0101

! 0000
        sub   %o2, %o1, %o0
        and   %o2, %o0, %o0
       

! 0001
        and   %o1, %o2, %o0

! 0010
        sub   %o2, %o1, %o0

! 0011
           

! 0100

! 0101

! 0110

! 0111

! 1000

! 1001

! 1010

! 1011

! 1100

! 1101

! 1110

! 1111

