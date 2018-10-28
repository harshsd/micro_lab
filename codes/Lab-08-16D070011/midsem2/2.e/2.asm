$INCLUDE(led.inc)
ORG 00H
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
ORG 0000H
LJMP MAIN		

ORG 0003H                  
LJMP ISR_EX0                ;jump to ISR of external interrupt

ORG 000BH                  
LJMP ISR_T0                ;jump to ISR



;--The main program for initialization

    
ORG 500H                 ; after vector tablespace
		

MAIN:
    MOV TH0,#0
	MOV TL0,#0
	
	MOV TMOD,#09H ;mode 1 
	MOV R2,#0
	MOV R5,#0
	MOV R6,#0
	MOV TCON,#11H
	MOV IE,#83H
	;SETB TR0
	HERE: SJMP HERE


BACK_Z: SJMP BACK_Z          




; Timer 0 ISR. Must be reloaded, not auto-reload

ORG 800H
SHOW_PULSE:
		lcall delay
		lcall delay
		lcall lcd_init      ;initialise LCD
		lcall delay
		lcall delay
		lcall delay
		mov a,#83h		 ;Put cursor on first row,5 column
		lcall lcd_command
		MOV DPTR,#my_string1
		lcall lcd_sendstring
		lcall delay
		lcall delay
		lcall delay
		mov a,#0C1h		 ;Put cursor on first row,5 column
		lcall lcd_command
		MOV DPTR,#my_string2
		lcall lcd_sendstring
		lcall delay
		MOV 4BH,#70H
		lcall lcd_sendstring_byte
		lcall delay
		MOV 4BH,#71H
		lcall lcd_sendstring_byte
		lcall delay
		MOV 4BH,#72H
		lcall lcd_sendstring_byte
		RET


ISR_T0:
	CLR TR0
    INC R2
	MOV TH0,#0
	MOV TL0,#0
	SETB TR0
RETI; return to main


ISR_EX0:
	CLR TR0
    MOV R4,TH0
	MOV R3,TL0
	INC R5
	CJNE R5,#5,return
	MOV R5,#0
	MOV 70H,R2
	MOV 71H,R4
	MOV 72H,R3
	LCALL SHOW_PULSE
	INC R6
	return:
	MOV TH0,#0
	MOV TL0,#0
	MOV R2,#0
	SETB TR0
	
RETI; return to main


my_string1:
         DB   "PULSE WIDTH", 00H
my_string2:
		 DB   "COUNT IS ", 00H
			 
END
    
    
