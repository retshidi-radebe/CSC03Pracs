;	Author:	Mr A Maganlal
;	P05 solution
; Calculate Health Score with functions

.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

include	io.inc ; I/O Functions

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD ; Exit function

.DATA
; Variables first so out array is at the first address in memory in the memory map
arrLVL 	DWORD	5 DUP (?)	; array of levels
arrDUR	DWORD	5 DUP (?) ; array of durations
arrSCR	DWORD	5 DUP (?) ; array of health scores
; String prompts
strWelcome		BYTE "Welcome to BeatWatch P05!", 10, 0
strLoop				BYTE "Do you wish to calculate another set of Health Scores? (Type 0 for NO or 1 for YES): ", 0
strPromptAge	BYTE "Please enter the age: ", 0
strPromptHRF	BYTE "Please enter the heart rate factor: ", 0
strPromptLVL	BYTE "Please enter 5 levels as indicated below: ", 10, 0
strPromptDUR	BYTE "Please enter 5 durations as indicated below: ", 10, 0
strPromptARR	BYTE 9, "Please enter value ", 0
strDisplayAge	BYTE "The age is: ", 0
strDisplayHRF	BYTE "The HRF is: ", 0
strDisplayLVL	BYTE "The levels are: ", 0
strDisplayDUR	BYTE "The durations are: ", 0
strDisplaySCR	BYTE "The health scores are: ", 0
; Strings for display
strNL				BYTE 10, 0
strColon		BYTE ": ", 0
strComma		BYTE ", ", 0
strSO				BYTE "[", 0	;	SquareBracket Open -> SO
strSC				BYTE "]", 0 ;	SquareBracket Close -> SC

.CODE

; void input(int* array, int length);
_input PROC NEAR32
	; BLOCK - Function entry
	; SUBBLOCK - Create stackframe for function
	PUSH ebp
	MOV ebp,	esp
	SUB esp,	0		; Create 0 local DWORDS (we could omit this line)
	; SUBBLOCK - save the registers
	PUSH eax
	PUSH ebx
	PUSH ecx
	PUSH edx
	; SUBBLOCK - save the flags register on the stack
	PUSHFD

	;	Parameters
	;	[ebp + 08] - Address of array
	;	[ebp + 12] - Length of array
	; Local variables
	;	None

	; BLOCK - Function body
	; Get user values into array
	; Using longer loop style so we can display index as part of prompt
	; We keep the array address in EBX since we don't have any calculations during input
inputLoopInit:
	MOV ebx,	[ebp+08] 	;	EBX = base address of array
	MOV ecx,	0				;	ECX starts at zero
inputLoopCond:
	CMP ecx, DWORD PTR [ebp+12]
	JAE inputLoopEnd
inputLoopBody:
	INVOKE OutputStr,	ADDR strPromptARR
	INVOKE OutputInt, ecx
	INVOKE OutputStr, ADDR strColon
	INVOKE InputInt
	MOV [ebx],	eax
	ADD ebx, 	4				; Shortcut for array offset calculation
	INC ecx 					; Get next input
	JMP inputLoopCond
inputLoopEnd:
	; BLOCK - Function exit
	; SUBBLOCK - Restore the flags register
	POPFD
	; SUBBLOCK - Restore the registers in reverse order
	POP	edx
	POP	ecx
	POP	ebx
	POP	eax
	; SUBBLOCK - Destroy the stack frame
	MOV	esp,	ebp
	POP ebp
	; SUBBLOCK - Return
	; void input(int* array, int length) -> 2 DWORDS = 8 bytes
	RET 8
_input ENDP

; void display(int* array, int length);
_display PROC NEAR32
	; BLOCK - Function entry
	; SUBBLOCK - Create stackframe for function
	PUSH ebp
	MOV ebp,	esp
	SUB esp,	0		; Create 0 local DWORDS (we could omit this line)
	; SUBBLOCK - save the registers
	PUSH eax
	PUSH ebx
	PUSH ecx
	PUSH edx
	; SUBBLOCK - save the flags register on the stack
	PUSHFD

	;	Parameters
	;	[ebp + 08] - Address of array
	;	[ebp + 12] - Length of array
	; Local variables
	;	None

	; BLOCK - Function body
	; Display array with brackets in a single line
	INVOKE OutputStr,	ADDR strSO
	; Using simpler JECXZ and LOOP syntax for loop
outputPHRLoopInit:
	MOV ebx,	[ebp+08] 	;	EBX = base address of array
	MOV ecx,	[ebp+12]	;	ECX = length
	JECXZ outputPHRLoopEnd
