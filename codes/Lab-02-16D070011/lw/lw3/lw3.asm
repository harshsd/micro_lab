org 00h
ljmp main
org 100h
;r0,r1,r3 and a used. Also push psw if it is needed
memcpy:
using 0
push ar4
push ar0
push ar1
push ar3
mov 4,a
mov r3,50h
mov a,51h
mov r0,a
mov r1,52h
clr c
subb a,r1
jc bisgreater
loop_back_1:mov a,@r0
mov @r1,a
inc r1
inc r0
djnz r3, loop_back_1
sjmp finish
bisgreater: 
mov a,r1
add a,r3
dec a
mov r1,a
mov a,r0
add a,r3
dec a
mov r0,a
loop_back_2: mov a,@r0
mov @r1,a
dec r1
dec r0
djnz r3,loop_back_2
mov a,4
pop ar3
pop ar1
pop ar0
pop ar4
ret

main:
lcall memcpy
finish: sjmp finish
end 