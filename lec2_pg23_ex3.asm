	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100
;Steps
;incrementallly write into fsr, then incrementally read into fsr, and them compare 
;use postinc in order to write it into addresses
;	
	
	
	
start
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs, sets C to zero, TRISC - sets into not 0/1, to control
	movlw	0xff		    ; all bits in
	movwf	TRISD, A	    ; Port D Direction Register
	bsf	PADCFG1,RDPU, A	    ; Turn on pull-ups for Port D
	movff	PORTD,0x08
	movlw 	0x0
	
	lfsr	FSR0, 0x140 ;load address 0x140 into FSR0
	lfsr	FSR1, 0x140 ;load address 0x140 into FSR0

	bra 	test

loop	movff 	0x06, POSTINC0	    ; outputs, to port C
	incf 	0x06, W, ACCESS	    ; +=1, moves f+1 into W mem

test	movwf	0x06, ACCESS	    ; moves W to 0x06,
	movf 	PORTD,W		    ; moves f to W,
	cpfsgt 	0x06, ACCESS	    ; compares 0x06 to W,
 	bra 	loop		    ; Not yet finished goto start of loop again

	movlw	0x0
	bra 	compare
	
read	cpfseq 	0x06, POSTINC1	    ; outputs, to port C
	bra	alert
	incf 	0x06, W, ACCESS	    ; +=1, moves f+1 into W mem

compare	movwf	0x06, ACCESS	    ; moves W to 0x06,
	movf 	PORTD,W		    ; moves f to W,
	cpfsgt 	0x06, ACCESS	    ; compares 0x06 to W,
 	bra 	read		    ; Not yet finished goto start of loop again
	bra	finish
	
alert	movlw	0xff
	movwf	PORTC		
	
finish	goto 	0x0		    ; Re-run program from start, jumps back to org 0x0

	end
	

	; W special register - arithmetic operations, f file, l literal value, ACCESS BANK GOOD,