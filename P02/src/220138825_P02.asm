;	Update all of this information to reflect your own details and the prac
;	Author:     RE Radebe
;	Template document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
;Inputs variables and the answers
HR0				DWORD	?
HR1				DWORD	?
HR2				DWORD	?
HR3				DWORD	?
HR4				DWORD	?
Avg				DWORD	?
RoundedAvg		DWORD	?
Max				DWORD	?

;String Prompts
strHR0			BYTE 	"Enter Heart Rate HR0: ",0
strHR1			BYTE 	"Enter Heart Rate HR1: ",0
strHR2			BYTE 	"Enter Heart Rate HR2: ",0
strHR3			BYTE 	"Enter Heart Rate HR3: ",0
strHR4			BYTE 	"Enter Heart Rate HR4: ",0
strAvg			BYTE	"Average Heart Rate: ",0
strRAvg			BYTE	"Rounded Heart Average: ",0
strMax			BYTE	"Maximum Heart Rate: ",0
strNL			BYTE	10,0
strDot			BYTE	"."

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
	
	;User input for HR0
	INVOKE	OutputStr, ADDR strHR0
	INVOKE 	InputInt
	mov		HR0, eax

	;User input for HR1
	INVOKE	OutputStr, ADDR strHR1
	INVOKE 	InputInt
	mov		HR1, eax

	;User input for HR2
	INVOKE	OutputStr, ADDR strHR2
	INVOKE 	InputInt
	mov		HR2, eax

	;User input for HR3
	INVOKE	OutputStr, ADDR strHR3
	INVOKE 	InputInt
	mov		HR3, eax

	;User input for HR4
	INVOKE	OutputStr, ADDR strHR4
	INVOKE 	InputInt
	mov		HR4, eax

	;Calculating the Average Heart Rate
	mov eax, HR0
	add eax, HR1
	add eax, HR2
	add eax, HR3
	add eax, HR4

	mov ebx, 5
	cdq
	div ebx

	mov Avg, eax

	;Calculating the Rounded Average Heart Rate
	mov eax, HR0
	add eax, HR1
	add eax, HR2
	add eax, HR3
	add eax, HR4

	add eax, 2	;This is for rounding off

	mov ebx, 5
	cdq
	div ebx

	mov RoundedAvg, eax

	;Finding the Maximum Heart Rate
	mov	eax, HR0
	mov ebx, HR1
	cmp	ebx, eax
	jle	loop1
	mov eax, ebx
loop1:
	mov ebx, HR2
	cmp	ebx, eax
	jle	loop2
	mov eax, ebx
loop2:
	mov ebx, HR3
	cmp	ebx, eax
	jle loop3
	mov eax, ebx
loop3:
	mov ebx, HR4
	cmp ebx, eax
	jle	loop4
	mov eax, ebx
loop4:
	mov Max, eax

	;Displaying the Average Heart Rate
	INVOKE	OutputStr, ADDR	strAvg
	INVOKE	OutputInt, Avg
	INVOKE	OutputStr, ADDR strNL

	;Displaying the Rounded Average Heart Rate
	INVOKE	OutputStr, ADDR	strRAvg
	INVOKE	OutputInt, RoundedAvg
	INVOKE	OutputStr, ADDR strNL

	;Displaying the Rounded Average Heart Rate
	INVOKE	OutputStr, ADDR	strMax
	INVOKE	OutputInt, Max
	INVOKE	OutputStr, ADDR strNL

	;To Loop back
	jmp _start

endProg:
	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
