; #################################################
; File: ATmega328P Blink Version 2
; A more general aproach to blink
;
; Created: 05/08/2020 39:03 PM
; Author : Daniel Balasa
; daniel.balasa@protonmail.com
; #################################################


; ---------- HEADER ZONE ----------
; global declaration 

.device ATmega328P					; declare the type of device
.equ F_CPU = 16000000				; the freq of the external oscilator is 16MHz (this is the case of the arduino board)

.equ F_MILSEC = F_CPU / 1000		; the number of cycles needed to achieve 1 ms delay derived from the frequency of the CPU


 ; ---------- CODE SEGMENT ----------
 ; code instructions and constant declarations in words located in FLASH

 .cseg						; Code Segment
	.org 0x0000				; place the following code in memory at this adderss 0x0000 (the begining of FLASH MEMORY) - 1 WORD Wide

	; this is the vector interupts table
	; delete the RETI instructions, uncomment the JMP instructions and implement the routines in the code segment as required
	
 	jmp RESET		; Reset - vector address contain a jump to the routine that executes after reset - main program - this is the first instruction to execute after reset
	reti			; jmp INT0		; IRQ0
	reti 			; jmp INT1		; IRQ1
	reti 			; jmp PCINT0		; PCINT0
	reti 			; jmp PCINT1		; PCINT1
	reti 			; jmp PCINT2		; PCINT2
	reti 			; jmp WDT		; Watchdog Timeout
	reti 			; jmp TIM2_COMPA	; Timer2 CompareA
	reti 			; jmp TIM2_COMPB	; Timer2 CompareB
	reti 			; jmp TIM2_OVF		; Timer2 Overflow
	reti 			; jmp TIM1_CAPT		; Timer1 Capture
	reti 			; jmp TIM1_COMPA	; Timer1 CompareA
	reti 			; jmp TIM1_COMPB	; Timer1 CompareB
	reti 			; jmp TIM1_OVF		; Timer1 Overflow
	reti 			; jmp TIM0_COMPA	; Timer0 CompareA
	reti 			; jmp TIM0_COMPB	; Timer0 CompareB
	reti 			; jmp TIM0_OVF		; Timer0 Overflow
	reti 			; jmp SPI_STC		; SPI Transfer Complete
	reti 			; jmp USART_RXC		; USART RX Complete
	reti 			; jmp USART_UDRE	; USART UDR Empty
	reti 			; jmp USART_TXC		; USART TX Complete
	reti 			; jmp ADC		; ADC Conversion Complete
	reti 			; jmp EE_RDY		; EEPROM Ready
	reti 			; jmp ANA_COMP		; Analog Comparator
	reti 			; jmp TWI		; 2-wire Serial
	reti 			; jmp SPM_RDY		; SPM Ready


;---------------------------------------------------------------------------------

RESET:												; Main program start here after reset

													; this is a best practice method if you port the software to older AVR's
													; SP in the newer versions is automatically initialized with RAMEND
				ldi		r16,high(RAMEND)			; initialize the Stack Pointer at the end of the SRAM memory
				out		SPH,r16						; Set Stack Pointer to top of SRAM (the high byte)
				ldi		r16,low(RAMEND)				; RAMEND is declared in <mp328pdef.inc>
				out		SPL,r16						; Set Stack Pointer to top of SRAM (the low byte)
				sei									; Enable interrupts

;---------------------------------------------------------------------------------

MAIN:			

				jmp		MAIN						; The end  of main loop


;---------------------------------------------------------------------------------

delay:			push	R24							; 2 cycles	; save R24 on stack
				push	R25							; 2 cycles	; save R25 on stack

wait_1ms:		ldi		R24, LOW(F_MILSEC/4-1)		; 1 cycle	; initialize R24:R25 with the vlaue of F_MILSEC
				ldi		R25, HIGH(F_MILSEC/4-1)		; 1 cycle	; this represents the number of cycles needed to waste to achieve 1ms delay

loop_1ms:		sbiw	R24:R25,1					; 2 cycles	; decrese the pair R24:R25 by 1
				nop									; 1 cycle	; add one more cycle in the loop
				brne	loop_1ms					; 1 cycle	; repeat decreasing by 1 until it reaches 0 - (2 cycles if true)

				pop		R25							; 2 cycles	; restore R25 from the stack
				pop		R24							; 2 cycles	; restore R24 from the stack
				sbiw	R24:R25,1					; 1 cycle	; decrese the (original) pair R24:R25 by 1 
				brne	delay						; 1 cycle	; go to wait another milisecond - (2 cycles if true)
