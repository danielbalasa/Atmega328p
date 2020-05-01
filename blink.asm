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
						; eg. reserve 1 byte to var1 - var1: .BYTE 1

; ---------- EEPROM SEGMENT ----------
; vraiable declarations in bytes located in EEPROM

 .ESEG						; EEPROM Segment
	.ORG 0x0000				; place the foloowing data in memory at this adderss (in EEPROM Data Memory)  - 1 BYTE Wide
	 					; eg. initialize 1 word in EEPROM - eevar1: .DW 0xAAAA

 ; ---------- CODE SEGMENT ----------
 ; code instructions and constant declarations in words located in FLASH

 .CSEG						; Code Segment
	.ORG 0x0000				; place the following code in memory at this adderss 0x0000 (the begining of FLASH MEMORY) - 1 WORD Wide

	; this is the vector interupts table
	; delete the RETI instructions, uncoment the JMP instructions and implement the routines in the code segment
	
 	jmp _reset		; Reset - vector address contain a jump to the routine that executes after reset - main program - this is the first instruction to execute after reset
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

_reset:					; Main program start here after reset

		ldi r16,high(RAMEND)	; initialize the Stack Pointer at the end of the SRAM memory
		out SPH,r16		; Set Stack Pointer to top of SRAM (the high byte)
		ldi r16,low(RAMEND)	; RAMEND is declared in <mp328pdef.inc>
		out SPL,r16		; Set Stack Pointer to top of SRAM (the low byte)
		sei			; Enable interrupts

		sbi DDRB, DDB5		; define pin13 as an OUTPUT pin - set pin 5 of the IO register 0x04 to 1

_mainloop:
		sbi 0x03, PORTB5	; turn LED on - set pin 5 of the IO register 0x03 to 1
		rcall _delay		; jump to the counting loop
		cbi PORTB, PORTB5	; turn LED off
		rcall _delay		; jump to the counting loop again
		rjmp _mainloop		; go back at the begining of the main loop
 
_delay:
		ldi r24, 0x00		; one second delay iteration - load register r24 with 0x00
		ldi r23, 0xd4		; load reggister r23 with value 0xd4 (212)
		ldi r22, 0x30		; load reggister r22 with value 0x30 (48)

_d1sec:					; delay ~1 second - the counting mechanism
		subi r24, 1		; substract 1 from r24 -> r24 = r24 - 1 - SET CARRY FLAG IF 0-1
		sbci r23, 0		; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		sbci r22, 0		; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		brcc _d1sec		; jump to _d1 if there is no carry - basically jump to _d1 as long as r22 did not reach 0
		ret			; this way the total number of iterations are 255 x 212 x 48 = 2594880 cycles at 16Mhz the CPU time is aprox 1 sec


;----------------------------------------------------------------------------
; the rest of the code including the definition of the interrupt routines


