
;-------------- byte2ascii conversion routine -----------

; the value to onvert is stored in r16 before calling the routine

clr r17                         ; this will hold the HUNDREDS
clr r18                         ; this will hold the TENS
clr r19                         ; this will hold the ONES

loop1:  cpi r16, 100            ; compare r16 with 100
        brsh loop2              ; if r16 >=
        subi r16, 100
        inc r17
        rjmp loop1
        
loop2: cpi r16, 10
       brsh loop3
       subi r16, 10
       inc r18
       rjmp loop2
       
loop3: cpi r16, 
       brsh endloop
       subi r16, 1
       inc r19
       rjmp loop3
       
end:  ldi r16

;------------------------- vers 2

;input: R16 = 8 bit value 0 ... 255
;output: R18, R17, R16 = digits
;bytes: 20
;
bcd:
ldi r18, -1 + '0'
_bcd1:
inc r18
subi r16, 100
brcc _bcd1
ldi r17, 10 + '0'
_bcd2:
dec r17
subi r16, -10
brcs _bcd2
sbci r16, -'0'
ret
