.MODEL TINY
.CODE
ORG 100h
START:
  MOV AH, 03h
  INT 10h
  MOV AX, 0B00h
  MOV ES, AX
  MOV BX, 0
  MOV ES:[BX], '5'
  RET
END START