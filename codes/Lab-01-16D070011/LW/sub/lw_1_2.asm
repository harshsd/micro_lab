org 0h
ljmp main
org 100h
	
main:

mov 60h,#0FFh
mov 61h,#0FFh
mov 70h,#0FCh
mov 71h,#0DEh

mov a,60h
anl a,#10000000b
rl a
mov 4,a
mov a,70h
anl a, #80h
rl a
mov 5,a

clr a
mov a,61H
subb a,71H
mov 64H,a

mov a,60H
subb a,70H
mov 63H,a

mov a,5
subb a,4
anl a,#1
mov 62h,a
loop: sjmp loop
end 