;	Memo for P05
;	Author:     Dr J du Toit

.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

include	io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
	;========================================Input variables =======================================
	userArray		DWORD			10 DUP (?)
	
	;========================================String prompts=========================================
	strOutputArray  BYTE			"The array is:",10,0
	strInputArr		BYTE			"Please input array item at index ",0
	strClampInput	BYTE			"Please input the value for the clamp: ",0
	strAverage		BYTE			"The average was:",0
	strColon		BYTE			":",0
	strNL			BYTE			10,0
	strQuit			BYTE			"Type 0 to quit:",0
	strTab			BYTE			9,0
	strOpenBracket	BYTE			"[",0
	strCloseBracket BYTE			"]",0
	strComma		BYTE			",",0
	
.CODE
	
;=======================================Input Function==================================================
;void input(int* array, int length);
;address of array		[ebp+8]
;length					[ebp+12]
input PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	
	;Backup our existing registers
	push				eax					;Do not backup eax if this is a value returning function 
	push				ebx
	push				ecx
	push				edx
	pushfd
	;This is the function code 
	;for(int n=0;n<10;n++){
	;   cout << "Please input array item at index : << n <<":";
    ;   cin >> array[n]
    ;}
	mov					ecx,0				;int n=0
inputForStart:
	cmp					ecx,[ebp+12]
	jge					inputForEnd			;n<10
	;This is what the macro INVOKE OutputStr, ADDR OutputStr
	lea					ebx,strInputArr
	push				ebx 
	call				OutputStr
	push				ecx 				;INVOKE OutputInt,ecx 
	call				OutputInt
	lea					ebx,strColon
	push				ebx 
	call				OutputStr
	
	;Calculate the address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;The memory address of array[n]
	call				InputInt
	mov					[ebx],eax			;cin >> array[n]
	
	inc					ecx					;n++ 
	jmp					inputForStart
inputForEnd:
	
	;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	pop					eax					;Do not restore eax, if this is a value returning function.
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					8
input ENDP

;=======================================Display Function==================================================
;void display(int* array, int length);
;address of array		[ebp+8]
;length					[ebp+12]
display PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	
	;Backup our existing registers
	push				eax					;Do not backup eax if this is a value returning function 
	push				ebx
	push				ecx
	push				edx
	pushfd
	;This is the function code 
	;cout << "The array is: << endl;
	;for(int n=0;n<10;n++){
	;   cout << array[n] << ","
    ;}
	lea					ebx,strOutputArray
	push				ebx 
	call				OutputStr
	
	mov					ecx,0				;int n=0
outputForStart:
	cmp					ecx,[ebp+12]
	jge					outputForEnd			;n<10
	
	;Calculate the address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;The memory address of array[n]
	mov					eax,[ebx]
	push				eax 
	call				OutputInt
	mov					eax,[ebp+12]
	dec					eax
	cmp					ecx,eax 
	jge					noComma
	lea					ebx,strComma
	push				ebx 
	call				OutputStr
noComma:
	
	inc					ecx
	jmp					outputForStart
outputForEnd:
	
	;Output a new line character
	lea					ebx,strNL
	push				ebx 
	call				OutputStr
	
	;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	pop					eax					;Do not restore eax, if this is a value returning function.
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					8
display ENDP	

;=======================================Average Function==================================================
;int average(int* array, int arrayLength)
;address of array		[ebp+8]
;length					[ebp+12]
average PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	sub					esp,4
	;sum				[ebp-4]
	;Backup our existing registers
	push				ebx
	push				ecx
	push				edx
	pushfd
	;int sum=0;
	;for(int n=0;n<10;n++){
	;   sum+=array[n]
	;}
	;return sum/10
	mov					DWORD PTR [ebp-4],0	;sum=0
	
	mov					ecx,0				;int n=0
avgForStart:
	cmp					ecx,[ebp+12]
	jge					avgForEnd			;n<10
	
	;Calculate the address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;The memory address of array[n]
	mov					eax,[ebx]
	add					[ebp-4],eax 
	
	inc					ecx
	jmp					avgForStart
avgForEnd:
	;calculate the average 
	mov					eax,[ebp-4]
	mov					edx,0
	mov					ecx,[ebp+12]
	div 				ecx
	
	;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					8
