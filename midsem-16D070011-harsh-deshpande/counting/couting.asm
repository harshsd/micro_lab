org 00h
ljmp main

org 100h

num_of_ones: ;number in R3 and result in R4
push 5
push 3
mov r5,#8
mov r4,#0
next_bit:mov a,r3
rrc a
mov r3,a
mov a,r4
addc a,#0
mov r4,a
djnz r5,next_bit
pop 3
pop 5
ret

find_z_and_o:
push 0
push 1
push 2
push 6
mov r2,#0
mov r0,#50h
mov r1,#60h
mov r6,#5
next_num:mov a,@r0
mov r3,a
acall num_of_ones
mov a,r2
add a,r4
mov r2,a
inc r0
djnz r6,next_num
;mov a,r2
mov @r1,2h
mov a,#40
clr c
subb a,r2
inc r1
mov @r1,a
pop 6
pop 2
pop 1
pop 0
ret

main:
mov 50h,#0A5h
mov 51h,#00h
mov 52h,#97h
mov 53h,#38h
mov 54h,#29h
acall find_z_and_o
stay:sjmp stay
end