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
art macro count
	call picture
	
again:
	mov ah,0
	int 16h
	cmp ax, 1c0dh ; Enter
	je next
	jmp exiting
	
next:
	test count,1
	jz stop
	call picture
	mov red_bg,0C0h
	mov yellow_bg,0F0h
	mov magenta_bg,0D0h
	mov cyan_bg,0B0h

stop:
	call picture
	mov red_bg,40h
	mov yellow_bg,0E0h
	mov magenta_bg,50h
	mov cyan_bg,30h

	inc count
	loop again
exiting:
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

    
    dec y1
    dec y2
    
    jmp destination
endm

;--------------------------------------------
;------------------- Вниз -------------------
;--------------------------------------------
pressButtonS macro y1, y2, destination
	cmp y2, 24d
    je destination
    
    inc y1
    inc y2
    
    jmp destination
endm

;--------------------------------------------
;------------------ Влево -------------------
;--------------------------------------------
pressButtonA macro x1, x2, destination
    cmp x1, 0d
    je destination
    
    dec x1
    dec x2
    
    jmp destination
endm

;--------------------------------------------
;------------------ Вправо ------------------
;--------------------------------------------
pressButtonD macro x1, x2, destination
	cmp x2, 79d
    je destination
    
    inc x1
    inc x2
    
    jmp destination
endm

;*********************************************************************************************************

;************************************************* data **************************************************
d1 SEGMENT para public 'data'
	inputStr label byte ; вводимая строка, не больше 6 символов
	size_of_buf db 7 ; размер буфера
	kol db (?) ; количество введённых символов
	stroka db 7 dup (?) ; буфер ввода чисел
	number dw 5 dup (0) ; массив чисел
	siz dw 5 ; количество чисел
	posCounter dw 0 ; счётчик положительных
	counter dw 1 ; счётчик для рисунка
	windowCounter dw 0 ; счётчик окон
	
	sumNeg dw 0 ; сумма отрицательных
	mulPos dw 0 ; произведение положительных
	diffRez dw 0 ; разность суммы и произведения

	black_bg db 0h ; чёрный фон
	white_bg db 70h ; белый фон
	gray_bg db 80h ; серый фон
	
	red_bg db 40h ; красный фон
	green_bg db 20h ; зелёный фон
	blue_bg db 10h ; синий фон
	
	brown_bg db 60h ; коричневый фон
	yellow_bg db 0E0h ; жёлтый фон
	
	cyan_bg db 30h ; голубой фон
	magenta_bg db 50h ; сиреневый фон
	
	bright_red_bg db 0C0h ; ярко-красный фон
	bright_green_bg db 0A0h ; ярко-зелёный фон
	bright_blue_bg db 90h ; ярко-синий фон
	
	bright_cyan_bg db 0B0h ; ярко-голубой фон
	bright_magenta_bg db 0D0h ; ярко-сиреневый фон
	
	bright_white_bg db 0F0h ; ярко-белый фон
	
	window_start_x db 2d
	window_start_y db 2d
	window_end_x db 38d
	window_end_y db 10d
	
	frame_start_x db 1d
	frame_start_y db 1d
	frame_end_x db 39d
	frame_end_y db 11d
	
	window_1_window_start_x db 2d
	window_1_window_start_y db 2d
	window_1_window_end_x db 38d
	window_1_window_end_y db 10d
	
	window_1_frame_start_x db 1d
	window_1_frame_start_y db 1d
	window_1_frame_end_x db 39d
	window_1_frame_end_y db 11d
	
	window_2_window_start_x db 2d
	window_2_window_start_y db 2d
	window_2_window_end_x db 38d
	window_2_window_end_y db 10d
	
	window_2_frame_start_x db 1d
	window_2_frame_start_y db 1d
	window_2_frame_end_x db 39d
	window_2_frame_end_y db 11d
	
	window_3_window_start_x db 2d
	window_3_window_start_y db 2d
	window_3_window_end_x db 38d
	window_3_window_end_y db 10d
	
	window_3_frame_start_x db 1d
	window_3_frame_start_y db 1d
	window_3_frame_end_x db 39d
	window_3_frame_end_y db 11d
	
	window_4_window_start_x db 2d
	window_4_window_start_y db 2d
	window_4_window_end_x db 38d
	window_4_window_end_y db 10d
	
	window_4_frame_start_x db 1d
	window_4_frame_start_y db 1d
	window_4_frame_end_x db 39d
	window_4_frame_end_y db 11d
	
	window_1_cur_pos_x db 0d
	window_1_cur_pos_y db 0d
	
	window_2_cur_pos_x db 0d
	window_2_cur_pos_y db 0d
	
	window_3_cur_pos_x db 0d
	window_3_cur_pos_y db 0d
	
	window_4_cur_pos_x db 0d
	window_4_cur_pos_y db 0d
	
	cur_pos_x db 0d
	cur_pos_y db 0d

	InputErrText db 'Input Error!', 10,10,'$'
	overflow db 'Overflow!', 10,10,'$'
	overflowSum db 'Sum overflow!',10,10,'$'
	sumNegText db 'Sum of negative: ','$'
	mulPosText db  'Mul of positive: ','$'
	diffResText db 'Difference: ','$'
	outStr db 6 dup (' '),'$'
	invitation db 'Input number from -29999 to 29999:$'
	pressAnyKey db 'Press any key', 10, '$'
	
	resizeText db 'Use WASD to move window',10,10,'$'

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
	art counter; выводим рисунок
	
