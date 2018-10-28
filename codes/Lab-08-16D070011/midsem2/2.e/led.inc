ORG 100H

;---------------------------
DELAY50:
PUSH 2
PUSH 1

MOV R2,#200
BACK1:
	MOV R1,#0FFH
	BACK:
		DJNZ R1, BACK
		DJNZ R2, BACK1

POP 1
POP 2
RET
;-----------------------------
DELAY5:
	PUSH 3
	
	MOV R3, #100
	LOOP4:
		LCALL DELAY50
		DJNZ R3, LOOP4
	
	POP 3
	RET
;----------------------------------	
DELAY1:
	PUSH 3
	
	MOV R3, #20
	LOOP5:
		LCALL DELAY50
		DJNZ R3, LOOP5
	
	POP 3
	RET
;----------------------------------------------------------------------

;---------------------------
CLEAR_LCD:
acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
		 
		 ret
;--------------------------------------

;---------------------------------------------------------------
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	 push 0e0h
	print_loop :
         clr   a                 ;clear Accumulator for any previous data
         movc  a,@a+dptr         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   dptr              ;increment data pointer
         sjmp  print_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine
;-----------------------------------------
lcd_sendstring_byte:  ;SENDS THE BTOA OF NUMBER AT 4BH
	 push 0e0h
	;print_loop :
      	 LCALL BTOA
         mov  a, 4CH         ;load the first character in accumulator
         ;jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
         ;inc   dptr              ;increment data pointer
         ;sjmp  print_loop    ;jump back to send the next character
		 
		 MOV A, 4DH
		 ACALL LCD_SENDDATA
;exit:    
	pop 0e0h
         ret                     ;End of routine
;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop7:	 mov r1,#255
	 loop8:	 djnz r1, loop8
	 djnz r0, loop7
	 pop 1
	 pop 0 
	 ret
;--------------------------------------Bin to ASCII-------------------
BTOA:   ;reads binary number at 4BH, writes ascii number to 4CH (MSB) AND 4DH (LSB)
	PUSH 0
	PUSH 01


	MOV R1, 4BH  ;READ ADDRESS TO THE B NUMBER
	MOV R0, #4CH  ;WRITE ADDRESS
	;LOOP6:
		MOV A, @R1
		ANL A, #0F0H
		SWAP A
		CLR C
		SUBB A, #10
		JC N
		JNC L
		L:
		LCALL LETTER
		SJMP CONTINUE
		N:
		LCALL NUMBER2

		CONTINUE:
		INC R0

		MOV A, @R1
		ANL A, #0FH
		CLR C
		SUBB A, #10
		JC N1
		JNC L1
	L1:
	LCALL LETTER1
	SJMP CONTINUE1

	N1:
	LCALL NUMBER1

	CONTINUE1:

	POP 01
	POP 0
RET
;----------------------------
LETTER:
MOV A, @R1
ANL A, #0F0H
SWAP A
ADD A, #37H
MOV @R0, A
RET
;---------------------------
NUMBER2:
MOV A, @R1
ANL A, #0F0H
SWAP A
ADD A, #30H
MOV @R0, A
RET
;----------------------------------------------------------------------
LETTER1:
MOV A, @R1
ANL A, #0FH
ADD A, #37H
MOV @R0, A
RET
;-------------------------
NUMBER1:
MOV A, @R1
ANL A, #0FH
ADD A, #30H
MOV @R0, A
RET

