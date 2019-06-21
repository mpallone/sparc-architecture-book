! 5-5 Write a program to initialize an array
! 
!         int ary[] = {3, 4, -5, 6, 2, 0}
!
! and then to sort the array, smallest element first.


    .global main

main:

    ! Initialize frame and stack pointers. Assume 0x20000 is the top of memory.
    !sethi  %hi(0x20000), %fp   ! <-- unnecessary, 'save' will set fp
    sethi  %hi(0x20000), %sp
    save %sp, -120, %sp

    ! Initialize the array.
    mov     3, %l0
    st     %l0, [%fp - 24]
    mov     4, %l0
    st     %l0, [%fp - 20]
    mov    -5, %l0
    st     %l0, [%fp - 16]
    mov     6, %l0
    st     %l0, [%fp - 12]
    mov     2, %l0
    st     %l0, [%fp -  8]
    mov     0, %l0
    st     %l0, [%fp -  4]


    ! Sort the array.


    ! %l0: address of the last element
    sub %fp, 4, %l0
    ! %l1: address of element that we're sorting
    sub %fp, 24, %l1

outerloop: ! for each element, find the smallest in the 
           ! remainder of the list, and then swap it.

    ! If we're at or past the end of the array, we're done sorting.
    cmp %l1, %l0  
    bge done
    nop

    mov %l1, %l2 ! %l2: address of the smallest element. 
    mov %l1, %l3 ! %l3: address of each element

innerloop: ! Find the smallest in the remainder of the list.
    
    ld [%l2], %l4 ! Load what's currently the smallest element into %l4
    ld [%l3], %l5 ! %l5: the value at [%l3], the element we're currently considering
    
    cmp %l4, %l5
    ble end_of_innerloop ! it's still the smallest
    nop

found_new_smallest:
    ! The value at the address in %l3 is the current smallest,
    ! so copy it into %l2
    mov %l3, %l2

end_of_innerloop:
    add %l3, 4, %l3 ! Look at the next element

    cmp %l3, %l0 ! See if we're past the end of the array
    ble innerloop
    nop

    ! If we made it here, we're done processing the innerloop,
    ! so we can do the swap. Remember that %l2 is the address
    ! of the smallest element in the remainder of the list, and
    ! %l1 is the address of the element we're currently trying
    ! to swap.
    
    ld [%l1], %l4
    ld [%l2], %l5
    st %l5, [%l1]
    st %l4, [%l2] 

    add %l1, 4, %l1 ! Prepare to sort the next element.

    ba outerloop

done:
    nop

    
