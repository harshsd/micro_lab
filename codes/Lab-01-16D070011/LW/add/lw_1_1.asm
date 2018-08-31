org 00h
ljmp main
org 100h
	
main:
mov 60h,#0FEh
mov 61h,#0BEh
mov 70h,#0FFh
mov 71h,#0FFh


mov a,60h
anl a,#10000000b
rl a
mov 4,a
mov a,70h
anl a, #80h
rl a
mov 5,a


clr a
clr c
addc a ,61h
addc a ,71h
mov 64h,a

mov a,60h
addc a,70h
mov 63h,a

clr a
addc a, r4
add a,r5
anl a,#1
mov 62h,a
loop: sjmp loop
end