; 
; File: ATmega328P Template ASM
;
; Created: 04/28/2020 39:03 PM
; Author : daniel balasa
;


; ---------- HEADER ZONE ----------

.DEVICE ATmega328P
.EQU F_CPU = 16000000	; the freq of the external oscilator is 16MHz (actually tested on an arduino board)

 
; ---------- DATA SEGMENT ----------
 
 .DSEG						; Data Segment
	.ORG 0x0100				; place the data in memory at this adderss (in SRAM Data Memory) - only .BYTE directives here - 1 BYTE Wide
	var1: .BYTE 1			; reserve 1 byte to var1

; ---------- EEPROM SEGMENT ----------

 .ESEG						; EEPROM Segment
	.ORG 0x0000				; place the data in memory at this adderss (in EEPROM Data Memory)  - 1 BYTE Wide
	 eevar1: .DW 0xAAAA		; initialize 1 word in EEPROM

 ; ---------- CODE SEGMENT ----------

 .CSEG						; Code Segment
	.ORG 0x0000				; place the code in memory at this adderss 0x0000 (the begining of FLASH MEMORY) - 1 WORD Wide

 	jmp RESET		; Reset - vector address contain a jump to the routine that executes after reset - main program - this is the first instruction to execute after reset
	reti			; jmp INT0			; IRQ0
	reti 			; jmp INT1			; IRQ1
	reti 			; jmp PCINT0		; PCINT0
	reti 			; jmp PCINT1		; PCINT1
	reti 			; jmp PCINT2		; PCINT2
	reti 			; jmp WDT			; Watchdog Timeout
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
	reti 			; jmp ADC			; ADC Conversion Complete
	reti 			; jmp EE_RDY		; EEPROM Ready
	reti 			; jmp ANA_COMP		; Analog Comparator
	reti 			; jmp TWI			; 2-wire Serial
	reti 			; jmp SPM_RDY		; SPM Ready


;---------------------------------------------------------------------------

RESET:	ldi r16,high(RAMEND)		; Main program start here after reset
		out SPH,r16					; Set Stack Pointer to top of RAM
		ldi r16,low(RAMEND)
		out SPL,r16
		sei							; Enable interrupts
