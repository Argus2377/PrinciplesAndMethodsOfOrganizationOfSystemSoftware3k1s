;************************************************ Макросы ************************************************
output macro srting ; макрос вывода сообщений
	push ax
	push dx
	mov dx, offset srting
	mov ah, 09h
	int 21h
	pop dx
	pop ax
endm

input macro srting ; макрос ввода строки
	push ax 
	push dx
	mov dx, offset srting
	mov ah, 0Ah
	int 21h
	pop dx
	pop ax
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
	
	sumNeg dw 0 ; сумма отрицательных
	mulPos dw 0 ; произведение положительных
	diffRez dw 0 ; Разность суммы и произведения
	
	newLine db 10,13,'$'
	inputError db 'Input Error!', 10,10,'$'
	overflow db 'Overflow!', 10,10,'$'
	overflowSum db 'Sum overflow!', 10,10,'$'
	sumNegText db 13,10, 'Sum of negative elements: ','$'
	mulPosText db 13,10, 'Mul of positive element: ','$'
	diffResText db 13,10,'Difference of sum and multiplication: ','$'
	outStr db 6 dup (' '),'$'
	invitation db 'Input number from -29999 to 29999: $'
	
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
start:	
	mov ax, d1
	mov ds, ax
	
	
	mov ax, 03h ; установка текстового видеорежима, очистка экрана, ah - номер функции,al - номер режима
	int 10h

    xor di,di ; di - номер числа в массиве
    mov cx, siz	; cx - размер массива
	
inputVal:	
	push cx
	
;--------------------------------------------
;----------------- Проверки -----------------
;--------------------------------------------
check:	
	output invitation ; вывод сообщения о вводе строки
	input inputStr ; ввод числа в виде строки
	output newLine ; переход на новую строку
	
	call range ; проверка диапазона вводимых чисел
	cmp bh, flagErr ; проверка на наличие ошибок
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
	output inputError	
	jmp check
		
;-----------------------------------------------
;------------- Сумма отрицательных -------------
;-----------------------------------------------
sumNegative: 
	mov cx, siz
	mov si, offset number
	
	;xor ax, ax
	
iter2:
	mov ax,[si]
	cmp ax,0 ; сравнение с 0
	jg pos1	; если число больше, то переход
	add sumNeg,ax ; иначе складываем в переменную ; добавить счётчик
	jo overflowSumErr ; если переполнение, то переход   ; в отчёт флаг переполнения
	
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
	imul bx ;в отчёт /переполнение при imul/
	jo overFlowErr ; если переполнение, то переход	
	
negative1:
	add si,0002
	loop iter1
	
	cmp posCounter,0
	jne iter3
	mov ax,0

iter3:	
	mov mulPos, ax ; заносим значение в переменную 

;----------------------------------------------------------------
;---------------- Разность произведения и суммы -----------------
;----------------------------------------------------------------
searchDiffSumMul:
	mov ax, mulPos; теория про деление
	sub ax, sumNeg
	mov diffRez, ax

	jmp resOutput		;переход к выводу результатов 
	
	
;-----------------------------------------------
;---------------- Вывод ошибок -----------------
;-----------------------------------------------
overFlowErr:		
	output overflow  ;вывод сообщения о переполнении
	jmp ending
	
overflowSumErr:
	output overflowSum
	jmp ending		
	
;---------------------------------------------------
;---------------- Вывод результата -----------------
;---------------------------------------------------
resOutput:		
	output sumNegText
	mov ax, sumNeg
	call BinToAsc
	output outStr

	mov cx,6 ; очистка буфера вывода
	xor si,si
clear1:		
	mov [outStr+si],' '
	inc si
	loop clear1

	output mulPosText
	mov ax,mulPos	
	call BinToAsc
	output outStr

	mov cx,6
	xor si,si
clear2:		
	mov [outStr+si],' '
	inc si
	loop clear2

	output diffResText
	mov ax,diffRez	
	call BinToAsc
	output outStr
	
	mov cx,6
	xor si,si
		
clear3:		
	mov [outStr+si],' '
	inc si
	loop clear3

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
;********************************************************************************************************	

c1 ENDS	
;********************************************************************************************************

end start
;********************************************************************************************************