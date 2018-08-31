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
	
	delay: ;delay of D/4 s
	using 0
	push ar0
	push ar4
	;mov r0, #2h
	outer:
	mov r4,#5
	inner:
	lcall delay_min
	djnz r4,inner
	djnz r0,outer
	pop ar4
	pop ar0
	ret	
	
	main:
	mov a,p1
	anl a,#0fh
	mov r0,a
	clr a
	tikde: lcall delay
	add a,#01h
	swap a
	anl a,#70h
	mov p1,a
	swap a
	sjmp tikde
	stay: sjmp stay
	end