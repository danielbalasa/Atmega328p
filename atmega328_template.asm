; #################################################
; File: ATmega328P Template ASM
; To be used as starting point for AVR ASM Projects
;
; Created: 04/28/2020 39:03 PM
; Author : daniel balasa
; #################################################


; ---------- HEADER ZONE ----------
; global declaration 

.DEVICE ATmega328P	; declare the type of device
.EQU F_CPU = 16000000	; the freq of the external oscilator is 16MHz (this is the case of the arduino board)
.INCLUDE mp328pdef.inc	; include de definitions for this type of micro controller
 
; ---------- DATA SEGMENT ----------
; variable declarations in bytes located in SRAM
 
 .DSEG						; Data Segment
	.ORG 0x0100				; place the following data in memory at this adderss (in SRAM Data Memory) - only .BYTE directives here - 1 BYTE Wide
	var1: .BYTE 1				; reserve 1 byte to var1

; ---------- EEPROM SEGMENT ----------
; vraiable declarations in bytes located in EEPROM

 .ESEG						; EEPROM Segment
	.ORG 0x0000				; place the foloowing data in memory at this adderss (in EEPROM Data Memory)  - 1 BYTE Wide
	 eevar1: .DW 0xAAAA			; initialize 1 word in EEPROM

 ; ---------- CODE SEGMENT ----------
 ; code instructions and constant declarations in words located in FLASH

 .CSEG						; Code Segment
	.ORG 0x0000				; place the following code in memory at this adderss 0x0000 (the begining of FLASH MEMORY) - 1 WORD Wide

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


;---------------------------------------------------------------------------

RESET:					; Main program start here after reset

		; this is a best practice method if you port the software to older AVR's
		; SP in the newer versions is automatically initialized with RAMEND
		ldi r16,high(RAMEND)	; initialize the Stack Pointer at the end of the SRAM memory
		out SPH,r16		; Set Stack Pointer to top of SRAM (the high byte)
		ldi r16,low(RAMEND)	; RAMEND is declared in <mp328pdef.inc>
		out SPL,r16		; Set Stack Pointer to top of SRAM (the low byte)
		sei			; Enable interrupts

