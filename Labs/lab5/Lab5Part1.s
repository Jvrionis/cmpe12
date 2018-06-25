/*
    James Vrionis
    Lab5
    Part1
 */

#include <WProgram.h>
#include <xc.h>
.global main

.text
.set noreorder
.ent main

main:
/* lw	register_destination, RAM_source */
/* sw	register_source, RAM_destination */
/* this code blocks sets up the ability to print, do not alter it */
ADDIU $v0, $zero,1     /* ADDIU -- Add immediate unsigned (no overflow) */
LA $t0, __XC_UART
SW $v0, 0($t0)
LA $t0, U1MODE
LW $v0, 0($t0)
ORI $v0, $v0,0b1000     /* Bitwise ors a register and an immediate value and stores the result in a register */
SW $v0, 0($t0)
LA $t0, U1BRG
ADDIU $v0, $zero, 12
SW $v0, 0($t0)

/* copy RAM address of var1 (presumably a label defined in the program) into register $t0 */
LA $a0,HelloWorld
JAL puts
NOP

/* (Input) */ 
/* Set input 0-7 registers to 1, 1111111 = 255 = 0xFF */
/* TRISECLR & PORTECLR = 255 = 0xFF */
LW $t8, input
ANDI $t1, $t1, 0 /*clear temp register $t1 */
ADD $t1, $t1, $t8 /*add 11111111 to $t1 */
SW $t1, TRISECLR
SW $t1, PORTECLR
ANDI $t1, $t1, 0
ADD $t1, $t1, $t8
SW $t1, PORTESET

/* set TRISD */
ADD $t1, $t1, $t8
SW $t1, TRISDSET

/* Clear $t8 for later */
ANDI $t8, $t8, 0


/*
(lw  register_destination, RAM_source) 
 1111 1111(255) : LED1-LED8
 0000 0001(1)   : LED1
 0000 1111(15)  : LED1-LED4
 1111 0000(240) : LED5-LED8
 */

loop:
LW $t6, PORTD
LW $t4, PORTF

/* Switches (1-4) */
/* Get bits 8, 9, 10, 11 from PORTD by shifting right by 8 */
/* shift to the right by 8 to get to the first 4 leds*/
SRL $t3, $t6, 8        
ANDI $t5, $t3, 15      /* 0000 1111 (LED1-LED4)*/
SW $t5, PORTESET       /* store addrss of PORTE in the shifted reg*/

/* Button (1) */
/* Button 1, PORTF */
/* Shift 3 to left to get the position of button 1 */
/* immediate store the binary string, the 1 in the string represnets button1, LED5 */
SLL $t0, $t4, 0b00000011   
ANDI $t2, $t0, 0b00010000  
SW $t2, PORTE	      /* Save address of PORTE (shifted register)*/

/* Buttons (2-4) */
/* Add remaining binary strings to PORTD, LED6-LED8 */
/* Save address of PORTE into $t8 */
ANDI $t8, $t6, 0b11100000  
SW $t8, PORTESET           

/* Jump back to loop */ 
J loop                  
NOP

/* unconditional jump to program label target */
hmm:    J hmm         
NOP
endProgram:
J endProgram
NOP
.end main

.data
HelloWorld: .asciiz "Uno32 connected!!\n"
input:      .word   0xFF /* 255 */ 
