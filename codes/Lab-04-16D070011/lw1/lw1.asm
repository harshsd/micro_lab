LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

org 00h
ljmp main
org 100h

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
	
	bin2ascii:
	using 0
	push ar0
	push ar1
	push ar3
	;push here
	mov r3,50h
	mov r0,52h ;read pointer
	mov r1,53h ;write pointer
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
		 acall delay
         clr   LCD_en
         
		 acall delay
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
		 acall delay
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
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delaylcd
    
         ret 

	 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delaylcd
		 acall delaylcd
         ret                  ;Return from busy routine
;------------------read helper functions---------------------
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
	
	setleds:
	setb p1.7
	setb p1.6
	setb p1.5
	setb p1.4
	ret
	
	clrleds:
	clr p1.7
	clr p1.6
	clr p1.5
	clr p1.4
	ret
;--------------take inputs  --------------------------------
	readNibble: ;moves nibble to @r1
	using 0
	push ar0
	push ar2
	readNibbleloop:
	lcall setleds
	mov r0,#10
	lcall delay
	lcall clrleds
	mov r0,#2
	lcall delay
	mov a,p1
	anl a,#0fh
	mov b,a
	swap a
	add a,#0fh
	mov p1,a
	mov r0,#10
	lcall delay
	jnb p1.0,readNibbleloop
	lcall clrleds
	mov r0,#2
	lcall delay
	mov @r1,b
	pop ar2
	pop ar0
	ret
	
	packNibbles: ;moves 4eh and 4fh to @r0
	push 0e0h
	mov a,4eh
	swap a
	add a,4fh
	mov @r0,a
	pop 0e0h
	ret

;--------------------read the data---------------------------------------------------
	readvalues:
	mov r2,50h
	mov r0,51h
	new_number1:mov r1,#4eh
	acall readNibble
	inc r1
	acall readNibble
	acall packNibbles
	inc r0
	djnz r2,new_number1
	acall clrleds
	ret
	
;-----------------------------display two digit number code -------------------------------
	display_values:
	;-----------------display on lcd. never exits---------------------------------------------
	mov r0,#2h
	acall delay ;delay for lcd power-up
	mov P2,#00h
    mov P1,#00h
	infinite_loop:
	acall lcd_init ;initialize lcd
	acall delaylcd
	acall delaylcd
	mov a,#83h
	acall lcd_command
	acall delaylcd
	;-----------------------------read the switches-------------------------------------------
	mov p1,#0ffh
	mov r0,#2h
	acall delay
	mov a,p1
	acall clrleds
	anl a,#0fh
	mov r4,a
	clr c
	subb a,50h
	jnc wrong_index
	mov a,r4
	add a,r4
	add a,53h
	mov r1,a
	mov a,@r1
	acall lcd_senddata
	acall delaylcd
	inc r1
	mov a,@r1
	acall lcd_senddata
	mov r0,#4h
	sjmp wait
	wrong_index: acall clrlcd
	wait:acall delay
	sjmp infinite_loop
	ret

;------------------------shuffle bits program---------------------------------------
	shuffleBits:
	using 0
	push ar0
	push ar1
	push ar2
	push ar3
	push 0e0h
	mov r2,50h
	mov r1,51h
	mov r0,52h
	dec r2
	loop_back: mov a,@r1
	inc r1
	xrl a,@r1
	mov @r0,a
	inc r0
	djnz r2,loop_back
	mov a,@r1
	mov r1,51h
	xrl a,@r1
	mov @r0,a
	pop 0e0h
	pop ar3
	pop ar2
	pop ar1
	pop ar0
	ret
;-------------------------main program-----------------------------------------------
	main:
	mov sp,#0cfh
	mov 50h,#2
	mov 51h,#60h
	mov 52h,#70h
	mov 53h,#40h
;--------------------------read in numbers------------------------------------------
	acall readvalues
;-----------------------------compute the second array and store in loc stored at 52h-------------
	acall shuffleBits
;--------------------------------convert the new numbers to their ascii values-------------------
	acall bin2ascii
;------------------------------display values-----------------------------------------------
	acall display_values
	stay: sjmp stay
	end