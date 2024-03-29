;prg17_1.asm
.386P	;ࠧ�襭�� ������権 i386
.MODEL large
;����� ���㠫���樨 ॣ���஢ al, ah, ax ��� eax
include	show.inc
include	mac.inc
;������� ��� ���ᠭ�� ���ਯ�஢ ᥣ���⮢
descr	STRUC
limit	dw	0
base_1	dw	0
base_2	db	0
attr	db	0
lim_atr	db	0
base_3	db	0
	ENDS
;����� ���樠����樨 ���ਯ�஢
load_descr	MACRO	des,seg_addr,seg_size
	mov	des.limit,seg_size
	xor	eax,eax
	mov	ax,seg_addr
	shl	eax,4
	mov	des.base_1,ax
	rol	eax,16
	mov	des.base_2,al
	ENDM
atr	MACRO	descr,bit1,bit2,bit3
	atr_&descr=constp or bit1 or bit2 or bit3
	ENDM
;������� ��� ���ᠭ�� �ᥢ�����ਯ�� gdtr � idtr
point	STRUC
lim	dw	0
adr	dd	0
	ENDS
;������� ��� ���ᠭ�� ���ਯ�஢ ⠡���� idt
descr_idt	STRUC
offs_1	dw	0
sel	dw	30h	;ᥫ���� ᥣ���� ������ � ⠡��� GDT
no_use	db	0
type_attr	db	8eh	;�� ���뢠���
offs_2	dw	0
	ENDS

;��ਡ��� ��� ���ᠭ�� ���ਯ�஢ ᥣ���⮢
constp	equ	10010000b
code_r_n	equ	00010000b
code_r_y	equ	00000010b
data_wm_n	equ	00000000b
data_wm_y	equ	00000010b
code_n	equ	00000000b
code_p	equ	00000100b
data_	equ	00000000b
stack_	equ	00000000b
code_	equ	00001000b
data_stk	equ	00000000b

stk	segment	stack 'stack' 
	db	256 dup (0)
stk	ends

;ᥣ���� � ⠡��楩 ��������� ���ਯ�஢
gdt_seg	segment	para public 'data' use16
gdt_0	descr	<0,0,0,0,0,0>
atr	gdt_gdt_8,data_wm_y,data_,data_stk
;����뢠�� ᠬ� GDT
gdt_gdt_8	descr	<0,0,0,atr_gdt_gdt_8,0,0>
gdt_ldt_10	descr	<0,0,0,0,0,0>	;�� �ᯮ��㥬
atr	gdt_ds_18,data_wm_y,data_,data_stk
;���ਯ�� ᥣ���� ������
gdt_ds_18	descr	<0,0,0,atr_gdt_ds_18,0,0>
atr	gdt_vbf_20,data_wm_y,data_,data_stk
gdt_es_vbf_20	descr	<0,0,0,atr_gdt_vbf_20,0,0>	;���������
atr	gdt_ss_28,data_wm_y,stack_,data_stk
gdt_ss_28	descr	<0,0,0, atr_gdt_ss_28,0,0>	;ᥣ���� �⥪�
atr	gdt_cs_30,code_r_y,code_n,code_
gdt_cs_30	descr	<0,0,0,atr_gdt_cs_30,0,0>	;ᥣ���� ����
atr	gdt_sirena_38,code_r_y,code_n,code_
gdt_sirena_38	descr	<0,0,0,atr_gdt_sirena_38,0,0>
gdt_size=$-gdt_0-1	;ࠧ��� GDT ����� 1
gdt_seg	ends

idt_seg	segment	para public 'data' use16
int00h	descr_idt	<dummy,,,,>
	REPT		2
	descr_idt	<dummy,,,,>
	ENDM
int03h	descr_idt	<int_03h,,,,>
	descr_idt	<dummy,,,,>
int05h	descr_idt	<int_05h,,,,>
	REPT	7
	descr_idt	<dummy_err,,,,>
	ENDM
int0dh	descr_idt	<int_0dh,,,,>
	REPT	3
	descr_idt	<dummy,,,,>
	ENDM
int11h	descr_idt	<dummy_err,,,,>
	REPT	14
	descr_idt	<dummy,,,,>
	ENDM
int20h	descr_idt	<new_08h,,,,>
int21h	descr_idt	<sirena,38h,,,>
	REPT	222
	descr_idt	<dummy,,,,>
	ENDM
idt_size=$-int00h-1
idt_seg	ends

;����� �ணࠬ��
data	segment	para public 'data' use16	;ᥣ���� ������
point_gdt	point	<gdt_size,0>
point_idt	point	<idt_size,0>
char	db	'0'
maskf	db	07h
position	dw	2000
tonelow	dw	2651	;������ �࠭�� ���砭�� 450 ��
cnt	db	0	;����稪 ��� ��室� �� �ணࠬ��
temp	dw	?	;������ �࠭�� ���砭��
min_index	dw	0
max_index	dw	99
data_size=$-point_gdt-1
data	ends

