LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

org 00h
ljmp main

org 03h
ljmp isr

org 0bh
inc r2
reti

org 20h
main:
mov sp,#0cfh
mov a,#0
mov r2,#0
mov r0,#50h
mov r1,#51h
mov th0 , #0
mov tl0 , #0
mov ie,#83h
mov ip,#01h
mov tmod, #09h
mov tcon, #11h
stay: 
sjmp stay

isr:
clr tr0
mov 52h,th0
mov 51h,tl0
mov 50h,r2
mov a,th0
cjne a,#0,cont
sjmp first_entry
cont:
lcall disp_6x
first_entry:
mov r2,#0
mov th0,#0
mov tl0,#0
setb tr0
mov a,#1
reti

;------------------display_codes--------------------------------
disp_6x:
push 0e0h
push 1
push 0
push 3
;mov 50h,#12h
;mov 51h,#34h
;mov 52h,#56h
lcall bin2ascii
lcall lcd_init
lcall delaylcd
mov a,#80h
;lcall lcd_command
lcall delaylcd
mov dptr,#count
lcall lcd_sendstring
lcall delaylcd
lcall delaylcd
mov a,#089h
;lcall lcd_command
lcall delaylcd
;mov dptr,#count
;lcall lcd_sendstring
lcall delaylcd
;mov a,#08ah
lcall lcd_command
mov r3,#6
mov r1,#60h
next_num:
mov a,@r1
lcall delaylcd
lcall lcd_senddata
mov r0,#2
lcall delay_min
lcall delaylcd
inc r1
djnz r3,next_num
mov r0,#2
lcall delay
lcall clrlcd
mov r0,#2
lcall delay
pop 3
pop 0
pop 1
pop 0e0h
ret
;----------------------------------------------------------------
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
	mov r3,#3
	mov r1,#50h
	mov r0,#60h
	new_number:
	mov a,@r1
	anl a,#0f0h
	swap a
	lcall convert
	mov @r0,a
	inc r0
	mov a,@r1
	anl a,#0fh
	lcall convert
	mov @r0,a
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
		 lcall delaylcd
         clr   LCD_en
         
		 lcall delaylcd
		 ret
		 
	lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delaylcd
         clr   LCD_en
	     lcall delaylcd

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delaylcd
         clr   LCD_en
         
		 lcall delaylcd
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delaylcd
         clr   LCD_en
         
		 lcall delaylcd

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift   ;change made!!
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delaylcd
         clr   LCD_en

		 lcall delaylcd
         
         ret                  ;Return from routine
		 
	 lcd_command:
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 ;mov   LCD_data,A     ;Move the command to LCD port
		 lcall delaylcd
         clr   LCD_en
		 lcall delaylcd
    
         ret 

	 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 lcall delaylcd
         clr   LCD_en
         lcall delaylcd
		 lcall delaylcd
         ret                  ;Return from busy routine	
	lcd_sendstring:
	 push 0e0h
	 lcd_sendstring1:
         clr   a                 ;clear Accumulator for any previous data
         movc  a,@a+dptr         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         lcall lcd_senddata      ;send first char
         inc   dptr              ;increment data pointer
         sjmp  LCD_sendstring1    ;jump back to send the next character
	exit:pop 0e0h
         ret                     ;End of routine	

;------------- ROM text strings---------------------------------------------------------------
count:
         DB   "COUNT IS: ", 00H
pulse:
		 DB   "PULSE WIDTH:", 00H
end