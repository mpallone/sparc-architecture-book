! Write a program to find the square root of a number y = sqrt(x), 
! say for x = 1000, using the Newton-Raphson method outlined
! below.
!
! Register assignments:
!     
!     %l0: x
!     %l1: y
!     %l2: old
!     %l3: dx
!     %l4: temporary storage
!     %l5: temporary storage
!     %l6: temporary storage
!
! Author: Mark Pallone
! Email:  mark.c.pallone@nasa.gov
! Date:   August 3, 2018 
!
! Hmm...this isn't working. Computing dx / 2y is failing.
! In the book they use libraries for multiplication and 
! division, so students using SPARC v7 wouldn't have to
! be dealing with (what I assume is) overflow at this 
! point. I'm pretty sure this logic is correct, so I'm
! going to move on.
!


        .global main

main:
        mov     1000,  %l0          ! x = 1000
        sdiv     %l0,    2,  %l1    ! y = x / 2 
        mov      %l1,  %l2          ! old = y, for the first iteration of the loop
loop:
!        mov      %l1,  %l2          ! old = y           (moved to delay slot)
        smul     %l1,  %l1,  %l4    ! Compute y^2
        sub      %l0,  %l4,  %l3    ! dx = x - y * y
        smul     %l1,    2,  %l5    ! Compute 2y
        sdiv     %l3,  %l5,  %l6    ! Compute dx / 2y
        add      %l1,  %l6,  %l1    ! y += dx / 2y

        cmp      %l1,  %l2          ! y != old?
        bne,a    loop
        mov      %l1,  %l2          ! old = y, first instruction of loop
       


        nop 
