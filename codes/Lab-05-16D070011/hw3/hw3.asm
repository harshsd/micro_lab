out equ p0.3

org 00h
ljmp main
org 0bh
	clr tr0
	clr tf0
	mov th0 , @r0
	mov tl0 , @r1
	cpl out
	setb tr0
	reti
org 100h
	delay_min: ;adds delay of 5ms
	using 0
	push ar1
	push ar2
	mov r2,#20
	back1:
		mov r1,#0ffh
		back:
			djnz r1,back
		djnz r2,back1
	pop ar2
	pop ar1
	ret
	
	delay: ;330ms * value in R3
	using 0
	push ar3
	push ar4
	;mov r0, #2h
	outer:
	mov r4,#66
	inner:
	lcall delay_min
	djnz r4,inner
	djnz r3,outer
	pop ar4
	pop ar3
	ret
	
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
	main:;0.00206l
	mov p0,#0
	mov r0,#81h
	mov r1,#82h
	mov tmod, #01h
	mov ie , #82h
	mov r3,#10
	mov p1,#0
	mov r3,#3
	acall delay
	mov r3,#2
	acall koga
	acall re
	mov r3,#1
	acall sa
	mov r3,#2
	acall re
	mov r3,#1
	acall ni
	mov r3,#3
	acall sa
	mov r3,#1
	acall delay
	acall pa
	acall dha
	mov r3,#2
	acall sa
	mov r3,#1
	acall re
	mov r3,#2
	acall ga
	mov r3,#1
	acall ma
	mov r3,#2
	acall re
	stay: sjmp stay
	
	sa:
	mov @r0,#10h
	mov @r1,#10h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	kore:
	mov @r0,#0fh
	mov @r1,#0fh
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	re:
	mov @r0,#0eh
	mov @r1,#45h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	koga:
	mov @r0,#0dh
	mov @r1,#5eh
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	ga:
	mov @r0,#0ch
	mov @r1,#0d3h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	ma:
	mov @r0,#0ch
	mov @r1,#03h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	tivma:
	mov @r0,#0bh
	mov @r1,#40h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	pa:
	mov @r0,#0ah
	mov @r1,#0a8h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	kodha:
	mov @r0,#09h
	mov @r1,#0fah
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	dha:
	mov @r0,#09h
	mov @r1,#90h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	koni:
	mov @r0,#08h
	mov @r1,#0f5h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	ni:
	mov @r0,#08h
	mov @r1,#7dh
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	varcha_sa:
	mov @r0,#07h
	mov @r1,#0f1h
	acall update
	setb tr0
	acall delay
	clr tr0
	clr out
	ret
	
	end	