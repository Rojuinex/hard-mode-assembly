_entry:
	MOV SP, 0x8000                     ;-- BC0080       ; 0x7C00
	JMP _main                          ;-- EB4200       ; 0x7C03
	; Padding for edits to entry
	                                   ;-- 9090         ; 0x7C06
	                                   ;-- 9090         ; 0x7C08
	                                   ;-- 90           ; 0x7C0A

video_mode dw 0                            ;-- 0000         ; 0x7C0B

title db "Memory inspector\n\n", 0         ; ...            ; 0x7C0D
;-- 4d656d6f727920696e73706563746f720a0a   ; 17 bytes
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
        ; GET CURRENT VIDEO MODE
	MOV AH, 0x0F                       ;-- B40F         ; 0x7C3D
	INT 0x10                           ;-- CD10         ; 0x7C3F
	RET                                ;-- C3           ; 0x7C41

_set_video_mode:
        ; SET VIDEO MODE
	MOV AH, 0x00                       ;-- B400         ; 0x7C42
	INT 0x10                           ;-- CD10         ; 0x7C44
	RET                                ;-- C3           ; 0x7C46
	


; Main function
_main:
	MOV ES, 0x0000                     ;-- 909090       ; 0x7C47
	; video_mode = _get_video_mode()
	MOV BX, _get_video_mode            ;-- BB3D7C       ; 0x7C4A
	CALL BX                            ;-- FFD3         ; 0x7C4D
	MOV BX, video_mode                 ;-- BB0B7C       ; 0x7C4F
	MOV [BX], AX                       ;-- 8907         ; 0x7C52
	; _set_video_mode(video_mode)
	MOV BX, _set_video_mode            ;-- BB427C       ; 0x7C54
	CALL BX                            ;-- FFD3         ; 0x7C57
	; _put_str(title)
	MOV AX, title                      ;-- B80D7C       ; 0x7C59
	MOV BX, _put_str                   ;-- BB207C       ; 0x7C5C
	CALL BX                            ;-- FFD3         ; 0x7C5F
	

	_main_loop:
		MOV BX, _clear_line        ;-- BB887C       ; 0x7C61
		CALL BX                    ;-- FFD3         ; 0x7C64
		MOV BX, _print_addr_info   ;-- BBAB7C       ; 0x7C66
		CALL BX                    ;-- FFD3         ; 0x7C69
		MOV BX, _process_input     ;-- BBC27C       ; 0x7C6B
		CALL BX                    ;-- FFD3         ; 0x7C6E
		JMP _main_loop             ;-- EBEF         ; 0x7C70
		; Get user input
		; Jump to _main_loop

	;-- 909090909090                                    ; 0x7C72
	;-- 909090909090                                    ; 0x7C78
	;-- 909090909090                                    ; 0x7C7E
	;-- 90909090                                        ; 0x7C84

_clear_line:
	PUSH AX                            ;-- 50           ; 0x7C88
	PUSH BX                            ;-- 53           ; 0x7C89
	PUSH CX                            ;-- 51           ; 0x7C8A
	MOV BX, video_mode                 ;-- BB0B7C       ; 0x7C8B
	MOV AX, [BX]                       ;-- 8B07         ; 0x7C8E
	XOR BX, BX                         ;-- 31DB         ; 0x7C90
	MOV BL, AH                         ;-- 88E3         ; 0x7C92
	DEC BX                             ;-- 4B           ; 0x7C94
	MOV AX, 0x0E0D                     ;-- B80D0E       ; 0x7C95
	INT 0x10                           ;-- CD10         ; 0x7C98
	MOV AL, 0x20                       ;-- B020         ; 0x7C9A
	_clear_line_loop:
		INT 0x10                   ;-- CD10         ; 0x7C9C
		DEC BX                     ;-- 4B           ; 0x7C9E
		OR BX, BX                  ;-- 08DB         ; 0x7C9F
		JNZ _clear_line_loop       ;-- 75F9         ; 0x7CA1
	MOV AL, 0x0D                       ;-- B00D         ; 0x7CA3
	INT 0x10                           ;-- CD10         ; 0x7CA5
	POP CX                             ;-- 59           ; 0x7BA7
	POP BX                             ;-- 5B           ; 0x7CA8
	POP AX                             ;-- 58           ; 0x7CA9
	RET                                ;-- C3           ; 0x7CAA

_print_addr_info:
	MOV AX, hello_world                ;-- B8B47C       ; 0x7CAB
	MOV BX, _put_str                   ;-- BB207C       ; 0x7CAE
	CALL BX                            ;-- FFD3         ; 0x7CB1
	; Display memory address
	; Display byte value
	RET                                ;-- C3           ; 0x7CB3

hello_world db "Hello, world!", 0          ; ...            ; 0x7CB4
;-- 48656c6c6f2c20576f726c6421             ; 13 bytes
;-- 00                                     ; null


_process_input:
	MOV AH, 0x01                       ;-- B401         ; 0x7CC2
	INT 0x16                           ;-- CD16         ; 0x7CC4
	JZ _process_input                  ;-- 74FA         ; 0x7CC6
	XOR AH, AH                         ;-- 30E4         ; 0x7CC8
	INT 0x16                           ;-- CD16         ; 0x7CCA
	RET                                ;-- C3           ; 0x7CCC
