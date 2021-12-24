;Вариант 10:
;	Вычислить сумму чисел, кратных заданному, а затем поделить это число на произведение положительных чисел

;-+-+-+-Макрос вывода сообщений на экран-+-+-+-
output macro f1
		push ax
		push dx
		mov dx, offset f1
		mov ah, 09h
		int 21h
		pop dx
		pop ax
endm

;-+-+-+-Макрос вывода строки символов-+-+-+-
input macro f2 	
		push ax 
		push dx
		mov dx, offset f2
		mov ah, 0Ah
		int 21h
		pop dx
		pop ax
endm

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

clearWindow macro
    mov ax, 0003
    int 10h
endm

drawTree macro
		mov cx,8
	l1:
		call drawin
		add bulb_color_1,10h
		sub bulb_color_2,10h
	
		mov ah,0
		int 16h
		loop l1
endm

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


pressButtonW macro y1, y2, destination
    cmp y1, 0d
    je destination
	cmp y2, 24d
    je destination
    
    dec y1
    inc y2
    
    jmp destination
endm

pressButtonS macro y1, y2, destination
    cmp y1, 8d
    je destination
	cmp y2, 17d
    je destination
    
    inc y1
    dec y2
    
    jmp destination
endm

pressButtonA macro x1, x2, destination
    cmp x1, 19d
    je destination
	cmp x2, 60d
    je destination
    
    inc x1
    dec x2
    
    jmp destination
endm

pressButtonD macro x1, x2, destination
    cmp x1, 0d
    je destination
	cmp x2, 79d
    je destination
    
    dec x1
    inc x2
    
    jmp destination
endm


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



d1 SEGMENT para public 'data'

		input_string label byte  ; Cтрока ввода (<=6)
		size_of_buf db 7         ; Размер буфера
		kol db (?)               ; Количество введеных символов
		stroka db 7 dup (?)      ; Буфер ввода чисел
		number dw 5 dup (0)  	 ; Mассив чисел
		
		CratSum dw 0              ; Сумма кратных чисел
		lenCratSum = $ - CratSum
		MulPositive dw 0          ; Произведение положительных
		lenMulPositive = $ - MulPositive
		Rez_of_Div dw 0           ; Результат деления суммы и произведения
		lenRez_of_Div = $ - Rez_of_Div
		size_of_num dw 5          ; Kоличество чисел
		CratNumber dw 5			  ; Кратное число
	
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
	
		new_line db 10,13,'$'
		InputErrText db 'Input Error!', 10,10,'$'
		zeroError db 'Zero',10,10,'$'
		overflowMul db 'Multiplication overflow!',10,10,'$'
		overflow db 'Sum overflow!', 10,10,'$'
		CratSumLine db 13,10, 'Sum of multiples numbers:                ','$'
		MulPositiveLine db 13,10, 'Mul of positive element:                 ','$'
		DivRezLine db 13,10,'Result of divide between Sum and Mul:    ','$'
		out_str db 6 dup (' '),'$'
		EnterLine db 'Input number from -29999 to 29999: $'
		Debug db 'debug', 10,10,'$'
		pressAnyKey db 'Press any key', 10, '$'
		
		treeText db 'Click any button',10,10,'$'
		resizeText db 'Use WASD to change window size',10,10,'$'
	
		flag_err equ 1
d1 ENDS



st1 SEGMENT para stack 'stack'
		dw 100 dup (?)
st1 ENDS



;-+-+-+-Точка входа в программу-+-+-+-
c1 SEGMENT para public 'code'
		ASSUME cs:c1, ds:d1, ss:st1
.386
start:	
		mov ax, d1
		mov ds, ax
	
		clearWindow
		
		drawTree
	
		clearWindow

resizeWindow:
		clearWindow
		output resizeText
		curPos 85d, 26d
		
		draw frame_start_x, frame_start_y, frame_end_x, frame_end_y, frame_color
		
		mov al,frame_start_x
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
		
		draw window_start_x, window_start_y, window_end_x, window_end_y, window_color
		
		mov ah, 0
		int 16h
    
		; if <Enter>
		cmp ax, 1c0dh
		je startInput
    
		; press W
		cmp al, 77h
		jne mainWindowsCheckPressA
		pressButtonW frame_start_y, frame_end_y, resizeWindow
    
		; press A
