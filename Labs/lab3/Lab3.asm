; James Vrionis
; Lab 3 Decimal to 2's Complement Conversion Program
; M,W 9-11
; Section 1A
;

;--------- Start program at x3000
	.ORIG	x3000
	
;------- Load Effective Address GREET into R0
	LEA R0, GREET    ;Prints Greet Message
	PUTS             ;Print to console 

START ; Load Effective Address USRIN (user input) into R0
	LEA R0, USRIN    ;Take input from user
	PUTS             
	
;---------------------Clearing Register
	AND R0, R0, 0 ; I/O STEAM
	AND R1, R1, 0 ; INT
	AND R2, R2, 0 ; FLAG
	AND R3, R3, 0 ; temp
	AND R4, R4, 0 ; temp
	AND R5, R5, 0 ; Mask
	AND R6, R6, 0 ; Counter, Kill
	AND R7, R7, 0 ; JSR 

;--------------------- Input 
READ
	GETC              ;x20 Read single char no echo 
	OUT               ;Output a character to console
	LD R6, KILL       ;Load terminating statement into R6
	ADD R3, R0, R6    ;Check contents of R3 and R6
	BRnp MAINPROGRAM  ;Valid Input -> Run
	LEA R0, QUIT      ;LOAD EXIT MESSAGE onto screen
	PUTS              ;Display Exit string to console
	HALT              ;End of Program 

;-------------------- Beginning Program
MAINPROGRAM
	ADD R3, R0, -10  ;Newlines
	BRz TWOSCOMP     ;Branch if zero condition
	LD R6, NEG       ;Gets the '-' sign
	ADD R3, R0, R6   ;Set R6 = R3  
	BRz FLAG1        ;Will add 1 to R2  
	LD R6, ZRO       ;Load '0' = (-)48 into 
	ADD R0, R0, R6   ;Set R6 = R0, take away 48, when no '-' is present
	JSR SUBROUT      ;Go to SUBROUT
	ADD R1, R1, R0   ;Set R0 = R1 
	BR  READ         ;Back to Read

;-------------------- Error Check 	
FLAG1
	ADD R2, R2, 1 ;Compare with 1
	BR READ       ;Back to READ

;-------------------- 2SC 
TWOSCOMP
	ADD R2, R2, -1 ;Check R2-1 is Negative
	BRn BINARYOP   ;If NOT 1
	NOT R1, R1     ;Invert R1
	ADD R1, R1, 1  ;Add 1 to R1

;-------------------- Make Binary  	
BINARYOP
	LEA R0, CONVERT ;Convert Dec -> Bin
	PUTS            ;Print it to screen    
	BR BINARYC      ;Loop back to Binaryc

;-------------------- From JSR 
SUBROUT
	ADD R3, R1, 0   ;0+R1 && 0+R3
	AND R6, R6, 0   ;Clear R6 and make it Counter
	ADD R6, R6, 9   ;Loop 10 times, make R6

;-------------------- MULTIPLY 
MULT
	BRz RETURN       
	ADD R1, R1, R3  ;R1*10 + R3
	ADD R6, R6, -1  ;Take away one from R6
	BR MULT         ;Keep mult until finished

;-------------------- Load MASK  
BINARYC
	LEA R4, MASK     ;Load mask into R4
	AND R2, R2, 0    ;Check if R2 && R2 = 0 
	ADD R2, R2, 15   ;First Mask Address, Count = 15
	LD R5, TWOZRO    ;Zeros for Mask

;-------------------- Make MASK
MAKEMASK
	BRn END          ;Check if Count is less 0 
	LDR R3, R4, 0	 ;Put value of Mask into R3 
	AND R0, R1, R3   ;Check all 16 for a match 
	BRz DISPLAY      ;Display if Zero
	AND R0, R0, 0    ;Set to 0
	ADD R0, R0, 1    ;Set to 1

;-------------------- Print Out
DISPLAY              
	ADD R0, R0, R5   ;Output and add a new bit 
	OUT              ;Print to Console
	ADD R4, R4, 1    ;Store next Mask
	ADD R2, R2, -1   ;Mask-1 to check
	BR MAKEMASK      ;Continue

;-------------------- Back to MAINPROGRAM
RETURN
	RET              ;Return to one instruction after JSR

;-------------------- END -> START
END 
	BR START         ;Continue Back to Start
	
HALT                 ;End of Program 


;-------------------- .FILLS	
	ZRO	.FILL #-48      ; '0'
	TWOZRO	.FILL #48   ; '0'
	NEG	.FILL #-45      ; '-'
	KILL	.FILL #-120 ; 'x'	

;-------------------- String Variables
	GREET	.STRINGZ "Welcome to the conversion program\n"
	USRIN	.STRINGZ "\nEnter a decimal number or x to quit:\n"
	CONVERT	.STRINGZ "\n---Decimal to Binary---\n"
	QUIT	.STRINGZ "\nBYE! BYE HAVE A GREAT DAY!\n"

;--------------------- Memory loc's   
MASK	.FILL	x8000
	.FILL	x4000
	.FILL	x2000
	.FILL	x1000
	.FILL	x0800
	.FILL	x0400
	.FILL	x0200
	.FILL	x0100
	.FILL	x0080
	.FILL	x0040
	.FILL	x0020
	.FILL	x0010
	.FILL	x0008
	.FILL	x0004
	.FILL	x0002
	.FILL	x0001
;---------------------------------------- 

.END