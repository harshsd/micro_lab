org 00h
ljmp main
org 100h
	
	sqrt: ;sqrt in a. else higher nibble in a.input in r0
	;mov 5,#0
	mov a,r0
	cjne a,#0,non_zero
	;mov 5,#1
	ret
	non_zero:
	mov r1,#16
	loop: mov a,r0
	mov b,r1
	div ab
	subb a,r1
	jnz not_square
	mov a,b	
	cjne a,#0,not_square
	mov a,r1
	swap a	
	ret
	not_square:
	djnz r1,loop
	mov a,r0
	;swap a
	ret
	
	main:
	mov 50h,#0ffh
	mov r0,50H
	lcall sqrt
	mov p1,a
	stay: sjmp stay
	end