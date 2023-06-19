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
  
#DEFINE	BTN1	PORTE,0
#DEFINE	BTN2	PORTE,1
#DEFINE CERO	B'00111111'
#DEFINE UNO	B'00000110'
#DEFINE DOS	B'01011011'
#DEFINE TRES	B'01001111'
  
CBLOCK	.13
    CONT
    MAX
    LESS
    I
    J
    I2
    J2
    NO2
    NO
 ENDC

  ORG .0
  BRA SETTINGS
  
  TABLA
    ADDWF   PCL,F
    RETLW   CERO
    RETLW   UNO
    RETLW   DOS
    RETLW   TRES
    

DELAY_100MS
    MOVLW   .70	;1CM
    MOVWF   NO2	;1CM
    NOP	
OTRA4
    DECFSZ  NO2	;1CM(N-1)+2CM
    GOTO    OTRA4   ;2CM(N-1)	;1+3N=194 N=64
    MOVLW   .105    ;1CM
    MOVWF   J2	;1 CM
DELAY_1MS2
    MOVLW   .77	;M(1CM)
    MOVWF   I2	;M(1 CM)
    NOP		;M(1CM)
OTRA3
    DECFSZ  I2,F	;(1CM(K-1)+2CM)M
    BRA	    OTRA3;(2CM(K-1))M
    DECFSZ  J2,F	;(1CM(M-1)+2CM
    BRA	    DELAY_1MS2;(2CM(M-1))
    RETURN	;2CM
    
    
DELAY_10MS
    MOVLW   .11	;1CM
    MOVWF   NO	;1CM
    NOP	
OTRA2
    DECFSZ  NO	;1CM(N-1)+2CM
    GOTO    OTRA2   ;2CM(N-1)	;1+3N=194 N=64
    MOVLW   .10	;1CM
    MOVWF   J	;1 CM
DELAY_1mS
    MOVLW   .77	;M(1CM)
    MOVWF   I	;M(1 CM)
    NOP		;M(1CM)
OTRA
    DECFSZ  I,F	;(1CM(K-1)+2CM)M
    BRA	    OTRA;(2CM(K-1))M
    DECFSZ  J,F	;(1CM(M-1)+2CM
    BRA	    DELAY_1mS;(2CM(M-1))
    RETURN	;2CM 
  
SETTINGS
    CLRF    PORTE
    SETF    TRISE
    MOVLW   H'0F'
    MOVWF   ADCON1
    MOVLW   .7
    CLRF    LATB
    CLRF    TRISB
    MOVLW   .3
    MOVWF   MAX
    MOVLW   .0
    MOVWF   LESS
PONCERO
    MOVLW   .0
    MOVWF   CONT
    MOVF    CONT,W
    RLNCF   WREG,W
    CALL    TABLA
    MOVWF   LATB
    
MAIN
    MOVF    CONT,W
    RLNCF   WREG,W
    CALL    TABLA
    MOVWF   LATB
 ;   BTFSS   BTN1;TOCARON BTN1?
  ;  GOTO    MAIN
   ; GOTO    SOLTAR
    
    
PREGUNTA
  BTFSC	    BTN1 ;aumenta 1	;¿YA TE PRESIONARON?¿VALES 0? RESISTOR PULL UP
  GOTO	    PREGUNTA2	;NO
  GOTO  SOLTAR

  
PREGUNTA2
  BTFSS	    BTN2	;¿YA TE PRESIONARON?¿VALES 1? RESISTOR PULL DOWN
  GOTO	    PREGUNTA	;NO
  GOTO  SOLTAR2
  
  
SOLTAR
    CALL    DELAY_10MS
    BTFSC   BTN1;SOLTARON BTN1?
    GOTO    SOLTAR
    GOTO    INC
    
SOLTAR2
    CALL    DELAY_10MS
    BTFSS   BTN2;SOLTARON BTN2?
    GOTO    SOLTAR2
    GOTO    INC_L
INC
    MOVF    CONT,W
    CPFSEQ  MAX
    GOTO    SIGUE
    GOTO    MAIN

INC_L
    MOVLW    CONT
    CPFSEQ  .0
    GOTO    ATRAS
    GOTO    PREGUNTA
    
SIGUE

    INCF    CONT
    MOVF    CONT,W
    RLNCF   WREG,W
    CALL    TABLA
    MOVWF   LATB
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    GOTO    PREGUNTA
ATRAS
    DECF    CONT
    MOVF    CONT,W
    RLNCF   WREG,W
    CALL    TABLA
    MOVWF   LATB
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    CALL    DELAY_100MS
    GOTO    PREGUNTA

    
    END



