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
	
	delay_250ms:
	push 1
	push 2
	reloop:mov r1,#5
	repeat:acall delay_min
	djnz r1,repeat
	djnz r2,reloop
	pop 2
	pop 1
	ret
	
	toggle:
	acall change_freq
	acall delay_250ms
	cpl p1.7
	acall toggle
	
	change_freq:
	mov b,#2
	mov a,r1
	;setb p1.3
	mov a,p1
	anl a,#08h
	mov r3,a	
	clr c
	subb a,r1
	jz exit
	mov a,r3
	mov r1,a
	mov a,r2
	div ab
	jnz divide
	mov a,#16
	divide: mov r2,a
	exit:ret
	
	main:
	mov r2,#16
	mov p1,#0Fh
	mov a,p1
	anl a,#08h
	mov r1,a
	sjmp toggle
	stay: sjmp stay	
	end