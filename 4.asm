;************************************************ Макросы ************************************************
;--------------------------------------------
;------------------ Вывод -------------------
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
;------------------ Вывод -------------------
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
;----------------- Рисование -----------------
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
;----------------- Очистка ------------------
;--------------------------------------------
clearWindow macro
    mov ax, 0003
    int 10h
endm

;--------------------------------------------
;----------------- Рисунок ------------------
;--------------------------------------------
art macro
	mov cx,8
l1:
	call picture
	add bulb_color_1,10h
	sub bulb_color_2,10h

	mov ah,0
	int 16h
	loop l1
endm

;------------------------------------------------
;----------------- Вывод в окне -----------------
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
;----------------- Позиция курсора -----------------
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
;----------------- Вверх --------------------
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
;------------------- Вниз -------------------
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
;------------------ Влево -------------------
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
;------------------ Вправо ------------------
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

;--------------------------------------------
;----------------- Задержка -----------------
;--------------------------------------------
sleep macro time
	push ax
	push cx
	
    mov al, 0
    mov ah, 86h
    mov cx, time
    int 15h
	
	pop cx
	pop ax
endm
;*********************************************************************************************************

;************************************************* data **************************************************
d1 SEGMENT para public 'data'
	inputStr label byte ; вводимая строка, не больше 6 символов
	kol db (?) ; количество введённых символов
	stroka db 7 dup (?) ; буфер ввода чисел
	number dw 5 dup (0) ; массив чисел
	siz dw 5 ; количество чисел
	posCounter dw 0 ; счётчик положительных
	
	sumNeg dw 0 ; сумма отрицательных
	mulPos dw 0 ; произведение положительных
	diffRez dw 0 ; Разность суммы и произведения

	bulb_color_1 db 30h
	bulb_color_2 db 40h
	tree_color db 20h
	pot_color db 10h
	window_color db 30h
	frame_color db 50h
	
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
	
	treeText db 'Click any button',10,10,'$'
	resizeText db 'Use WASD to change window size',10,10,'$'

	flagErr equ 1
d1 ENDS
;********************************************************************************************************

;************************************************ stack *************************************************
st1 SEGMENT para stack 'stack'
	dw 100 dup (?)
st1 ENDS
;********************************************************************************************************

;************************************************* code *************************************************
c1 SEGMENT para public 'code'
	ASSUME cs:c1, ds:d1, ss:st1
;************************************************* Код **************************************************
.386
start:	
	mov ax, d1
	mov ds, ax

	clearWindow ; очищаем экран
	art ; выводим рисунок
	
;--------------------------------------------------
;----------------- Изменение окна -----------------
;--------------------------------------------------
resizeWindow:
	clearWindow
	output resizeText ; вывод сообщения о работе с окном
	curPos 85d, 26d ; задаём позицию курсора
	
	draw frame_start_x, frame_start_y, frame_end_x, frame_end_y, frame_color ; отрисовываем рамку
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
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
	
	draw window_start_x, window_start_y, window_end_x, window_end_y, window_color ;  отрисовываем окно
	
	mov ah, 0
	int 16h
    
	cmp ax, 1c0dh ; Enter
	je startInput
   
	cmp al, 77h  ; W
	jne mainWindowsCheckPressA
	pressButtonW frame_start_y, frame_end_y, resizeWindow ; изменение размера окна
    
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
	
;--------------------------------------------
;----------------- Проверки -----------------
;--------------------------------------------
startInput:
	mov al,window_start_x ; изменяем координаты для помещения курсора внуть окна
	mov cur_pos_x,al
	
	mov al,window_start_y
	mov cur_pos_y,al
	
	curPos cur_pos_x, cur_pos_y ; перемещение курсора
	
	xor di,di ; di - номер числа в массиве
	mov cx, siz	; cx - размер массива

inputVal:	
	push cx

;--------------------------------------------
;----------------- Проверки -----------------
;--------------------------------------------
check:	
	output invitation
	inc cur_pos_y ; смещаем курсор на строку вниз
	input inputStr ; ввод числа в виде строки
	curPos cur_pos_x, cur_pos_y ; смещаем курсор на строку вниз

	call range ; проверка диапазона вводимых чисел
	cmp bh,flagErr ; проверка на наличие ошибок
	je inErr
	
	call acceptable ; проверка допустимости символов
	cmp bh, flagErr
	je inErr   

	call AscToBin ; преобразование строки в число
	add di,0002
	pop cx
	loop inputVal
	jmp sumNegative
	
inErr:   		
	jmp inputErr
	
;-----------------------------------------------
;------------- Сумма отрицательных -------------
;-----------------------------------------------
sumNegative:
	mov cx, siz
	mov si, offset number
	
	xor ax, ax
	
