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

	delay: ;adds delay equal to D/2 seconds where D is stored in r0
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
	
	setleds:
	setb p1.7
	setb p1.6
	setb p1.5
	setb p1.4
	ret
	
	clrleds:
	clr p1.7
	clr p1.6
	clr p1.5
	clr p1.4
	ret
	
	readNibble: ;moves nibble to @r1
	using 0
	push ar0	
	lcall setleds
	mov r0,#10
	lcall delay
	lcall clrleds
	mov r0,#2
	lcall delay
	mov a,p1
	anl a,#0fh
	mov b,a
	swap a
	add a,#0fh
	mov p1,a
	mov r0,#10
	lcall delay
	;mov r0,#2
	;mov a,p1
	;anl a,#0fh
	;cjne a,#0fh,readNibble
	jnb p1.0,readNibble
	;setb p1.7
	mov @r1,b
	pop ar0
	ret
	
	packNibbles:
	mov a,4eh
	swap a
	add a,4fh
	mov 50h,a
	ret
	
	main:
	mov r1,#4eh
	lcall readNibble
	inc r1
	lcall readNibble
	lcall packNibbles
	lcall clrleds
	stay: sjmp stay
	end