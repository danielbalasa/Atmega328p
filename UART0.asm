; #################################################
; File: initUART
; enables UART transmission with 8 data, 1 parity, no stop bit at input baudrate
;
; Created: 04/28/2020 39:03 PM
; Author : Daniel Balasa
; daniel.balasa@protonmail.com
; #################################################


; ---------- HEADER ZONE ----------
; global declaration 

.device ATmega328P	; declare the type of device
.equ F_CPU = 16000000	; the freq of the external oscilator is 16MHz (this is the case of the arduino board)

;.include mp328pdef.inc	; include de definitions for this type of micro controller


; ---------- DATA SEGMENT ----------
; variable declarations in bytes located in SRAM
 
 .dseg						; Data Segment
	.org 0x0100				; place the following data in memory at this adderss (in SRAM Data Memory) - only .BYTE directives here - 1 BYTE Wide
	var1: .BYTE 1			; reserve 1 byte to var1

; ---------- EEPROM SEGMENT ----------
; vraiable declarations in bytes located in EEPROM

 .eseg						; EEPROM Segment
	.org 0x0000				; place the foloowing data in memory at this adderss (in EEPROM Data Memory)  - 1 BYTE Wide
	 eevar1: .dw 0xAAAA			; initialize 1 word in EEPROM

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


;---------------------------------------------------------------------------

RESET:								; Main program start here after reset

		; this is a best practice method if you port the software to older AVR's
		; SP in the newer versions is automatically initialized with RAMEND

		ldi r16,high(RAMEND)		; initialize the Stack Pointer at the end of the SRAM memory
		out SPH,r16					; Set Stack Pointer to top of SRAM (the high byte)
		ldi r16,low(RAMEND)			; RAMEND is declared in <mp328pdef.inc>
		out SPL,r16					; Set Stack Pointer to top of SRAM (the low byte)
		; ....
		rcall uart_init				
		; ....
		sei							; Enable interrupts

		ldi		ZL,LOW(2*myStr1)			; load Z pointer with
		ldi		ZH,HIGH(2*myStr1)			; myStr address
		rcall	uart_send_string			; transmit string

MAIN_LOOP:	jmp MAIN_LOOP


;---------------------------------------------------------------------------
uart_init:								; enables UART transmission with 8 data, 1 parity, no stop bit at input baudrate

	.equ	baud = 9600					; baudrate
	.equ	bps	= (F_CPU/16/baud) - 1	; baud prescale

	ldi	r16,LOW(bps)					; load baud prescale
	ldi	r17,HIGH(bps)					; into r17:r16

	sts	UBRR0L,r16						; load baud prescale
	sts	UBRR0H,r17						; to UBRR0

	ldi	r16,(1<<RXEN0)|(1<<TXEN0)		; enable transmitter
	sts	UCSR0B,r16						; and receiver

	ret									; return from subroutine


;---------------------------------------------------------------------------
uart_send_char:							; transmits single ASCII character via UART
										; Using this subroutine simply requires loading a character into r16 before calling it
											
	lds		r17,UCSR0A					; load UCSR0A into r17
	sbrs	r17,UDRE0					; wait for empty transmit buffer
	rjmp	uart_send_char					; repeat loop

	sts		UDR0,r16					; transmit character

	ret									; return from subroutine

;---------------------------------------------------------------------------
uart_send_string:						; transmits null terminated string via UART

	lpm	r16,Z+							; load character from pmem
	cpi	r16,$00							; check if null
	breq		uart_send_string_end	; branch if null

	uart_send_string_wait:
		lds	r17,UCSR0A					; load UCSR0A into r17
		sbrs	r17,UDRE0				; wait for empty transmit buffer
		rjmp	uart_send_string_wait	; repeat loop

	sts	UDR0,r16						; transmit character
	rjmp	uart_send_string			; repeat loop

	uart_send_string_end:
	ret								; return from subroutine



; -------------------------------------------------
; data

myStr1:	.db	"ATmega328P Initialized!",10,13,$00
