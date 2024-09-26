;************************************************ ??????? ************************************************
;--------------------------------------------
;------------------ ????? -------------------
;--------------------------------------------
output macro f1
    push ax
    push dx
    mov dx, offset f1
    mov ah, 09h
    int 21h
    pop dx
    pop ax
endm

;--------------------------------------------
;------------------ ????? -------------------
;--------------------------------------------
input macro f2  
    push ax 
    push dx
    mov dx, offset f2
    mov ah, 0Ah
    int 21h
    pop dx
    pop ax
endm

;---------------------------------------------
;----------------- ????????? -----------------
;---------------------------------------------
draw macro xStart, yStart, xEnd, yEnd, color
    push ax
    push dx
    push cx
    
    mov ax, 0600h
    
    mov ch, yStart
    mov cl, xStart
    
    mov dh, yEnd  
    mov dl, xEnd  
    
    mov bh, color 
    
    int 10h       
    
    pop cx
    pop dx
    pop ax
endm

;--------------------------------------------
;----------------- ??????? ------------------
;--------------------------------------------
clearWindow macro
    mov ax, 0003
    int 10h
endm

;--------------------------------------------
;----------------- ??????? ------------------
;--------------------------------------------
art macro
    call picture
    
again:
    mov ah,0
    int 16h
    cmp ax, 1c0dh ; Enter
    je next
    jmp exiting
    
next:
    mov red_bg,0C0h
    mov yellow_bg,00F0h
    mov magenta_bg,0D0h
    mov cyan_bg,0B0h
    call picture
    call music
exiting:
endm

;------------------------------------------------
;----------------- ????? ? ???? -----------------
;------------------------------------------------
printStringInWindow macro string, col, row
    push ax
    push dx
    
    mov ah, 2
    mov dh, row
    mov dl, col
    mov bh, 0
    int 10h
    
    mov ah, 09h
    mov dx, offset string
    int 21h
    
    pop dx
    pop ax
endm

;---------------------------------------------------
;----------------- ??????? ??????? -----------------
;---------------------------------------------------
curPos macro x, y
    push ax
    push dx
    push cx
    
    mov ah, 2
    mov dh, y  
    mov dl, x
    mov bh, 0   
    int 10h       
    
    pop cx
    pop dx
    pop ax
endm

;--------------------------------------------
;----------------- ????? --------------------
;--------------------------------------------
pressButtonW macro y1, y2, destination
    cmp y1, 0d
    je destination
    cmp y2, 24d
    je destination
    
    dec y1
    inc y2
    
    jmp destination
endm

;--------------------------------------------
;------------------- ???? -------------------
;--------------------------------------------
pressButtonS macro y1, y2, destination
    cmp y1, 8d
    je destination
    cmp y2, 17d
    je destination
    
    inc y1
    dec y2
    
    jmp destination
endm

;--------------------------------------------
;------------------ ????? -------------------
;--------------------------------------------
pressButtonA macro x1, x2, destination
    cmp x1, 19d
    je destination
    cmp x2, 60d
    je destination
    
    inc x1
    dec x2
    
    jmp destination
endm

;--------------------------------------------
;------------------ ?????? ------------------
;--------------------------------------------
pressButtonD macro x1, x2, destination
    cmp x1, 0d
    je destination
    cmp x2, 79d
    je destination
    
    dec x1
    inc x2
    
    jmp destination
endm

;*********************************************************************************************************

