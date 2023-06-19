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

    ;2 botones uno enciende y el otro apaga

  CBLOCK	.0
  CONTEO
  CONTEO2
ENDC
  
#DEFINE	BOTON_ON    PORTE,0
#DEFINE	BOTON_OFF   PORTE,1
#DEFINE	LED	    PORTB,6
  
  ORG	.0
  GOTO	INICIO

RETARDO_10ms
  NOP
  NOP
  NOP
  MOVLW	    .10		;1CM ES M
  MOVWF	    CONTEO2	;1CM
  GOTO	    RETARDO_1ms	;2CM
  
RETARDO_1ms
  MOVLW	    .133	;M*1CM ES K
  MOVWF	    CONTEO	;M*1CM
  
REPETICION
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  NOP			;K*M*1CM
  DECFSZ    CONTEO,F	;(K-1)*M*1CM (NO) + M*2CM (SI)
  GOTO	    REPETICION	;(K-1)*M*2CM
  DECFSZ    CONTEO2,F	;(M-1)*1CM (NO) + 2CM (SI)
  GOTO	    RETARDO_1ms	;(M-1)*2CM
  RETURN		;2CM
  
INICIO
  CLRF	    PORTE
  MOVLW	    B'00000011'	;RE1 ES APAGADO Y RE2 ES ENCENDIDO, AMBAS ENTRADAS
  MOVWF	    TRISE
  MOVLW	    .15
  MOVWF	    ADCON1
  CLRF	    PORTB
  CLRF	    TRISB
  MOVLW	    B'01110000'
  MOVWF	    OSCCON	;FRECUENCIA 8MHz
  
PREGUNTA
  BTFSC	    BOTON_ON	;¿YA TE PRESIONARON?¿VALES 0? RESISTOR PULL UP
  GOTO	    PREGUNTA2	;NO
OTRA
  CALL	    RETARDO_10ms;ESPERO A QUE TERMINE EL REBOTE
  BTFSS	    BOTON_ON	;PREGUNTO SI YA SE ESTABILIZO 
			;¿TE SOLTARON?¿VALES 1?
  GOTO	    OTRA	;NO
  GOTO	    ON		;SI
  
PREGUNTA2
  BTFSS	    BOTON_OFF	;¿YA TE PRESIONARON?¿VALES 1? RESISTOR PULL DOWN
  GOTO	    PREGUNTA	;NO
OTRA2
  CALL	    RETARDO_10ms;ESPERO A QUE TERMINE EL REBOTE
  BTFSC	    BOTON_OFF	;PREGUNTO SI YA SE ESTABILIZO 
			;¿TE SOLTARON?¿VALES 0?
  GOTO	    OTRA2	;NO
  GOTO	    OFF		;SI
  
ON
  BSF	    LED
  GOTO	    PREGUNTA
  
OFF
  BCF	    LED
  GOTO	    PREGUNTA
  END

