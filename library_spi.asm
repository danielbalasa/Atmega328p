; #################################################
; File: ATmega328P SPI Library Implementation
; This is a SPI library implemented in ASM
; 
; Created: 04/28/2020 16:23
; Author : Daniel Balasa
; daniel.balasa@protonmail.com
; #################################################






; -----------------------------------------------------------------------------------------	
_SPI_MasterInit:	; intiliaze the SPI interface
			; setting the direction of the port pins
			; DDRB is the Direction Register for Port B
			sbi DDRB, DDB2			; SlaveSelect or ChipSelect or LOAD (OUTPUT)
			sbi DDRB, DDB5			; SCK - clock (OUTPUT)
			sbi DDRB, DDB3			; MOSI - the data OUT from master (OUTPUT)
		
			; making the pin 5 on port B (Chip Select) UP - none selected
			; PORTB is the data register for Port B
			sbi PORTB, PORTB5		; make CS up - put a HIGH logic (5V) on pin5/portB


			; load the SPI settings on the r16
			; these settings are device dependent
			; CHANGE THE SETTINGS AS NEEDED BASED ON THE DEVICE YOU ARE CONNECTING WITH
			
			ldi r16, 0b0101_0010	
			; the structure of the SPI COntrol Register (SPCR)
			; SPIE 	= SPI Interrupt Enable		- 0
			; SPE	= SPI Enable			- 1
			; DORD	= Data Order			- 0
			; MSTR	= Master/Slave Select		- 1
			; CPOL	= Clock Polarity		- 0
			; CPHA	= Clock Phase			- 0
			; SPR1	= SPI Clock Rate Select1	- 1
			; SPR0	= SPI Clock Rate Select0	- 0
			
			; write the settings to the SPI Control Register (SPCR)
			out SPCR, r16			
			ret
    
;-------------------------------------------------------------------------------------------
_SPI_MasterTransmit:				; transmit on SPI the value of register r16
	
		; writing in the SPI Data Register initiate the data transmission
		out SPDR, r16			; send 1 byte to the slave on the MOSI line
		
	wait_to_transmit:
		in r16, SPSR			; read the status register for SPI
		sbrs r16, SPIF			; if not busy transmiting skip next instruction, otherwise go to wait_to_transmit
		rjmp wait_to_transmit
		ret
