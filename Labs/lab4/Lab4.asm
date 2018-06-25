; James Vrionis
; JVrionis
; Lab4
; Section 1A

;---------------------------------------------------------------------	

	.ORIG x3000
	GREET	.STRINGZ "Welcome to my Caesar CIPHRer!\n"
	CIPHR	.STRINGZ "\nWhat is your CIPHRer(1-25)?\n"
	STRSZ	.STRINGZ "What is the string(up to 200 characters)?\n"
	CHOICE	.STRINGZ "Would you to like (E)ncrypt, (D)ecrypt, or e(X)it?\n"
	NEWLINE	.STRINGZ "\n"
	STREXIT	.STRINGZ "\nGOODBYE!\n"
	ANSWER	.STRINGZ "\n Here is your string and the decrypted result\n"
	LEA R0, GREET
	PUTS
;---------------------------------------------------------------------	

START	
	AND R1, R1, 0	;storing INT here
	AND R2, R2, 0	;storing COUNT
	AND R3, R3, 0	;ASCII value of INT offset
	AND R4, R4, 0	;ASCII offset of hyphen
	AND R5, R5, 0	;trash register
	AND R6, R6, 0	;flag
	AND R7, R7, 0	;JSR Dependent 

	LEA R0, CHOICE  ;(E)ncrypt, (D)ecrypt, or e(X)it?
	PUTS

	GETC		;Wait for input from CHOICE
	OUT
	LD R5, KILL	;Load terminating character.. 'X' 
	ADD R1, R0, R5 	;Add -88 to input. if 0 exit
	BRz EXIT	;Go to EXIT

;- Encrypt or Decrypt ------------------------------------------------
	LD R5, E	;Check if usr wants to Encrypt
	ADD R1, R0, R5	;Add -69 to input
	BRz CIPHRER	;Ask for Cipher value (1-25)

;---------------------------------------------------------------------
	LD R5, D	;D is Decryption 
	ADD R1, R0, R5	;Add -68 to input 
	BRnp START	;Jump back to Start input not valid 

;---------------------------------------------------------------------

;---------------------------------------------------------------------
FlagDE	
	ADD R6, R6, #1	;1 is Decrypt and 0 is Encrypt
	ST R6, FLAG	;Flag==1 || FLag ==0  
	AND R6,R6, 0    ;Encrypt
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
CIPHRER 
	LEA R0, CIPHR	; ASK THE USER FOR WHICH VALUE THEY WANT FOR CIPHRER
	PUTS			; PRINT OUT STRING
;---------------------------------------------------------------------

;---------------------------------------------------------------------
INPUT	
	GETC			;Get input then loop if value is greater than 9
	OUT
	
	LD R5, LF		;Load value -10 i.e Return 
	ADD R1, R0, R5		;Did usr hit Return?
	BRz SETDECRYPT		;Yes, Jump to Decrypt
	
	LD R5, NINE		;Otherwise check if value is less than 9
	ADD R1, R0, R5		;Did user hit Return?
	BRp START	
	
	LD R5, NUMZERO		;Is value greater than or equal to 0
	ADD R1, R0, R5	
	BRn START		;Go back to start if False
	ADD R4, R1,#-1		;Flag
	AND R6, R6,#0	
;---------------------------------------------------------------------

