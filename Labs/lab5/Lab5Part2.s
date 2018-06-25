/*
    James Vrionis
    Lab 5
    Part2
*/

#include <WProgram.h>
#include <xc.h>
.global main

.text
.set noreorder
.ent main
main:
    /* Same as Part 1, So we can print */
    ADDIU $v0,$zero,1 
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    
 
    LA $a0,HelloWorld
    JAL puts
    NOP

/* (Input) */ 
/* Set input 0-7 registers to 1, 1111111 = 255 = 0xFF */
/* TRISECLR & PORTECLR = 255 = 0xFF */

/* Load word at RAM address contained in input into $t8 */
 LW $t8, input  
 ANDI $t1, $t1, 0  /* Clear temp register $t1*/
 ADD $t1, $t1, $t8 /* Add 11111111 to $t1*/
 SW $t1, TRISECLR
 SW $t1, PORTECLR
 ANDI $t1, $t1, 0
 ADD $t1, $t1, $t8
 SW $t1, PORTESET

 /*set TRISD*/
 ADD $t1, $t1, $t8
 SW $t1, TRISDSET
 
/* Clear $t8 for later */
ANDI $t8, $t8, 0
 
/* Frequency (Speed) */        
LI   $a0, 0x0800

/* Switches (1-4) */
/* Get bits 8, 9, 10, 11 from PORTD by shifting right by 8 */
/* shift to the right by 8 to get to the first 4 leds*/
LW $t2,PORTD
SRL $t2,$t2,8 
ANDI $t2, $t2, 15 /* 0000 1111 (LED1-LED4), sw1-sw4 */

ADDI $t2,$t2,1
MUL $a0, $t2, $a0

/* Load values into the registers */
LW $t3, led1
LW $t8, led8
LW $t9, led1_led8

/* Shift Left */
/* Clear PORTE */
/* Set PORTE */
LtfShft:  
SW $t9, PORTECLR 
SW $t3, PORTESET 
SLL $t3,$t3,1 /* Shift to the left by 1 */

NOP 
/* end of left shift*/

/* Used later to compare in loops */  
LW $t7, zero

/* i=0 && i < sppedDelay then increment i */
/* if a0 == t7, if equals 0, go to finish delay, else proceed, exit foor loop */
MyDelay:
BEQ $a0, $t7, MyDelay_end 
ADDI $t7, $t7, 1 /* otherwise increment */
B MyDelay /* i != MyDelay keep looping */
NOP 
/* end of MyDelay */

/* MyDelay_end starts, that will be the end of 'delay' */
/* if t3 != t8 (go back to left shift) , shifted t3 != 1000 0000 (start Right Shift)  */
MyDelay_end:    
BNE $t3,$t8,LtfShft 
NOP 
/*end of MYDELAY_end*/

/* Load 0000 0001 into t8 for comparison */
/* Used later to compare in loops */ 
LW $t8,led1 

/* Right Shift */  
/* When t3 == 1000 0000, then led8 is on (shift to right) */
/* clear PORTE*/
/* set PORTE*/
RitShft:
SW $t9, PORTECLR 
SW $t3, PORTESET 
SRL $t3,$t3,1 /* Shift to the right by 1 */
     
NOP 
/* End of Right Shift */

/* Used later to compare in loops */ 
LW $t7, zero
    
/* i=0 && i < frequency_Delay then increment i */
/* if a0 == t7, if equals 0, go to finish delay, else proceed, exit foor loop */
MyDelay2:
BEQ $a0, $t7, MyDelay2_end 
ADDI $t7, $t7, 1 /* otherwise increment*/
B MyDelay2 /* i != MyDelay keep looping */
NOP 
/*end of MyDelay2*/

/* if t3 != t8 (go back to left shift) , shifted t3 != 0000 0001 (start Right Shift)  */
MyDelay2_end:    
BNE $t3,$t8,RitShft 
NOP 
/*end of MyDelay2_end*/

    
.end main
    
 .data
HelloWorld: .asciiz "Uno32 connection is succefful!!\n"
input:      .word   0xFF
led1:       .word   0b00000001
led8:       .word   0b10000000
led1_led8:  .word   0b11111111
zero:       .word   0
