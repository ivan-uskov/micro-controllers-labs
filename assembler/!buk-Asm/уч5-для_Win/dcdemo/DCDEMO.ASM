.386
.model flat, stdcall
include win32.inc

extrn            BeginPaint:PRp     Txtrn            BeginPaintma:�o�         @ �      WDAleROCo�         @ �CreateCompatibleDCleROCo�         @ �CreateWindowExAleROCo�         @ �DefWindowProcAleROCo�         @ �DeleteDCleROCo�         @ �DeleteObjecAleROCo�         @ �DispatchMessageAleROCo�         @ �End WDAleROCo�         @ �ExitProcessleROCo�         @ �GetClientRecAleROCo�         @ �GetMessageAleROCo�         @ �GetModuleHandleAleROCo�         @ �GetObjecAAleROCo�         @ �GetStockObjecAleROCo�         @ �LoadCursorAleROCo�         @ �LoadIconAleROCo�         @ �LoadImageAleROCo�         @ �PostQuitMessageleROCo�         @ �RegisterClassAleROCo�         @ �SelectObjecAleROCo�         @ �ShowWindowleROCo�         @ �StretchBlAleROCo�         @ �TranslateMessageleROCo�         @ �UpdateWindowleROCo�
BITMAP struct
@ �bmType   @ �dd ?
@ �bmWidth   @ �dd ?
@ �bmHeight  @ �dd ?
@ �bmWidthBytes�dd ?
@ �bmPlanes� @ �dw ?
@ �bmBitsPixel �dw ?
@ �bmBits   @ �dd ?
BITMAP endso�
LR_LOADFROMFILE  = 010h
SRCCOPY     @ �= 00CC0020h
IMAGE_BITMAP  @ �= 0o�
.datao�
newhwnd     @ �dd 0o�msg              MSGSTRUCT   <?>
wc               WNDCLASS    <?>

hDC              dd ?
hCompatibleDC    dd ?
 WDAStruct   @ �PAINTSTRUCT <?>
hBitmap          dd ?
hOldBitmap       dd ?
RecA             RECT <?>
Bitmap           BITMAP <?>

hInstance    @ �dd 0o�
szTitleName    @db 'DCDemo', 0o�szClassName    @db 'ASMCLASS32',0o�szImg            db 'IMG.BMP',0o�
.code
;-----------------------------------------------------------------------------o�start:
@ ������     @ �GetModuleHandleA, 0o�@ ������mov�����[hInstance], eaxo�
; initialize the WndClass structureo�@ ������mov�����[wc.clsStyle], CS_HREDRAW + CS_VREDRAWo�@ ������mov�����[wc.clsLpfnWndProc], offset DCDemoWndProco�@ ������mov�����[wc.clsCbClsExtra], 0o�@ ������mov�����[wc.clsCbWndExtra], 0o�o�@ ������mov�����eax,�[hInstance]o�@ ������mov�����[wc.clsHInstance], eaxo�
@ ������     @ �LoadIconA, 0, IDI_APPLICATIONo�@ ������mov�����[wc.clsHIcon], eaxo�
@ ������     @ �LoadCursorA, 0 ,IDC_ARROWo�@ ������mov�����[wc.clsHCursor], eaxo�
@ ������     @ �GetStockObjecA, WHITE_BRUSHo�@ ������mov�����[wc.clsHbrBackground], eaxo�
@ ������mov�����[wc.clsLpszMenuName], 0o�@ ������mov�����[wc.clsLpszClassName], offset szClassNameo�
@ ������     @ �RegisterClassA, offset wco�
@ ������     @ �CreateWindowExA, 0,offset szClassName,offset szTitleName, \
@ ������        WS_OVERLAPPEDWINDOW,CW_USEDEFAULT, \
@ ������        CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,0,0, \
@ ������        [hInstance], 0o�o�@ ������mov�����[newhwnd], eaxo�
@ ������     @ �ShowWindow,�[newhwnd], SW_SHOWNORMAL
@ ������     @ �UpdateWindow,�[newhwnd]o�
msg_loop:
@ ������     @ �GetMessageA, offset msg, 0, 0, 0o�@ ������.if�����eax != 0o�@ ������@ ������     @ �TranslateMessage, offset msgo�@ ������@ ������     @ �DispatchMessageA, offset msgo�@ ������@ ������jmp�����msg_loopo�@ ������.endif
@ ������     @ �ExitProcess,�[msg.msWPARAM]o�

