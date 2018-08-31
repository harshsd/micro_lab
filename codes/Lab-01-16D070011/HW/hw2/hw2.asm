Org 00h
ljmp main
Org 100h

main:

MOV 50H, #08H

MOV R2,50H
MOV R1,#01H
MOV R0,#51H

up: ADD A,R1
MOV @R0, A
INC R0
INC R1
DJNZ R2,up

stay: SJMP stay
END