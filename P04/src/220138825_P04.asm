;	Update all of this information to reflect your own details and the prac
;	Author:     RE RADEBE 220138825
;	Practical Assignment 04
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
		; STRING PROMPTS
	strAge				BYTE	"Enter the Age: ", 0
	strRHR				BYTE	"Enter the Resting Heart rate (RHR): ", 0
	strCMul				BYTE 	"Enter Calorie Multiplier (CMul): ", 0
	strHR1				BYTE	"Enter the Heart Rate 01: ", 0
	strHR2				BYTE	"Enter the Heart Rate 02: ", 0
	strHR3				BYTE	"Enter the Heart Rate 03: ", 0		
	strHRF				BYTE	"Heart Rate Factors: ", 0
	strExit				BYTE 	"Press 0 to exit or any positive number to contunue: ", 0
	strDisp1			BYTE	"HRF[", 0
	strDisp2			BYTE	"], ", 0
	arrHR				BYTE	10 DUP	(?)
	strNL				BYTE	10 ,0
	
		;User Input Data variables
	HR					DWORD	3	DUP	(?)
	HRF					DWORD	3  	DUP (?)	

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
	sub esp, 12

	;===========Input the Age============
	INVOKE		OutputStr, ADDR	strAge
	INVOKE		InputInt
	mov 		[esp], eax		;Age storage

	;===========Input the Resting Heart Rate============
	INVOKE		OutputStr, ADDR	strRHR
	INVOKE		InputInt
	mov			[esp + 4], eax	;RHR storage

	;===========Input the Calorie Multiplier============
	INVOKE		OutputStr, ADDR	strCMul
	INVOKE		InputInt
	mov			[esp + 8], eax	;CMul storage

	;===========Input the Heart Rates (Arrray Instantiation)============
	mov 		ecx, 3
	lea			esi, HR

	;Firsr Heart Rate
	INVOKE		OutputStr, ADDR	strHR1
	INVOKE		InputInt
	mov			[esi], eax
	add			esi, 4

	;Second Heart Rate
	INVOKE		OutputStr, ADDR	strHR2
	INVOKE		InputInt
	mov			[esi], eax
	add			esi, 4

	;Third Heart Rate
	INVOKE		OutputStr, ADDR	strHR3
	INVOKE		InputInt
	mov			[esi], eax
	add			esi, 4	

	;===========Calculating Heart Rate for each Heart Rate(and Instantiations)============
	mov			ecx, 3
	lea			esi, HR
	lea			edi, HRF

CalculationLoop:	
	mov			eax, [esi]
	sub			eax, [esp + 4]
	imul		eax, [esp + 8]
	mov			ebx, 220
	sub			ebx, [esp]

	cdq
	idiv		ebx
	sub			eax, [esp + 4]
	mov			[edi], eax
	add			esi, 4
	add			edi, 4
	loop		CalculationLoop

	;===========Displaying Heart Rate Factors============
	INVOKE		OutputStr, ADDR	strHRF
	mov			ecx, 3
	lea			esi, HRF
	xor			ebx, ebx

DisplayingLoop:
	push		ecx

	INVOKE		OutputStr, ADDR	strDisp1
	mov			eax, ebx
	INVOKE		OutputInt, eax
	INVOKE		OutputStr, ADDR	strDisp2

	mov			eax, [esi]
	INVOKE		OutputInt, eax
	add			esi, 4
	inc			ebx
	pop			ecx
	loop		DisplayingLoop

	;===========Exit the program============
	INVOKE		OutputStr, ADDR	strNL
	INVOKE		OutputStr, ADDR strExit
	INVOKE		InputInt
	cmp			eax, 0
	je			EndProgram
	jg			_start

EndProgram:
	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
