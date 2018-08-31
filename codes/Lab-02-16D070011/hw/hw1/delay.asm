led equ p0
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
	outer:
	mov r4,#10
	inner:
	lcall delay_min
	djnz r4,inner
	djnz r0,outer
	pop ar4
	pop ar0
	ret
	
	main:
	mov led,#00h
	mov r0,4fh
	endless:
	mov a,#80h
	mov p0,a
	lcall delay
	mov a,#0
	mov p0,a
	lcall delay
	sjmp endless
	end	