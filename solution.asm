TITLE Assignment 2    (template.asm)

; Author(s): Lauren Gliane
; Last Modified: 1/30/2025
; OSU email address: glianel@oregonstate.edu
; Course number/section: CS 271
; Assignment Number: 2                Due Date: 1/30/2025
; Description: Calculate the factors of each number within a range of numbers and indicate which numbers are prime

INCLUDE Irvine32.inc

; (insert constant definitions here) 
; declare perimeter factor here 
PERIMETER_FACTOR = 2

.data

; (insert variable definitions here)
	program_intro		BYTE		"Assignment 2: Calculating factors and primes by Lauren Gliane", 0
	;EC_message		BYTE		"[Extra Credit has been implemented]", 0
	instructions		BYTE		"Please enter information to the following prompts to calculate factors and find prime numbers!", 0
	ask_username		BYTE		"Enter your name: ", 0
	good_bye			BYTE		"Goodbye ", 0
	
	prompt_1			BYTE		"Enter the lower bound: ", 0
	prompt_2			BYTE		"Enter the upper bound: ", 0
	range_1			BYTE		"(Must be between 1 - 1000) ", 0
	prompt_4			BYTE		"Would you like to make another calculation? (Yes=1/No=0) ", 0
	colon			BYTE		" : ", 0
	space			BYTE		" ", 0
	
	prime_txt			BYTE		"** Prime Number **", 0
	
	username			BYTE		33 DUP(0)
	upper_range		DWORD	1000
	lower_range		DWORD	1
	lower_bound		DWORD	?
	upper_bound		DWORD	?
	factor_counter		DWORD	?

	buffer			BYTE		21 DUP(0)		; input buffer

.code
main PROC

; (insert executable instructions here)

; 1. Introduce the program, programmer, and instructions
	; Program introduction
	mov		edx, OFFSET program_intro
	call		WriteString
	call		Crlf

	; Program instructions
	mov		edx, OFFSET instructions
	call		WriteString
	call		Crlf

	; Ask for user name
	mov		edx, OFFSET ask_username
	call		WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
	call		ReadString
	call		Crlf

AGAIN:
; 2. Get the upper and lower bounds from the user 
	; Length Instructions

	mov		edx, OFFSET prompt_1 ; ask for lower bound
	call		WriteString
	mov		edx, OFFSET range_1
	call		WriteString
	call		ReadInt		; user input will be stored in eax
	
	cmp		eax, lower_range
	jl		AGAIN		; restart prompt if not in range

	cmp		eax, upper_range
	jg		AGAIN
	
	mov		lower_bound, eax

AGAIN2:
	mov		edx, OFFSET prompt_2 ; ask user for upper bound
	call		WriteString
	mov		edx, OFFSET range_1
	call		WriteString
	call		ReadInt
	
	cmp		eax, lower_range
	jl		AGAIN2		; restart prompt if not in range
	cmp		eax, upper_range
	jg		AGAIN2

	cmp		eax, lower_bound	; check upper_bound > lower_bound
	jle		AGAIN2

	mov		upper_bound, eax


; 4. Factor Calculation 

number_loop:
	mov		eax, lower_bound	
	cmp		eax, upper_bound		;compare current number to upper bound
	jg		PROMPT				; exit loop if greater than upper bound

	mov		eax, lower_bound	; print number - start at lower bound
	call		WriteInt
	call		Crlf

	mov		edx, OFFSET colon	; formatting colon
	call		WriteString

	mov		factor_counter, 0	;set factor counter to zero

	mov		ecx, 1			; begin factor search at 1

factor_loop:
	cmp		ecx, lower_bound	; loop stops when factor is great than curr number
	jg		prime_calc		; skip to prime calculation

	mov		eax, lower_bound
	mov		edx, 0			; clear edx remainder
	;mov		ebx, lower_bound
	div		ecx
	cmp		edx, 0
	jne		factor_not_found	; skip number if remainder is not zero

	mov		eax, ecx			; print factor
	call		WriteInt
	mov		edx, OFFSET space
	call		WriteString

	inc		factor_counter		; increment factor counter

factor_not_found:
	inc		ecx				; increment divisor
	jmp		factor_loop

	
; 5. Prime Calculation

prime_calc:
	cmp		factor_counter, 2			; if prime, only two factors (1 and itself)
	jne		not_prime

	mov		edx, OFFSET prime_txt		; print prime indicator
	call		WriteString
	call		Crlf

not_prime:
	call		Crlf

next:
	inc		lower_bound
	jmp		number_loop


; 8. Ask user if they want to go again
PROMPT:
	mov		edx, OFFSET prompt_4	; ask user to go again
	call		WriteString
	call		ReadInt				; user response stored in eax	
	cmp		eax, 1
	je		AGAIN
	cmp		eax,0
	jne		PROMPT				; if user input is not equal to zero jump back to PROMPT, otherwise continue to farewell

; 9. Farewell "Goodbye" 
	mov		edx, OFFSET good_bye
	call		WriteString

	mov		edx, OFFSET username
	call		WriteString
	call		Crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
