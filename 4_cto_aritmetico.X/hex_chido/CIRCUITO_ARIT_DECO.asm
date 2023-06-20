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
  
  #DEFINE DATOA   .0
  #DEFINE DATOB   .1
  #DEFINE MINUENDO .2
  #DEFINE SUSTRAENDO .4
  #DEFINE DIFERENCIA .6
  #DEFINE SIGNO	.8
  #DEFINE SWA_5	  PORTA,RA5
  #DEFINE SWA_4	  PORTA,RA4
		    ; -gfedcba
  #DEFINE CERO	    B'00111111'
  #DEFINE UNO	    B'00000110'
  #DEFINE DOS	    B'01011011'
  #DEFINE TRES	    B'01001111'
  #DEFINE CUATRO    B'01100110'
  #DEFINE CINCO	    B'01101101'
  #DEFINE SEIS	    B'01111101'
  #DEFINE SIETE	    B'00000111'
  #DEFINE OCHO	    B'01111111'
  #DEFINE NUEVE	    B'01101111'
  #DEFINE SIGNO_NEGATIVO   B'10000000' ; Valor para mostrar el signo negativo en el display de 7 segmentos
  
  
  
  ;INICIO
    ORG	.0
    GOTO INICIO

TABLA	ADDWF	PCL,F
	RETLW	CERO
	RETLW	UNO
	RETLW	DOS 
	RETLW	TRES
	RETLW	CUATRO
	RETLW	CINCO
	RETLW	SEIS
	RETLW	SIETE 
	RETLW	OCHO
	RETLW	NUEVE
    
INICIO	MOVLW	.7 	;W=7
	MOVWF 	CMCON	;W=CMCON=7 Y EL COMPARADOR DE VOLTAJES
					;SE APAGA
	MOVLW	.15		;W=15
	MOVWF	ADCON1	;W=ADCON1=15 LAS ENTRDAS DE LOS PORTS
					;A,B,E SON DIGITALES
	MOVLW	B'01111111'	; W = 127
	MOVWF 	TRISA,0		; W=TRISA= 127 PUERTOA TIENE SEEE EEEE
	CLRF	WREG,0		;LIMPIAR A W=0
	CLRF 	PORTA,0		; LOS PUERTOS DE E / S SE LIMPIAN
	CLRF	TRISB,0		;PB ES SALIDA
	CLRF	LATB,0
	CLRF    LATD,0
	CLRF    TRISD,0		;Para la salida del SIGNO
	
MAIN
	CLRF    LATD,0
	
	;MASCARA R3, R2 
	MOVFF	PORTA,DATOA  	;PA=DATOA
	MOVLW	B'00001100'	;LOS BITS DE R3 Y R2 SON LAS ENTRADAS DE A
	ANDWF	DATOA,F		;DATOA TENDRA SOLO EL VALOR EN LOS BITS
				;DE R3 Y R2
					
	; MASCARA R1, R0
	MOVFF	PORTA,DATOB	;PA = DATOB
	MOVLW	B'00000011'	;LOS BITS DE R1 Y R0
	ANDWF	DATOB,F	;
	
	; ROTAREMOS R3, R2 = B'00001100' A LOS VALORES EN D'  2 Y 1' = B'00000011'
	RRNCF	DATOA,F 	;ROTAMOS A B'00000100'
	RRNCF	DATOA,F		;ROTAMOS A B'00000010'
	
SWA5
	BTFSC SWA_5 ;SWA5,  Vales 0?
	GOTO SWA4 ;No vale 1
	GOTO SWA4_1 ;Si
SWA4
	BTFSC SWA_4 ;SW4,  Vales 0?
	GOTO SWA5 ;No vale 1
	GOTO MULT ;Si
SWA4_1 
	BTFSC SWA_4 ;SW4,  Vales 0? 
	GOTO RESTA ;No vale 1
	GOTO SUMA ;Si


SUMA 
	MOVF	DATOA,W	    ;MANDAMOS F A W
	ADDWF	DATOB,W	    ;SUMAMOS DATOA + DATOB
	RLNCF	WREG,W	    ;W SE HACE PAR
	CALL	TABLA	    ;DECO
	MOVWF	LATB,0		    ;EL RESULTADO ES MOSTRADO POR LATB
	GOTO	MAIN		    ;LO REGRESO A LAS OPCIONES



RESTA
	MOVF	DATOB,W	    ;MANDAMOS F A W
	SUBWF	DATOA,W	    ;RESTAMOS DATOB - DATOA
	BTFSC STATUS,N ;Evaluar NEGATIVE
	GOTO CON_SIGNO
	GOTO SIN_SIGNO
SIN_SIGNO
	MOVWF DIFERENCIA,0 ;DIREFERNECIA = W (resultado)
	MOVLW H'0';W = 0
	MOVWF SIGNO,0 ;SIGNO = W = 0
	GOTO RESULTADO
CON_SIGNO
	MOVWF DIFERENCIA ;DIREFERNECIA = W (resultado)
	COMF DIFERENCIA ;DIFERENCIA = DIFERENCIA (resultado negado)
	MOVLW B'10000000'  ;W = 1
	ADDWF DIFERENCIA	;DIFERENCIA = DIFERENCIA (resultado negado) + W (1)
	MOVLW B'10000000'  ;W = 1
	MOVWF SIGNO ;SIGNO = W = 1
	GOTO RESULTADO
RESULTADO
    MOVWF SIGNO,W   ;W=SIGNO
    MOVWF LATD    ;Mostramos el signo en LATD
    MOVF DIFERENCIA,W  ;W = DIFERENCIA (resultado)
    RLNCF WREG,W  ;W se hace par para poder sumarse al PCL
    CALL TABLA	;Llamamos a la tabla
    MOVWF LATB,0
    GOTO MAIN
	

MULT
	MOVF	DATOA,W	    ;MANDAMOS F A W
	MULWF	DATOB		    ;SE MULTIPLICA DATOA X DATOB
	MOVFF	PRODL,WREG	    ;EL RESULTADO ES MOSTRADO POR LATB
	RLNCF	WREG,W	    ;W SE HACE PAR
	CALL	TABLA	    ;LLAMAMOS A LA TABLA
	MOVWF	LATB,0	    ;EL RESULTADO ES MOSTRADO POR LATB
	GOTO	MAIN	
   



	
FIN     GOTO INICIO
	END
	


