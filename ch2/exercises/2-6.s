! Find a zero of
!
!   y = 3x^4 - 17x^3 + 14x^2 - 23x + 15
! 
! by starting with x = 10 and decrementing.
!
! Register assignments:
!
!   %l0 = y
!   %l1 = x
!   %l2 = x^2 
!   %l3 = x^3
!   %l4 = x^4 
!   %l5 = 3x^4
!   %l6 = 17x^3
!   %l7 = 14x^2
!
!   %i0 = 23x 

        .global main

main:

          mov    10, %l1     ! x = 10
        
loop:
        smul    %l1, %l1, %l2     ! %l2 = x^2
        smul    %l2, %l1, %l3     ! %l3 = x^3
        smul    %l3, %l1, %l4     ! %l4 = x^4

        smul      3, %l4, %l5     ! %l5 =  3x^4
        smul     17, %l3, %l6     ! %l6 = 17x^3
        smul     14, %l2, %l7     ! %l7 = 14x^2
        smul     23, %l1, %i0     ! %i0 = 23x

        sub     %l5, %l6, %l0     ! y  = 3x^4 - 17x^3
        add     %l0, %l7, %l0     ! y += 14x^2
        sub     %l0, %i0, %l0     ! y -= 23x
        add     %l0,  15, %l0     ! y += 15

test:
        ! "Your program should include a specific check so that x is not
        ! decremented below zero." 
        !cmp     %l1, 0            ! x == 0?
        tst     %l1
        be      end

        !cmp     %l0, 0 
        tst     %l0
        bnz,a  loop
        dec     %l1               ! x--

end:        
        nop
        

