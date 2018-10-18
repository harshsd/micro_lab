LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
out equ p1.7	
	
org 00h
ljmp main

org 0bh
	clr tr0
	clr tf0
	mov th0 , 50h
	mov tl0 , 51h
	add a,#1h
	cjne a,#128,skip
	cpl out
	mov a,#0
	skip:setb tr0
	reti

org 100h
main:
mov a,#0
mov 50h , #0C3h
mov 51h , #50h
mov p1,#0
mov tmod , #01h
mov ie , #82h
setb tr0
stay: sjmp stay

end