iter2:
	mov ax,[si]
	cmp ax,0 ; сравнение с 0
	jg pos1	; если число больше, то переход
	add sumNeg,ax ; иначе складываем в переменную
	jo overflowSumErr ; если переполнение, то переход   
	
pos1:		
	add si,0002
	loop iter2
	
;---------------------------------------------------
;------------- Умножение положительных -------------
;---------------------------------------------------
mulPositive:
	mov cx,siz			
	mov si,offset number
	
	mov ax,1 ; для умножения заносим 1
	
iter1:
	mov bx,[si]
	cmp bx,00h ; проверка на отрицательность
	jl negative1 ; если отрицательный - пропускаем
	inc posCounter
	imul bx
	jo overFlowErr ; если переполнение, то переход	
	
negative1:
	add si,0002
	loop iter1
	
	cmp posCounter,0 ; если положительных нет - заносим 0
	jne iter3
	mov ax,0

iter3:	
	mov mulPos, ax ; заносим значение в переменную 

;----------------------------------------------------------------
;---------------- Разность произведения и суммы -----------------
;----------------------------------------------------------------
searchDiffSumMul:
	mov ax, mulPos
	sub ax, sumNeg
	mov diffRez, ax

	jmp resOutput ; переход к выводу результатов 

;-----------------------------------------------
;---------------- Вывод ошибок -----------------
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
;---------------- Вывод результата -----------------
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

	mov cx,6			;очистка буфера вывода
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

	mov cx,6			;очистка буфера вывода
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
	
	mov cx,6			;очистка буфера вывода
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
	
;********************************************** Процедуры ***********************************************	
;--------------------------------------------
;------------ Проверка диапазона ------------
;--------------------------------------------
range PROC
    xor bh, bh
	xor si, si
	
	cmp kol, 05h ; выходим,если символов <5
	jb exit
		
	cmp stroka, 2dh ; проверка на наличие первого символа минуса
	jne minus
	
	cmp kol, 06h ; выходим, если первый символ - минус,и символов <6
	jb exit        
	
	inc si ; иначе проверим первый символ
	jmp first

minus:   
	cmp kol,6 ; если введено 6 символов и первый - не минус - выводим ошибку
	je error1
	
first:  
	cmp stroka[si], 32h ; сравниваем первый символ с '2'
	jna exit ; выходим,если первый <= '2'
	
error1:
	mov bh, flagErr ; отмечаем ошибку
	
exit:
	ret
range ENDP

;-----------------------------------------------
;------------ Проверка допустимости ------------
;-----------------------------------------------
acceptable PROC
	xor bh, bh
    xor si, si
	xor ah, ah
	xor ch, ch
	
	mov cl, kol	; количество введенных символов
	
m11:	
	mov al, [stroka + si] ; первый символ
	cmp al, 2dh 
	jne accept	; если не минус - проверка допустимости
	cmp si, 00h	; если минус  - является ли он первым
	jne error2	; если не первый - ошибка
	jmp m13
	
accept:
	cmp al, 30h	; является ли введенный символ цифрой
	jb error2
	cmp al, 39h
	ja error2
	
m13: 	
	inc si
	loop m11
	jmp m14
	
error2:	
	mov bh, flagErr	; при недопустимости символа bh = flagErr
	
m14:	
	ret
acceptable ENDP

;--------------------------------------------
;------------- Из ASCII в число -------------
;--------------------------------------------
AscToBin PROC
	xor ch, ch
	mov cl, kol
	xor bh, bh
	mov bl, cl
	dec bl
	mov si, 01h ; вес разряда
	
n1:	
	mov al, [stroka + bx]
	xor ah, ah
	cmp al, 2dh	; проверим знак числа
	je otr	; если число отрицательное
	sub al,	30h
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
	neg [number + di] ; представим отрицательное число в дополнительном коде
	
n2:	
	ret
AscToBin ENDP

;--------------------------------------------
;------------- Из числа в ASCII -------------
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

picture proc ; рисунок
	draw 0d, 0d, 80d, 25d, 0F0h
	draw 0d, 0d, 80d, 19d, 0B0h
	output treeText
	draw 12d, 6d, 13d, 7d, 50h
	draw 12d, 8d, 13d, 9d, tree_color
	draw 10d, 10d, 15d, 15d, tree_color
	draw 8d, 12d, 9d, 13d, bulb_color_1
	draw 16d, 12d, 17d, 13d, bulb_color_2
	draw 8d, 16d, 17d, 19d, tree_color
	draw 6d, 18d, 7d, 19d, bulb_color_2
	draw 18d, 18d, 19d, 19d, bulb_color_1
	draw 12d, 20d, 13d, 21d, pot_color
	
	ret
picture endp
;********************************************************************************************************	

c1 ENDS	
;********************************************************************************************************	

end start
;********************************************************************************************************	
