.386
.model flat, stdcall
option casemap: none

include lib.inc

include C:/masm32/include/gdi32.inc
includelib C:/masm32/lib/gdi32.lib
 
includelib C:/masm32/lib/user32.lib
includelib C:/masm32/lib/kernel32.lib

.data

symb_amount dd 0

divider1 db 6
divider2 dd 62

cycle_count db 0
min_cycle db 0

mem dd 0
mem2 dd 0

first_str dd 0
third_str dd 55,83,56,81,79,101,81,86

a db 97,115,101,105
b dd 0
d dd 0

summ dd 0
pass_sum dd 0
sum_changed dd 0

count db 0

val db 0

arr db 49,50,63,216,209,147,234,147,67,176,7,0,127,51,49,15,148,77,76,56

arr2 db 115,5,0,0,50,13,0,0,234,9,0,0,176,7,0,0,252
db 3,0,0,217,8,0,0,50,13,0,0,234,9,0,0,176,7,0,0,252,3
db 0,0,217,8,0,0,62,9,0,0,50,13,0,0,234,9,0,0,222,8,0,0,33,3,0,0,172,8,0,0
db 179,8,0,0,115,10,0,0,57,12,0,0,170,9,0,0,188,15,0,0
db 181,9,0,0,50,13,0,0,238,12,0,0,176,7,0,0,176,7,0,0
db 252,3,0,0,217,2,0,0,49,7,0,0,234,9,0,0,176,7,0,0

arr_ins dd 246,3966,63486,1015803,16252863,260045823,4160733182

shift db 28,24,20,16,12,8,4

elems db 0,4,6,12,16,20
elems2 db 0,4,8,12,16,20,24

alphabet db 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',0

hInstance dd ?

hWndEdit HWND ?
hWndEdit2 HWND ?
hWndBtn HWND ?
hWndLabel dd ?
hWndLabe2 dd ?

lenght db 0

res db ?

nick dd ?

byte1 dd ?
byte2 db ?

txtbuff db 255 dup(?)

ClassMainName db 'test',0
WinMainName db "KeyGen for Zephyrouse's KeygenMe #4 ",0 ; 

labelType db "static",0
edit db "edit",0
btn db "button",0

labelName db "Enter your name here: ",0
labelPass db "Your key: ",0
labelAuth db "cODEd bY [UltraLazer]",0

genText db "Generate",0
extBtnText db "Exit",0
abtBtnText db "About",0

abtMsgTitle db "About",0
abtMsgText db "KeyGen for Zephyrouse's KeygenMe #4 made by UltraLazer",0

error db "Enter your name please!",0

hfont dd ?

lf LOGFONT <14,5,0,0,0,0,0,0,0,0,0,0,0,'Sans-serif'>                    

.const

labelIdName equ 1
labelIdPass equ 2
labelIdAuth equ 3

editName equ 4
editPass equ 5

genBtnId equ 6
extBtnId equ 7
abtBtnId equ 8

.code
start:

invoke GetModuleHandle, 0
mov hInstance, eax
invoke WinMain, hInstance,0, 0, 1
invoke ExitProcess, 0

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
LOCAL wc:WNDCLASSEX
LOCAL msg:MSG
LOCAL hWnd:HWND

    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbWndExtra, 0
    mov wc.cbClsExtra,DLGWINDOWEXTRA
    mov wc.hbrBackground,COLOR_BTNFACE+1
    mov wc.lpszMenuName, 0
    mov wc.lpszClassName, OFFSET ClassMainName
    invoke LoadIcon, 0, IDI_APPLICATION
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    invoke LoadCursor, 0, IDC_ARROW
    mov wc.hCursor, eax
    invoke RegisterClassEx, addr wc

    INVOKE CreateWindowEx,0,addr ClassMainName,addr WinMainName,\
    WS_OVERLAPPEDWINDOW-WS_SIZEBOX-WS_MAXIMIZEBOX,CW_USEDEFAULT,\
    CW_USEDEFAULT,430,165,0,0,\
    hInst,0

    mov hWnd, eax

    invoke ShowWindow, hWnd,1
    invoke UpdateWindow, hWnd

    .while TRUE
        invoke GetMessage, addr msg, 0, 0, 0
        .break .if(!eax)
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
    .endw
    mov eax, msg.wParam
    ret
