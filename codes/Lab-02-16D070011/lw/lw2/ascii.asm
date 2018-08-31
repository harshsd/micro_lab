org 00h
ljmp main
org 100h
	
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
	
	main:
	mov 50h,#3
	mov 51h,#60h
	mov 52h,#70h
	mov 60h,#12h
	mov 61h,#9ah
	mov 62h,#0efh
	lcall bin2ascii
	here:sjmp here
	end