average ENDP

;=======================================Divide Function==================================================
;void divide(int* array, int arrayLength, int divisor);
;address of array		[ebp+8]
;length					[ebp+12]
;divisor				[ebp+16]
divide PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	
	;Backup our existing registers
	push				eax					;Do not backup eax if this is a value returning function 
	push				ebx
	push				ecx
	push				edx
	pushfd
	
	;Function code
	mov					ecx,0				;int n=0
divForStart:
	cmp					ecx,[ebp+12]
	jge					divForEnd			;n<10
	
	;Calculate the address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;The memory address of array[n]
	mov					eax,[ebx]
	mov					edx,0
	div					DWORD PTR [ebp+16]
	;Store the answer back into the array 
	imul				edx,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,edx 			;The memory address of array[n]
	mov 				[ebx],eax 
	
	inc					ecx
	jmp					divForStart
divForEnd:
	
	;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	pop					eax					;Do not restore eax, if this is a value returning function.
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					12
divide ENDP	

;=======================================Clamp Function==================================================
;void clamp(int* array, int arrayLength, int clampValue);
;address of array		[ebp+8]
;length					[ebp+12]
;clampValue				[ebp+16]
clamp PROC NEAR32
	;Creating the stack frame
	push				ebp
	mov					ebp,esp
	;Create space for local variables
	
	;Backup our existing registers
	push				eax
	push				ebx
	push				ecx
	push				edx
	pushfd
	;
	mov					ecx,0				;int n=0
clampForStart:
	cmp					ecx,[ebp+12]
	jge					clampForEnd			;n<10
	
	;Calculate the address of the array[n]
	imul				eax,ecx,4
	mov					ebx,DWORD PTR [ebp+8]
	add					ebx,eax 			;The memory address of array[n]
	mov					eax,[ebx]
	cmp					eax,[ebp+16]
	jle					doNotClamp
	mov					eax,[ebp+16]
	mov					[ebx],eax 
doNotClamp:

	inc					ecx
	jmp					clampForStart
clampForEnd:
	
	;Restore the registers to their original value
	popfd
	pop					edx
	pop					ecx
	pop					ebx
	pop 				eax
	
	;Destroying the stack frame
	mov					esp,ebp
	pop					ebp
	;Return instruction
	;ret uses an operand indicating the number of PARAMETERS
	ret					8
clamp ENDP

;======================================The 'main' function==============================================
_start:

TopOfMain:
	; input(&userArray,length);
	lea					ebx,userArray
	mov					eax,10 
	push				eax
	push				ebx 
	call				input
	
	; display(&userArray,length);
	lea					ebx,userArray
	mov					eax,10 
	push				eax
	push				ebx 
	call				display
	
	;Prompt the average output 
	lea					ebx,strAverage
	push				ebx 
	call				OutputStr 
	
	;int average(int* array, int arrayLength)
	lea					ebx,userArray
	mov					eax,10 
	push				eax
	push				ebx 
	call				average
	;make a copy of the avg into edx 
	mov					edx,eax 
	;Output	the value 
	push				eax
	call				OutputInt
	
	lea					ebx, strNL
	push				ebx 
	call				OutputStr
	;void divide(int* array, int arrayLength, int divisor);
	lea					ebx,userArray
	mov					eax,10 
	push				edx 
	push				eax
	push				ebx 
	call				divide
	
	; display(&userArray,length);
	lea					ebx,userArray
	mov					eax,10 
	push				eax
	push				ebx 
	call				display
	
	;Get the clamp value
	lea					ebx,strClampInput
	push				ebx 
	call				OutputStr
	call				InputInt
	mov					edx,eax				;Store the clamp value in edx 
	
	
	;void clamp(int* array, int arrayLength, int clampValue);
	lea					ebx,userArray
	mov					eax,10
	push				edx 
	push				eax
	push				ebx 
	call				clamp
	
	; display(&userArray,length);
	lea					ebx,userArray
	mov					eax,10 
	push				eax
	push				ebx 
	call				display
	
	;=================================Loop until quit=============================================
	lea					ebx,strQuit
	push				ebx
	call				OutputStr
	call				InputInt
	cmp					eax,0
	jne					TopOfMain

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END


    