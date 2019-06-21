	.global main
main:
	save %sp, -96, %sp
	mov 9, %l0		!initialize x
	sub %l0, 1, %o0		!(x - 1) into %o0
	sub %l0, 7, %o1		!(x - 7) into %o1
	smul %o0, %o1, %o0	!I'm adding here instead of multiplying
        mov %o0, %l2
	nop
	sub %l0, 11, %o1	!(x - 11) into %o1, the divisor (which I guess I won't be dividing with...)
	mov %o1, %l2
	sdiv %o0, %o1, %o0	!I'm adding here instead of dividing
	nop
	mov %o0, %l1		!Store it in y
	mov 1, %g1	 	!trap dispatch
	!ta  0			!trap to system
