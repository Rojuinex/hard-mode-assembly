_entry:
	MOV SP, 0x1000              ;-- BC0010
	XOR AX, AX                  ;-- 31C0

	_entry_loop:
		CALL _print_byte    ;-- E80800
		INC AX              ;-- 40
		CMP AX, 0x0100      ;-- 3D0010
		JS _entry_loop      ;-- 78F7
	
_hang:
	JMP _hang                   ;-- EBFE

_print_byte:
; AL = the byte to be printed
	PUSH AX                     ;-- 50
	PUSH BX                     ;-- 53
	MOV BL, AL                  ;-- 88C3

	AND AL, 0xF0                ;-- 24F0
	SHR AL, 0x04                ;-- C0E804
	CALL _print_nibble          ;-- E80F00
	MOV AL, BL                  ;-- 88D8
	AND AL, 0x0F                ;-- 240F
	CALL _print_nibble          ;-- E80800
	MOV AX, 0x0E20              ;-- B8200E
	INT 0x10                    ;-- CD10


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
