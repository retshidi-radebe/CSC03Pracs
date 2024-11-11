;	Update all of this information to reflect your own details and the prac
;	Author:     RE Radebe 220138825
;	Practical Assessment 05
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE	io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
	;========================================String prompts=========================================
	strAge						BYTE	"Please Enter your age:	", 0
	strHRF						BYTE	"Please Enter your HRF: ", 0
	strLevel					BYTE	"Enter level value at the index ", 0
	strDuration					BYTE	"Enter duration value at the index ", 0
	strScores					BYTE	"The scores are: ", 0
	strExit						BYTE	"Press 0 to exit or any positive number to contunue: ", 0
	;========================================Input variables =======================================
	Levels						DWORD	10 DUP(?)
	Durations					DWORD	10 DUP(?)
	Scores						DWORD	10 DUP(?)

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
	;========================================Input Function with it's paras====================================
	input PROC NEAR32
		push					ebp
		mov						ebp, esp
		push					ecx				; Count
		push 					ebx				; Array address

		mov						esi, [ebp+8]
		mov						ecx, [ebp+12]		;This counts the elements

	InputLoop:
		lea						edx, strLevel
		call					OutputStr
		call					InputInt
		mov						[esi], eax		;Stores the input value
		add						esi, 4			; moving to the element of arayy
		loop					InputLoop		

		pop						ebx
		pop						ecx
		pop						ebp
		ret						
	input ENDP
	;========================================HealthScore Function with it's paras====================================
	healthScore PROC NEAR32
		push					ebp
		mov						ebp, esp

		mov						eax, [ebp+8]				;Age
		idiv					ebx
		add						eax, 5
		push					eax

		mov						eax, [ebp+12]
		imul					eax, [ebp+16]
		imul					eax, [ebp+20]

		pop						ebx
		cdq
		idiv					ebx
		pop						ebp
		ret
	healthScore ENDP		

	;========================================FinalScore Function with it's paras====================================

	finalScore PROC	NEAR32
		push					ebp
		mov						ebp, esp
		push					ebx					
		push					ecx
		push					edx

		mov						esi, [ebp+12]			; Levels array
		mov						edi, [ebp+16]			; Duration arrya
		mov						ebx, [ebp+20]			; Score array
		mov						ecx, 10				; Loop counter

	ScoreLoop:
		mov						eax, [esi]			; Load level
		imul					eax, [edi]			; Multiply by duration
		add						eax, [ebp+8]			; Adding HRF
		push					DWORD ptr [ebp+8]	;Age
		push					DWORD ptr [edi]		;Duration
		push					DWORD ptr [esi]
		push					DWORD ptr [ebp+24]
		call					healthScore
		mov						[ebx], eax			; Storing the results in the score array
		add						esi, 4				; Moving to the next level element
		add						edi, 4				; Moving to the next duration element
		add						ebx, 4				; Moving to the next score element
		loop					ScoreLoop

		pop						edx
		pop						ecx
		pop						ebx
		pop						ebp
		ret
	finalScore ENDP

	;========================================Display Function with it's paras====================================

	display PROC NEAR32
		push					ebp
		mov						ebp, esp
		push					ecx
		push					ebx

		mov						esi, [ebp+8]
		mov						ecx, [ebp+12]			; Counting the elements

		lea						edx, strScores
		push					edx
		call					OutputStr

	DisplayLoop:
		mov						eax, [esi]			; Loading the score
		push					eax	
		call					OutputInt			; Displayong the score
		add						esi, 4				; Moving to the next element of array
		loop					DisplayLoop

		pop						ebx
		pop						ecx
		pop						ebp
		ret
	display	ENDP

	;========================================The main====================================
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
	TopOfMain:
		sub						esp, 8

		; This is the imputs for Age and HRF
		lea						ebx, strAge
		push					ebx
		call					OutputStr
		call					InputInt
		mov						[esp+4], eax			;Age storage

		lea						ebx, strHRF
		push					ebx
		call					OutputStr
		call					InputInt
		mov						[esp], eax				; HRF storage

		; These are the inputs for levels and duration
		lea						ebx, Levels
		mov						eax, 10
		push					eax
		push					ebx
		call					input

		lea						ebx, Durations
		mov						eax, 10
		push					eax
		push					ebx
		call					input

		;Calculating and storing the scores
		lea						ebx, Levels
		lea						ecx, Durations
		lea						edx, Scores
		mov						eax, [esp+4]			;Loading Age
		mov						ebx, [esp]				;Loading HRF	
		push					edx
		push					ecx
		push					ebx
		call					finalScore

		; Displaying the scores
		lea						ebx, Scores
		mov						eax, 10
		push					eax
		push					ebx
		call					display

	;========================================Exit  Prompt====================================
		lea						ebx, strExit
		push					ebx
		call					OutputStr
		call					InputInt
		cmp						eax, 0
		jne						TopOfMain	

		add						esp, 8

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
