led equ p1

org 00h
ljmp main
org 100h
	
	zeroOut:
	using 0
	push ar0
	push ar1
	mov r0,50h
	mov r1,51h
	loop:
	mov @r1,#0
	inc r1
	djnz r0,loop
	pop ar1
	pop ar0
	ret	
	
		convert:
	mov b,a
	clr c
	subb a,#0ah
	mov a,b
	jc is_int
	add a,#55
	jmp skip
	is_int:
	add a,#30h
	skip:ret
	
	bin2ascii:
	using 0
	push ar0
	push ar1
	push ar3
	;push here
	mov r3,50h
	mov r0,51h ;read pointer
	mov r1,52h ;write pointer
	new_number:
	mov a,@r0
	anl a,#0f0h
	swap a
	lcall convert
	mov @r1,a
	inc r1
	mov a,@r0
	anl a,#0fh
	lcall convert
	mov @r1,a
	inc r1
	inc r0
	djnz r3,new_number
	;pop here
	pop ar3
	pop ar1
	pop ar0
	ret
	
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
finish:mov a,4
pop ar3
pop ar1
pop ar0
pop ar4
ret

	delay_min: ;adds delay of 50ms
	using 0
	push ar1
	push ar2
	mov r2,#200
	back1:
		mov r1,#0ffh
		back:
			djnz r1,back
		djnz r2,back1
	pop ar2
	pop ar1
	ret
	
	delay:
	using 0
	push ar0
	push ar4
	mov r0,#02h	
	outer:
	mov r4,#10
	inner:
	lcall delay_min
	djnz r4,inner
	djnz r0,outer
	pop ar4
	pop ar0
	ret	
	
	display:
	using 0
	push ar0
	push ar1
	push ar2
	mov 2,a
	mov r0,50h
	mov r1,51h
	loop1:
	mov a,@r1
	anl a,#0fh
	swap a
	mov led,a
	lcall delay
	inc r1
	djnz r0,loop1
	mov led,#0
	mov a,2
	pop ar2
	pop ar1
	pop ar0
	ret
	
	main:
mov sp,#0cfh

mov 50h,#4
mov 51h,#70h
lcall zeroOut

mov 50h,#4
mov 51h,#75h
lcall zeroOut

mov 50h,#2
mov 51h,#60h
mov 52h,#70h
lcall bin2ascii

mov 50h,#4
mov 51h,#70h
mov 52h,#75h
lcall memcpy

mov 50h,#4
mov 51h,#75h
mov 4fh,#2
lcall display

here:SJMP here
end