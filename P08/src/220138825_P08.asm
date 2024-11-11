;	Update all of this information to reflect your own details and the prac
;	Author:     RE Radebe
;	220138825	Practical Assessment 08
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA

;Global variables
	Rewards			DWORD	7 DUP(99, 80, 57, 0, 0, 0, 110)		; Rewards for 7 days
	numDays			DWORD	7							; Number of days	
	intResult		DWORD	?							; Store integer Ave
	floatResult		REAL4	?							; Store float Ave

; String Promps	
	StrIntAverage	BYTE	"Integer Average: ", 0
	StrFloatAverage	BYTE	"Floating Point Average: ", 0
	strNL			BYTE	10, 0
	strRewards		BYTE	"Rewards for Fitness Goals: ", 0

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE

;============================ Function to calculate integer average ============================
calculateIntAverage PROC NEAR32

	mov			ecx, numDays						; Load number of days into ecx
	mov			eax, 0								; Clear eax 
	mov 		esi, 0								; Index for Rewards

sumLoopInt:
	add			eax, Rewards[esi]					; Add rewards to sum
	add			esi, 4								; Move to the next reward	
	loop		sumLoopInt

	mov			ebx, numDays						; Load number of days
	xor			edx, edx							; Clear edx	
	div			ebx									; eac = sum / numDays
	mov			intResult, eax						; Store integer result in intResult

	ret

calculateIntAverage ENDP

;============================ Function to calculate floating-point average =====================
calculateFloatAverage PROC NEAR32
	finit								; Initialize FPU
	fldz								; Load 0.0 into FPU stack
	mov 			ecx, numDays		; Load number of days into ecx
	mov				esi, 0				; Index for Rewars

sumLoopFloat:
	fild			DWORD PTR Rewards[esi]	; Load each integer as float intp FPU
	fadd									; Add the value to the FPU's sack
	add				esi, 4
	loop			sumLoopFloat

	fild			DWORD PTR numDays		; Load numDays as integer in FPU
	fdiv									; Divide sum by numDays
	fstp			floatResult				; Store the result into floatResult

	ret

calculateFloatAverage ENDP

;============================ Function to display rewards array =============================
displayRewards PROC NEAR32

	mov 			ecx, numDays
	mov				esi, 0

displayLoop:
	INVOKE			OutputInt, Rewards[esi]		; Display each element in Rewards array
	INVOKE			OutputStr, ADDR strNL
	add 			esi, 4
	loop			displayLoop

	ret

displayRewards ENDP

;============================ Main Program Entry ============================

_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
main PROC NEAR32

	INVOKE			OutputStr, ADDR strRewards
	INVOKE			OutputStr, ADDR strNL

	;Displaying the Rewards
	call			displayRewards

	;Calculating integer average
	call			calculateIntAverage

	; Displaying integher average
	INVOKE			OutputStr, ADDR	StrIntAverage
	INVOKE			OutputInt, intResult
	INVOKE			OutputStr, ADDR strNL

	; Calculating floating point average
	call			calculateFloatAverage

	; Displaying Floating point results
	INVOKE			OutputStr, ADDR StrFloatAverage
	INVOKE			OutputFloat, floatResult
	INVOKE			OutputStr, ADDR strNL
main ENDP
	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
