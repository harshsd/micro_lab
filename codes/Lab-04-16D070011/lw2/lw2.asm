LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

org 00h
ljmp main
org 100h
;-----------------delay codes-----------------------------------
	delay_min: ;adds delay of 50ms
	using 0
	push ar1
	push ar2
	mov r2,#200
	back1:
		mov r1,#0ffh
		back:
			djnz r1,back
		djnz r2,back1
	pop ar2
	pop ar1
	ret

	delay: ;adds delay equal to D/2 seconds where D is stored in r0
	using 0
	push ar0
	push ar4	
	outer:
	mov r4,#10
	inner:
	lcall delay_min
	djnz r4,inner
	djnz r0,outer
	pop ar4
	pop ar0
	ret
;------------------------bin2ascii codes-----------------------
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
	
	bin2ascii:   ;ascii codes pushed into r6 and r7
	using 0
	push ar0
	push ar1
	push ar3
	;push here
	;mov r3,#16 					;change made!!
	;mov r0,52h ;read pointer	;change made!!
	;mov r1,53h ;write pointer	;change made!!
	;new_number:
	mov a,@r1
	anl a,#0f0h
	swap a
	lcall convert
	mov r6,a
	;inc r1
	mov a,@r1
	anl a,#0fh
	lcall convert
	mov r7,a
	inc r1
	inc r0
	;djnz r3,new_number
	;pop here
	pop ar3
	pop ar1
	pop ar0
	ret

;------------------lcd display functions---------------------
	;----------------------lcd delay-----------------------
delaylcd:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret
;---------------------------------------------------------
;----------------------------------LCD codes----------------------------------------------
	clrlcd:
		 mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delaylcd
         clr   LCD_en
         
		 acall delaylcd
		 ret
		 
	lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delaylcd
         clr   LCD_en
	     acall delaylcd

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delaylcd
         clr   LCD_en
         
		 acall delaylcd
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delaylcd
         clr   LCD_en
         
		 acall delaylcd

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift   ;change made!!
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delaylcd
         clr   LCD_en

		 acall delaylcd
         
         ret                  ;Return from routine
		 
	 lcd_command:
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 ;mov   LCD_data,A     ;Move the command to LCD port
		 acall delaylcd
         clr   LCD_en
		 acall delaylcd
    
         ret 

	 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delaylcd
         clr   LCD_en
         acall delaylcd
		 acall delaylcd
         ret                  ;Return from busy routine
;---------------------------------------one-time-display-----------------------------------		 
	display4:
	;push 05h
	mov r5,#4
	four_loop:
	acall bin2ascii
	mov a,r6
	acall lcd_senddata
	acall delaylcd
	mov a,r7
	acall lcd_senddata
	acall delaylcd
	inc r1
	djnz r5,four_loop
	;pop 05h
	ret
;------------------------------------mem-initialilze----------------------------------
	mem_initialize:
	push 0
	push 1
	mov r0,#0a0h
	mov r1,#020h
	big_loop:
	mov a,r1
	mov @r1,a
	inc r1
	djnz r0,big_loop
	pop 1
	pop 0
	ret
;-----------------------------------------mem-initialize1------------------------------
	mem_initialize1:
	mov r2,#0e0h
	mov r1,#020h
	againn:mov a,r1
	mov @r1,a
	inc r1
	djnz r2,againn
	ret
;------------------------------------------clear leds--------------------------------
	clrleds:
	clr p1.7
	clr p1.6
	clr p1.5
	clr p1.4
	ret
;----------------------------------------main program---------------------------------
	main:
	acall delaylcd
	mov SP,#07h
	acall mem_initialize1
	endless:
	mov p1,#0ffh
	mov r0,#2h
	acall delay
	mov a,p1
	acall clrleds
	swap a
	anl a,#0f0h
	mov r1,a
	;acall bin2ascii
	mov r4,#02h
	repeat_again:
	acall lcd_init
	;acall delaylcd
	mov LCD_data,#083h	;doesnt work
	acall lcd_command
	mov LCD_data,#083h
	acall lcd_command
	acall display4
	mov LCD_data,#0c3h
	acall lcd_command
	acall display4
	mov r0,#10
	acall delay
	djnz r4,repeat_again
	sjmp endless
	end