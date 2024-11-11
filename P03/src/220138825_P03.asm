;	Update all of this information to reflect your own details and the prac
;	Author:     RE RADEBE
;	Practical Assignment 03
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
; STRING PROMPTS
strHeartRate			BYTE	"Enter the Heart Rate", 0
strAge					BYTE	"Enter your Age: ",0
strColon				BYTE	58,0
strArrayInput			BYTE	"Heart Rates Input: ",0
strArrayOutput			BYTE	"Percentages Output: ",0
strIntensity			BYTE	"The Intensity: ",0
strNone					BYTE	"None", 0
strLight				BYTE	"Light", 0
strModerate				BYTE	"Moderate", 0
strVigorous				BYTE	"Vigorous", 0
strNL					BYTE	10,0
strSpace				BYTE	32,0
strExit					BYTE	"Press 0 to exit or any positive number to contunue"

;User Input Data variables
ArrayHR					DWORD	8 DUP(?)
Age						DWORD	?
ArrayPercentage			DWORD	8 DUP(?)
AVGPercentage			DWORD	?
Intensity				BYTE	15 DUP(?)


; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.
	LEA ebx, ArrayHR
	LEA edx, ArrayPercentage
	Heart_Rates:
		mov ecx, 1

		;==================Heart Rate 01================
		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 02================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 03================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 04================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 05================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 06================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 07================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Heart Rate 08================

		inc			ecx
		add			ebx, 4

		INVOKE 		OutputStr, ADDR strHeartRate
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE 		OutputInt, ecx
		INVOKE		OutputStr, ADDR	strSpace
		INVOKE		OutputStr, ADDR strColon
		INVOKE 		InputInt
		mov 		DWORD PTR [ebx], eax

		;==================Input Age================
		INVOKE		OutputStr, ADDR strAge
		INVOKE		InputInt
		mov Age		, eax		

		;==================Calculating the Percentage================
		mov ecx, 0
		percentages:
			mov eax, [ebx+ecx*4]
			sub	eax, Age
			mov edx, 0
			mov ebx, 220
			sub ebx, Age
			cdq
			div	ebx
			cmp	eax, 100
			jle value
			mov	eax, 100
			value:
			mov [ArrayPercentage+ecx*4], eax
			inc ecx
			cmp ecx, 8
			jne percentages

		;==================Output Array================
		INVOKE	OutputStr, ADDR strArrayOutput
		mov		ecx, 0
		ArrayOutput:
			mov		eax, ArrayPercentage
			INVOKE	OutputInt, eax
			INVOKE	OutputStr, ADDR strNL
			inc		ecx
			cmp		ecx, 8
			jne		ArrayOutput

		;==================Calculating Average================
		xor			eax, eax
		mov			ecx, 0
		AverageP:
			add		eax, ArrayPercentage
			inc		ecx
			cmp		ecx, 8
			jne		AverageP
		mov			ebx, 8
		cdq
		div			ebx
		mov			AVGPercentage, eax

		;==================Heart Rate 01================

			mov			eax, AVGPercentage
			cmp			eax, 60
			jl			None
			cmp			eax, 69
			jle			Light
			cmp			eax, 79
			jle			Moderate
			jmp			Vigorous

		None:
		mov			eax, OFFSET strNone
		jmp			DisplayIntensity

		Light:
		mov			eax, OFFSET strLight
		jmp			DisplayIntensity

		Moderate:
		mov			eax, OFFSET strModerate
		jmp			DisplayIntensity

		Vigorous:
		mov			eax, OFFSET strVigorous
		jmp			DisplayIntensity

		DisplayIntensity:
		INVOKE		OutputStr, eax
		INVOKE		OutputStr, ADDR strNL

		;==================Prompt for Exit================
		INVOKE	OutputStr, ADDR	strExit
		INVOKE	InputInt
		cmp		eax, 0
		je		endHeart_Rates
		jg 		Heart_Rates

		endHeart_Rates:

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
