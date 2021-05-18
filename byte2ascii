
;-------------- byte2ascii conversion routine -----------

; the value to onvert is stored in r16 before calling the routine

clr r17                         ; this will hold the HUNDREDS
clr r18                         ; this will hold the TENS
clr r19                         ; this will hold the ones

loop1:  cpi r16, 100
        brsh loop2
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
