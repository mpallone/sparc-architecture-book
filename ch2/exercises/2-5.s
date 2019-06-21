! Assuming that all variables are in registers
!
!   while ((a + b) * c <= x)
!   {
!     x = x - 10;
!     c = (c * a) / b;
!   }
!
!
! Register assignments:
!   
!   %l0: a
!   %l1: b
!   %l2: c
!   %l3: x 
!

        .global main
main:
        mov   6, %l0   ! a
        mov   9, %l1   ! b
        mov   3, %l2   ! c
        mov   100, %l3   ! x

        ba test
        nop

loop:
        smul    %l2, %l0, %l4       ! Compute (c * a)
        sdiv    %l4, %l1, %l2       ! Compute (c * a) / b
        
test:
        add     %l0, %l1, %l4       ! Compute (a + b)
        smul    %l4, %l2, %l5       ! Compute (a + b) * c 
        
        cmp     %l5, %l3
        ble,a   loop
        sub     %l3,  10, %l3       ! x -= 10, first instruction of loop
        
               



        nop   ! I get segfaults without this noop o.O