;-----------------------------------------------------------------------------o�DCDemoWndProc @ �proc uses ebx edi esi, hwnd:DWORD, wmsg:DWORD,\
@ ������         wparam:DWORD, lparam:DWORDo�
@ ������ mp�����[wmsg], WM_PAINT
@ ������je    @wmpWDA
@ ������ mp�����[wmsg], WM_DESTROY
@ ������je    @wmdestroyo�
@ ������     @ �DefWindowProcA,�[hwnd],[wmsg],[wparam],[lparam]o�@ ������jmp�����finisho�
wmpWDA:
;=================================================================o�
@ ������; ����砥� ���⥪�� ���ன�⢠
@ ������     @ �      WDA,�[hwnd], offset  WDAStructo�@ ������mov�����[hDC], eaxo�
@ ������; ����㦠�� bitmap, ����� �㤥� �⮡ࠦ����� � ����, �� 䠩��
@ ������     @ �LoadImageA, 0,offset szImg,IMAGE_BITMAP, \
@ ������        0,0,LR_LOADFROMFILEo�@ ������mov�����[hBitmap], eaxo�
@ ������; ����砥� ࠧ��୮��� ����㦥����� bitmap'�
@ ������     @ �GetObjecAA,�[hBitmap], size BITMAP, offset Bitmapo�

@ ������; ������� ᮢ���⨬� � ���⥪�⮬ ���� ���⥪�� � �����
@ ������     @ �CreateCompatibleDC,�[hDC]o�@ ������mov�����[hCompatibleDC], eaxo�
@ ������; ������ ����㦥��� �� 䠩�� bitmap ⥪�騬 � ᮢ���⨬�� ���⥪��
@ ������     @ �SelectObjecA,�[hCompatibleDC], [hBitmap]o�@ ������mov�����[hOldBitmap], eaxo�
@ ������; ��।��塞 ࠧ��� ࠡ�祩 ������ ����
@ ������     @ �GetClientRecA,�[hwnd], offset RecAo�
@ ������; �����㥬 bitmap � ᮢ���⨬��� �� �᭮���� ���⥪��
@ ������; � ���⠡�஢�����
@ ������     @ �StretchBlA,�[hDC],0,0,[RecA.rcRight],[RecA.rcBottom], \
@ ������        [hCompatibleDC],0,0,[Bitmap.bmWidth],[Bitmap.bmHeight], \
@ ������        SRCCOPYo�
@ ������; ����� ������ ���� bitmap ⥪�騬
@ ������     @ �SelectObjecA,�[hCompatibleDC], [hOldBitmap]o�
@ ������; ����塞 ����㦥��� � ��᪠ bitmap
@ ������     @ �DeleteObjecA, [hBitmap]o�
@ ������; ����塞 ᮢ���⨬� ���⥪��
@ ������     @ �DeleteDC,�[hCompatibleDC]o�
@ ������; �᢮������� �᭮���� ���⥪��, ������� ����ᮢ��
@ ������; ࠡ�祩 ������ ����
@ ������     @ �End WDA,�[hwnd], offset  WDAStructo�o�@ ������mov�����eax,�0o�@ ������jmp�����finisho�;=================================================================o�
wmdestroy:
@ ������push   @0o�@ ������     @ �PostQuitMessageo�@ ������mov�����eax,