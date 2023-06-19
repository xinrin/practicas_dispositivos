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
  
;Display de 7 segmentos catodocomun  
#DEFINE CERO B'0111111'
#DEFINE UNO B'00000110'
#DEFINE DOS B'01011011'
#DEFINE TRES B'01001111'
#DEFINE CUATRO B'01100110'
#DEFINE CINCO B'01101101'
#DEFINE SEIS B'01111101'
#DEFINE SIETE B'01000111'
#DEFINE OCHO B'01111111'
#DEFINE NUEVE B'01100111'

  #DEFINE ENTRADAX .1
  #DEFINE ENTRADAY .0
  
  #DEFINE SW0 PORTA,0 ;Definimos a switch 0 como entrada de puerto 0
  #DEFINE SW1 PORTA,1 ;Definimos a switch 1 como entrada de puerto 0
  
  ORG .0
  
  GOTO CONFIGURAR
  
  TABLA
    ADDWF PCL,F ;PCL lee instrucciones posteriores a la actual (2)
    RETLW CERO  ;Regresamos el valor de la literal en W
    RETLW UNO
    RETLW DOS
    RETLW TRES
    RETLW CUATRO
    RETLW CINCO
    RETLW SEIS
    RETLW SIETE
    RETLW OCHO
    RETLW NUEVE
    
  CONFIGURAR
  MOVLW	    .15
  MOVWF	    ADCON1
  MOVLW	    .7
  
  MOVLW	    B'11111111'
  MOVWF	    TRISA
  CLRF LATB
  CLRF TRISB
  
  MAIN
  
  MOVFF PORTA,ENTRADAY ;NUESTRO PUERTO A ES IGUAL A LA ENTRADA Y
  MOVLW B'00001100'
  ANDWF ENTRADAY,F ;GUARDAMOS LA ENTRADA Y EN UN REGISTRO F
                   ;MACARA1
  
  RRNCF ENTRADAY,F ;Movemos hacia la derecha el valor de nuestro archivo
                   ;00000110
  RRNCF ENTRADAY,F ;Movemos hacia la derecha el valor de nuestro archivo
                   ;00000011

  MOVFF PORTA,ENTRADAX
  MOVLW B'00110000'
  ANDWF ENTRADAX,F
  
  RRNCF ENTRADAY,F ;Movemos hacia la derecha el valor de nuestro archivo
                   ;00110000
  RRNCF ENTRADAY,F ;Movemos hacia la derecha el valor de nuestro archivo
                   ;00011000
  RRNCF ENTRADAY,F ;Movemos hacia la derecha el valor de nuestro archivo
                   ;00000110
  RRNCF ENTRADAY,F ;Movemos hacia la derecha el valor de nuestro archivo
                   ;00000011
		   
  BTFSS SW1 ;Vale 1 ?
  GOTO Switch0_0 ;No
  GOTO Switch0_1 ;Si
  
  Switch0_0
  BTFSS SW0 ;Vale 1?
  GOTO SUMA ;0
  GOTO RESTA;1
  
  Switch0_1
  BTFSS SW1 ;Vale 1?
  GOTO MULTIPLIC ;0
  GOTO NAH;1
  
  SUMA ;OPERACION DE SUMA
	MOVF	    ENTRADAY,W ;Movemos Entraday a W
	ADDWF	    ENTRADAX,W ;Sumamos
	
	GOTO	   DECODIFIACION1 ;Vamos a decodificacion
	
 RESTA
 MOVF	    ENTRADAY,W ;Movemos Entraday a W		
 SUBWF	    ENTRADAX,W ;Restamos     
 BTFSC      STATUS,C ;Revisamos si tenemos carry     
 GOTO       DECODIFIACION1  ;No     
 GOTO       NEGATIVO   ;Si  
	
	

 MULTIPLIC
	MOVF	    ENTRADAY,W ;Movemos Entraday a W
	MULWF	    ENTRADAX   ;Multiplicamos
	GOTO	    DECODIFIACION2 ;vamos a deco2

 NAH ;Aqui no hacemos nada
	CLRF LATB ;LIMPIAMOS PUERTO B
	
	
 DECODIFIACION1 
	RLNCF WREG,W ;Rotamos hacia la izquierda sin carry para multiplicar por 2
	CALL TABLA  ;Llamamos a los valores de la tabla
	MOVWF LATB ;Guardamos en latb en w
	GOTO MAIN

 DECODIFIACION2 ;Para multiplicacion
	RLNCF PRODL,W ;Rotamos hacia la izquierda sin carry para multiplicar por 2
	CALL TABLA  ;Llamamos a los valores de la tabla
	MOVWF LATD  ;Guardamos en latb en w
	GOTO MAIN
	
 NEGATIVO
	BSF LATD,7 ;Creamos una salida para dar negativo
	NEGF WREG ;Volvemos el resultado en positivo
        GOTO  DECODIFIACION1 
     
	END


