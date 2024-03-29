;mac.inc
GetStr	macro	Buf,MaxLen
	local	m,TmpBuf
;���� ��ப� �ந����쭮� ����� (�㭪�� 0ah int 21h)
;�� �室�:
;Buf - ���� ��ப� �㤠 �㤥� ����饭 ����
;MaxLen - ���ᨬ��쭠� ����� �������� ��ப�
;�� ��室� - ��������� ��ப� �� ����� Buf
;al - ����� ��������� ��ப�
	jmp	m
TmpBuf	label	byte	;�६���� ���� �ଠ⮬ ��� �㭪樨 0ah (int 21h)
	rept	MaxLen+3	;���. �� ���� - �㦥���� ���ଠ��
	db	' '
	endm
m:
	SaveReg	<ds,es,dx,cx>
	xor	cx,cx
	mov	cs:TmpBuf,MaxLen+1
	mov	ah,0ah
	push	ds
	pop	es
	push	cs
	pop	ds
	lea	dx,cs:TmpBuf
	int	21h
	mov	al,cs:TmpBuf+1
;����뫪� TmpBuf � Buf � ᤢ����  �� ��� ���� ����� (��� 㤠����� �㦥���� ᨬ�����):
	mov	cl,al	;����� ��������� ��ப� � al
	lea	si,cs:TmpBuf+2	;��㤠 - ds:si
	lea	di,buf	;�㤠 - es:di
rep	movsb
	LoadReg	<cx,dx,es,ds>
	endm

mov_string	macro	dest,src,len
;����뫪� ��ப
;�� �室� �����䨪����: ��ப�-���筨�� - src, ��ப�-�ਥ����� - dest
;ᥣ����� ॣ����� ds (��� ���筨��) � es (��� �ਥ�����) ������ ���� ����㦥�� 
;�ࠢ���묨 ���祭�ﬨ �� �맮�� ���ப������
	mov	cx,len
	lea	si,src
	lea	di,dest
rep	movsb	
	endm

null_string	macro	dest,len
	local	m,Z_String
;���⪠ ��ப� �ந����쭮� ����� �஡�����
;�� �室�:
;dest - ���� ��ப�
;len - ����� ��頥��� ��ப�
	jmp	m
Z_String	label	byte	;����� ��ப�
	rept	len
	db	' '
	endm
m:
	SaveReg	<ds,es,cx,si,di>
	mov	cx,len
	push	ds
	pop	es	;���� dest (�ਥ����) - es:di
	push	cs
	pop	ds	;���� Z_String (���筨�) - ds:si
	lea	si,cs:Z_String
	lea	di,dest
rep	movsb	
	LoadReg	<di,si,cx,es,ds>
	endm
OutStr	macro	str
;�뢮� ��ப� �� ��࠭.
;�� �室� - �����䨪��� ��砫� �뢮����� ��ப�.
;��ப� ������ �����稢����� ᨬ����� '$'.
;�� ��室�- ᮮ�饭�� �� ��࠭�.
	SaveReg	<ax,dx>
	mov	ah,09h
	lea	dx,str
	int	21h
	LoadReg	<dx,ax>
	endm

GetChar	macro
;���� ᨬ���� � ����������.
;�� ��室� - � al ������ ᨬ���.
	mov	ah,01h
	int	21h
	endm

OutChar macro
;�뢮� ᨬ���� �� ��࠭.
;�� �室� - � dl �뢮���� ᨬ���.
	push	ax
	mov	ah,02h
	int	21h
	pop	ax
endm

SaveReg	macro	RegList
;���࠭���� 㪠������ � ᯨ᪥ RegList ॣ���஢ � �⥪�
;ᯨ᮪ ॣ���஢ ������ ���� �����祭 � 㣫��� ᪮���, 
;���ਬ�� - <ax,bx,cx>
	irp	reg,<RegList>
	push	reg
	endm
	endm

LoadReg	macro	RegList
;����⠭������� 㪠������ � ᯨ᪥ RegList ॣ���஢ �� �⥪�
;ᯨ᮪ ॣ���஢ ������ ���� �����祭 � 㣫��� ᪮���, 
;���ਬ�� - <ax,bx,cx>
	irp	reg,<RegList>
	pop	reg
	endm
	endm

clear_r	macro	rg
;���⪠ ॣ���� rg
	xor	rg,rg
	endm

conv_16_2	macro
;����� �८�ࠧ������ ᨬ���� ��⭠����筮� ����
;� �� ������ ���������� � al
	sub	dl,30h
	cmp	dl,9h
	jle	$+5
	sub	dl,7h
	endm

init_ds	macro
;����� ����ன�� ds �� ᥣ���� ������
	mov	ax,data
	mov	ds,ax
	xor	ax,ax
	endm

delay	macro	time
	local	ext,iter	
;����� ����প�. �� �室� - ���祭�� ��६����� ����প� (� ���).
	push	cx
	mov	cx,time
ext:	push	cx
	mov	cx,5000	;�� ���祭�� ����� ��������, ��室� �� �ந�����⥫쭮�� ������.
iter:	loop	iter
	pop	cx
	loop	ext
	pop	cx
	endm

_Exit	macro
;��室 �� �ணࠬ��.
	mov	ax,4c00h
	int	21h
	endm