mainWindowsCheckPressA:
		cmp al, 61h
		jne mainWindowsCheckPressS
		pressButtonA frame_start_x, frame_end_x, resizeWindow
    
		; press S
mainWindowsCheckPressS:
		cmp al, 73h
		jne mainWindowsCheckPressD
		pressButtonS frame_start_y, frame_end_y, resizeWindow
    
		; press D
mainWindowsCheckPressD:
		cmp al, 64h
		jne resizeWindow
		pressButtonD frame_start_x, frame_end_x, resizeWindow
		
		

;-+-+-+-Ввод элементов с проверкой-+-+-+-
startInput:
		mov al,window_start_x
		mov cur_pos_x,al
		
		mov al,window_start_y
		mov cur_pos_y,al
		
		curPos cur_pos_x, cur_pos_y
		
		xor di,di		
		mov cx, size_of_num	
	
inputVal:	
		push cx
	
check:	
		output EnterLine
		inc cur_pos_y
		input input_string
		curPos cur_pos_x, cur_pos_y
		;output new_line  
	
		call diapazon		;Проверка диапазона
		cmp bh, flag_err  	;Сравним bh и flag_err
		je inErr         	;Если равен 1 сообщение об ошибке ввода

		call dopust			;Проверка допустимости
		cmp bh, flag_err  	;Сравним bh и flag_err
		je inErr         	
	
		call AscToBin 	
		inc di
		inc di
		pop cx
		loop inputVal
		jmp searchCratSum
	
inErr:   		
		;output InputErr	
		jmp inputErr
	
;-+-+-+-Нахождение суммы элементов, кратных заданному-+-+-+-
searchCratSum:
		mov cx, size_of_num	
		mov si, offset number
		xor ax, ax
sumCrat:
		mov ax,[si]
		cmp ax, 0	
		jnl no_neg
		neg ax
no_neg:
		cwd
		idiv CratNumber
		cmp dx,0
		je e3
e2:
		inc si
		inc si
		loop sumCrat
		jmp searchMulPus
e3:
		mov ax,[si]
		add CratSum,ax
		jo overFlowErr
		jmp e2 
		
;-+-+-+-Нахождение произведения положительных элементов-+-+-+-
searchMulPus:
		mov cx, size_of_num				
		mov si, offset number
	
		mov ax, 1				;для умножения заносим 1
	
plusEl:
		mov bx,[si]
		cmp bx, 00h
		jl minusEl				;если отрицательный - пропускаем
		imul bx					
		jo overflowMulErr
	
minusEl:
		inc si
		inc si
		loop plusEl
	
		cmp ax,0
		je zeroErr
	
		mov MulPositive, ax			;заносим значение в переменную 

;-+-+-+-Деление суммы на произведение-+-+-+-
		mov ax,CratSum
		cwd
		idiv MulPositive
		mov Rez_of_Div,ax
		jmp resOutput

;-+-+-+-Вывод ошибок-+-+-+-
overFlowErr:	
		draw 27d, 9d, 53d, 16d, 40h
		
		;mov cur_pos_x, 34d
		;mov cur_pos_y, 12d
		curPos 34d,12d
		output overflow
		;mov cur_pos_x, 33d
		;mov cur_pos_y, 14d
		curPos 33d,14d
		output pressAnyKey, 33d, 14d
	
		mov ah, 0
		int 16h
		
		jmp progend	
zeroErr:		
		draw 27d, 9d, 53d, 16d, 40h
		
		;mov cur_pos_x, 34d
		;mov cur_pos_y, 12d
		curPos 34d,12d
		output zeroError
		;mov cur_pos_x, 33d
		;mov cur_pos_y, 14d
		curPos 33d,14d
		output pressAnyKey, 33d, 14d
	
		mov ah, 0
		int 16h

		jmp progend
inputErr:		
		draw 27d, 9d, 53d, 16d, 40h
		
		;mov cur_pos_x, 34d
		;mov cur_pos_y, 12d
		curPos 34d,12d
		output InputErrText
		;mov cur_pos_x, 33d
		;mov cur_pos_y, 14d
		curPos 33d,14d
		output pressAnyKey, 33d, 14d
	
		mov ah, 0
		int 16h

		jmp progend
overflowMulErr:	
		draw 27d, 9d, 53d, 16d, 40h
		
		;mov cur_pos_x, 34d
		;mov cur_pos_y, 12d
		curPos 34d,12d
		output overflowMul
		;mov cur_pos_x, 33d
		;mov cur_pos_y, 14d
		curPos 33d,14d
		output pressAnyKey, 33d, 14d
	
		mov ah, 0
		int 16h

		jmp progend		