;---------------------------------------------------------------------
MULT	
	ADD R6, R6,R3		;Value*10
	ADD R2,R2,#-1		;R2 = R2 -1
	BRp MULT		;Continue if R2 > 0

	ADD R3, R6, R4		;Add the next number 
	ADD R5, R3, #0
	ST R5, INT		;Store value into INT
	AND R2, R2, #0	
	ADD R2, R2, #10
	BRnzp INPUT		;Back to INPUT
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
SETDECRYPT	
	LEA R0, STRSZ		;Load Effective Address 'String size' to R0 
	PUTS
	
	AND R1, R1, #0 		;Clear Registers 
	AND R2, R2, #0
	AND R3, R3, #0	
	AND R4, R4, #0 
	AND R5, R5, #0
	AND R6, R6, #0
	LD R4, ARRYSIZE 	;2x200 is size of Array 
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
GETSTRING	
	GETC			;Wait for input
	OUT			;Print input to terminal
	LD R5, LF		;Load enter
	ADD R2,R0,R5		;Check if input - LF = 0 
	BRz CHECK		;if 0 jump to check
	
	ADD R5,R0,0		;R5 = R0
	LEA R0, ARRAY		;Load Array to R0
	ADD R6,R0,R1		;R6=R0+R1 (index of array)
	STR R5,R6,0		;Store R5 <- R6
	ADD R1,R1,1         	;R1 = R1+1
	ADD R4,R4,-1		;R4 = R4-1
	BRp GETSTRING		;Get rest of the String, until we reach LF
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
CHECK	
	LEA R0, ARRAY		;Load Array into R0
	LD R5, INT		;Load Int into R56=
	AND R1,R1,0		;Clear R1
	AND R3, R3,0		;Clear R3
	AND R4, R4,0		;Clear R4
	AND R6,R6,0		;Clear R6
	LD R2, FLAG		;Decrypt == 1 || Encrypt == 0 
	ADD R2, R2, 0		;Branch check 
	BRz ENCRYPT		;Go to ENCRYPT if R2 = 0
;---------------------------------------------------------------------

;---------------------------------------------------------------------
DECRYPT 
	JSR DECRYPT1		;Jump to DECRYPT1
	BRnzp RESULT		;Print Result
;---------------------------------------------------------------------

;---------------------------------------------------------------------
ENCRYPT 
	JSR ENCRYPT1		;Jump to ENCRYPT1 
;---------------------------------------------------------------------

;---------------------------------------------------------------------
RESULT
	LEA R0,ANSWER		;Print out Result 
	PUTS
	JSR PRINT		;Jump to subroutine PRINT
	LD R0, INT		;Load R0 <- INT
	BRnzp START		;GO back to START (Unconditionally)
;---------------------------------------------------------------------

;---------------------------------------------------------------------
ENCRYPT1			;From JSR ENCRYPT1
	ADD R2,R0,R3		
	LD R4, ARRYSIZE		;Load R4 <- size of array 
	ADD R1,R2,R4		;Add size of Array to R1
	LDR R6,R2,0		;Get the char
	BRz DONE		;Go to RESULT if 0
	LD R4, A		;Load R4 <- A 
	ADD R4,R6,R4		;R4= R6+R4 , which makes char > A
	BRn SAVE		;if 0 save Encryption
	LD R4, Z		;Load R4 <- Z
	ADD R4,R6,R4		;R4= R6+R4 , which makes char > Z
	BRnz MAKECAP
	LD R4,a			;Load R4 <- a
	ADD R4,R6,R4		;a  < char 
	BRn SAVE		;Save if negative 
	LD R4,z			;;Load R4 <- z
	ADD R4,R6,R4		;z  < char 
	BRnz LOWERCASE		;Make lower-case 
	BRp SAVE		;Otherwise save
;---------------------------------------------------------------------

;---------------------------------------------------------------------
MAKECAP
	ADD R6,R6,R5	;Add offset, R6=R6+R5
	LD R4,Z		;Load R4 <-Z
	ADD R4,R6,R4	;R4 = R6+R4
	BRnz SAVE       ;Neg/Zero -> Save
	LD R4,NTWTYSIX	;Otherwise Load R4 <- (-26)
	ADD R6,R6,R4	;Add offset (-26)
	BRnzp SAVE		;Save capitol value
;---------------------------------------------------------------------

;---------------------------------------------------------------------
LOWERCASE
	ADD R6,R6,R5	;Add offset, R6=R6+R5
	LD R4, z 	;Load R4 <-z
	ADD R4,R6,R4	;R4 = R6+R4
	BRnz SAVE	;Neg/Zero -> Save
	LD R4, NTWTYSIX		;Otherwise Load R4 <- (-26)
	ADD R6,R6,R4	;Add offset (-26)
;---------------------------------------------------------------------

;---------------------------------------------------------------------
SAVE
	STR R6,R1,0		;Save R6 <- R1 
	ADD R3,R3,1		;Counter
	BRnzp ENCRYPT1	;Go to ENCRYPTION
;---------------------------------------------------------------------

