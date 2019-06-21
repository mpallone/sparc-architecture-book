	.global main
main:
	mov 17, %l0               ! a = 17
	mov -3, %l1               ! b = -3
        add %l0, %l1, %l2         ! %l2 = (a + b)
        sub %l0, %l1, %l3         ! %l3 = (a - b)
        smul %l2, %l3, %l4        ! %l4 = (a + b) * (a - b)
        sdiv %l4, 3, %l5          ! divide by c
	