;--------------------------------------------------
;----------------- Изменение окна -----------------
;--------------------------------------------------
moveWindow:
	clearWindow
	output resizeText ; вывод сообщения о работе с окном
	curPos 85d, 26d ; задаём позицию курсора
	
	cmp windowCounter,0
	je dw0
	cmp windowCounter,1
	je dw1
	cmp windowCounter,2
	je dw2
	cmp windowCounter,3
	je dw3
	
dw3:
	draw window_3_frame_start_x, window_3_frame_start_y, window_3_frame_end_x, window_3_frame_end_y, yellow_bg
	draw window_3_window_start_x, window_3_window_start_y, window_3_window_end_x, window_3_window_end_y, gray_bg
	
dw2:
	draw window_2_frame_start_x, window_2_frame_start_y, window_2_frame_end_x, window_2_frame_end_y, yellow_bg
	draw window_2_window_start_x, window_2_window_start_y, window_2_window_end_x, window_2_window_end_y, gray_bg
	
dw1:
	draw window_1_frame_start_x, window_1_frame_start_y, window_1_frame_end_x, window_1_frame_end_y, yellow_bg
	draw window_1_window_start_x, window_1_window_start_y, window_1_window_end_x, window_1_window_end_y, gray_bg
	
dw0:	
	draw frame_start_x, frame_start_y, frame_end_x, frame_end_y, yellow_bg ; отрисовываем рамку
	
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
	
	draw window_start_x, window_start_y, window_end_x, window_end_y, gray_bg ;  отрисовываем окно
	
	mov ah, 0
	int 16h
    
	cmp ax, 1c0dh ; Enter
	je fix
	
   
	cmp al, 77h  ; W
	jne PressA
	pressButtonW frame_start_y, frame_end_y, moveWindow 
    
	PressA:
	cmp al, 61h  ; A
	jne PressS
	pressButtonA frame_start_x, frame_end_x, moveWindow
    
	PressS:
	cmp al, 73h   ; S
	jne PressD
	pressButtonS frame_start_y, frame_end_y, moveWindow
    
	PressD:
	cmp al, 64h   ; D
	jne moveWindow
	pressButtonD frame_start_x, frame_end_x, moveWindow

fix:
	cmp windowCounter,0
	je fix1
	cmp windowCounter,1
	je fix2
	cmp windowCounter,2
	je fix3
	cmp windowCounter,3
	je fix4
	
fix1:
	mov al,window_start_x ; изменяем координаты для помещения курсора внуть окна
	mov window_1_cur_pos_x,al
	
	mov al,window_start_y
	mov window_1_cur_pos_y,al
	
	inc windowCounter
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_1_frame_start_x,al
	
	mov al,frame_start_y
	mov window_1_frame_start_y,al

	mov al,frame_end_x
	mov window_1_frame_end_x,al
		
	mov al,frame_end_y
	mov window_1_frame_end_y,al
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_1_window_start_x,al
	inc window_1_window_start_x
	
	mov al,frame_start_y
	mov window_1_window_start_y,al
	inc window_1_window_start_y

	mov al,frame_end_x
	mov window_1_window_end_x,al
	dec window_1_window_end_x
	
	mov al,frame_end_y
	mov window_1_window_end_y,al
	dec window_1_window_end_y
	
	jmp moveWindow
	
