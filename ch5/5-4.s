! Write a program to initialize an array
!     
!     int ary[] = {3, 4, -5, 6, 2, 0}
!
! and then to find the largest element by searching the array.


    .global main

main:

    ! Initialize frame and stack pointers. Assume 0x20000 is the top of memory.
    !sethi  %hi(0x20000), %fp   ! <-- unnecessary, 'save' will set fp
    sethi  %hi(0x20000), %sp
    save %sp, -120, %sp
   
    ! Initialize the array.
    mov     3, %l0
    st      %l0, [%fp - 24]

    mov     4, %l0
    st      %l0, [%fp - 20]

    mov     -5, %l0    
    st      %l0, [%fp - 16]
    
    mov      6, %l0
    st      %l0, [%fp - 12]

    mov     2, %l0
    st      %l0, [%fp -  8]
 
    mov      0, %l0
    st      %l0, [%fp - 4]

    
    ! Find the largest element by searching the array.  

    ! %l0: largest element
    ! %l2: offset of current element

    mov 24, %l2

    ! Assume the first element is the largest.
    ld  [%fp - 24], %l0


loop:
    cmp %l2, %g0 
    be done

    sub %fp, %l2, %l3
    ld  [%l3], %l4

    cmp %l0, %l4
    ble,a 1f
    mov %l4, %l0 
1: 
   ba loop 
    sub %l2, 4, %l2        

done:
    nop

    
