org 00h
ljmp main
org 100h
	
	exchange:;check and sort numbers in @r0 and @r1
	mov a,@r0
	xrl a,@r1
	anl a,#80h
	cjne a,#80h,same_sign
	mov a,@r0
	anl a,#80h
	cjne a,#80h,change
	sjmp exit
	same_sign:
	mov a,@r0
	clr c
	subb a,@r1
	jc exit
	change: mov a,@r0
	xch a,@r1
	mov @r0,a
	exit:ret
	
	sort:
	mov r3,#05h
	outer:mov r0,#50h
	mov r1,#51h
	mov r2,#05h
	again:acall exchange
	inc r0
	inc r1
	djnz r2,again
	djnz r3,outer
	ret
	
	
	main:
clr c	
mov 50h,#040h
mov 51h,#020h
mov 52h, #080h
mov 53h, #0ach
mov 54h, #0bdh
mov 55h, #0deh
acall sort
stay:sjmp stay
end