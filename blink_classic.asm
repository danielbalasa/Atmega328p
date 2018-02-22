
;
; blink with a cpu 1 clock counter - classic delay
; the cpu is busy counting during delay 
;
; Created: 2/16/2018 8:39:03 PM
; Author : daniel
;

 
 .EQU F_CPU = 16000000	; the freq of the external oscilator is 16MHz (actually tested on an arduino board)
 .ORG 0					; place the code in memory at this adderss 0x0000 (the begining of FLASH MEMORY)

 	jmp RESET		; Reset - vector address contain a jump to the routine that executes after reset - main program 
;	iret			; jmp INT0		; IRQ0
;	iret 			; jmp INT1		; IRQ1
;	iret 			; jmp PCINT0		; PCINT0
;	iret 			; jmp PCINT1		; PCINT1
;	iret 			; jmp PCINT2		; PCINT2
;	iret 			; jmp WDT			; Watchdog Timeout
;	iret 			; jmp TIM2_COMPA	; Timer2 CompareA
;	iret 			; jmp TIM2_COMPB	; Timer2 CompareB
;	iret 			; jmp TIM2_OVF	; Timer2 Overflow
;	iret 			; jmp TIM1_CAPT	; Timer1 Capture
;	iret 			; jmp TIM1_COMPA	; Timer1 CompareA
;	iret 			; jmp TIM1_COMPB	; Timer1 CompareB
;	iret 			; jmp TIM1_OVF	; Timer1 Overflow
;	iret 			; jmp TIM0_COMPA	; Timer0 CompareA
;	iret 			; jmp TIM0_COMPB	; Timer0 CompareB
;	iret 			; jmp TIM0_OVF	; Timer0 Overflow
;	iret 			; jmp SPI_STC		; SPI Transfer Complete
;	iret 			; jmp USART_RXC	; USART RX Complete
;	iret 			; jmp USART_UDRE	; USART UDR Empty
;	iret 			; jmp USART_TXC	; USART TX Complete
;	iret 			; jmp ADC			; ADC Conversion Complete
;	iret 			; jmp EE_RDY		; EEPROM Ready
;	iret 			; jmp ANA_COMP	; Analog Comparator
;	iret 			; jmp TWI			; 2-wire Serial
;	iret 			; jmp SPM_RDY		; SPM Ready


;---------------------------------------------------------------------------
RESET:	ldi r16,high(RAMEND)		; Main program start here after reset
		out SPH,r16		; Set Stack Pointer to top of RAM
		ldi r16,low(RAMEND)
		out SPL,r16
		sei			; Enable interrupts

		sbi DDRB, DDB5				; define pin13 as an OUTPUT pin - set pin 5 of the IO register 0x04 to 1

_loop:
		sbi 0x03, PORTB5			; turn LED on - set pin 5 of the IO register 0x03 to 1
		rcall _delay				; jump to the counting loop
		cbi PORTB, PORTB5			; turn LED off
		rcall _delay				; jump to the counting loop again
		rjmp _loop				; go back at the begining of the main loop
 
_delay:
		ldi r24, 0x00				; one second delay iteration - load register r24 with 0x00
		ldi r23, 0xd4				; load reggister r23 with value 0xd4 (212)
		ldi r22, 0x30				; load reggister r22 with value 0x30 (48)
_d1:							; delay ~1 second - the counting mechanism
		subi r24, 1				; substract 1 from r24 -> r24 = r24 - 1 - SET CARRY FLAG IF 0-1
		sbci r23, 0				; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		sbci r22, 0				; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		brcc _d1				; jump to _d1 if there is no carry - basically jump to _d1 as long as r22 did not reach 0
		ret					; this way the total number of iterations are 255 x 212 x 48 = 2594880 cycles at 16Mhz the CPU time is aprox 1 sec


;----------------------------------------------------------------------------
; the rest of the code including the definition of the interrupt routines
