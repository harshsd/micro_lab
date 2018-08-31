org 00h
ljmp main
org 100h
	delay_timer0:
	using 0
	push 0e0h
	clr c
	mov a,@r1
	cpl a
	add a,#1
	mov tl0,a
	mov a,@r0
	cpl a
	addc a,#0h
	mov th0,a
	setb tr0
	check: jnb tf0, check
	clr tr0
	clr tf0
	pop 0e0h
	ret
	
	second_delay:
	mov r4,#31
	back: acall delay_timer0
	djnz r4,back
	ret
	
	led_blink:
	inc r5
	cpl p1.7
	acall second_delay
	sjmp led_blink
	
	main:
	mov r5,#0
	mov r0,#81h
	mov r1,#82h
	mov @r0,#0fbh
	mov @r1,#0ffh
	mov tmod, #01h
	mov p1,#0
	sjmp led_blink
	stay: sjmp stay
	end