outputPHRLoopBody:
	MOV edx,	[ebx]
	INVOKE OutputInt, edx
	CMP ecx, 1 											; Don't print the last comma!
	JE outputPHRLoopNoComma
	INVOKE OutputStr,	ADDR strComma
outputPHRLoopNoComma:
	ADD ebx,	4
	LOOP outputPHRLoopBody
outputPHRLoopEnd:
	INVOKE OutputStr,	ADDR strSC
	INVOKE OutputStr,	ADDR strNL
	; BLOCK - Function exit
	; SUBBLOCK - Restore the flags register
	POPFD
	; SUBBLOCK - Restore the registers in reverse order
	POP	edx
	POP	ecx
	POP	ebx
	POP	eax
	; SUBBLOCK - Destroy the stack frame
	MOV	esp,	ebp
	POP ebp
	; SUBBLOCK - Return
	; void display(int* array, int length); -> 2 DWORDS = 8 bytes
	RET 8
_display ENDP

; int healthScore(int age, int level, int duration, int hrf);
_healthScore PROC NEAR32
	; BLOCK - Function entry
	; SUBBLOCK - Create stackframe for function
	PUSH ebp
	MOV ebp,	esp
	SUB esp,	4		; Create 1 local DWORDS
	; SUBBLOCK - save the registers
	; NO EAX due to return
	PUSH ebx
	PUSH ecx
	PUSH edx
	; SUBBLOCK - save the flags register on the stack
	PUSHFD

	;	Parameters
	;	[ebp + 08] - age
	;	[ebp + 12] - level
	;	[ebp + 16] - duration
	;	[ebp + 20] - hrf
	; Local variables
	;	[ebp - 04] - denom - denominator

	; BLOCK - Function body
	; HealthScore = (level * duration * HRF) / ( (age/10) + 5)
	; SUBBLOCK - calculate denominator
	MOV eax,	[ebp+08]	; EAX = age
	MOV ebx,	10
	CDQ
	DIV ebx 						; EAX = age/10 , EDX = remainder (not used)
	ADD eax, 5					; EAX = ( (age/10) + 5)
	MOV [ebp-04], eax 	; denom = ( (age/10) + 5)
	; SUBBLOCK - calculate numerator
	MOV eax, [ebp+12] 			; EAX = level
	MUL DWORD PTR [ebp+16]	; EAX = level * duration
	MUL DWORD PTR [ebp+20]	; EAX = level * duration * hrf
	; SUBBLOCK - calculate health score
	CDQ
	DIV DWORD PTR [ebp-04] 	; EAX = (level * duration * hrf) / ( (age/10) + 5), remainder (not used)

	; BLOCK - Function exit
	; SUBBLOCK - Restore the flags register
	POPFD
	; SUBBLOCK - Restore the registers in reverse order
	POP	edx
	POP	ecx
	POP	ebx
	; SUBBLOCK - Destroy the stack frame
	MOV	esp,	ebp
	POP ebp
	; SUBBLOCK - Return
	; int healthScore(int age, int level, int duration, int hrf); -> 4 DWORDS = 16 bytes
	RET 16
_healthScore ENDP

; void finalScore(int age, int* levels, int* durations, int hrf, int* scores);
_finalScore PROC NEAR32
	; BLOCK - Function entry
	; SUBBLOCK - Create stackframe for function
	PUSH ebp
	MOV ebp,	esp
	SUB esp,	8		; Create 1 local DWORDS
	; SUBBLOCK - save the registers
	PUSH eax
	PUSH ebx
	PUSH ecx
	PUSH edx
	; SUBBLOCK - save the flags register on the stack
	PUSHFD

	;	Parameters
	;	[ebp + 08] - age
	;	[ebp + 12] - level array
	;	[ebp + 16] - duration array
	;	[ebp + 20] - hrf
	;	[ebp + 24] - scores array
	; Local variables
	;	[ebp - 04] - length (should have been a paramter but there was an error in the practical)
	;	[ebp - 08] - offset (used in loop since all offsets are the same)

	; BLOCK - Function body
	MOV [ebp-04], DWORD PTR 5
	; Using longer loop style so we can calcuate offsets for three arrays using ecx
finalScoreLoopInit:
	MOV ecx,	0				;	ECX starts at zero
finalScoreLoopCond:
	CMP ecx, DWORD PTR [ebp-04]
	JAE finalScoreLoopEnd
