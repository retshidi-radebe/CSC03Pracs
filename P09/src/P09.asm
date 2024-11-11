.386
.MODEL FLAT, stdcall 
.STACK 4096
.CODE

; LibMain function tests which action is currently beign performed
; The function returns if the DLL is loaded correctly or not.
; We avoid the complex logic here for simplicity.
LibMain proc instance:DWORD, reason:DWORD, unused:DWORD
    mov eax, 1
    ret
LibMain ENDP

;===================================ComputeResult Function=======================================
computeResult PROC  NEAR32 firstNumber:DWORD, secondNumber:DWORD, multiplier:DWORD, divisor:DWORD

    ;Load parameters into registers
    mov     eax, firstNumber
    mov     eax, secondNumber   ; eax = firstNumber + secondNumber
    mov     ebx, multiplier
    imul    eax, ebx            ; eax = (firstNumber + secondNumber) * multiplier

    mov     ecx, divisor        ; eax = eax / divisor
    cdq
    idiv    ecx

    imul    eax, eax            ; eax = eax ^ 2 (squaring the results)

    ret                         ; return the results
computeResult ENDP

end LibMain