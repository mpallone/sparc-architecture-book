! Write a program to initialize each element of an array
! 
!     int fact[6];
! 
! to the factorial of the subscript.

    .global main

main:

    ! Initialize frame and stack pointers.
    sethi %hi(0x20000), %sp  ! Assume 0x20000 is the top of memory
    save %sp, -120, %sp

    ! Save a pointer to the first element into %l0
    sub %fp, 24, %l0

    ! Save a pointer to the last element into %l7
    sub %fp, 4, %l7

    ! %l1: the current element. Start at the beginning of the list.
    mov %l0, %l1

outerloop:
    
    ! The outerloop will walk through each element
    ! in the list; the innerloop will calculate the
    ! factorial for the current element.    

    ! See if we're finished.
    cmp %l1, %l7
    bg done
    nop

    ! Calculate the current subscript into %l2
    sub %l1, %l0, %l2
    udiv %l2, 4, %l2

    ! We will accumulate the factorial into %l3
    mov %l2, %l3

    ! Special case: 0! = 1
    cmp %l3, 0
    be,a end_of_innerloop
    mov 1, %l3
    
innerloop:
 
    ! If %l2 is 1 or 0, then no calculation is necessary.
    cmp %l2, 1
    ble end_of_innerloop
    nop

    ! Accumulate the factorial into %l3
    sub %l2, 1, %l2
    umul %l3, %l2, %l3

    ba innerloop
    nop

end_of_innerloop:

    st %l3, [%l1]

    ! Advance %l1 to point to the next element
    add %l1, 4, %l1 

    ba outerloop
    nop

done:
    nop  
