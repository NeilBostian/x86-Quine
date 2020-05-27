; Print symbol macro
%macro psym 1
    mov r8, %1
    call pstr
%endmacro

section .text

; Function pstr (print string)
; Call with string reference in r8
pstr:
    mov rdx, 0 ; rdx stores our string length
.lstart:
    mov rcx, r8
    add rcx, rdx

    xor rbx, rbx ; Clear EBX register to store our character
    mov bl, [rcx] ; Dereference the pointer to our current character

    cmp bl, 0x00 ; If null character, return
    jz .lend

    add rdx, 1 ; Else, loop
    jnz .lstart
.lend:
    mov rax, 4   ; sys_write
    mov rbx, 1   ; stdout
    mov rcx, r8  ; string ptr
    int 0x80
    ret

; Function pch (print char)
; Call with char reference in r8
pch:
    mov rax, 4
    mov rbx, 1
    mov rcx, r8
    mov rdx, 1
    int 0x80
    ret

global main
main:
    ; Print base text
    psym text

    ; Print first tab plus quote
    psym start

    ; 2 variables on stack
    sub rsp, 16
    mov qword [rsp + 8], 0x0000000000000000 ; Stores our loop counter
    mov qword [rsp + 16], 0x0000000000000000 ; Stores a 1 if the prior loop iteration was a newline, otherwise 0

.lstart:
    mov rax, [rsp + 8]
    mov al, [text + rax]

    cmp al, 0x00
    je .lend

    ; Check for newline flag and write `startl`
    cmp qword [rsp + 16], 1
    jne .lafter_newlinecheck
    mov qword [rsp + 16], 0
    psym startl

.lafter_newlinecheck:
    cmp al, 0x0A
    je .lfound_newline
    cmp al, 0x22
    je .lfound_quote
    jne .lfound_literal

.lfound_literal:
    mov r8, text
    add r8, [rsp + 8]
    call pch
    jmp .linc

.lfound_quote:
    psym quotescape
    jmp .linc

.lfound_newline:
    psym endl ; Print our end of line string
    mov qword [rsp + 16], 1 ; Set newline flag on
    jmp .linc

; Increment & Loop
.linc:
    inc qword [rsp + 8]
    jmp .lstart

.lend:
    psym end
    mov rax, 1 ; sys_exit
    mov rbx, 0x00 ; exit code
    int 0x80

section .data
start  db "      ", 0x22, 0x00 ; Start of output
startl db "    , ", 0x22, 0x00 ; Start line
quotescape db 0x22, ", 0x22, ", 0x22, 0x00 ; Escape quote
endl   db 0x22, ", 0x0A \", 0x0A, 0x00 ; End line
end    db "    , 0x00", 0x0A, 0x00 ; End of input
text   db \
