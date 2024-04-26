_entry:
	MOV  SP, 0x1000   ;-- BC0010
	CALL _get_key     ;-- E80A00
	CALL _put_char    ;-- E80200
	JMP  _entry       ;-- EBF8


_put_char:
; AL = character to print
	MOV AH, 0x0E      ;-- B40E
	INT 0x10          ;-- CD10
	RET               ;-- C3


_get_key:
	XOR AH, AH        ;-- 30E4
	INT 0x16          ;-- CD16
	RET               ;-- C3
