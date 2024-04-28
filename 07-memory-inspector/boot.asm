_entry:
	MOV SP, 0x8000                     ;-- BC0080       ; 0x7C00
	JMP _main                          ;-- EB4200       ; 0x7C03
	; Padding for edits to entry
	                                   ;-- 9090         ; 0x7C06
	                                   ;-- 9090         ; 0x7C08
	                                   ;-- 9090         ; 0x7C0A
	                                   ;-- 9090         ; 0x7C0C

title db "Memory inspector\n", 0           ; ...            ; 0x7C0E
;-- 4d656d6f727920696e73706563746f720a     ; 17 bytes
;-- 00                                     ; null           ; 0x7C1F

; Utility procedures

_put_str:
; AX = address of string
	PUSH AX                            ;-- 50           ; 0x7C20
	PUSH BX                            ;-- 53           ; 0x7C21
	MOV BX, AX                         ;-- 89C3         ; 0x7C22

	_put_str_loop:
		MOV AL, [BX]               ;-- 8B07         ; 0x7C24
		INC BX                     ;-- 43           ; 0x7C26
		OR AL, AL                  ;-- 08C0         ; 0x7C27
		JZ _put_str_done           ;-- 740F         ; 0x7C29
		MOV AH, 0x0E               ;-- B40E         ; 0x7C2B
		INT 0x10                   ;-- CD10         ; 0x7C2D
		CMP AL, 0x0A               ;-- 3C0A         ; 0x7C2F
		JNE _put_str_loop          ;-- 75F1         ; 0x7C31
		MOV AX, 0x0E0D             ;-- B80D0E       ; 0x7C33
		INT 0x10                   ;-- CD10         ; 0x7C36
		JMP _put_str_loop          ;-- EBEA         ; 0x7C38

	_put_str_done:
	POP BX                             ;-- 5B           ; 0x7C3A
	POP AX                             ;-- 58           ; 0x7C3B
	RET                                ;-- C3           ; 0x7C3C

_get_video_mode:
	MOV AH, 0x0F                       ;-- B40F         ; 0x7C3D
	INT 0x10                           ;-- CD10         ; 0x7C3F
	RET                                ;-- C3           ; 0x7C41

_set_video_mode:
	MOV AH, 0x00                       ;-- B400         ; 0x7C42
	INT 0x10                           ;-- CD10         ; 0x7C44
	RET                                ;-- C3           ; 0x7C46

; Main function
_main:
	MOV BX, _get_video_mode            ;-- BB3D7C       ; 0x7C47
	CALL BX                            ;-- FFD3         ; 0x7C4A
	MOV BX, _set_video_mode            ;-- BB427C       ; 0x7C4C
	CALL BX                            ;-- FFD3         ; 0x7C4F
	MOV AX, title                      ;-- B80E7C       ; 0x7C51
	MOV BX, _put_str                   ;-- BB207C       ; 0x7C54
	CALL BX                            ;-- FFD3         ; 0x7C57

_halt:
	HLT                                ;-- F4           ; 0x7C59
	JMP _halt                          ;-- EBFD         ; 0x7C5A



