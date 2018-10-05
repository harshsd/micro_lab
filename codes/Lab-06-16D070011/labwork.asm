LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
org 00h
ljmp main
org 003Bh
using 0	
push ar3	
ljmp check_key
;mov r0,#4
;acall delay
;mov a,9eh
;mov p1,#0f0h
;reti
;sttay:sjmp sttay
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
;----------------------------main  program--------------------------

	main:
	mov sp,#0c0h
	mov r0,#2
	acall delay
	acall lcd_init
	acall delaylcd
	acall clrlcd
	acall delaylcd
	mov LCD_data,#80h
	acall delaylcd
	acall lcd_command
	;mov a,#0
	;mov 9eh,a
	;------- keypad configuration------------
	mov p1,#0f0h		;LSB as row, MSB as column									
	setb IE.7
	
	mov a,0b1h		;IEN1, interrupt enable register
	ORL a,#01		;changing only the required bit, without changing the other bits
	mov 0b1h,a			

	mov 9cH,#0Fh		;KBLS (level selector), MSB as row, LSB as column
	mov 9dH,#0f0h		;KBE (Keyboard enable) LSB as interrupt, MSB as I/O


	;For more information about KBE, KBLS, KBF read the datasheet from page no. 84
;----------------------------------------
	mov r3,#65
	mov r1,#16
	next_char:mov a,r3
	acall lcd_senddata
	inc r3
;	ljmp 003bh
	acall delay
	djnz r1 , next_char
	sjmp main
	
org 200h
;---------------------------------check which key is pressed-----------------------
	check_key:
	push 0e0h
	push 0
	;--------------debouncing part--------------------------------------
	mov p1,#0f0h
	acall delaylcd
	mov a,p1
	anl a ,#0f0h
	cjne a,#0f0h,no_bounce
	ljmp exit_int
	;-----------------------------finding row and column------------------------------
	no_bounce:
	;mov p1,#00h
	;mov r0,#10
	;acall delay
	xrl a,#0fh
	mov p1,a
	acall delaylcd
	mov a,p1
	cpl a
	mov r5,a
	anl a,#0fh
	acall log2
	mov r6,a
	mov a,r5
	anl a,#0f0h
	swap a
	acall log2
	mov b,#4
	mul ab
	add a,r6
	mov r5,a
	subb a,#10
	mov a,r5
	jc less_than_A
	add a,#55
	sjmp next
	less_than_A: 
	add a,#48
	;swap a
	;mov b,#4
	;mul ab
	;add a,r6	;index stored in r6 ;change here if needed
	;add a,#30h
	;-----------display the key code--------------------
	next:
	acall clrlcd
	acall delaylcd
	acall lcd_init
	acall delaylcd
	acall delaylcd
	acall lcd_senddata
	acall delaylcd
	mov r0,#6
	acall delay
	acall clrlcd
	acall delaylcd
	;---------------exit--------------------
	exit_int:
	pop 0
	pop 0e0h
	pop ar3
	push 0e0h
	push 0
	mov a,r3
	add a,#3fh
	;mov a,#87h
	mov LCD_data,a
	acall delaylcd
	acall delaylcd
	acall lcd_command
	acall delaylcd
	acall delaylcd
	mov LCD_data,a
	acall delaylcd
	acall delaylcd
	acall lcd_command
	mov a,9Eh
	keep_checking:mov p1,#0f0h
	mov a,p1
	cjne a,#0f0h,keep_checking
	exited:pop 0
	mov a,9Eh
	pop 0e0h
	reti
	
	log2:
	push 0
	mov r0,#0
	divide_again:mov b,#2
	div ab
	inc r0
	jnz divide_again
	dec r0
	mov a,r0
	pop 0
	ret
	end