WinMain endp

WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

.IF uMsg==WM_CREATE   

    invoke CreateFontIndirectA,addr lf
    mov hfont,eax

    invoke CreateWindowEx, 0,addr labelType,addr labelName,WS_CHILD or WS_VISIBLE ,12, 5, 200, 15, hWnd, labelIdName,hInstance, 0 
    invoke SendMessageA,eax,WM_SETFONT,hfont,1
    
    invoke CreateWindowEx,WS_EX_CLIENTEDGE, addr edit,0,WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_AUTOHSCROLL,12,25,300,25,hWnd,editName,hInstance,0
    mov hWndEdit,eax
    invoke SendMessageA,eax,WM_SETFONT,hfont,1
    invoke SetFocus, eax

    invoke CreateWindowEx, 0,addr labelType,addr labelPass,WS_CHILD or WS_VISIBLE ,12, 55, 200, 20, hWnd, labelIdPass,hInstance, 0 
    invoke SendMessageA,eax,WM_SETFONT,hfont,1

    invoke CreateWindowEx,WS_EX_CLIENTEDGE, addr edit,0,WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_READONLY or ES_AUTOHSCROLL,12,75,300,25,hWnd,editPass,hInstance,0
    mov hWndEdit2,eax
    invoke SendMessageA,eax,WM_SETFONT,hfont,1

    invoke CreateWindowEx, 0,addr labelType,addr labelAuth,WS_CHILD or WS_VISIBLE ,12, 110, 200, 20, hWnd, labelIdAuth,hInstance, 0 
    invoke SendMessageA,eax,WM_SETFONT,hfont,1

    invoke CreateWindowEx,WS_EX_LTRREADING,addr btn,addr genText,WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,330,15,80,25,hWnd,genBtnId,hInstance,0
    invoke SendMessageA,eax,WM_SETFONT,hfont,1

    invoke CreateWindowEx,WS_EX_LTRREADING,addr btn,addr extBtnText,WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,330,50,80,25,hWnd,extBtnId,hInstance,0
    invoke SendMessageA,eax,WM_SETFONT,hfont,1

    invoke CreateWindowEx,WS_EX_LTRREADING,addr btn,addr abtBtnText,WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,330,100,80,25,hWnd,abtBtnId,hInstance,0
    invoke SendMessageA,eax,WM_SETFONT,hfont,1

.ELSEIF uMsg==WM_COMMAND
    mov eax,wParam
    .IF lParam==0
    .ELSE
    .IF ax==genBtnId
        shr eax,16
	.IF ax==BN_CLICKED
    
        invoke GetWindowTextLength,hWndEdit
    
        .if al > 0

            invoke GetDlgItemText, hWnd, editName, addr nick, 30
            
            call generate
            
            invoke SetWindowText,hWndEdit2,addr res

            ;call exit

            mov txtbuff,0

            mov res,0
            mov nick,0
            
            mov count,0
            mov cycle_count,0
            mov min_cycle,0
            
            mov symb_amount,0
            
            mov first_str,0
            
            mov a[0],97
            mov a[1],115
            mov a[2],101
            mov a[3],105
            
            mov b,0
            mov d,0
        
            mov summ,0
            mov pass_sum,0
            mov sum_changed,0
                      
            mov mem,0
            mov mem2,0
                      
            mov val,0
        .else

            invoke SetWindowText,hWndEdit2,addr error
        .endif
           
     .ENDIF
     .ELSEIF ax==extBtnId
        shr eax,16
        .IF ax==BN_CLICKED
            invoke PostQuitMessage, 0
        .endif
      .ELSEIF ax==abtBtnId
        shr eax,16
        .IF ax==BN_CLICKED
            invoke MessageBox,0,offset abtMsgText,addr abtMsgTitle,MB_OK
     .ENDIF
     .ENDIF
     .ENDIF
.ELSEIF uMsg==WM_DESTROY
invoke PostQuitMessage, 0
.ELSE
invoke DefWindowProc, hWnd, uMsg, wParam, lParam
.ENDIF
ret
WndProc endp

