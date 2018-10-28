ORG 0000H
LJMP MAIN		

ORG 000BH                  
LJMP ISR_T0                ;jump to ISR



;--The main program for initialization

    
ORG 0030H                 ; after vector tablespace

;load TL0 and TH0 with value stored in 82H and 81H
Load_timer0:
	PUSH 0
	MOV R0,#81H
	CLR C
	MOV A,#00H
	SUBB A,@R0
	MOV TL0,A
	INC R0
	MOV A,#00H
	SUBB A,@R0
	MOV TH0,A
	POP 0
	RET
		

MAIN:
	;for 1/60 second
    MOV R0,#81H
	MOV @R0,#35H
	INC R0
	MOV @R0,#82H
	MOV IE,#82H
	LCALL Load_Timer0
	MOV TMOD,#01H ;mode 1 
	MOV R2,#0 ;for counting number of clock cycles
	MOV P1,#00H
	SETB TR0
	HERE: SJMP HERE


BACK: SJMP BACK          




; Timer 0 ISR. Must be reloaded, not auto-reload

ORG 200H
ISR_T0:
	CLR TR0
    INC R2
	CJNE R2,#60,return
	MOV R2,#0
	XRL P1,#0FFH 
	
	return:
	LCALL Load_timer0
	SETB TR0
RETI; return to main

END
    
    
