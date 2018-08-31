led equ p1

org 00h
ljmp main
org 100h
	
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
	mov r1,#51h
	loop:
	mov a,@r1
	anl a,#0fh
	rr a
	rr a
	rr a
	rr a
	mov led,a
	lcall delay
	inc r1
	djnz r0,loop
	mov a,2
	pop ar2
	pop ar1
	pop ar0
	ret
	
	main:
	mov 50h , #3h
	mov 51h , #05h
	mov 52h , #0ah
	mov 53h , #0fh
	lcall display
	stay:sjmp stay
	end