;************************************************* data **************************************************
d1 SEGMENT para public 'data'
    inputStr label byte ; ???????? ??????, ?? ?????? 6 ????????
    size_of_buf db 7 ; ?????? ??????
    kol db (?) ; ?????????? ????????? ????????
    stroka db 7 dup (?) ; ????? ????? ?????
    number dw 5 dup (0) ; ?????? ?????
    siz dw 5 ; ?????????? ?????
    posCounter dw 0 ; ??????? ?????????????
    counter dw 1 ; ??????? ??? ???????
    
    sumNeg dw 0 ; ????? ?????????????
    mulPos dw 0 ; ???????????? ?????????????
    diffRez dw 0 ; ???????? ????? ? ????????????

    black_bg db 0h ; ?????? ???
    white_bg db 70h ; ????? ???
    gray_bg db 80h ; ????? ???
    
    red_bg db 40h ; ??????? ???
    green_bg db 20h ; ??????? ???
    blue_bg db 10h ; ????? ???
    
    brown_bg db 60h ; ?????????? ???
    yellow_bg db 0E0h ; ?????? ???
    
    cyan_bg db 30h ; ??????? ???
    magenta_bg db 50h ; ????????? ???
    
    bright_red_bg db 0C0h ; ????-??????? ???
    bright_green_bg db 0A0h ; ????-??????? ???
    bright_blue_bg db 90h ; ????-????? ???
    
    bright_cyan_bg db 0B0h ; ????-??????? ???
    bright_magenta_bg db 0D0h ; ????-????????? ???
    
    bright_white_bg db 0F0h ; ????-????? ???
    
    window_start_x db 19d
    window_start_y db 8d
    window_end_x db 60d
    window_end_y db 17d
    
    frame_start_x db 18d
    frame_start_y db 7d
    frame_end_x db 61d
    frame_end_y db 18d
    
    cur_pos_x db 0d
    cur_pos_y db 0d

    InputErrText db 'Input Error!', 10,10,'$'
    overflow db 'Overflow!', 10,10,'$'
    overflowSum db 'Sum overflow!',10,10,'$'
    sumNegText db 13,10, 'Sum of negative elements: ','$'
    mulPosText db 13,10, 'Mul of positive element: ','$'
    diffResText db 13,10,'Difference of sum and multiplication: ','$'
    outStr db 6 dup (' '),'$'
    invitation db 'Input number from -29999 to 29999: $'
    pressAnyKey db 'Press any key', 10, '$'
    
    resizeText db 'Use WASD to change window size',10,10,'$'

    flagErr equ 1
    
    port61  db 0
    NOTE_B0 dw 31d
    NOTE_C1 dw 33d
    NOTE_CS1 dw 35d
    NOTE_D1 dw 37d
    NOTE_DS1 dw 39d
    NOTE_E1 dw 41d
    NOTE_F1 dw 44d
    NOTE_FS1 dw 46d
    NOTE_G1 dw 49d
    NOTE_GS1 dw 52d
    NOTE_A1 dw 55d
    NOTE_AS1 dw 58d
    NOTE_B1 dw 62d
    NOTE_C2 dw 65d
    NOTE_CS2 dw 69d
    NOTE_D2 dw 73d
    NOTE_DS2 dw 78d
    NOTE_E2 dw 82d
    NOTE_F2 dw 87d
    NOTE_FS2 dw 93d
    NOTE_G2 dw 98d
    NOTE_GS2 dw 104d
    NOTE_A2 dw 110d
    NOTE_AS2 dw 117d
    NOTE_B2 dw 123d
    NOTE_C3 dw 131d
    NOTE_CS3 dw 139d
    NOTE_D3 dw 147d
    NOTE_DS3 dw 156d
    NOTE_E3 dw 165d
    NOTE_F3 dw 175d
    NOTE_FS3 dw 185d
    NOTE_G3 dw 196d
    NOTE_GS3 dw 208d
    NOTE_A3 dw 220d
    NOTE_AS3 dw 233d
    NOTE_B3 dw 247d
    NOTE_C4 dw 262d
    NOTE_CS4 dw 277d
    NOTE_D4 dw 294d
    NOTE_DS4 dw 311d
    NOTE_E4 dw 330d
    NOTE_F4 dw 349d
    NOTE_FS4 dw 370d
    NOTE_G4 dw 392d
    NOTE_GS4 dw 415d
    NOTE_A4 dw 440d
    NOTE_AS4 dw 466d
    NOTE_B4 dw 494d
    NOTE_C5 dw 523d
    NOTE_CS5 dw 554d
    NOTE_D5 dw 587d
    NOTE_DS5 dw 622d
    NOTE_E5 dw 659d
    NOTE_F5 dw 698d
    NOTE_FS5 dw 740d
    NOTE_G5 dw 784d
    NOTE_GS5 dw 831d
    NOTE_A5 dw 880d
    NOTE_AS5 dw 932d
    NOTE_B5 dw 988d
    NOTE_C6 dw 1047d
    NOTE_CS6 dw 1109d
    NOTE_D6 dw 1175d
    NOTE_DS6 dw 1245d
    NOTE_E6 dw 1319d
    NOTE_F6 dw 1397d
    NOTE_FS6 dw 1480d
    NOTE_G6 dw 1568d
    NOTE_GS6 dw 1661d
    NOTE_A6 dw 1760d
    NOTE_AS6 dw 1865d
    NOTE_B6 dw 1976d
    NOTE_C7 dw 2093d
    NOTE_CS7 dw 2217d
    NOTE_D7 dw 2349d
    NOTE_DS7 dw 2489d
    NOTE_E7 dw 2637d
    NOTE_F7 dw 2794d
    NOTE_FS7 dw 2960d
    NOTE_G7 dw 3136d
    NOTE_GS7 dw 3322d
    NOTE_A7 dw 3520d
    NOTE_AS7 dw 3729d
    NOTE_B7 dw 3951d
    NOTE_C8 dw 4186d
    NOTE_CS8 dw 4435d
    NOTE_D8 dw 4699d
    NOTE_DS8 dw 4978d