finalScoreLoopBody:
	MOV eax, 0
	IMUL eax, ecx, 4 	; EAX = index * size
	MOV [ebp-08], eax ; offset = index * size
	; Parameters for function call healthScore
	PUSH [ebp+20]				; param4 hrf
	MOV ebx,	[ebp+16]	; duration base address
	ADD ebx,	[ebp-08]  ; EBX = duration[i]
	PUSH [ebx]					; param3 duration[i]
	MOV ebx,	[ebp+12]	; level base address
	ADD ebx,	[ebp-08]  ; EBX = level[i]
	PUSH [ebx]					; param2 level[i]
	PUSH [ebp+08]				; param1 age
	CALL _healthScore
	MOV edx, eax 				; EDX = healthScore

	MOV ebx,	[ebp+24]	; scores base address
	ADD ebx,	[ebp-08]  ; EBX = scores[i]
	MOV [ebx], edx 			; scores[i] = healthScore

	INC ecx 					; Get next index
	JMP finalScoreLoopCond
finalScoreLoopEnd:

	; BLOCK - Function exit
	; SUBBLOCK - Restore the flags register
	POPFD
	; SUBBLOCK - Restore the registers in reverse order
	POP	edx
	POP	ecx
	POP	ebx
	POP	eax
	; SUBBLOCK - Destroy the stack frame
	MOV	esp,	ebp
	POP ebp
	; SUBBLOCK - Return
	; void finalScore(int age, int* levels, int* durations, int hrf, int* scores)->5 DWORDS = 20 bytes
	RET 20
_finalScore ENDP

_start:
	;	BLOCK - Create stackframe for _start
	PUSH ebp
	MOV ebp,	esp
	SUB esp, 	12 	; Create 3 local DWORDS

	; It's a good idea to keep track of local variable offsets for reference in calculations
	; Local variables
	; [EBP - 04]	age
	; [EBP - 08]	hrf
	; [EBP - 12]	length of arrays

	MOV [ebp-12],	DWORD PTR 5 ; Set array length to 5

	; Show welcome message
	INVOKE OutputStr,	ADDR strWelcome

	; Never jump to the start label, custom label below for looping
progStart:
	; BLOCK - Input
	; SUBBLOCK - Get age
	INVOKE OutputStr,	ADDR strPromptAge
	INVOKE InputInt
	MOV [ebp-04],	eax 	; age = user input
	; SUBBLOCK - Get RHR
	INVOKE OutputStr,	ADDR strPromptHRF
	INVOKE InputInt
	MOV [ebp-08],	eax 	; hrf = user input
	; SUBBLOCK - Get level array
	INVOKE OutputStr,	ADDR strPromptLVL
	PUSH [ebp-12]	;	param2 length
	LEA ebx, arrLVL
	PUSH ebx 			;	param1 level array address
	CALL _input
	; SUBBLOCK - Get duration array
	INVOKE OutputStr,	ADDR strPromptDUR
	PUSH [ebp-12]	;	param2 length
	LEA ebx, arrDUR
	PUSH ebx 			;	param1 level array address
	CALL _input

	; BLOCK - Calculate final health scores
	LEA ebx, arrSCR
	PUSH ebx 				; param5 scores array
	PUSH [ebp-08]		; param4 hrf
	LEA ebx, arrDUR
	PUSH ebx 				; param3 duration array
	LEA ebx, arrLVL
	PUSH ebx 				; param2 level array
	PUSH [ebp-04]		; param1 age
	CALL _finalScore

	; BLOCK - Output
	; SUBBLOCK - Display age
	INVOKE OutputStr,	ADDR strDisplayAge
	INVOKE OutputInt, [ebp-04]
	INVOKE OutputStr,	ADDR strNL
	; SUBBLOCK - Display hrf
	INVOKE OutputStr,	ADDR strDisplayHRF
	INVOKE OutputInt, [ebp-08]
	INVOKE OutputStr,	ADDR strNL
	; SUBBLOCK - Display level array
	INVOKE OutputStr,	ADDR strDisplayLVL
	PUSH [ebp-12]	;	param2 length
	LEA ebx, arrLVL
	PUSH ebx 			;	param1 level array address
	CALL _display
	; SUBBLOCK - Display duration array
	INVOKE OutputStr,	ADDR strDisplayDUR
	PUSH [ebp-12]	;	param2 length
	LEA ebx, arrDUR
	PUSH ebx 			;	param1 level array address
	CALL _display
	; SUBBLOCK - Display scores array
	INVOKE OutputStr,	ADDR strDisplaySCR
	PUSH [ebp-12]	;	param2 length
	LEA ebx, arrSCR
	PUSH ebx 			;	param1 level array address
	CALL _display

	; BLOCK - Prompt repeat and loop to start
	INVOKE OutputStr, ADDR strLoop
	INVOKE InputInt
	CMP eax, 0
	JNE progStart
progExit:
	INVOKE ExitProcess, 0	; Exit
Public _start
END
