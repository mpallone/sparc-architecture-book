! Find the maximum of 
! 
!     y = x^3 - 14x^2 + 56x - 64
! 
! in the range -2 <= x <= 8
!
!
! %l0 = x
! %l1 = temporary register
! %l2 = x^2
! %l3 = x^3
! %l4 = y
! %l5 = max
!

        .global main
main:
        ba       test
        mov      -2,   %l0          ! x = -2

loop:
        smul     %l0, %l2, %l3      ! %l3 = x^3
        
        smul     14,  %l2, %l1      ! Compute 14x^2
        sub      %l3, %l1, %l4      ! y = x^3 - 14x^2

        smul     56, %l0,  %l1      ! Compute 56x
        add      %l4, %l1, %l4      ! y += 56x

        sub      %l4, 64, %l4       ! y -= 64


        ! The first time through the loop, we can set
        ! %l5/max_value to y. Every other iteration, we
        ! need to compare against the current max.

        cmp      %l0, -2
        be       newmax             ! Use delay slot to increment x
        inc      %l0

        cmp      %l4, %l5           ! compare y to max

        ble      test               ! Don't overwrite max if <=
        nop

       

newmax:         
        mov      %l4, %l5           ! max = y 
        

test:
        cmp      %l0,  8
        ble,a    loop
        smul     %l0, %l0, %l2      ! First instruction of loop: %l2 = x^2
        
        
        nop                         ! I get a segfault if I don't have this instruction...
