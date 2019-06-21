! Write a program to extract a field from register %l0. The position of 
! the least significant bit is to be specified in register %l2 and the
! number of bits in the field in register %l3. The result of executing 
! your program is to extract the field specified from register %l0,
! storing the field in %l1. 

.global main

main:

    mov 0x0123, %l0
    sll %l0, 16, %l0
    or  %l0,  1, %l0      ! Store the number in l0

    mov 16,         %l2   ! Position of the lsb
    mov 12,          %l3   ! number of bits

    mov 32,         %o0

    add %l2, %l3, %l4
    sub %o0, %l4, %l5
    sll %l0, %l5, %l1
    sub %o0, %l3, %l5
    srl %l1, %l5, %l1

    

    

