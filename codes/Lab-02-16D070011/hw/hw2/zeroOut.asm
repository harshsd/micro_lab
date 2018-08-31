org 00h
ljmp main
org 100h
	
	zeroOut:
	using 0
	push ar0
	push ar1
	mov r0,50h
	mov r1,51h
	loop:
	mov @r1,#0
	inc r1
	djnz r0,loop
	pop ar1
	pop ar0
	ret
	
	main:
	lcall zeroOut
	stay: sjmp stay
	end