SOUND	SEGMENT	byte private use16
	assume	cs:SOUND,ds:DATA,ss:STK
sirena	PROC		;���짮��⥫�᪮� ���뢠���
	push	ds
	push	ax
	push	cx
	push	dx
go:
;����ᨬ ᫮�� ���ﭨ� 10110110b(0�6h) � �������� ॣ���� (���� 43h)
	mov	al,0B6h
	out	43h,al
	in	al,61h	;����稬 ���祭�� ���� 61h � al
	or	al,3	;���樠�����㥬 ������� � ������ ⮪ � ���� 61h
	out	61h,al
	mov	cx,2083	;������⢮ 蠣�� ��㯥��⮣� ��������� ⮭�
musicup:
;� ax ���祭�� ������ �࠭��� ����� 
	mov	ax,tonelow
	out	42h,al	;� ���� 42h ����襥 ᫮�� ax :al
	xchg	al,ah	;����� ����� al � ah
	out	42h,al	;� ���� 42h ���襥 ᫮�� ax:ah
	add	tonelow,1	;����蠥� ⮭
	delay 1	;����প� �� 1 ���
	mov	dx,tonelow	;� dx ⥪�饥 ���祭�� �����
	mov	temp,dx	;temp - ���孥� ���祭�� ����� 
	loop	musicup	;������� 横� ����襭��
	mov	cx,2083	; ����⠭����� ���稪 横��
musicdown:
	mov	ax,temp	;� ax ���孥� ���祭�� �����
	out	42h,al	;� ���� 42h ����襥 ᫮�� ax :al
	mov	al,ah	;����� ����� al � ah
	out	42h,al;� ���� 42h ���襥 ᫮�� ax :ah
	sub	temp,1	;�������� �����
	delay 1	;����প� �� 1 ���
	loop musicdown	;������� 横� ���������
nosound:
	in	al,61h	;����稬 ���祭�� ���� 61h � AL
	and	al,0FCh	;�몫���� �������
	out	61h,al	;� ���� 61h
	mov	dx,2651	;��� ��᫥����� 横���
	mov	tonelow,dx
	inc	cnt	;㢥��稢��� ����稪 ��室��, � ���� 
;������⢮ ���砭�� �७�
	cmp	cnt,5	;5 ࠧ ? 

	jne	go	;�᫨ ��� - ��� �� ���� go
	pop	dx
	pop	cx
	pop	ax
	pop	ds
	mov	bp,sp
	mov	eax,[bp]
	show	eax,0
	mov	eax,[bp+4]
	show	eax,160
	mov	eax,[bp+8]
	show	eax,320
	db	66h
	iret
	endp
sound_size=$-sirena-1
sound	ends

code	segment	byte public 'code' use16
;ᥣ���� ���� � 16-ࠧ�來� ०���� ����樨
	assume	cs:code,ss:stk
dummy	proc	;�᪫�祭�� ��� ���� �訡��
	mov	ax,0ffffh
	db	66h
	iret
	endp
dummy_err	proc	;�᪫�祭�� � ����� �訡��
	pop	eax	;᭨���� � �⥪� ��� �訡�� � �� ��࠭
	db	66h
	iret
	endp
int_03h	proc
;��� �⮣� �᪫�祭�� �� �ନ����� ���� �訡��,
;���⮬� ��������㥬 ᮤ�ন��� eip � �⥪� � �����頥��� � �ணࠬ��
	pop	eax
	show	eax,0
	push	eax
	db	66h
	iret
	endp
int_05h	proc	;��ࠡ��稪 ��� 5-�� �᪫�祭�� - ������� bound
	mov	al,5
	mov	ah,al
	mov	si,2
	db	66h
	iret
	endp
int_0dh	proc
	pop	eax	;᭨���� � �⥪� ��� �訡��
	sub	bx,4	;��ࠢ�塞 ��稭� ������������� �᪫�祭��
	db	66h	;�����頥��� ���⭮ � ����� ������⮩ �������
	iret
	endp
new_08h	proc	;����� ���뢠��� �� ⠩���
	assume	ds:data
	push	ds
	push	es
	push	ax
	push	bx
	mov	ax,20h
	mov	es,ax
scr:
	mov	al,char
	mov	ah,maskf
	mov	bx,position
	mov	es:[bx],ax
	add	bx,2
	mov	position,bx
	inc	char
	pop	bx
	pop	ax
	pop	es
	pop	ds
	mov	al,20h
	out	20h,al
	db	66h
	iret
	endp
