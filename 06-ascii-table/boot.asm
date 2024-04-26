_entry:
	MOV SP, 0x1000              ;-- BC0010
	XOR AX, AX                  ;-- 31C0
	XOR BX, BX                  ;-- 31DB

	_loop:
		MOV AL, BL          ;-- 88D8
		CALL _print_byte    ;-- E82000
		MOV AL, 0x20        ;-- B020
		CALL _put_char      ;-- E81600
		MOV AL, BL          ;-- 88D8
		CALL _put_char      ;-- E81100
		MOV AL, 0x0A        ;-- B00A
		CALL _put_char      ;-- E80C00
		MOV AL, 0x0D        ;-- B00D
		CALL _put_char      ;-- E80700
		INC BL              ;-- FEC3
		JNZ _loop           ;-- 75E3


_hang:
	HLT                         ;-- F4
	JMP _hang                   ;-- EBFD



_put_char:
; AL = character to print
	MOV AH, 0x0E                ;-- B40E
	INT 0x10                    ;-- CD10
	RET                         ;-- C3


_print_byte:
; AL = the byte to be printed
	PUSH AX                     ;-- 50
	PUSH BX                     ;-- 53
	MOV BL, AL                  ;-- 88C3

	AND AL, 0xF0                ;-- 24F0
	SHR AL, 0x04                ;-- C0E804
	CALL _print_nibble          ;-- E80A00
	MOV AL, BL                  ;-- 88D8
	AND AL, 0x0F                ;-- 240F
	CALL _print_nibble          ;-- E80300


	POP BX                      ;-- 5B
	POP AX                      ;-- 58
	RET                         ;-- C3
	

_print_nibble:
; AL = the nibble to print
; 0-9 => 0x30-0x39
; A-F => 0x41-0x46

	CMP AL, 0x0A                ;-- 3C0A
	JS _print_nibble_1          ;-- 7802
	ADD AL, 0x07                ;-- 0407
	_print_nibble_1:
	ADD AL, 0x30                ;-- 0430
	MOV AH, 0x0E                ;-- B40E
	INT 0x10                    ;-- CD10
	RET                         ;-- C3
