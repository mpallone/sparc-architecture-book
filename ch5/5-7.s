! You are to translate the following C code into assembly language. All variables
! are to be allocated space on the stack using local_var and var macros. For
! program entry you are to use begin_main and end_main macros. In the program
! you are to use only registers %o0 and %o1. All variables are to be accessed from
! the stack such that at any time during program execution the latest values of the
! variables are located on the stack. You are to execute the statements in the order
! given. Do not try to optimize your code.
!
!     char ca;
!     short sb;
!     int ic;
!     char cd;
!     short se;
!     int ig;
!
!     ca = 17;
!     cd = ca + 23;
!     ic = -63 + ca;
!     ig = ic + cd;
!     sb = ic / ca;
!     se = cd * sb + ic;

    .global main

main:

    ! Initialize stack and frame pointers
    sethi %hi(0x20000), %sp ! Assume 0x20000 is the top of the stack
    save %sp, -92, %sp

    ! Variable locations:
    !     ca: %fp - 24
    !     cd: %fp - 20
    !     ic: %fp - 16
    !     ig: %fp - 12
    !     sb: %fp -  8
    !     se: %fp -  4

    mov 17, %l0
    st %l0, [%fp - 24]
