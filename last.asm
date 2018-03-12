
;
; SPI init and send byte routines
; 
;
; Created: 2/16/2018 8:39:03 PM
; Author : daniel
;

;	.include m328Pdef.inc 
 .device ATmega328P
 .EQU F_CPU = 16000000	; the freq of the external oscilator is 16MHz (actually tested on an arduino board)
 .ORG 0x0000					; place the code in memory at this adderss 0x0000 (the begining of FLASH MEMORY)

 	jmp RESET		; Reset - vector address contain a jump to the routine that executes after reset - main program 
	reti			;	jmp INT0		; IRQ0
	reti			;	jmp INT1		; IRQ1
	reti			;	jmp PCINT0		; PCINT0
	reti			;	jmp PCINT1		; PCINT1
	reti			;	jmp PCINT2		; PCINT2
	reti			;	jmp WDT			; Watchdog Timeout
	reti			;	jmp TIM2_COMPA	; Timer2 CompareA
	reti			;	jmp TIM2_COMPB	; Timer2 CompareB
	reti			;	jmp TIM2_OVF	; Timer2 Overflow
	reti			;	jmp TIM1_CAPT	; Timer1 Capture
	reti			;	jmp TIM1_COMPA	; Timer1 CompareA
	reti			;	jmp TIM1_COMPB	; Timer1 CompareB
	reti			;	jmp TIM1_OVF	; Timer1 Overflow
	reti			;	jmp TIM0_COMPA	; Timer0 CompareA
	reti			;	jmp TIM0_COMPB	; Timer0 CompareB
	reti			;	jmp TIM0_OVF	; Timer0 Overflow
	reti			;	jmp SPI_STC		; SPI Transfer Complete
	reti			;	jmp USART_RXC	; USART RX Complete
	reti			;	jmp USART_UDRE	; USART UDR Empty
	reti			;	jmp USART_TXC	; USART TX Complete
	reti			;	jmp ADC			; ADC Conversion Complete
	reti			;	jmp EE_RDY		; EEPROM Ready
	reti			;	jmp ANA_COMP	; Analog Comparator
	reti			;	jmp TWI			; 2-wire Serial
	reti			;	jmp SPM_RDY		; SPM Ready


;---------------------------------------------------------------------------
RESET:								; Main program start here after reset
		ldi r16,high(RAMEND)		
		out SPH,r16					; Set Stack Pointer to top of RAM
		ldi r16,low(RAMEND)
		out SPL,r16
		sei							; Enable interrupts

;------test zone for debuger-----------------------------



;------test zone for debuger-----------------------------
		
		call SPI_Init				; initialize the SPI

		call MAX7219_Init			; initilize the chip

;call _delay




_loop:

		ldi ZL, low(pattern1<<1)
		ldi ZH, high(pattern1<<1)
		call MAX7219_Send_box
		
		call _delay

		
		ldi ZL, low(pattern3<<1)
		ldi ZH, high(pattern3<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern4<<1)
		ldi ZH, high(pattern4<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern2<<1)
		ldi ZH, high(pattern2<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern5<<1)
		ldi ZH, high(pattern5<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern6<<1)
		ldi ZH, high(pattern6<<1)
		call MAX7219_Send_box

		call _delay


		ldi ZL, low(pattern7<<1)
		ldi ZH, high(pattern7<<1)
		call MAX7219_Send_box

		call _delay


		ldi ZL, low(pattern8<<1)
		ldi ZH, high(pattern8<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern9<<1)
		ldi ZH, high(pattern9<<1)
		call MAX7219_Send_box

		call _delay

;------------------------ aici incepe anisia

		ldi ZL, low(pattern2<<1)
		ldi ZH, high(pattern2<<1)
		call MAX7219_Send_box

		call _delay


		ldi ZL, low(pattern4<<1)
		ldi ZH, high(pattern4<<1)
		call MAX7219_Send_box

		call _delay


		ldi ZL, low(pattern10<<1)
		ldi ZH, high(pattern10<<1)
		call MAX7219_Send_box

		call _delay


		ldi ZL, low(pattern11<<1)
		ldi ZH, high(pattern11<<1)
		call MAX7219_Send_box

		call _delay

        ldi ZL, low(pattern10<<1)
		ldi ZH, high(pattern10<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern2<<1)
		ldi ZH, high(pattern2<<1)
		call MAX7219_Send_box

		call _delay
		ldi ZL, low(pattern12<<1)
		ldi ZH, high(pattern12<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern13<<1)
		ldi ZH, high(pattern13<<1)
		call MAX7219_Send_box

		call _delay

		ldi ZL, low(pattern14<<1)
		ldi ZH, high(pattern14<<1)
		call MAX7219_Send_box

		call _delay


		ldi ZL, low(pattern15<<1)
		ldi ZH, high(pattern15<<1)
		call MAX7219_Send_box

		call _delay









		rjmp _loop					; go back at the begining of the main loop
 
_delay:
		ldi r24, 0x00				; one second delay iteration - load register r24 with 0x00
		ldi r23, 0xd4				; load reggister r23 with value 0xd4 (212)
		ldi r22, 0x30				; load reggister r22 with value 0x30 (48)
_d1:								; delay ~1 second - the counting mechanism
		subi r24, 1					; substract 1 from r24 -> r24 = r24 - 1 - SET CARRY FLAG IF 0-1
		sbci r23, 0					; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		sbci r22, 0					; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		brcc _d1					; jump to _d1 if there is no carry - basically jump to _d1 as long as r22 did not reach 0
		ret							; this way the total number of iterations are 255 x 212 x 48 = 2594880 cycles at 16Mhz the CPU time is aprox 1 sec

