! Compute
!
!     y = 3x^4 + 5x^3 - 17x^2 + 33x - 15
!
! for x = 3.


	.global main
main:
	mov 	3, %l0	              ! x = 3
	
        smul    %l0, %l0, %l1         ! %l1 = x^2
	smul    %l1, %l0, %l2         ! %l2 = x^3
	smul    %l2, %l0, %l3         ! %l3 = x^4

        ! Compute into %l4, so that %l4 is effectively y.
	! Use %l5 as a temporary register.

        smul      3, %l3, %l4         ! %l4 = 3x^4	

	smul      5, %l2, %l5         ! Compute 5x^3
	add       %l4, %l5, %l4       ! %l4 += 5x^3

	smul      17, %l1, %l5	      ! Compute 17x^2
	sub       %l4, %l5, %l4       ! %l4 -= 17x^2
	
	smul      33,  %l0, %l5       ! Compute 33x
	add       %l4, %l5, %l4       ! %l4 += 33x