d1 ENDS
;********************************************************************************************************

;************************************************ stack *************************************************
st1 SEGMENT para stack 'stack'
    dw 250 dup (?)
st1 ENDS
;********************************************************************************************************

;************************************************* code *************************************************
c1 SEGMENT para public 'code'
    ASSUME cs:c1, ds:d1, ss:st1
;************************************************* ??? **************************************************
.286
.386
start:  
    mov ax, d1
    mov ds, ax

    clearWindow ; ??????? ?????
    art counter; ??????? ???????
    
;--------------------------------------------------
;----------------- ????????? ???? -----------------
;--------------------------------------------------
resizeWindow:
    clearWindow
    output resizeText ; ????? ????????? ? ?????? ? ?????
    curPos 85d, 26d ; ?????? ??????? ???????
    
    draw frame_start_x, frame_start_y, frame_end_x, frame_end_y, yellow_bg ; ???????????? ?????
    
    mov al,frame_start_x ; ????????? ?????????? ??? ????????? ???? ?????? ?????
    mov window_start_x,al
    inc window_start_x
    
    mov al,frame_start_y
    mov window_start_y,al
    inc window_start_y

    mov al,frame_end_x
    mov window_end_x,al
    dec window_end_x
    
    mov al,frame_end_y
    mov window_end_y,al
    dec window_end_y
    
    draw window_start_x, window_start_y, window_end_x, window_end_y, gray_bg ;  ???????????? ????
    
    mov ah, 0
    int 16h
    
    cmp ax, 1c0dh ; Enter
    je startInput
   
    cmp al, 77h  ; W
    jne mainWindowsCheckPressA
    pressButtonW frame_start_y, frame_end_y, resizeWindow ; ????????? ??????? ????
    
mainWindowsCheckPressA:
    cmp al, 61h  ; A
    jne mainWindowsCheckPressS
    pressButtonA frame_start_x, frame_end_x, resizeWindow
    
mainWindowsCheckPressS:
    cmp al, 73h   ; S
    jne mainWindowsCheckPressD
    pressButtonS frame_start_y, frame_end_y, resizeWindow
    
mainWindowsCheckPressD:
    cmp al, 64h   ; D
    jne resizeWindow
    pressButtonD frame_start_x, frame_end_x, resizeWindow
    
startInput:
    mov al,window_start_x ; ???????? ?????????? ??? ????????? ??????? ????? ????
    mov cur_pos_x,al
    
    mov al,window_start_y
    mov cur_pos_y,al
    
    curPos cur_pos_x, cur_pos_y ; ??????????? ???????
    
    xor di,di ; di - ????? ????? ? ???????
    mov cx, siz ; cx - ?????? ???????

inputVal:   
    push cx

