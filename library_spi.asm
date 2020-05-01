; #################################################
; File: ATmega328P SPI Library Implementation
; This is a SPI library implemented in ASM
; 
; Created: 04/28/2020 16:23
; Author : Daniel Balasa
; daniel.balasa@protonmail.com
; #################################################






; -----------------------------------------------------------------------------------------	
_SPIInit:					; intiliaze the SPI interface
		sbi DDRB, DDB2			; SlaveSelect or ChipSelect or LOAD
		sbi DDRB, DDB5			; SCK - clock
		sbi DDRB, DDB3			; MOSI - the data OUT from master
		sbi PORTB, PORTB5		; make SS up


		ldi r16, 0b0101_0010		;
		out SPCR, r16
		ret
    
;-------------------------------------------------------------------------------------------
_SPITransmit:					; transmit on SPI the value of register r16
	
		out SPDR, r16
		
		wait_to_transmit:
		in r16, SPSR			; read the status register for SPI
		sbrs r16, SPIF			; if not busy transmiting skip next instruction, otherwise go to wait_to_transmit
		rjmp wait_to_transmit
		ret
