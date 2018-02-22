
;
; Title: asm template
;
; Created: 2/16/2018 8:39:03 PM
;
; Author : daniel
;

;--------------------------------------------------------------------------- 
 .EQU F_CPU = 16000000		; the freq of the external oscilator is 16MHz (actually tested on an arduino board)
 .ORG 0				; place the code in memory at this address 0x0000 (the begining of FLASH MEMORY)

 	jmp RESET		; Reset - vector address contain a jump to the routine that executes after reset - main program 
	iret 			;jmp INT0		; IRQ0
	iret 			;jmp INT1		; IRQ1
	iret 			;jmp PCINT0		; PCINT0
	iret 			;jmp PCINT1		; PCINT1
	iret			;jmp PCINT2		; PCINT2
	iret 			;jmp WDT		; Watchdog Timeout
	iret			;jmp TIM2_COMPA		; Timer2 CompareA
	iret			;jmp TIM2_COMPB		; Timer2 CompareB
	iret			;jmp TIM2_OVF		; Timer2 Overflow
	iret			;jmp TIM1_CAPT		; Timer1 Capture
	iret			;jmp TIM1_COMPA		; Timer1 CompareA
	iret			;jmp TIM1_COMPB		; Timer1 CompareB
	iret			;jmp TIM1_OVF		; Timer1 Overflow
	iret			;jmp TIM0_COMPA		; Timer0 CompareA
	iret			;jmp TIM0_COMPB		; Timer0 CompareB
	iret			;jmp TIM0_OVF		; Timer0 Overflow
	iret			;jmp SPI_STC		; SPI Transfer Complete
	iret			;jmp USART_RXC		; USART RX Complete
	iret			;jmp USART_UDRE		; USART UDR Empty
	iret			;jmp USART_TXC		; USART TX Complete
	iret			;jmp ADC		; ADC Conversion Complete
	iret			;jmp EE_RDY		; EEPROM Ready
	iret			;jmp ANA_COMP		; Analog Comparator
	iret			;jmp TWI		; 2-wire Serial
	iret			;jmp SPM_RDY		; SPM Ready


;---------------------------------------------------------------------------
RESET:	
	ldi r16,high(RAMEND)	; Main program start here after reset
	out SPH,r16		; Set Stack Pointer to top of RAM
	ldi r16,low(RAMEND)
	out SPL,r16
	sei			; Enable interrupts


;----------------------------------------------------------------------------
; the rest of the code including the definition of the interrupt routines