;--------------------------------------------
;----------------- ???????? -----------------
;--------------------------------------------
check:  
    output invitation
    inc cur_pos_y ; ??????? ?????? ?? ?????? ????
    input inputStr ; ???? ????? ? ???? ??????
    curPos cur_pos_x, cur_pos_y ; ??????? ?????? ?? ?????? ????

    call range ; ???????? ????????? ???????? ?????
    cmp bh,flagErr ; ???????? ?? ??????? ??????
    je inErr
    
    call acceptable ; ???????? ???????????? ????????
    cmp bh, flagErr
    je inErr   

    call AscToBin ; ?????????????? ?????? ? ?????
    add di,0002
    pop cx
    loop inputVal
    jmp sumNegative
    
inErr:          
    jmp inputErr
    
;-----------------------------------------------
;------------- ????? ????????????? -------------
;-----------------------------------------------
sumNegative:
    mov cx, siz
    mov si, offset number
    
    xor ax, ax
    
iter2:
    mov ax,[si]
    cmp ax,0 ; ????????? ? 0
    jg pos1 ; ???? ????? ??????, ?? ???????
    add sumNeg,ax ; ????? ?????????? ? ??????????
    jo overflowSumErr ; ???? ????????????, ?? ???????   
    
pos1:       
    add si,0002
    loop iter2
    
;---------------------------------------------------
;------------- ????????? ????????????? -------------
;---------------------------------------------------
mulPositive:
    mov cx,siz          
    mov si,offset number
    
    mov ax,1 ; ??? ????????? ??????? 1
    
iter1:
    mov bx,[si]
    cmp bx,00h ; ???????? ?? ???????????????
    jl negative1 ; ???? ????????????? - ??????????
    inc posCounter
    imul bx
    jo overFlowErr ; ???? ????????????, ?? ???????  
    
negative1:
    add si,0002
    loop iter1
    
    cmp posCounter,0 ; ???? ????????????? ??? - ??????? 0
    jne iter3
    mov ax,0

iter3:  
    mov mulPos, ax ; ??????? ???????? ? ?????????? 

;----------------------------------------------------------------
;---------------- ???????? ???????????? ? ????? -----------------
;----------------------------------------------------------------
searchDiffSumMul:
    mov ax, mulPos
    sub ax, sumNeg
    mov diffRez, ax

    jmp resOutput ; ??????? ? ?????? ??????????? 

;-----------------------------------------------
;---------------- ????? ?????? -----------------
;-----------------------------------------------
overFlowErr:
    draw 27d, 9d, 53d, 16d, 40h
        
    curPos 34d,12d
    output overflow
        
    curPos 33d,14d
    output pressAnyKey, 33d, 14d
    
    mov ah, 0
    int 16h
        
    jmp ending  
        
inputErr:       
    draw 27d, 9d, 53d, 16d, 40h
    
    curPos 34d,12d
    output InputErrText

    curPos 33d,14d
    output pressAnyKey, 33d, 14d
    
    mov ah, 0
    int 16h

    jmp ending
    
overflowSumErr: 
    draw 27d, 9d, 53d, 16d, 40h

    curPos 34d,12d
    output overflowSum

    curPos 33d,14d
    output pressAnyKey, 33d, 14d
    
    mov ah, 0
    int 16h
    
    jmp ending
    
;---------------------------------------------------
;---------------- ????? ?????????? -----------------
;---------------------------------------------------
resOutput:      
    clearWindow
    draw 0d, 0d, 50d, 4d, 0E0h
    
    mov cur_pos_x, 0d
    mov cur_pos_y, 0d
    
    curPos cur_pos_x, cur_pos_y
    
    output sumNegText
    mov ax, sumNeg
    call BinToAsc
    output outStr
    inc cur_pos_y

    mov cx,6            ;??????? ?????? ??????
    xor si,si
    
clear1:     
    mov [outStr+si],' '
    inc si
    loop clear1

    curPos cur_pos_x, cur_pos_y
    output mulPosText
    mov ax,mulPos   
    call BinToAsc
    output outStr
    inc cur_pos_y

    mov cx,6            ;??????? ?????? ??????
    xor si,si
    
clear2:     
    mov [outStr+si],' '
    inc si
    loop clear2

    curPos cur_pos_x, cur_pos_y
    output diffResText
    mov ax,diffRez  
    call BinToAsc
    output outStr
    inc cur_pos_y
    
    mov cx,6            ;??????? ?????? ??????
    xor si,si
    
