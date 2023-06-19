;MULTIPLEXOR DE 8 OPERACIONES DE 2 CANTIDADES DE 2 BITS (X1, X0 y Y1, Y0)
    
    #include "p18F4450.inc"    


; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:3276?

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
?

#DEFINE	    OPX .1
#DEFINE	    OPY .0
#DEFINE SW0 PORTA,RA0
#DEFINE SW1 PORTA,RA1
#DEFINE SW2 PORTA,RA2


  
  ORG .0
  
INICIO
  MOVLW	    .15
  MOVWF	    ADCON1
  MOVLW	    .7
  
  MOVLW	    B'11111111'
  MOVWF	    TRISA
  MOVLW	    B'00000000'
  MOVWF	    TRISB	   
  
 
  CLRF	    LATB
  CLRF	    WREG
  
PROGRAMA
	MOVFF	    PORTA,OPY	;PORTA=OPY
	MOVLW	    B'00011000'	
	ANDWF	    OPY,F		;MASCARA1
	
					;Y=00011000
	RRNCF	    OPY,F		;Y=00001100
	RRNCF	    OPY,F		;Y=00000110
	RRNCF	    OPY,F		;Y=00000011
	
	MOVFF	    PORTA,OPX	;PORTA=OPX
	MOVLW	    B'01100000'	
	ANDWF	    OPX,F		;MASCARA2
	
					;X=01100000
	RRNCF	    OPX,F      	;X=00110000
	RRNCF	    OPX,F		;X=00011000
	RRNCF	    OPX,F		;X=00001100
	RRNCF	    OPX,F		;X=00000110
	RRNCF	    OPX,F		;X=00000011

	BTFSS	    SW2	    ;SW2, 풴ALES 1? 
	GOTO	    SW1_0   ;NO
	GOTO	    SW1_1   ;SI
  
SW1_0
	BTFSS	    SW1	    ;SW1_0 풴ALES 1?
	GOTO	    SW0_00  ;VALGO 0
	GOTO	    SW0_01  ;VALGO 1
SW1_1
	BTFSS	    SW1     ;SW1_1 풴ALES 1?
	GOTO	    SW0_10  ;VALGO 0
	GOTO	    SW0_11  ;VALGO 1
SW0_00
	BTFSS	    SW0	    ;SW0_00 풴ALES 1? 
	GOTO	    SUMA    ;VALGO 0	    000
	GOTO	    RESTA   ;VALGO 1	    001
SW0_01
	BTFSS	    SW0	    ;SW0_01 풴ALES 1?
	GOTO	    MULT    ;VALGO 0	    010	    
	GOTO	    AND    ;VALGO 1	    011
SW0_10
	BTFSS	    SW0	    ;SW0_10 풴ALES 1? 
	GOTO	    OR	    ;VALGO 0	    100
	GOTO	    XOR	    ;VALGO 1	    101
  
SW0_11
	BTFSS	    SW0	    ;SW0_11 풴ALES 1?
	GOTO	    NOT	    ;VALGO 0	    110	    
	GOTO	   COM2	    ;VALGO 1	    111

SUMA
	MOVF	    OPY,W		
	ADDWF	    OPX,W
	MOVWF	    LATB 
	GOTO	    PROGRAMA	
RESTA
	MOVF	    OPY,W
	SUBWF	    OPX,W
	MOVWF	    LATB 
	GOTO	    PROGRAMA	
MULT
	MOVF	    OPY,W
	MULWF	    OPX
	MOVFF	    PRODL,LATB
	GOTO	    PROGRAMA	
AND
	MOVF	    OPY,W
	ANDWF	    OPX,W
	MOVWF	    LATB 
	GOTO	    PROGRAMA
OR
	MOVF	    OPY,W
	IORWF	    OPX,W
	MOVWF	    LATB 
	GOTO	    PROGRAMA
XOR
	MOVF	    OPY,W
	XORWF	    OPX,W
	MOVWF	    LATB 
	GOTO	    PROGRAMA
NOT
	MOVF	    OPY,W
	COMF	    WREG,W
	MOVWF	    LATB 
	GOTO	    PROGRAMA
COM2
       NEGF OPY
       MOVFF OPY,LATB	            
       GOTO PROGRAMA
   
END


