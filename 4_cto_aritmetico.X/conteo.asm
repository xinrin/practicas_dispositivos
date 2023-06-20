;PROGRAMA PARA MOSTRAR EN UN EXHIBIDOR DE 7 SEGMENTOS
; CATODO COMUN, LOS NUMEROS DE 2 BITS 
 ; 7 6 5 4 3 2 1 0
 ; - g f e d c b a 
; ALUMNO: SERRANO G MEZ MARIO ALBERTO
    

; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

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
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

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
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)
    
  ;ALU 
  
  ;CONSTANTES Y REGISTROS
  
#DEFINE CERO B'00111111'
#DEFINE UNO B'00000110'
#DEFINE DOS B'01011011'
#DEFINE TRES B'01001111'
#DEFINE CUATRO B'1100110'
#DEFINE CINCO B'1101101'
#DEFINE SEIS B'1111101'
#DEFINE SIETE B'1000111'
#DEFINE OCHO B'1111111'
#DEFINE NUEVE B'1100111'

#DEFINE	    OPX .1
#DEFINE	    OPY .0
    
#DEFINE SW0 PORTA,0
#DEFINE SW1 PORTA,1

    ORG .0
  
    GOTO CONFIGURA
  
 TABLA
    ADDWF PCL,F
    RETLW CERO
    RETLW UNO
    RETLW DOS
    RETLW TRES
    RETLW CUATRO
    RETLW CINCO
    RETLW SEIS
    RETLW SIETE
    RETLW OCHO
    RETLW NUEVE
 
CONFIGURA 
  MOVLW	    .15
  MOVWF	    ADCON1
  MOVLW	    .7
  MOVWF	    CMCON
  
  MOVLW	    B'11111111'
  MOVWF	    TRISA
CLRF LATD
CLRF TRISD
 
PROGRAMA
	MOVFF	    PORTA,OPY	;PORTA=OPY
	MOVLW	    B'00001100'	
	ANDWF	    OPY,F		;MASCARA1
	
	
	RRNCF	    OPY,F		;Y=00000110
	RRNCF	    OPY,F		;Y=00000011
	
	MOVFF	    PORTA,OPX	;PORTA=OPX
	MOVLW	    B'00110000'	
	ANDWF	    OPX,F		;MASCARA2
	
					
	     	;X=00110000
	RRNCF	    OPX,F		;X=00011000
	RRNCF	    OPX,F		;X=00001100
	RRNCF	    OPX,F		;X=00000110
	RRNCF	    OPX,F		;X=00000011

BTFSS	    SW1    ;SW2, ¿VALES 1? 
	GOTO	    SW0_0   ;NO
	GOTO	    SW0_1   ;SI
SW0_0
	BTFSS	    SW0	    ;SW1_0 ¿VALES 1?
	GOTO	    SUMA  ;VALGO 0
	GOTO	    RESTA  ;VALGO 1
SW0_1
	BTFSS	    SW0     ;SW1_1 ¿VALES 1?
	GOTO	    MULT  ;VALGO 0
	GOTO	    XXX  ;VALGO 1

SUMA
	MOVF	    OPY,W		
	ADDWF	    OPX,W
	
	GOTO	    DECOFICIFA	
RESTA
	
	
MOVF	    OPY,W		; W = COPY, mover el valor de COPY a W
SUBWF	    OPX,W          ; realizar la resta de OPX y W, que es COPY
BTFSC       STATUS, C      ; verificar si el resultado es negativo
GOTO        DECOFICIFA        ; saltar a NEGATIVO si es negativo
GOTO        NEGATIVO        ; saltar a POSITIVO si es positivo
	
	

MULT
	MOVF	    OPY,W
	MULWF	    OPX
	GOTO	    DECOFICIFAMUL

XXX
	CLRF LATD
	
	
DECOFICIFA
	RLNCF WREG,W
	CALL TABLA 
	MOVWF LATD
	GOTO PROGRAMA

	
DECOFICIFAMUL
	RLNCF PRODL,W
	CALL TABLA 
	MOVWF LATD
	GOTO PROGRAMA
NEGATIVO
	
	BSF LATD,7
	NEGF WREG
        GOTO DECOFICIFA


     
	END
	