;---------------------------------------------------------------------------------------
;pattern1:	.db 0xAA,0x55,0xAA,0x55,0xAA,0x55,0xAA,0x55
;pattern2:	.db 0x55,0xAA,0x55,0xAA,0x55,0xAA,0x55,0xAA

pattern1:	.db 0x00,0x00,0xFF,0xFF,0b11011011,0b11000011,0b11000011,0x00 ; E
pattern2:	.db 0x00,0xFF,0xFF,0b00110011,0b00110011,0xFF,0xFF,0x00 ; A

pattern3:	.db 0b00000000, 0b11111111, 0b00001001, 0b00011001, 0b00101001, 0b01001111, 0b10000000, 0b00000000 ; R
pattern4:   .db 0b00000000, 0b11111111, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b11111111, 0b00000000	; N
pattern5:	.db 0b00001000, 0b00001000, 0b11001000, 0b01111110, 0b01111110, 0b11001000, 0b00001000, 0b00001000 ; om
pattern6:   .db 0b00010000, 0b00111000, 0b01111100, 0b11111110, 0b01111100, 0b00111000, 0b00010000, 0b00000000	; romb
pattern7:	.db 0b00000000, 0b00000100, 0b00000100, 0b01111100, 0b01111000, 0b01111100, 0b00000100, 0b00000100
pattern8:   .db 0b00000000, 0b11000000, 0b11000000, 0b11101000, 0b11000100, 0b11000010, 0b11000000, 0b00000000
pattern9:	.db 0b11111000, 0b11110000, 0b11111000, 0b11110000, 0b11111000, 0b11110000, 0b11111000, 0b11110000


pattern10:	.db 0b00000000, 0b00000000, 0b00000000, 0b11111011, 0b11111011, 0b00000000, 0b00000000, 0b00000000 ; I
pattern11:	.db 0b11011111, 0b11011111, 0b11011011, 0b11011011, 0b11011011, 0b11011011, 0b11111011, 0b11111011 ; S
pattern12:	.db 0b00000000, 0b00010110, 0b00110110, 0b01110010, 0b01111110, 0b01110000, 0b00110000, 0b00010000 ; boat
pattern13:	.db 0b00000000, 0b00001000, 0b11111000, 0b00111110, 0b11111110, 0b00010000, 0b00001000, 0b00000000	; zombie
pattern14:  .db 0b11000000, 0b00100000, 0b11111000, 0b00111000, 0b11111000, 0b00100000, 0b11000000, 0b00000000	; spider
pattern15:	.db 0b11111111, 0b10011001, 0b10011001, 0b11100111, 0b11100111, 0b10011001, 0b10011001, 0b11111111	; dies


;---------------------------------------------------------------------------------------
MAX7219_Init:						; initialize the CHIP

		ldi r16, 0x0C
		ldi r17, 0b0000_0000		; Put the chip in shutdownmode
		call MAX7219_Send_Frame

		ldi r16, 0x0A
		ldi r17, 0b0000_0000		; Set the intensity to the lowest (1 from 16)
		call MAX7219_Send_Frame

		ldi r16, 0x09
		ldi r17, 0b0000_0000		; Decode mode is NO DECODE
		call MAX7219_Send_Frame

		ldi r16, 0x0B
		ldi r17, 0b0000_0111		; Display all 8 columns
		call MAX7219_Send_Frame

		ldi r16, 0x0C
		ldi r17, 0b0000_0001		; Put the chip in normal operation mode
		call MAX7219_Send_Frame

;---------------------------------------------------------------------------------------
MAX7219_Send_box:	

		ldi r18,8
		ldi r19,1
		goloop:
		mov r16,r19
		lpm r17, Z
		call MAX7219_Send_Frame
		adiw ZH:ZL,1
		inc r19
		dec r18
		brne goloop
		ret


;---------------------------------------------------------------------------------------
MAX7219_Send_Frame:					; send a frame of 16 bits using SPI - r16,r17
									; r16 contains the address
									; r17 contains the data
		cbi PORTB, PORTB2			; SS or CS or LOAD set to 0/LOW to signal the start of the data
		call SPI_Transmit			; register r16 is sent
		mov r16, r17				; move the content of r17 in r16
		call SPI_Transmit			; register r16 is sent
		sbi PORTB, PORTB2			; SS or CS or LOAD set to 1/HIGH to signal the end of the data frame

							

; -----------------------------------------------------------------------------------------	
SPI_Init:							; intiliaze the SPI interface
		sbi DDRB, DDB2				; SlaveSelect or ChipSelect or LOAD
		sbi DDRB, DDB5				; SCK - clock
		sbi DDRB, DDB3				; MOSI - the data OUT from master
		sbi PORTB, PORTB5			; make SS up


		ldi r16, 0b0101_0010		;
		out SPCR, r16
		ret
;-------------------------------------------------------------------------------------------
SPI_transmit:					; transmit on SPI the value of register r16
	
		out SPDR, r16
		
		wait_to_transmit:
		in r16, SPSR			; read the status register for SPI
		sbrs r16, SPIF			; if not busy transmiting skip next instruction, otherwise go to wait_to_transmit
		rjmp wait_to_transmit
		ret




;----------------------------------------------------------------------------
; the rest of the code including the definition of the interrupt routines