generate:

    mov symb_amount,eax
    imul eax,170017
    mov b,eax

    begin:
    xor eax,eax
    mov eax,symb_amount
    cmp min_cycle,al
    jz next
    xor edx,edx
    mov al,min_cycle
    mov dl,byte ptr nick[eax]
    add summ,edx
    inc min_cycle
    jmp begin

    next:
    mov min_cycle,0
    
    inc symb_amount

    xor summ,1768256353
    mov edx,summ
    mov d,edx
    
    further:
    xor eax,eax
    mov al,cycle_count
    xor edx,edx
    div dword ptr divider1
    
    cmp edx,12
    jge sub_edx
    
    cmp cycle_count,0
    jg another
    
    after:
    mov eax,dword ptr a
    
    continue:
    xor eax,dword ptr b
    xor eax,dword ptr d
    xor eax,1879068672

    xor edx,edx
    mov dl,cycle_count
    mov first_str[edx*4],eax; îñíîâîïîëîã� þù� ÿ ñòðîê� 

    back:
    inc cycle_count
    mov summ,0
    mov eax,symb_amount
    cmp dl,al
    jz next_part
    jmp further
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Second part
    
    next_part:
    xor eax,eax
    mov cycle_count,0
    
    next_cycle:
    xor edx,edx
    mov al,cycle_count
    div symb_amount
    cmp edx,6
    jge change
  
    part:
    mov eax,first_str[edx*4]
    xor edx,edx
    mov dl,cycle_count
    xor eax,dword ptr arr2[edx*4]
    xor edx,edx
    div divider2
    mov al,byte ptr alphabet[edx]
    xor edx,edx
    mov dl,cycle_count
    mov [res+edx],al
    inc cycle_count
    xor eax,eax
    cmp cycle_count,80
    jl next_cycle
    
    mov [res+edx+1],45
    
    mov cycle_count,0
    mov pass_sum,0
    
    call third_part
    
    ret
    
    another:
    cmp edx,0
    jz after
    mov eax,dword ptr arr[edx*4 - 4]
    jmp continue
    
    sub_edx:
    sub edx,12
    jmp another
    
    change:
    cmp edx,12
    jge change2
    sub edx,6
    jmp part
    
    change2:
    sub edx,12
    jmp part
    
    third_part:
    xor eax,eax
    mov al,cycle_count
    mov al,byte ptr res[eax]
    add pass_sum,eax
    mov eax,pass_sum
    inc cycle_count
    cmp cycle_count,32
    jl third_part
    
    mov cycle_count,0
    
    ;xor al,al
    xor eax,eax
    mov eax,pass_sum 
    imul eax,27
    xor eax,2053468264
    
    mov sum_changed,eax
    
    mov count,0
    
    xor eax,eax
    xor ecx,ecx
    
    mov eax,sum_changed
    
    mov cl,cycle_count
    mov cl,shift[ecx]
    
    shr eax,cl
    
    cmp eax,9
    jle correct
    
    back_to:
    
    mov [res+33],al
    
    sub al,48

    mov mem,eax

    contin:

    mov eax,mem
    
    shl eax,4
    
    xor edx,edx
    
    mov dl,count
    mov dl,byte ptr alphabet[edx]
    mov val,dl
    
    cmp dl,48
    jl add_to
    cmp dl,57
    jg sub_to
    sub dl,48
    jmp add_to
    
    sub_to:
    sub dl,55
    jmp add_to
    
    add_to:
    add eax,edx
    
    mov mem2,eax
    
    mov cl,cycle_count
    inc cl

    mov cl,cycle_count
    inc cl
    mov cl,shift[ecx]
    
    mov edx,sum_changed
    shr edx,cl

    xor eax,edx 
    
    xor edx,edx
    mov dl,cycle_count
    mov dl,elems2[edx]
    mov edx,[arr_ins + edx]
    
    inc count
    
    cmp count,62
    jz next_byte
    cmp eax,edx
    jnz contin
    
    next_byte:
    xor edx,edx
    mov cl,val
    mov dl,cycle_count
    add dl,34
    mov [res+edx],cl
    
    mov eax,mem2
    mov mem,eax
    
    mov count,0
    
    inc cycle_count
    
    cmp cycle_count,7
    jnz contin
    
    ret
    
    correct:
    add al,48
    jmp back_to
    
end start