;-+-+-+-Вывод полученных результатов-+-+-+-
resOutput:		
		clearWindow
		draw 0d, 0d, 50d, 4d, 0E0h
		
		mov cur_pos_x, 0d
		mov cur_pos_y, 0d
		
		curPos cur_pos_x, cur_pos_y
		
		output CratSumLine
		;add cur_pos_x, lenCratSum
		mov ax, CratSum
		call BinToAsc
		output out_str
		inc cur_pos_y
		;mov cur_pos_x, 0d

		mov cx,6			;очистка буфера вывода
		xor si,si
clear1:		
		mov [out_str+si],' '
		inc si
		loop clear1

;----------
		curPos cur_pos_x, cur_pos_y
		output MulPositiveLine
		;add cur_pos_x, lenMulPositive
		mov ax,MulPositive
		call BinToAsc
		output out_str
		inc cur_pos_y
		;mov cur_pos_x, 0d

		mov cx,6			;очистка буфера вывода
		xor si,si
clear2:		
		mov [out_str+si],' '
		inc si
		loop clear2

;----------
		curPos cur_pos_x, cur_pos_y
		output DivRezLine
		;add cur_pos_x, lenRez_of_Div
		mov ax,Rez_of_Div	
		call BinToAsc
		output out_str
		inc cur_pos_y
		;mov cur_pos_x, 11d
	
		mov cx,6			;очистка буфера вывода
		xor si,si
		
clear3:		
		mov [out_str+si],' '
		inc si
		loop clear3

;----------
		mov ah, 0
		int 16h

		jmp progend
progend:	
		mov ax,4c00h
		int 21h
	
	

DIAPAZON PROC
		xor bh, bh
		xor si, si
	
		cmp kol, 05h 	; Если ввели менее 5 символов, проверим их допустимость
		jb dop
		
		cmp stroka, 2dh 	; Eсли ввели 5 или более символов проверим является ли первый минусом
		jne plus 	; Eсли 1 символ не минус, проверим число символов
	
		cmp kol, 06h 	; Eсли первый - минус и символов меньше 6 проверим допустимость символов 
		jb dop        
	
		inc si		; Иначе проверим первую цифру
		jmp first

plus:   
		cmp kol,6	; Bведено 6 символов и первый - не минус 
		je error1	; Oшибка
	
first:  
		cmp stroka[si], 32h	; Cравним первый символ с '2'
		jna dop		; Eсли первый <= '2' - проверим допустимость символов
	
error1:
		mov bh, flag_err	; Иначе bh = flag_err
	
dop:	
		ret
DIAPAZON ENDP


DOPUST PROC

		xor bh, bh
		xor si, si
		xor ah, ah
		xor ch, ch
	
		mov cl, kol	; В (cl) количество введенных символов
	
m11:	
		mov al, [stroka + si] 	; B (al) - первый символ
		cmp al, 2dh	; Является ли символ минусом
		jne testdop	; Если не минус - проверка допустимости
		cmp si, 00h	; Если минус  - является ли он первым символом
		jne error2	; Если минус не первый - ошибка
		jmp m13
	
testdop:
		cmp al, 30h	;Является ли введенный символ цифрой
		jb error2
		cmp al, 39h
		ja error2
	
m13: 	
		inc si
		loop m11
		jmp m14
	
error2:	
		mov bh, flag_err	; При недопустимости символа bh = flag_err
	
m14:	
		ret
DOPUST ENDP


AscToBin PROC
		xor ch, ch
		mov cl, kol
		xor bh, bh
		mov bl, cl
		dec bl
		mov si, 01h  ; В si вес разряда
	
n1:	
		mov al, [stroka + bx]
		xor ah, ah
		cmp al, 2dh	; Проверим знак числа
		je otr	; Eсли число отрицательное
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
		neg [number + di]	; Представим отрицательное число в дополнительном коде
	
n2:	
		ret
AscToBin ENDP


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
		mov [out_str + si], dl
		dec si
		cmp ax, 00h
		jne mm1
		pop ax
		cmp ax, 00h
		jge mm2
		mov [out_str + si], 2dh
	
mm2:	
		ret
BinToAsc ENDP

drawin proc
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
drawin endp
	  
c1 ENDS	
end start