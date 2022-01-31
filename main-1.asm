;
; FinalProject2.asm
;
; Created: 11/20/2020 6:41:26 PM
; Author : Austin Hood
; Purpose: Cycle through 3 modes of LED patterns and loop infinatly until given input from push button



main:
		;set stack pointer
		ldi		r16,HIGH(RAMEND)
		out		SPH,r16
		ldi		r16,LOW(RAMEND)
		out		SPL,r16

		;set port directions
		ldi		r16,0b00000111	;button input and 3 colors for multi led
		out		DDRB,r16
		ldi		r16,0b11111111      ;sets all ports to output high
		out		DDRD,r16
	

		;steps into loops with button press
		sbis	PINB,3
		rjmp	main

		call	LED_1
		
;---------------------------------------------------------------------------------------------------------------------------

LED_1:


		cbi		PORTB,2		;makes sure it does not stay white after LED_3 is used
        sbi		PORTB,0		;sets yellow without interfering with input pin
		sbi		PORTB,1
							;-------------------------------------------------
		clr	r16				
		out PORTD,r16		;clears all leds after loop is finished and prevents interferance from other modules
		call	timer_1	

		sbi		PORTD,0
		call	timer_1

		sbi		PORTD,1
		call	timer_1

		sbi		PORTD,2
		call	timer_1

		sbi		PORTD,3
		call	timer_1
													;pattern 
		sbi		PORTD,4
		call	timer_1

		sbi		PORTD,5
		call	timer_1

		sbi		PORTD,6
		call	timer_1

		sbi		PORTD,7
		call	timer_1
		call	timer_1		;waits for a full second
		call	timer_1
		call	timer_1
							;----------------------------------------------------------
		
        sbis    PINB,3		;escapes the loop if input from buttton is detected
		rjmp	LED_1

        call    LED_2		;jumps into next mode

LED_2:

		clr	r16
		out	PORTD,r16

		cbi		PORTB,1			;clears yellow from LED_1
        sbi		PORTB,0			;purple
		sbi		PORTB,2

								;--------------------------------------------------

		ldi	r16,0b10100101      ;lights all red leds
		out	PORTD,r16

		call	timer_1			;gives time for it to stay in the mode
		call	timer_1

		ldi	r16,0b01011010      ;lights up all green leds
		out	PORTD,r16
								
		call	timer_1
		call	timer_1

								;---------------------------------------------------

        sbis      PINB,3
		rjmp	LED_2

        call      LED_3

LED_3:

		clr r16
		out	PORTD,r16

		cbi		PORTB,0
		cbi		PORTB,1
		sbi		PORTB,2			;blue

								;------------------------------------------------------

		clr	r16				
		out PORTD,r16		;clears all leds after loop is finished and prevents interferance from other modules
		call	timer_1	

		sbi		PORTD,0
		sbi		PORTD,7
		call	timer_1
		call	timer_1

		sbi		PORTD,1
		sbi		PORTD,6
		call	timer_1
		call	timer_1
														;outside in pattern
		sbi		PORTD,2
		sbi		PORTD,5
		call	timer_1
		call	timer_1

		sbi		PORTD,3
		sbi		PORTD,4
		call	timer_1
		call	timer_1

								;-----------------------------------------------------------

        sbis    PINB,3
		rjmp	LED_3

        call    LED_1

;-------------------------------------------------------------------------------------------------------------------------------------------

timer_1:

		ldi		r20,HIGH(49911)
		sts		TCNT1H, r20
		ldi		r20,LOW(49911)
		sts		TCNT1L,r20

		clr		r20
		sts		TCCR1A,r20

		ldi		r20,(1<<CS12)
		sts		TCCR1B,r20

tov1_lp:

		sbis	TIFR1,TOV1
		rjmp	tov1_lp

		clr		r20
		sts		TCCR1B, r20

		ldi		r20,(1<<TOV1)
		out		TIFR1, r20

		ret