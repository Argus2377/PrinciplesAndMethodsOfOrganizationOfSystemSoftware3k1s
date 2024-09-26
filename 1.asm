.model small
extrn _printf:near
extrn _getch:near
extrn  _summ:word
PUBLIC _asmrazn
PUBLIC asmsumm
.CODE
_asmrazn PROC near           ;x:word,y:word
	push bp
	mov bp,sp
;Вызов станд. функии С printf(mes)
	mov dx,offset mes1
	push dx
	call _printf
	pop ax
        mov ax,[bp+4]     ;x
        sub ax,[bp+6]     ;y
;Функция возвращает значение через AX
	push ax
        call _getch
	pop ax
	pop bp
	ret
_asmrazn endp
asmsumm PROC  near x:word,y:word
	push bp
	mov bp,sp
;Вызов станд. функии С printf(mes)
	mov dx,offset mes2
	push dx
	call _printf
	pop ax
        mov ax,y            ;[bp+4]
        add ax,x            ;[bp+6]
;Функция возвращает значение через _summ
	mov _summ,ax
        call _getch
	pop bp
	ret 4
asmsumm endp

.data
mes1 db "Assembler: b-a ",10,13,0
mes2 db 10,13,"Assembler: a+b",10,13,0
end
