org 00h
ljmp main
org 100h
	
	lower_nibble:
	mov a,51h
	mov b,61h
	mul ab
	mov 73h,a
	mov 72h,b
	clr c
	ret
	
	middle_nibble:
	mov a,@r0
	mov b,@r1
	mul ab
	add a,72h
	mov 72h,a
	mov a,71h
	addc a,b
	mov 71h,a
	jnc exit
	inc 70h
	exit:clr c
	ret
	
	upper_nibble:
	mov a,60h
	mov b,50h
	mul ab
	add a,71h
	mov 71h,a
	mov a,70h
	addc a,b
	mov 70h,a
	ret
	
	main:
	mov 50h,#0ffh
	mov 51h,#0ffh
	mov 60h,#0ffh
	mov 61h,#0ffh
	mov 70h,#0
	mov 71h,#0
	mov 72h,#0
	mov 73h,#0
	acall lower_nibble
	mov r0,#50h
	mov r1,#61h
	acall middle_nibble
	mov r0,#51h
	mov r1,#60h
	acall middle_nibble
	acall upper_nibble
	stay: sjmp stay
	end	