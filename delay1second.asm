; ##################################################
; File: Delay 1 second for ATmega328P 
;        running @ 16 MHz
;
; This is the implementation of the classic delay
; routine
;
; Created: 05/23/2021 19:59 PM
; Author : Daniel Balasa
; daniel.balasa@protonmail.com
; ##################################################

_STD_delay1second:
		ldi r24, 0x00		; one second delay iteration - load register r24 with 0x00
		ldi r23, 0xd4		; load register r23 with value 0xd4 (212)
		ldi r22, 0x30		; load register r22 with value 0x30 (48)

_d1sec:					; delay ~1 second - the counting mechanism
		subi r24, 1		; substract 1 from r24 -> r24 = r24 - 1 - SET CARRY FLAG IF 0-1
		sbci r23, 0		; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		sbci r22, 0		; substract only the carry flag from the previous instruction - SET ALSO THE CARRY FLAG 
		brcc _d1sec		; jump to _d1 if there is no carry - basically jump to _d1 as long as r22 did not reach 0
		ret			; this way the total number of iterations are 255 x 212 x 48 = 2594880 cycles at 16Mhz the CPU time is aprox 1 sec