;---------------------------------------------------------------------
DONE	
	RET		;Return when DONE
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
DECRYPT1
	ADD R2,R0,R3	;Counter
	LD R4, ARRYSIZE	;Load R4 <- size of array 
	ADD R1,R2,R4	;Add size of Array to R1
	LDR R6,R2,0		;Get the char
	BRz RETURNDECRYPT	; Go to RET for DECRYPTION if = 0 
	LD R4, A	; Load R4 <- A
	ADD R4,R6,R4	;R4= R6+R4 , which makes char > A
	BRn STDECRYPT	;If == 0 go to STDECRYPT
	LD R4, Z	;Load R4 <- Z
	ADD R4,R6,R4	;R4= R6+R4 , which makes char > Z
	BRnz MAKECAPD	;If Neg/Zero go to MAKECAPD 
	LD R4, a	;Load R4 <- a
	ADD R4,R6,R4	;a  < char
	BRn STDECRYPT	; If neg save
	LD R4, z	; Load R4 <- z 
	ADD R4,R6,R4	;z < char
	BRnz LOWERCASED	;If Neg/Zero go to LOWERCASED
	BRp STDECRYPT	;If Positive go to STDECRYPT
;---------------------------------------------------------------------

;---------------------------------------------------------------------
MAKECAPD
	NOT R4,R5	;R4 = !R5 
	ADD R4,R4,1	;R4 = R4+1
	ADD R6,R6,R4	;R6 = R6+R4 offset
	LD R4, A	;Load R4 <- A
	ADD R4,R6,R4	;R4 = R6+R4 offset
	LD R4,TWTYSIX	;Load R4 <- 26
	ADD R6,R6,R4	;R6 = R6+R4
	BRnzp STDECRYPT ; Go to STDECRYPT (unconditionally) 
;---------------------------------------------------------------------

;---------------------------------------------------------------------
LOWERCASED
	NOT R4, R5		;R4 = !R5 
	ADD R4,R4,1		;R4 = R4+1
	ADD R6,R6,R4	;R6 = R6+R4 offset
	LD R4, a	;Load R4 <- a
	ADD R4,R6,R4	;R4 = R6+R4 offset
	BRzp STDECRYPT	; if Zero/Pos go to STDECRYPT
	LD R4, TWTYSIX		;Load R4 <- 26 
	ADD R6,R6,R4		;R6 = R6+R4
;---------------------------------------------------------------------

;---------------------------------------------------------------------
STDECRYPT
	STR R6,R1,0		;Store into Array 
	ADD R3,R3,1		;Count
	BRnzp DECRYPT1 ; jump to DECRYPT1 (unconditionally) 
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
RETURNDECRYPT 			;If done go to Load A <- R4 
	RET		
;---------------------------------------------------------------------


;- Print subroutine --------------------------------------------------
PRINT	
	LEA R0, ARRAY		;Load Effective Address of Array into R0
	PUTS
	LEA R0, NEWLINE		;Load Newline -> R0 
	PUTS
	LEA R0, ARRAY		;Load (LEA) other part of array
	LD R4, ARRYSIZE		;Set size to 200
	ADD R0,R0,R4 		;R0 = R0+R4
	PUTS
	LEA R0,NEWLINE		;Load Newline -> R0 
	PUTS
	BRnzp START     	;Back to START
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
EXIT	
	LEA R0, STREXIT ;Print goodbye if input equals to X 
	PUTS         
	HALT		 ;End of Program
;---------------------------------------------------------------------

;- VARIABLES ---------------------------------------------------------
KILL	.FILL -88 		;-(X), checks if user wants to exit
NUMZERO	.FILL -47		;Negative of '0'
ARRYSIZE	.FILL #200	;200
NINE	.FILL -57		;Neg of ASCII value of 9
INT 	.FILL X0000     ;Shift number
FLAG	.FILL 0         ;Flag 
A	.FILL -65           ;-A, neg of ASCII value
Z	.FILL -90			;-Z, neg of ASCII value
E	.FILL -69 			;-E, This checks if user wants Encryption 
a	.FILL -97			;-a on ASCII table
z	.FILL -122			;-z on ASCII table
TWTYSIX	.FILL #26
NTWTYSIX	.FILL #-26  
D	.FILL -68 			;-D, This checks if user wants Decryption 
LF	.FILL -10			;-(New Line Feed)
ARRAY 	.BLKW 400 		;Location of the Array in Memory

	.END 

;---------------------------------------------------------------------