clear3:     
    mov [outStr+si],' '
    inc si
    loop clear3

    mov ah, 0
    int 16h

    jmp ending
    
ending: 
    mov ax,4c00h
    int 21h
    
;********************************************** ????????? ***********************************************   
;--------------------------------------------
;------------ ???????? ????????? ------------
;--------------------------------------------
range PROC
    xor bh, bh
    xor si, si
    
    cmp kol, 05h ; ???????,???? ???????? <5
    jb exit
        
    cmp stroka, 2dh ; ???????? ?? ??????? ??????? ??????? ??????
    jne minus
    
    cmp kol, 06h ; ???????, ???? ?????? ?????? - ?????,? ???????? <6
    jb exit        
    
    inc si ; ????? ???????? ?????? ??????
    jmp first

minus:   
    cmp kol,6 ; ???? ??????? 6 ???????? ? ?????? - ?? ????? - ??????? ??????
    je error1
    
first:  
    cmp stroka[si], 32h ; ?????????? ?????? ?????? ? '2'
    jna exit ; ???????,???? ?????? <= '2'
    
error1:
    mov bh, flagErr ; ???????? ??????
    
exit:
    ret
range ENDP

;-----------------------------------------------
;------------ ???????? ???????????? ------------
;-----------------------------------------------
acceptable PROC
    xor bh, bh
    xor si, si
    xor ah, ah
    xor ch, ch
    
    mov cl, kol ; ?????????? ????????? ????????
    
m11:    
    mov al, [stroka + si] ; ?????? ??????
    cmp al, 2dh 
    jne accept  ; ???? ?? ????? - ???????? ????????????
    cmp si, 00h ; ???? ?????  - ???????? ?? ?? ??????
    jne error2  ; ???? ?? ?????? - ??????
    jmp m13
    
accept:
    cmp al, 30h ; ???????? ?? ????????? ?????? ??????
    jb error2
    cmp al, 39h
    ja error2
    
m13:    
    inc si
    loop m11
    jmp m14
    
error2: 
    mov bh, flagErr ; ??? ?????????????? ??????? bh = flagErr
    
m14:    
    ret
acceptable ENDP

;--------------------------------------------
;------------- ?? ASCII ? ????? -------------
;--------------------------------------------
AscToBin PROC
    xor ch, ch
    mov cl, kol
    xor bh, bh
    mov bl, cl
    dec bl
    mov si, 01h ; ??? ???????
    
n1: 
    mov al, [stroka + bx]
    xor ah, ah
    cmp al, 2dh ; ???????? ???? ?????
    je otr  ; ???? ????? ?????????????
    sub al, 30h
    mul si
    add [number + di], ax
    mov ax, si
    mov si, 10
    mul si
    mov si, ax
    dec bx
    loop n1
    jmp n2
otr:    
    neg [number + di] ; ?????????? ????????????? ????? ? ?????????????? ????
    
n2: 
    ret
AscToBin ENDP

;--------------------------------------------
;------------- ?? ????? ? ASCII -------------
;--------------------------------------------
BinToAsc PROC
    xor si, si
    add si, 05h
    mov bx, 0Ah
    push ax
    cmp ax, 00h
    jnl mm1
    neg ax
    
mm1:    
    cwd
    idiv bx
    add dl,30h
    mov [outStr + si], dl
    dec si
    cmp ax, 00h
    jne mm1
    pop ax
    cmp ax, 00h
    jge mm2
    mov [outStr + si], 2dh
    
mm2:    
    ret
BinToAsc ENDP

