;	Update all of this information to reflect your own details and the prac
;	Author:     Dr J du Toit
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
AHR DWORD 161	;AHR value
Duration DWORD 109	;Duration value
Steps DWORD 12323	;Steps value
Calories DWORD ?

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
	;The simplied formula := (AHR x Duration + 5 x Steps)/100
	mov eax, AHR		;result := AHR
	imul eax, Duration	;result := AHR x Duration
	mov ecx, Steps		;result := Steps
	imul ecx, 5			;result := Steps x 5
	add eax, ecx		;result := (AHR x Duration) + (Steps x 5)
	mov ebx, 100		;Divisor
	cdq
	idiv ebx			;result := (AHR x Duration + 5 x Steps)/100
	mov Calories, ebx	;Answer

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
