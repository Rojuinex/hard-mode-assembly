_entry:
	MOV  SP, 0x1000   ;-- BC0010
	CALL _get_key     ;-- E81300

	CMP AL, 0x0D      ;-- 3C0D
	JNE _disp_char    ;-- 7505
	CALL _put_char    ;-- E80700
	MOV AL, 0x0A      ;-- B00A

	_disp_char:
	CALL _put_char    ;-- E80200
	JMP  _entry       ;-- EBEC


_put_char:
; AL = character to print
	MOV AH, 0x0E      ;-- B40E
	INT 0x10          ;-- CD10
	RET               ;-- C3


_get_key:
	XOR AH, AH        ;-- 30E4
	INT 0x16          ;-- CD16
	RET               ;-- C3
