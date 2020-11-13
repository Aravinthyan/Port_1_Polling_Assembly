            .cdecls C,LIST,"msp430g2553.h"       ; Include device header file

            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------

            .text                           ; Assemble into program memory.
			.global _main

_main:
RESET:
	mov.w   #__STACK_END,SP         ; Initialize stackpointer
	mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

	bis.b	#BIT0,&P1DIR		; make P1.0 output and P1.3 input
	bis.b	#BIT3,&P1REN		; enable pull up/down resistor
	bis.b	#BIT3,&P1OUT		; enable pull up resistor for P1.3
	bic.b 	#BIT0,&P1OUT		; make P1.0 low

mainloop:
	bit.b	#BIT3,&P1IN				; bit-wise and
	jz		toggle					; if button is pressed go to toggle
	jmp 	mainloop				; else go back to mainloop

toggle:
	xor.b	#BIT0,&P1OUT		; toggle LED
	mov.w	#50000,R15				; count from 50000 to 0 for swuth debounce
delay:
	dec.w	R15
	jnz		delay
	jmp		mainloop				; go back to mainloop
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .end
