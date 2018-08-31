org 00h
ljmp main
org 100h
	
	bin2grey: ;Binary in R3 and Grey in R5
	using 0
	clr c
	mov a,r3
	rrc a
	xrl a,r3
	mov r5,a
	ret
	
	grey2bin: ;Grey in R3 and binary in R5
	using 0
	push ar3
	clr c
	mov r4,#07h
	mov b,r3
	loop:
		mov a,b
		rrc a
		clr c
		mov b,a
		xrl a,r3
		mov r3,a
		djnz r4,loop
	mov 5,3
	pop ar3	
	ret 	
	
	input:
	clr a
	clr c
	mov a,#07h
	jb p1.2 , b2
	subb a,#04h
	b2: jb p1.1 , b1
	subb a,#02h
	b1: jb p1.0 , b0
	subb a , #01h
	b0: ret
	
;	setbits:
;	mov r6,a
;	anl a,#04h
;	jz b6
;	setb p1.6
;	b6: mov a,r6
;	anl a,#02h
;	jz b5
;;	setb p1.5
	;b5: mov a,r6
	;anl a,#1h
	;jz b4
	;setb p1.4
	;b4: ret
	
	main:
	;setb p1.3
	;setb p1.2
	;setb p1.1
	;clr p1.0
	mov a , p1
	;sjmp input
	anl a,#07h
	mov r3,a
	jnb p1.3 , here
	;setb p1.4
	;sjmp main
	;here: clr p1.4
	lcall grey2bin
	sjmp skip
	here: lcall bin2grey
	skip: mov a,r5
	anl a,#0fh
	swap a
	;lcall setbits
	mov p1,a
	;sjmp main
	stay: sjmp stay 
	end