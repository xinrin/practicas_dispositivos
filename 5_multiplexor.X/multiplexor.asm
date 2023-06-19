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
    
    #DEFINE CERO   B'00111111'
    #DEFINE UNO    B'00000110'
    #DEFINE DOS    B'01011011'
    #DEFINE TRES   B'01001111'
    #DEFINE CUATRO B'01100110'
    #DEFINE CINCO  B'01101101'
    #DEFINE SEIS   B'01111101'
    #DEFINE SIETE  B'01000111'
    #DEFINE OCHO   B'01111111'
    #DEFINE NUEVE  B'01100111'
    #DEFINE DIEZ   B'01110111'
    #DEFINE DOCE   B'00111001'
    #DEFINE CATORCE  B'01111001'
    
    #DEFINE DATOA B'00000111'
    #DEFINE BOTONA PORTA,RA2 ;Pausa
    #DEFINE BOTONB PORTA,RA1 ;Reset
    #DEFINE BOTONC PORTA,RA0 ;Par o impar
  
 CBLOCK	.12
    I
    J
 ENDC
     
    ORG	.0  ;DIREC DE LA MEM PROG DONDE SE ESCRIBE 
	    ;LA PRIMER INSTRUCCION
BRA SETTINGS
    	    
DELAY_100mS ;Espera de 100 mili segundos
    MOVLW   .1000	;1CM Movemos 64 a W
    MOVWF   J	;1CM Guardamos W en nuestro registro VAL
DELAY_1mS
    MOVLW   .81	;M(1CM)
    MOVWF   I	;M(1 CM)
    NOP		;M(1CM)
OTRA
    DECFSZ  I,F	;Decrementamos F hasta que sea 0 
                ;OCUPAMOS F PARA GUARDAR EN EL MISMO REGISTRO
    GOTO    OTRA;Vamos hasta otra
    DECFSZ  J,F	;Decrementamos F hasta que Sea 0
    GOTO    DELAY_1mS;(2CM(M-1))
    RETURN	;2CM   
    
PAUSA
    BTFSS BOTONA ;Esta en pausa ?
    RETURN ;No
    GOTO PAUSA; Si
    
SETTINGS
    CLRF PORTA
    SETF TRISA ;Abrimos todos los puertos
    MOVLW .15
    MOVWF ADCON1    ;Digitalizamos
    MOVLW .7	   
    CLRF  TRISB      
    CLRF  LATB    
    CLRF  WREG
    
MAIN
    BTFSS BOTONC ;BOTONC ES 1?
    GOTO PARES;No
    GOTO IMPARES;Si
    
IMPARES
    BTFSS BOTONC ;BOTONC ES 1?
    GOTO PARES;No
    GOTO UNO_2;Si
    
PARES
    BTFSS BOTONC ;BOTONC ES 1?
    GOTO CATORCE_1;No
    GOTO IMPARES;Si

CATORCE_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   CATORCE  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO DOCE_1 ;No
    GOTO IMPARES ;Si
    
DOCE_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   DOCE  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;ES 1?
    GOTO DIEZ_1;NO
    GOTO IMPARES;SI

DIEZ_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   DIEZ  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO OCHO_1 ;No
    GOTO IMPARES ;Si

OCHO_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   OCHO  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO SEIS_1 ;No
    GOTO IMPARES ;Si
    
SEIS_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   SEIS  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO CUATRO_1 ;No
    GOTO IMPARES ;Si
    
CUATRO_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   CUATRO  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO DOS_1 ;No
    GOTO IMPARES ;Si
    
DOS_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   DOS  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO CERO_1 ;No
    GOTO IMPARES ;Si
   
CERO_1
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   CERO  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    GOTO MAIN ;No
    
;IMPAREEEEEEEESSSSSSSSSSSSSSSSSSS
    
UNO_2
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   UNO  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO PARES ;No
    GOTO TRES_2 ;Si
    
TRES_2
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   TRES  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO PARES ;No
    GOTO CINCO_2 ;Si
    
CINCO_2
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   CINCO  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO PARES ;No
    GOTO SIETE_2 ;Si
    
SIETE_2
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   SIETE  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    BTFSS BOTONC ;Es 1?
    GOTO PARES ;No
    GOTO NUEVE_2 ;Si
    
NUEVE_2
    BTFSC BOTONA ;No esta pausado?
    CALL  PAUSA ;No
    BTFSC BOTONB ; No esta reseteado?
    GOTO PARES ;No
    MOVLW   NUEVE  ;Si
    MOVWF   LATB
    CALL    DELAY_100mS	
    CALL    DELAY_100mS
    
    GOTO MAIN
    END



