org 00h
ljmp main
org 100h
	
	
	factorial: ;r2 has n, r3 answer
	clr a
	orl a,r2
	jz skip
	push 2
	dec r2
	acall factorial
	pop 2
	mov a,r2
	mov b,r3
	mul ab
	mov r3,a
	skip:
	ret
	
	main:
	mov r2,#5
	mov r3,#1
	acall factorial
	stay:sjmp stay
	end