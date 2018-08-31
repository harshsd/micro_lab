org 00h
ljmp main
org 0bh
	clr tr0
	clr tf0
	mov th0 , @r0
	mov tl0 , @r1
	cpl p1.7
	setb tr0
	reti
org 100h
	update:
	mov a,@r1
	cpl a
	add a,#1
	mov @r1,a
	mov a,@r0
	cpl a
	addc a,#0
	mov @r0,a
	ret
	main:
	mov p1,#0
	mov r0,#81h
	mov r1,#82h
	mov @r0,#0A0h
	mov @r1,#00h
	acall update
	mov tmod, #01h
	mov ie , #82h
	mov th0 , #0ffh
	mov tl0 , #0ffh
	setb tr0
	stay: sjmp stay
	end