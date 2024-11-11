;	Update all of this information to reflect your own details and the prac
;	Author:     RE Radebe 220138825
;	Practical Assigment 07
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
;==========================Global Vars=========================
	strInput			BYTE	100 DUP(?)					; input storage
	strReversed			BYTE	100 DUP(?)					; reversed storage
	searchChar			BYTE	?							; search Character
	replaceChar			BYTE	?							; replace character

;=========================String Prompts=======================
	StringPrompt		BYTE	"Enter a string: ", 0
	SearchPrompt		BYTE	"Search Character: ", 0
	ReplacePrompt		BYTE	"Replace with: ", 0
	ModPrompt			BYTE	"Modified String: ", 0
	OutputPrompt		BYTE	"Reversed string: ", 0
	strExit				BYTE	"Press 0 to exit or any positive number to continue: ", 0	


; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
;==================ReplaceCharacters Function====================
replaceCharacters PROC NEAR32
	push		ebp
	mov			ebp, esp
	mov			esi, offset strInput

loop_replace:
	mov			al, [esi]			; Load byte
	cmp			al, 0				; null-terminator
	je			replace_done		; break the looop if the end of string

	cmp			al, searchChar		; Check the search character
	jne			char_copy			; Copy the character if no
	mov			al, replaceChar		; raplace if they match
	mov			[esi], al

char_copy:
	inc			esi							; store byte
	jmp			loop_replace				; repeat for next chars

replace_done:
	mov			esp, ebp
	pop			ebp
	ret	
replaceCharacters ENDP

;=================================GetStringLength Function================================
getStringLen	PROC	NEAR32
	push		ebp
	mov			ebp, esp
	mov			esi, offset	strInput
	xor			ecx, ecx

lengthLoop:
	mov			al, [esi + ecx]
	cmp			al, 0
	je			endlength	
	inc			ecx
	jmp			lengthLoop

endLength:
	mov			eax, ecx
	mov			esp, ebp
	pop			ebp

	ret		
getStringLen	ENDP

;==================================ReversedString Function================================
reversedString PROC NEAR32
	push		ebp
	mov			ebp, esp
	mov			esi, offset strInput
	mov			edi, offset strReversed
	call		getStringLen				;Length input string

	dec 		eax
	mov			ecx, eax

reverse_loop:
	mov			al, [esi + ecx]		; load Byte
	mov			[edi], al			; Store it
	inc			edi					; Move forward
	dec			ecx					; Move backward
	cmp			ecx, -1		
	jg			reverse_loop		; stop reversing if ecx is less zero

	mov			BYTE	PTR [edi], 0
	mov			esp, ebp
	pop			ebp
	ret			
reversedString ENDP

InputChar PROC	NEAR32
    ; Backup registers
    push 		ebp
    mov 		ebp, esp

    ; Read one character from standard input (file descriptor 0)
    mov 		eax, 3      ; Syscall number for sys_read
    mov 		ebx, 0      ; File descriptor for stdin
    lea 		ecx, [esp+4]; Store the character in a temporary variable on the stack
    mov 		edx, 1      ; Read one byte (one character)
    int 		80h         ; Trigger interrupt for syscall

    ; Move the character from the stack into the AL register
    mov 		al, BYTE PTR [esp+4]

    ; Restore registers
    mov 		esp, ebp
    pop 		ebp
    ret
InputChar	ENDP

;====================================Main Function================================
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
    ; Prompt user for string input
    lea  eax, StringPrompt
    push eax
    call OutputStr

    mov  eax, 100                    ; Limit input size to 100 chars
    push eax
    lea  eax, strInput
    push eax
    call InputStr                    ; Get the user input string

    ; Prompt for search character
    lea  eax, SearchPrompt
    push eax
    call OutputStr
    call InputChar                   ; Get the character to search for
    mov  searchChar, al              ; Store it in searchChar

    ; Prompt for replacement character
    lea  eax, ReplacePrompt
    push eax
    call OutputStr
    call InputChar                   ; Get the character to replace with
    mov  replaceChar, al             ; Store it in replaceChar

    ; Call replaceCharacters to perform replacement
    call replaceCharacters

    ; Display the modified string
    lea  eax, ModPrompt
    push eax
    call OutputStr

    lea  eax, strInput
    push eax
    call OutputStr                   ; Output modified string

    ; Call reverseString to reverse the string
    call reversedString

    ; Display the reversed string
    lea  eax, OutputPrompt
    push eax
    call OutputStr

    lea  eax, strReversed
    push eax
    call OutputStr                   ; Output reversed string	

;========================================Exit  Prompt====================================
		lea						ebx, strExit
		push					ebx
		call					OutputStr
		call					InputInt
		cmp						eax, 0
		jne						_start	

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