new_8259a	proc
;� al - ���祭�� ������ ��������
;����� ��� ����饣� ����஫���
	push	ax
	mov	al,00010001b
	out	20h,al	;ICW1 � ���� 20h
	jmp	$+2
	jmp	$+2	;����প�, �⮡� �ᯥ�� ��ࠡ���� ��������
	pop	ax
	out	21h,al	;ICW2 � ���� 20h - ���� ������ �����
	jmp	$+2
	jmp	$+2	;����প�, �⮡� �ᯥ��
			;��ࠡ���� ��������
	mov	al,00000100b
	out	21h,al	;ICW3 - ������ ������砥���
			;� �஢�� 2 (�. ��. 15.1)
	jmp	$+2
	jmp	$+2	;����প�, �⮡� �ᯥ��
			;��ࠡ���� ��������
	mov	al,00000001b
	out	21h,al	;ICW4 - EOI �뤠�� �ணࠬ�� ���짮��⥫�
	ret
	endp
main	proc
	mov	ax,stk
	mov	ss,ax
;������塞 ⠡���� ��������� ���ਯ�஢
assume	ds:GDT_SEG
	mov	ax,GDT_SEG
	mov	ds,ax
	load_descr	gdt_gdt_8,GDT_SEG,gdt_size
	load_descr	gdt_ds_18,DATA,data_size
	load_descr	gdt_es_vbf_20,0b800h,3999
	load_descr	gdt_ss_28,STK,255
	load_descr	gdt_cs_30,CODE,code_size
	load_descr	gdt_sirena_38,SOUND,sound_size
	assume	ds:data
	mov	ax,data
	mov	ds,ax
;����㦠�� gdtr
	xor	eax,eax
	mov	ax,GDT_SEG
	shl	eax,4
	mov	point_gdt.adr,eax
	lgdt	point_gdt
;����頥� ���뢠���
	cli
	mov	al,80h
	out	70h,al
	mov	al,20h	;����� ���祭�� �������� �����
	call	new_8259A
;����㦠�� idtr
	xor	eax,eax
	mov	ax,IDT_SEG
	shl	eax,4
	mov	point_idt.adr,eax
	lidt	point_idt
;��४��砥��� � ���饭�� ०��
	mov	eax,cr0
	or	al,1
	mov	cr0,eax
;����ࠨ���� ॣ�����
	db	0eah	;��設�� ��� ������� jmp
	dw	offset protect	;ᬥ饭�� ��⪨ ���室�
			;� ᥣ���� ������
	dw	30h	;ᥫ���� ᥣ���� ���� � GDT
protect:
;����㧨�� ᥫ����� ��� ��⠫��� ���ਯ�஢
	mov	ax,18h
	mov	ds,ax
	mov	ax,20h
	mov	es,ax
	mov	ax,28h
	mov	ss,ax
;ࠡ�⠥� � ���饭��� ०���:
;ࠧ�蠥� ���뢠��� �� ⠩���, ������
	sti
	delay	3500
	cli
;����� �����㥬 ������������� ����
;�᪫��⥫��� ���権 (⨯� �訡��): 5 � 13
	mov	si,130
	bound	si,dword ptr min_index
	mov	bx,data_size
	mov	ax,[bx]
;� ⥯��� �����㥬 ������������� �᪫��⥫쭮� ���樨 ⨯� ����誨 - 3:
	int	3
;��ࠡ��뢠�� �� � � ���� �ᯥ� ����᪠��
;�� ��㣮�� ᥣ���� ������ �७�
	int	21h
;��⮢���� � ���室� � ॠ��� ०��
;���뢠��� ����饭�
;��९ணࠬ���㥬 ����஫���
	mov	al,08h
	call	new_8259A
;�ନ஢���� ���ਯ�஢ ��� ॠ�쭮�� ०���
	assume	ds:GDT_SEG
	mov	ax,8h
	mov	ds,ax
	mov	gdt_ds_18.limit,0ffffh
	mov	gdt_es_vbf_20.limit,0ffffh
	mov	gdt_ss_28.limit,0ffffh
	mov	gdt_cs_30.limit,0ffffh
	assume	ds:DATA
;����㧪� ⥭���� ���ਯ�஢
	mov	ax,18h
	mov	ds,ax
	mov	ax,20h
	mov	es,ax
	mov	ax,28h
	mov	ss,ax
	db	0eah
	dw	offset jump
	dw	30h
jump:	mov	eax,cr0
	and	al,0feh
	mov	cr0,eax
	db	0eah
	dw	offset r_mode
	dw	CODE
r_mode:
	mov	ax,DATA
	mov	ds,ax
	mov	ax,STK
	mov	ss,ax
	mov	ax,3ffh
	mov	point_idt.lim,ax
	xor	eax,eax
	mov	point_idt.adr,eax
	lidt	point_idt
;ࠧ�蠥� ���뢠���
	sti
	xor	al,al
	out	70h,al
;����砭�� ࠡ��� �ணࠬ�� (�⠭���⭮)
	mov	ax,4C00h
	int	21h
main	ENDP
code_size=$-dummy
code	ends
end	main
