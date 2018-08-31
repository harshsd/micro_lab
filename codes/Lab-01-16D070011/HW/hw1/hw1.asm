Org 00h
ljmp main
Org 100h
main:

MOV 50H,#0AH
MOV 60H,#0FFH

MOV A,50H
ADD A,60H
MOV 70H,A
MOV R0, #00H
JNC here
INC R0
here: MOV 71H,R0
stay: SJMP stay
END