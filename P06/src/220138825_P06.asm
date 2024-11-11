;	Update all of this information to reflect your own details and the prac
;	Author:     Radebe RE 220138825	
;	Practical Assignment 05 2024
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

;Include the I/O function
INCLUDE		io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
;================================Global Variables===============================
	stepCountArray		DWORD		7 Dup(10, 20, 30, 40, 50, 60, 70)		;This is for seven days
	stepCountSum		DWORD		0	;This stores the steps sum
	stepCountAverage	DWORD		0	;This stores the average steps
	index				DWORD		0
	days				DWORD		7	;Days in a week

;===============================String Prompts===================================
	strExit				BYTE		"Press 0 to exit or any positive number to continue: ", 0
	strSum				BYTE		"Sum of the step count: ", 0
	strAve				BYTE		"Average Step Count: ", 0
	strNL				BYTE		10, 0

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE

;==================================Recursive Step Counting Function===================

RecursiveStepCount PROC NEAR32
	;Stack Frame setups
	push		ebp
	mov			ebp, esp

	;Backingup existing registers
	push		eax
	push 		ebx
	push 		ecx
	push 		edx
	pushfd

	;Getting the index value
	mov			ecx, [ebp+8]		;ecx = index

	;Base casing
	cmp			ecx, [days]
	jge			baseCase

	;Get current steps
	mov			eax, [stepCountArray + ecx*4]	;Loading the step count here
	add			[stepCountSum], eax				;Summing up the steps here

	;Incrementing
	inc			ecx

	;Recursive call
	push		ecx
	call		RecursiveStepCount
	pop			ecx

baseCase:
	;Restoring the existing registers
	popfd
	pop			edx
	pop			ecx
	pop			ebx
	pop			eax

	;Destroying the stack frmae
	mov			esp, ebp
	pop			ebp

	;Return the parameters
	ret			4
RecursiveStepCount ENDP

;===================================Main Function=================================
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
	
	;Stack Frame set up
	push		ebp
	mov			ebp, esp

	;Create space on the stack for local variable
	sub			esp, 12

	;Initialization
	mov			eax, 0
	mov			[ebp-4], eax		;intCount
	mov			[ebp-8], eax		;intConter

	;Call resursive function
	lea			ecx, [index]
	push		ecx
	call		RecursiveStepCount
	pop			ecx

	;Calculating the Average
	mov			eax, [stepCountSum]		;Loading the stepCountSum into eax
	mov			ebx, [days]				;Loading the days into ebx
	xor			edx,edx					; Clear edx
	div 		ebx						; StepCountSum/days
	mov			[stepCountAverage], eax	;Storing inside StepCountAcerage

	;Outsput Sum
	lea			eax, [strSum]
	push 		eax
	call		OutputStr
	mov			eax, [stepCountSum]
	push 		eax
	call		OutputInt
	lea			eax, [strNL]
	push 		eax
	call		OutputStr

	;Output Average
	lea			eax, [strAve]
	push 		eax
	call		OutputStr
	mov			eax, [stepCountAverage]
	push 		eax
	call		OutputInt
	lea			eax, [strNL]
	push 		eax
	call		OutputStr

	;========================================Exit  Prompt====================================
		lea						ebx, strExit
		push					ebx
		call					OutputStr
		call					InputInt
		cmp						eax, 0
		jne						_start
	;Destroying the stack frame
	mov			esp, ebp
	pop			ebp

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
