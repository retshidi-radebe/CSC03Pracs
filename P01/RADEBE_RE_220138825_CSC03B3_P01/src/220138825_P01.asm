;	Update all of this information to reflect your own details and the prac
;	Author:     RE Radebe
;	Practical 01 document
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
;Strings
strStride BYTE "Enter stride length: ",0
strSteps BYTE "Enter number of steps: ",0
strDMeters BYTE "Distance in meters: ",0
strDKilos BYTE "Distance in kilometers: ",0
strNewLine BYTE 10,0
StrDot BYTE " remainder ",0

;Integers
intStride DWORD ?
intSteps DWORD ?
intDMeters DWORD ?
intDKilos DWORD ?

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.

	;Stride
	INVOKE OutputStr, ADDR strStride	;This prints "Enter stride length:"
	INVOKE InputInt						;Gets the input of stride length
	MOV intStride, eax					;Store the input value into intStride

	;Steps
	INVOKE OutputStr, ADDR strStride	;This prints "Enter number of steps:"
	INVOKE InputInt						;Gets the input of number of steps
	MOV intSteps, eax					;Store the input value into intSteps

	;Calculating Distance in Meters
	MOV eax, intStride
	MUL intSteps						;eax = intStride x intSteps

	MOV ebx, 100
	DIV ebx								;eax = eax / 100

	MOV intDMeters, eax					;Store the answer for Distance in meters

	INVOKE OutputStr, ADDR strDMeters	;Pull the string variable and display
	INVOKE OutputInt, intDMeters		;Pull the integer variable and display
	INVOKE OutputStr, ADDR StrDot
	INVOKE OutputInt, edx				;remainder
	INVOKE OutputStr, ADDR strNewLine

	MOV eax, intDMeters
	MOV ebx, 1000
	CDQ
	DIV ebx

	MOV intDKilos, eax

	INVOKE OutputStr, ADDR strDKilos	;Pull the string variable and display
	INVOKE OutputInt, intDKilos			;Pull the integer variable and display
	INVOKE OutputStr, ADDR StrDot
	INVOKE OutputInt, edx				;remainder
	INVOKE OutputStr, ADDR strNewLine


	

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
