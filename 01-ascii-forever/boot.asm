XOR    AX, AX       ;-- 31C0
XOR    BX, BX       ;-- 31DB

MOV    AH, 0x0E     ;-- B40E

_put_char:
MOV    AL, BL       ;-- 88D8
INT    0x10         ;-- CD10
INC    BL           ;-- FEC3
JNZ    _put_char    ;-- 75F8
XOR    BX, BX       ;-- 31DB

_put_char:
JMP    _put_char    ;-- EBF4
