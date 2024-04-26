; BIOS loads us at 0x7c00
_entry:
	                                 ; Setup the stack pointer
	MOV SP, 0x1000                   ; BC0010    3    7C00
	MOV AX, msg                      ; B81F7C    3    7C03
	CALL _print_string               ; E80200    3    7C06

_hang:
	JMP _hang                        ; EBFE      2    7C09

_print_string:
; AX = address of string
	PUSH AX                          ; 50        1    7C0B
	PUSH BX                          ; 53        1    7C0C
	MOV BX, AX                       ; 89C3      2    7C0D

	_print_string_loop:
		MOV AL, [BX]             ; 8B07      2    7C0F
		INC BX                   ; 43        1    7C11
		OR AL, AL                ; 09C0      2    7C13
		JZ _print_string_done    ; 7405      2    7C15
		MOV AH, 0x0E             ; B40E      2    7C17
		INT 0x10                 ; CD10      2    7C19
		JMP _print_string_loop   ; EBF3      2    7C1B

	_print_string_done:
	POP BX                           ; 5B        1    7C1C
	POP AX                           ; 58        1    7C1D
	RET                              ; C3        1    7C1E

msg db "Hello, world!", 0                ; ...      14    7C1F