fix2:
	mov al,window_start_x ; изменяем координаты для помещения курсора внуть окна
	mov window_2_cur_pos_x,al
	
	mov al,window_start_y
	mov window_2_cur_pos_y,al
	
	inc windowCounter
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_2_frame_start_x,al
	
	mov al,frame_start_y
	mov window_2_frame_start_y,al

	mov al,frame_end_x
	mov window_2_frame_end_x,al
		
	mov al,frame_end_y
	mov window_2_frame_end_y,al
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_2_window_start_x,al
	inc window_2_window_start_x
	
	mov al,frame_start_y
	mov window_2_window_start_y,al
	inc window_2_window_start_y

	mov al,frame_end_x
	mov window_2_window_end_x,al
	dec window_2_window_end_x
	
	mov al,frame_end_y
	mov window_2_window_end_y,al
	dec window_2_window_end_y
	
	jmp moveWindow
	
fix3:
	mov al,window_start_x ; изменяем координаты для помещения курсора внуть окна
	mov window_3_cur_pos_x,al
	
	mov al,window_start_y
	mov window_3_cur_pos_y,al
	
	inc windowCounter
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_3_frame_start_x,al
	
	mov al,frame_start_y
	mov window_3_frame_start_y,al

	mov al,frame_end_x
	mov window_3_frame_end_x,al
		
	mov al,frame_end_y
	mov window_3_frame_end_y,al
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_3_window_start_x,al
	inc window_3_window_start_x
	
	mov al,frame_start_y
	mov window_3_window_start_y,al
	inc window_3_window_start_y

	mov al,frame_end_x
	mov window_3_window_end_x,al
	dec window_3_window_end_x
	
	mov al,frame_end_y
	mov window_3_window_end_y,al
	dec window_3_window_end_y
	
	jmp moveWindow
	
fix4:
	mov al,window_start_x ; изменяем координаты для помещения курсора внуть окна
	mov window_4_cur_pos_x,al
	
	mov al,window_start_y
	mov window_4_cur_pos_y,al
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_4_frame_start_x,al
	
	mov al,frame_start_y
	mov window_4_frame_start_y,al

	mov al,frame_end_x
	mov window_4_frame_end_x,al
		
	mov al,frame_end_y
	mov window_4_frame_end_y,al
	
	mov al,frame_start_x ; уменьшаем координаты для помещения окна внутри рамки
	mov window_4_window_start_x,al
	inc window_4_window_start_x
	
	mov al,frame_start_y
	mov window_4_window_start_y,al
	inc window_4_window_start_y

	mov al,frame_end_x
	mov window_4_window_end_x,al
	dec window_4_window_end_x
	
	mov al,frame_end_y
	mov window_4_window_end_y,al
	dec window_4_window_end_y
	
startInput:

	curPos window_1_cur_pos_x, window_1_cur_pos_y ; перемещение курсора
	
	xor di,di ; di - номер числа в массиве
	mov cx, siz	; cx - размер массива

inputVal:	
	push cx

;--------------------------------------------
;----------------- Проверки -----------------
;--------------------------------------------
check:	
	output invitation
	inc window_1_cur_pos_y ; смещаем курсор на строку вниз
	input inputStr ; ввод числа в виде строки
	curPos window_1_cur_pos_x, window_1_cur_pos_y ; смещаем курсор на строку вниз

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
	draw 27d, 9d, 53d, 16d, bright_red_bg
		
	curPos 34d,12d
	output overflow
		
	curPos 33d,14d
	output pressAnyKey, 33d, 14d
	
	mov ah, 0
	int 16h
		
	jmp ending	
		
inputErr:		
	draw 27d, 9d, 53d, 16d, bright_red_bg
	
	curPos 34d,12d
	output InputErrText

	curPos 33d,14d
	output pressAnyKey, 33d, 14d
	
	mov ah, 0
	int 16h

	jmp ending
	
overflowSumErr:	
	draw 27d, 9d, 53d, 16d, bright_red_bg

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
	
	curPos window_2_cur_pos_x, window_2_cur_pos_y
	output sumNegText
	mov ax, sumNeg
	call BinToAsc
	output outStr

	mov cx,6			;очистка буфера вывода
	xor si,si
	
clear1:		
	mov [outStr+si],' '
	inc si
	loop clear1

	curPos window_3_cur_pos_x, window_3_cur_pos_y 
	output mulPosText
	mov ax,mulPos	
	call BinToAsc
	output outStr

	mov cx,6			;очистка буфера вывода
	xor si,si
	
clear2:		
	mov [outStr+si],' '
	inc si
	loop clear2

	curPos window_4_cur_pos_x, window_4_cur_pos_y 
	output diffResText
	mov ax,diffRez	
	call BinToAsc
	output outStr
	
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
;********************************************************************************************************	

c1 ENDS	
;********************************************************************************************************	

end start
;********************************************************************************************************	