picture proc ; ???????
    draw 20d, 2d, 22d, 3d, red_bg
    draw 14d, 4d, 28d, 4d, red_bg
    draw 16d, 5d, 26d, 5d, red_bg
    draw 18d, 6d, 24d, 6d, red_bg
    draw 16d, 7d, 26d, 8d, red_bg

    draw 20d, 7d, 22d, 7d, green_bg
    draw 18d, 8d, 24d, 8d, green_bg
    draw 16d, 9d, 26d, 9d, green_bg
    draw 14d, 10d, 28d, 10d, green_bg
    draw 12d, 11d, 30d, 11d, green_bg
    draw 10d, 12d, 32d, 12d, green_bg

    draw 14d, 13d, 28d, 13d, green_bg
    draw 12d, 14d, 30d, 14d, green_bg
    draw 10d, 15d, 32d, 15d, green_bg
    draw 8d, 16d, 34d, 16d, green_bg

    draw 12d, 17d, 30d, 17d, green_bg
    draw 10d, 18d, 32d, 18d, green_bg
    draw 8d, 19d, 34d, 19d, green_bg
    draw 6d, 20d, 36d, 20d, green_bg
    draw 4d, 21d, 38d, 21d, green_bg
    
    draw 18d, 22d, 24d, 24d, brown_bg
    
    draw 8d, 21d, 10d, 21d, cyan_bg
    draw 12d, 20d, 14d, 20d, cyan_bg
    draw 16d, 19d, 18d, 19d, cyan_bg
    draw 20d, 18d, 22d, 18d, cyan_bg
    draw 24d, 17d, 26d, 17d, cyan_bg
    draw 28d, 16d, 30d, 16d, cyan_bg
    
    draw 12d, 16d, 14d, 16d, magenta_bg
    draw 16d, 15d, 18d, 15d, magenta_bg
    draw 20d, 14d, 22d, 14d, magenta_bg
    draw 24d, 13d, 26d, 13d, magenta_bg
    draw 28d, 12d, 30d, 12d, magenta_bg
    
    draw 12d, 12d, 14d, 12d, yellow_bg
    draw 16d, 11d, 18d, 11d, yellow_bg
    draw 20d, 10d, 22d, 10d, yellow_bg
    draw 24d, 9d, 26d, 9d, yellow_bg
    ret
picture endp

music proc
;**********************************************************************************************

jmp beg

    freq    DW 262, 440, 440, 392
            DW 440, 349, 262, 262
            DW 262, 440, 440, 466
            DW 392, 523, 392, 523, 294
            DW 294, 466, 466, 440
            DW 392, 349, 262, 440
            DW 440, 392, 440, 349, -1
            
    delay   Db 4 dup(4)
            Db 4 dup(4)
            Db 4 dup(4)
            Db 4,6,2,2 dup(4)
            Db 4 dup(4)
            Db 4 dup(4)
            Db 3 dup(4),2 dup(6)
 
; ??? ????????? ?????????? ??????? ?????? ??? ???????? ??????? ? ???????? ????????????
; ????? ??????? ????????? ??????? ? ??????? DI ? ???????????? ? ??????? CX
; ???????? ???? ????????? ???????????
 
sound: 
    pusha
    mov al,0B6h
    out 43h,al
    mov dx, 14h   ; freq=1331000 Hz
    mov ax, 4f38h
    div di
    out 42h,al
    mov al,ah
    out 42h,al
    in al,61h
    mov ah,al
    mov port61,al
    or al,3  ; speaker on
    out 61h,al
    push es
    push ax
    mov  ax,0
    mov  es,ax
    
wt0:
    mov  ax,es:[46Ch]
    
wt1:
    push ax
    mov  ah,1
    int 16h
    jnz ex
    pop  ax
    cmp  ax,es:[46Ch]
    jz   wt1
    loop wt0
    pop  ax
    pop  es
    mov al,ah
    out 61h,al ; speaker off
    popa
    ret
 
beg:
    push cs
    pop ds
    mov si,offset freq
    mov bp,offset delay
    
nextnote:
    lodsw
    cmp ax,-1
    jz dosexit
    add ax,ax ; freq=freq*2
    mov di,ax
    mov al,ds:[bp]
    mov ah,0
    shr ax,0  ; ??? ?????? ???????????, ??? ?????? ????????
    mov cx,ax
    call sound
    inc bp
    jmp nextnote
    
ex: 
    mov al,port61
    out 61h,al ; speaker off
    mov ah,0
    int 16h
    jmp dosexit
    dosexit:
ret
music endp
;********************************************************************************************************   

c1 ENDS 
;********************************************************************************************************   

end start
;********************************************************************************************************   