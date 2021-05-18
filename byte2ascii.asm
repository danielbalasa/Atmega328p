; #################################################
; File: byte2ascii
; Convert one register (R16) into ASCII digits (R18,R17,R16)
; This can be used to be sent to USART0
;
; Created: 18/May/2021 
; Author : Daniel Balasa
; daniel.balasa@protonmail.com
; #################################################


;-------------- byte2ascii conversion routine -----------
; input: R16 = 8 bit value in the range 0 ... 255
; output: R18, R17, R16 = ascii codes for the digits
; ASCII values for digits are from $30 for 0 ... till $39 for 9
; R18 will hold HUNDREDS, R17 will hold TENS, R16 will be left with ONES

byte2ascii:     ldi r18, -1 + '0'               ; initialize r18 with the value $2F one step below ascii value of 0
_bcd1:          inc r18                         ; increment R18
                subi r16, 100                   ; substract 100 from the value of R16 (our number to be converted)
                brcc _bcd1                      ; if the result of the subtraction is not bellow 0 than go back and repeat
                ldi r17, 10 + '0'               ; initialize R17 with $3A one step over acii value of 9
_bcd2:          dec r17                         ; substract 1 from R17
                subi r16, -10                   ; substract -10 from R16 (actually adding 10 to the negative result of previous operation)
                brcs _bcd2                      ; if the result is with cary go back and repeat .....
                sbci r16, -'0'                  ; .....
ret
;---------------------------------------------------------


;-------------- byte2ascii2uart conversion and send to uart routine -----------
; input: R16 = 8 bit value in the range 0 ... 255
; output: R18, R17, R16 = ascii codes for the digits will be sent to UART (interface needs to be confured and enabled)
; intermediary: R19 to test for the UART readiness
; ASCII values for digits are from $30 for 0 ... till $39 for 9
; R18 will hold HUNDREDS, R17 will hold TENS, R16 will be left with ONES

byte2ascii2uart:     ldi r18, -1 + '0'               ; initialize r18 with the value $2F one step below ascii value of 0
_b2a2u1               inc r18                        ; increment R18
                     subi r16, 100                   ; substract 100 from the value of R16 (our number to be converted)
                     brcc _b2a2u1                    ; if the result of the subtraction is not bellow 0 than go back and repeat
                     ldi r17, 10 + '0'               ; initialize R17 with $3A one step over acii value of 9
_b2a2u2:             dec r17                         ; substract 1 from R17
                     subi r16, -10                   ; substract -10 from R16 (actually adding 10 to the negative result of previous operation)
                     brcs _b2a2u2:                   ; if the result is with cary go back and repeat .....
                     sbci r16, -'0'                  ; .....
_b2a2ur18:           lds  r19,UCSR0A                 ; this portion will send R18 to UART - load UCSR0A into r19
	                   sbrs	r19,UDRE0					         ; wait for empty transmit buffer
	                   rjmp	_b2a2ur18: 					       ; repeat loop
                     sts UDR0,r18                    ; transmit character in R18 to UART
_b2a2ur17:           lds  r19,UCSR0A                 ; this portion will send R17 to UART - load UCSR0A into r19
	                   sbrs	r19,UDRE0					         ; wait for empty transmit buffer
	                   rjmp	_b2a2ur17: 					       ; repeat loop
                     sts UDR0,r17                    ; transmit character in R17 to UART
_b2a2ur16:           lds  r19,UCSR0A                 ; this portion will send R16 to UART - load UCSR0A into r19
	                   sbrs	r19,UDRE0					         ; wait for empty transmit buffer
	                   rjmp	_b2a2ur16: 					       ; repeat loop
                     sts UDR0,r16                    ; transmit character in R18 to UART               
                  
                    
ret
;---------------------------------------------------------



