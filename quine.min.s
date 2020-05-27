%macro psym 1
    mov r8, %1
    call pstr
%endmacro
section .text
pstr:
    mov rdx, 0
.lstart:
    mov rcx, r8
    add rcx, rdx
    xor rbx, rbx
    mov bl, [rcx]
    cmp bl, 0x00
    jz .lend
    add rdx, 1
    jnz .lstart
.lend:
    mov rax, 4
    mov rbx, 1
    mov rcx, r8
    int 0x80
    ret
pch:
    mov rax, 4
    mov rbx, 1
    mov rcx, r8
    mov rdx, 1
    int 0x80
    ret
global main
main:
    psym text
    psym start
    sub rsp, 16
    mov qword [rsp + 8], 0x0000000000000000
    mov qword [rsp + 16], 0x0000000000000000
.lstart:
    mov rax, [rsp + 8]
    mov al, [text + rax]
    cmp al, 0x00
    je .lend
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
    psym endl
    mov qword [rsp + 16], 1
    jmp .linc
.linc:
    inc qword [rsp + 8]
    jmp .lstart
.lend:
    psym end
    mov rax, 1
    mov rbx, 0x00
    int 0x80
section .data
start  db "      ", 0x22, 0x00
startl db "    , ", 0x22, 0x00
quotescape db 0x22, ", 0x22, ", 0x22, 0x00
endl   db 0x22, ", 0x0A \", 0x0A, 0x00
end    db "    , 0x00", 0x0A, 0x00
text   db \
      "%macro psym 1", 0x0A \
    , "    mov r8, %1", 0x0A \
    , "    call pstr", 0x0A \
    , "%endmacro", 0x0A \
    , "section .text", 0x0A \
    , "pstr:", 0x0A \
    , "    mov rdx, 0", 0x0A \
    , ".lstart:", 0x0A \
    , "    mov rcx, r8", 0x0A \
    , "    add rcx, rdx", 0x0A \
    , "    xor rbx, rbx", 0x0A \
    , "    mov bl, [rcx]", 0x0A \
    , "    cmp bl, 0x00", 0x0A \
    , "    jz .lend", 0x0A \
    , "    add rdx, 1", 0x0A \
    , "    jnz .lstart", 0x0A \
    , ".lend:", 0x0A \
    , "    mov rax, 4", 0x0A \
    , "    mov rbx, 1", 0x0A \
    , "    mov rcx, r8", 0x0A \
    , "    int 0x80", 0x0A \
    , "    ret", 0x0A \
    , "pch:", 0x0A \
    , "    mov rax, 4", 0x0A \
    , "    mov rbx, 1", 0x0A \
    , "    mov rcx, r8", 0x0A \
    , "    mov rdx, 1", 0x0A \
    , "    int 0x80", 0x0A \
    , "    ret", 0x0A \
    , "global main", 0x0A \
    , "main:", 0x0A \
    , "    psym text", 0x0A \
    , "    psym start", 0x0A \
    , "    sub rsp, 16", 0x0A \
    , "    mov qword [rsp + 8], 0x0000000000000000", 0x0A \
    , "    mov qword [rsp + 16], 0x0000000000000000", 0x0A \
    , ".lstart:", 0x0A \
    , "    mov rax, [rsp + 8]", 0x0A \
    , "    mov al, [text + rax]", 0x0A \
    , "    cmp al, 0x00", 0x0A \
    , "    je .lend", 0x0A \
    , "    cmp qword [rsp + 16], 1", 0x0A \
    , "    jne .lafter_newlinecheck", 0x0A \
    , "    mov qword [rsp + 16], 0", 0x0A \
    , "    psym startl", 0x0A \
    , ".lafter_newlinecheck:", 0x0A \
    , "    cmp al, 0x0A", 0x0A \
    , "    je .lfound_newline", 0x0A \
    , "    cmp al, 0x22", 0x0A \
    , "    je .lfound_quote", 0x0A \
    , "    jne .lfound_literal", 0x0A \
    , ".lfound_literal:", 0x0A \
    , "    mov r8, text", 0x0A \
    , "    add r8, [rsp + 8]", 0x0A \
    , "    call pch", 0x0A \
    , "    jmp .linc", 0x0A \
    , ".lfound_quote:", 0x0A \
    , "    psym quotescape", 0x0A \
    , "    jmp .linc", 0x0A \
    , ".lfound_newline:", 0x0A \
    , "    psym endl", 0x0A \
    , "    mov qword [rsp + 16], 1", 0x0A \
    , "    jmp .linc", 0x0A \
    , ".linc:", 0x0A \
    , "    inc qword [rsp + 8]", 0x0A \
    , "    jmp .lstart", 0x0A \
    , ".lend:", 0x0A \
    , "    psym end", 0x0A \
    , "    mov rax, 1", 0x0A \
    , "    mov rbx, 0x00", 0x0A \
    , "    int 0x80", 0x0A \
    , "section .data", 0x0A \
    , "start  db ", 0x22, "      ", 0x22, ", 0x22, 0x00", 0x0A \
    , "startl db ", 0x22, "    , ", 0x22, ", 0x22, 0x00", 0x0A \
    , "quotescape db 0x22, ", 0x22, ", 0x22, ", 0x22, ", 0x22, 0x00", 0x0A \
    , "endl   db 0x22, ", 0x22, ", 0x0A \", 0x22, ", 0x0A, 0x00", 0x0A \
    , "end    db ", 0x22, "    , 0x00", 0x22, ", 0x0A, 0x00", 0x0A \
    , "text   db \", 0x0A \
    , 0x00
