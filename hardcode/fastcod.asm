!to "fastcod.prg" , CBM

fastcode = $2000



     READAST 	            = $6C ;adres aktualnie odczytywanej bitmapy obiektu
     READASTHI            = $6D
     WRITEAST	            = $6E ;adres aktualnie zapisywanego pierwszego "pionowego paska" obiektu
     WRITEASTHI           = $6F

;========
;DO DEBUGU - WEKTOR ADRESU BITMAPY ASTERA DO PRZEPISANIA NA SPRAJTA
     SPR_PLOT             = $70
     SPR_PLOTHI           = $71
;========

;***** ; 4 wektory do przepisywania danych
     VEC1                 = $72	; 5TY WIERSZ BITMAPY ZAPISYWANEJ
     VEC1HI               = $73	
     VEC2                 = $74	; 2GI WIERSZ BITMAPY ZAPISYWANEJ
     VEC2HI               = $75
     VEC3                 = $76	; 3CI WIERSZ BITMAPY ZAPISYWANEJ
     VEC3HI               = $77
     VEC4                 = $78	; 4TY WIERSZ BITMAPY ZAPISYWANEJ
     VEC4HI               = $79
;***********
     NR_OBJ               = $7A ;nr bitmapy aktualnie przepisywanej na ekran (0 do 95)

     FROM_LINE		        = $7B ; PRZEPISYWANY OBIEKT LINIA POCZATKOWA
     TO_LINE 		          = $7C ; PRZEPISYWANY OBIEKT LINIA KONCOWA
     FROM_COLUMN	        = $7D ; PRZEPISYWANY OBIEKT KOLUMNA POCZATKOWA
     TO_COLUMN 	          = $7E ; PRZEPISYWANY OBIEKT KOLUMNA KONCOWA

     VEC_SELFMOD  	      = $7F ; ADRES DO WPISANIA RTS W KODZIE NARZUCANIA LINII 
     OLD_X_POZ		        = $81
     OLD_Y_POZ		        = $82
;***** ; 3 wektory do przepisywania danych
     VEC_2 		            = $83 ; 2GI WIERSZ BITMAPY ODCZYTYWANEJ
     VEC_2HI 	            = $84 
     VEC_3 		            = $85 ; 3CI WIERSZ BITMAPY ODCZYTYWANEJ
     VEC_3HI 	            = $86
     VEC_4 		            = $87 ; 4TY WIERSZ BITMAPY ODCZYTYWANEJ
     VEC_4HI 	            = $88

     MANY_OBJ	            = $89 ; ILOSC OBIEKTOW NA EKRANIE
     ACT_OBJ		          = $8a ; AKTUALNIE OBRABIANY OBIEKT
     WAIT_IRQ	            = $8b ; OCZEKIWANIE NA RAMKE W RAZIE GDY JEST MALO OBIEKTOW
;---


*= fastcode


;==================

!byte <NARZUCAJ_Y0
!byte <NARZUCAJ_Y1
!byte <NARZUCAJ_Y2
!byte <NARZUCAJ_Y3
!byte <NARZUCAJ_Y4
!byte <NARZUCAJ_Y5
!byte <NARZUCAJ_Y6
!byte <NARZUCAJ_Y7

!byte >NARZUCAJ_Y0
!byte >NARZUCAJ_Y1
!byte >NARZUCAJ_Y2
!byte >NARZUCAJ_Y3
!byte >NARZUCAJ_Y4
!byte >NARZUCAJ_Y5
!byte >NARZUCAJ_Y6
!byte >NARZUCAJ_Y7
;===
NARZUCAJ_Y0 

          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN


          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y0,Y
          STA START_EOR_LINE_Y0
          LDA TAB_ADLINE_HI_Y0,Y
          STA START_EOR_LINE_Y0+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y0+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y0+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y

          

NARZ_BIG_Y0

          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI


          LDA WRITEAST
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          
START_EOR_LINE_Y0 = *+1
          JSR $1111



          CPX TO_COLUMN
          BCS EOF_NARZ3

          INX

          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y0

EOF_NARZ3
          LDA #$A0 ;LDA $ZZZZ,X
          LDY #$00
          STA (VEC_SELFMOD),Y
          RTS
LINE_00_Y0
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_01_Y0
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_02_Y0
          LDY #$02
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_03_Y0
          LDY #$03
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_04_Y0
          LDY #$04
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_05_Y0
          LDY #$05
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_06_Y0
          LDY #$06
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_07_Y0
          LDY #$07
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y          
+:
LINE_08_Y0
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_09_Y0
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_10_Y0
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_11_Y0
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_12_Y0
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_13_Y0
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_14_Y0
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_15_Y0
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          EOR (VEC2),Y
          STA (VEC2),Y          
+:
LINE_16_Y0
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_17_Y0
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_18_Y0
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_19_Y0
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_20_Y0
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_21_Y0
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_22_Y0
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_23_Y0
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          EOR (VEC3),Y
          STA (VEC3),Y          
+:
LINE_24_Y0
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_25_Y0
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_26_Y0
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_27_Y0
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_28_Y0
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_29_Y0
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_30_Y0
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
LINE_31_Y0
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          EOR (VEC4),Y
          STA (VEC4),Y          
+:
          RTS
LINE_32_Y0
          NOP
;---
TAB_ADLINE_LO_Y0 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y0
!byte <LINE_01_Y0
!byte <LINE_02_Y0
!byte <LINE_03_Y0
!byte <LINE_04_Y0
!byte <LINE_05_Y0
!byte <LINE_06_Y0
!byte <LINE_07_Y0
!byte <LINE_08_Y0
!byte <LINE_09_Y0
!byte <LINE_10_Y0
!byte <LINE_11_Y0
!byte <LINE_12_Y0
!byte <LINE_13_Y0
!byte <LINE_14_Y0
!byte <LINE_15_Y0
!byte <LINE_16_Y0
!byte <LINE_17_Y0
!byte <LINE_18_Y0
!byte <LINE_19_Y0
!byte <LINE_20_Y0
!byte <LINE_21_Y0
!byte <LINE_22_Y0
!byte <LINE_23_Y0
!byte <LINE_24_Y0
!byte <LINE_25_Y0
!byte <LINE_26_Y0
!byte <LINE_27_Y0
!byte <LINE_28_Y0
!byte <LINE_29_Y0
!byte <LINE_30_Y0
!byte <LINE_31_Y0
!byte <LINE_32_Y0
;---
TAB_ADLINE_HI_Y0 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y0
!byte >LINE_01_Y0
!byte >LINE_02_Y0
!byte >LINE_03_Y0
!byte >LINE_04_Y0
!byte >LINE_05_Y0
!byte >LINE_06_Y0
!byte >LINE_07_Y0
!byte >LINE_08_Y0
!byte >LINE_09_Y0
!byte >LINE_10_Y0
!byte >LINE_11_Y0
!byte >LINE_12_Y0
!byte >LINE_13_Y0
!byte >LINE_14_Y0
!byte >LINE_15_Y0
!byte >LINE_16_Y0
!byte >LINE_17_Y0
!byte >LINE_18_Y0
!byte >LINE_19_Y0
!byte >LINE_20_Y0
!byte >LINE_21_Y0
!byte >LINE_22_Y0
!byte >LINE_23_Y0
!byte >LINE_24_Y0
!byte >LINE_25_Y0
!byte >LINE_26_Y0
!byte >LINE_27_Y0
!byte >LINE_28_Y0
!byte >LINE_29_Y0
!byte >LINE_30_Y0
!byte >LINE_31_Y0
!byte >LINE_32_Y0
;LNG_NARZ_Y0 = * - NARZUCAJ_Y0
;------------------------------------
NARZUCAJ_Y1 ;WEJSCIE - X JUZ JEST SKIEROWANE NA KOLUMNE

          
          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN



          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y1,Y
          STA START_EOR_LINE_Y1
          LDA TAB_ADLINE_HI_Y1,Y
          STA START_EOR_LINE_Y1+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y1+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y1+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y1
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA READAST
          ;CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI


          LDA WRITEAST
          AND #$F8
          CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y1 = *+1
          JSR $1111



          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:          
          LDA WRITEAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y1


LINE_00_Y1          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y1          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_02_Y1          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_03_Y1          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_04_Y1          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_05_Y1          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_06_Y1          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_07_Y1          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y1          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y1          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_10_Y1          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_11_Y1          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_12_Y1          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_13_Y1          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_14_Y1          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_15_Y1          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y1          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y1          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_18_Y1          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_19_Y1          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_20_Y1          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_21_Y1          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_22_Y1          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_23_Y1          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y1          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y1          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_26_Y1          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_27_Y1          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_28_Y1          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_29_Y1          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_30_Y1          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_31_Y1          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y1
          NOP
;---
TAB_ADLINE_LO_Y1 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y1
!byte <LINE_01_Y1
!byte <LINE_02_Y1
!byte <LINE_03_Y1
!byte <LINE_04_Y1
!byte <LINE_05_Y1
!byte <LINE_06_Y1
!byte <LINE_07_Y1
!byte <LINE_08_Y1
!byte <LINE_09_Y1
!byte <LINE_10_Y1
!byte <LINE_11_Y1
!byte <LINE_12_Y1
!byte <LINE_13_Y1
!byte <LINE_14_Y1
!byte <LINE_15_Y1
!byte <LINE_16_Y1
!byte <LINE_17_Y1
!byte <LINE_18_Y1
!byte <LINE_19_Y1
!byte <LINE_20_Y1
!byte <LINE_21_Y1
!byte <LINE_22_Y1
!byte <LINE_23_Y1
!byte <LINE_24_Y1
!byte <LINE_25_Y1
!byte <LINE_26_Y1
!byte <LINE_27_Y1
!byte <LINE_28_Y1
!byte <LINE_29_Y1
!byte <LINE_30_Y1
!byte <LINE_31_Y1
!byte <LINE_32_Y1
;---
TAB_ADLINE_HI_Y1 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y1
!byte >LINE_01_Y1
!byte >LINE_02_Y1
!byte >LINE_03_Y1
!byte >LINE_04_Y1
!byte >LINE_05_Y1
!byte >LINE_06_Y1
!byte >LINE_07_Y1
!byte >LINE_08_Y1
!byte >LINE_09_Y1
!byte >LINE_10_Y1
!byte >LINE_11_Y1
!byte >LINE_12_Y1
!byte >LINE_13_Y1
!byte >LINE_14_Y1
!byte >LINE_15_Y1
!byte >LINE_16_Y1
!byte >LINE_17_Y1
!byte >LINE_18_Y1
!byte >LINE_19_Y1
!byte >LINE_20_Y1
!byte >LINE_21_Y1
!byte >LINE_22_Y1
!byte >LINE_23_Y1
!byte >LINE_24_Y1
!byte >LINE_25_Y1
!byte >LINE_26_Y1
!byte >LINE_27_Y1
!byte >LINE_28_Y1
!byte >LINE_29_Y1
!byte >LINE_30_Y1
!byte >LINE_31_Y1
!byte >LINE_32_Y1
;LNG_NARZ_Y1 = * - NARZUCAJ_Y1
;------------------------------------
NARZUCAJ_Y2 

          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN

          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y2,Y
          STA START_EOR_LINE_Y2
          LDA TAB_ADLINE_HI_Y2,Y
          STA START_EOR_LINE_Y2+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y2+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y2+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y2
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA WRITEAST
          AND #$F8
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y2 = *+1
          JSR $1111


          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y2


LINE_00_Y2          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y2          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_02_Y2          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_03_Y2          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_04_Y2          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_05_Y2          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_06_Y2          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_07_Y2          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y2          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y2          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_10_Y2          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_11_Y2          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_12_Y2          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_13_Y2          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_14_Y2          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_15_Y2          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y2          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y2          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_18_Y2          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_19_Y2          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_20_Y2          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_21_Y2          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_22_Y2          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_23_Y2          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y2          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y2          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_26_Y2          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_27_Y2          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_28_Y2          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_29_Y2          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_30_Y2          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_31_Y2          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y2          
          NOP
          

;---
TAB_ADLINE_LO_Y2 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y2
!byte <LINE_01_Y2
!byte <LINE_02_Y2
!byte <LINE_03_Y2
!byte <LINE_04_Y2
!byte <LINE_05_Y2
!byte <LINE_06_Y2
!byte <LINE_07_Y2
!byte <LINE_08_Y2
!byte <LINE_09_Y2
!byte <LINE_10_Y2
!byte <LINE_11_Y2
!byte <LINE_12_Y2
!byte <LINE_13_Y2
!byte <LINE_14_Y2
!byte <LINE_15_Y2
!byte <LINE_16_Y2
!byte <LINE_17_Y2
!byte <LINE_18_Y2
!byte <LINE_19_Y2
!byte <LINE_20_Y2
!byte <LINE_21_Y2
!byte <LINE_22_Y2
!byte <LINE_23_Y2
!byte <LINE_24_Y2
!byte <LINE_25_Y2
!byte <LINE_26_Y2
!byte <LINE_27_Y2
!byte <LINE_28_Y2
!byte <LINE_29_Y2
!byte <LINE_30_Y2
!byte <LINE_31_Y2
!byte <LINE_32_Y2
;---
TAB_ADLINE_HI_Y2 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y2
!byte >LINE_01_Y2
!byte >LINE_02_Y2
!byte >LINE_03_Y2
!byte >LINE_04_Y2
!byte >LINE_05_Y2
!byte >LINE_06_Y2
!byte >LINE_07_Y2
!byte >LINE_08_Y2
!byte >LINE_09_Y2
!byte >LINE_10_Y2
!byte >LINE_11_Y2
!byte >LINE_12_Y2
!byte >LINE_13_Y2
!byte >LINE_14_Y2
!byte >LINE_15_Y2
!byte >LINE_16_Y2
!byte >LINE_17_Y2
!byte >LINE_18_Y2
!byte >LINE_19_Y2
!byte >LINE_20_Y2
!byte >LINE_21_Y2
!byte >LINE_22_Y2
!byte >LINE_23_Y2
!byte >LINE_24_Y2
!byte >LINE_25_Y2
!byte >LINE_26_Y2
!byte >LINE_27_Y2
!byte >LINE_28_Y2
!byte >LINE_29_Y2
!byte >LINE_30_Y2
!byte >LINE_31_Y2
!byte >LINE_32_Y2
;------------------------------------
NARZUCAJ_Y3

          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN          

          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y3,Y
          STA START_EOR_LINE_Y3
          LDA TAB_ADLINE_HI_Y3,Y
          STA START_EOR_LINE_Y3+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y3+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y3+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y3
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA WRITEAST
          AND #$F8
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y3 = *+1
          JSR $1111


          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y3


LINE_00_Y3          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y3          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_02_Y3          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_03_Y3          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_04_Y3          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_05_Y3          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_06_Y3          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_07_Y3          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y3          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y3          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_10_Y3          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_11_Y3          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_12_Y3          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_13_Y3          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_14_Y3          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_15_Y3          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y3          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y3          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_18_Y3          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_19_Y3          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_20_Y3          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_21_Y3          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_22_Y3          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_23_Y3          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y3          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y3          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_26_Y3          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_27_Y3          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_28_Y3          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_29_Y3          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_30_Y3          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_31_Y3          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y3          
          NOP

;---
TAB_ADLINE_LO_Y3 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y3
!byte <LINE_01_Y3
!byte <LINE_02_Y3
!byte <LINE_03_Y3
!byte <LINE_04_Y3
!byte <LINE_05_Y3
!byte <LINE_06_Y3
!byte <LINE_07_Y3
!byte <LINE_08_Y3
!byte <LINE_09_Y3
!byte <LINE_10_Y3
!byte <LINE_11_Y3
!byte <LINE_12_Y3
!byte <LINE_13_Y3
!byte <LINE_14_Y3
!byte <LINE_15_Y3
!byte <LINE_16_Y3
!byte <LINE_17_Y3
!byte <LINE_18_Y3
!byte <LINE_19_Y3
!byte <LINE_20_Y3
!byte <LINE_21_Y3
!byte <LINE_22_Y3
!byte <LINE_23_Y3
!byte <LINE_24_Y3
!byte <LINE_25_Y3
!byte <LINE_26_Y3
!byte <LINE_27_Y3
!byte <LINE_28_Y3
!byte <LINE_29_Y3
!byte <LINE_30_Y3
!byte <LINE_31_Y3
!byte <LINE_32_Y3
;---
TAB_ADLINE_HI_Y3 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y3
!byte >LINE_01_Y3
!byte >LINE_02_Y3
!byte >LINE_03_Y3
!byte >LINE_04_Y3
!byte >LINE_05_Y3
!byte >LINE_06_Y3
!byte >LINE_07_Y3
!byte >LINE_08_Y3
!byte >LINE_09_Y3
!byte >LINE_10_Y3
!byte >LINE_11_Y3
!byte >LINE_12_Y3
!byte >LINE_13_Y3
!byte >LINE_14_Y3
!byte >LINE_15_Y3
!byte >LINE_16_Y3
!byte >LINE_17_Y3
!byte >LINE_18_Y3
!byte >LINE_19_Y3
!byte >LINE_20_Y3
!byte >LINE_21_Y3
!byte >LINE_22_Y3
!byte >LINE_23_Y3
!byte >LINE_24_Y3
!byte >LINE_25_Y3
!byte >LINE_26_Y3
!byte >LINE_27_Y3
!byte >LINE_28_Y3
!byte >LINE_29_Y3
!byte >LINE_30_Y3
!byte >LINE_31_Y3
!byte >LINE_32_Y3
;------------------------------------
NARZUCAJ_Y4

          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN

          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y4,Y
          STA START_EOR_LINE_Y4
          LDA TAB_ADLINE_HI_Y4,Y
          STA START_EOR_LINE_Y4+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y4+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y4+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y4
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA WRITEAST
          AND #$F8
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y4 = *+1
          JSR $1111


          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y4


LINE_00_Y4          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y4          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_02_Y4          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_03_Y4          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_04_Y4          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_05_Y4          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_06_Y4          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_07_Y4          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y4          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y4          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_10_Y4          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_11_Y4          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_12_Y4          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_13_Y4          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_14_Y4          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_15_Y4          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y4          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y4          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_18_Y4          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_19_Y4          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_20_Y4          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_21_Y4          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_22_Y4          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_23_Y4          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y4          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y4          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_26_Y4          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_27_Y4          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_28_Y4          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_29_Y4          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_30_Y4          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_31_Y4          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y4          
          NOP

;---
TAB_ADLINE_LO_Y4 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y4
!byte <LINE_01_Y4
!byte <LINE_02_Y4
!byte <LINE_03_Y4
!byte <LINE_04_Y4
!byte <LINE_05_Y4
!byte <LINE_06_Y4
!byte <LINE_07_Y4
!byte <LINE_08_Y4
!byte <LINE_09_Y4
!byte <LINE_10_Y4
!byte <LINE_11_Y4
!byte <LINE_12_Y4
!byte <LINE_13_Y4
!byte <LINE_14_Y4
!byte <LINE_15_Y4
!byte <LINE_16_Y4
!byte <LINE_17_Y4
!byte <LINE_18_Y4
!byte <LINE_19_Y4
!byte <LINE_20_Y4
!byte <LINE_21_Y4
!byte <LINE_22_Y4
!byte <LINE_23_Y4
!byte <LINE_24_Y4
!byte <LINE_25_Y4
!byte <LINE_26_Y4
!byte <LINE_27_Y4
!byte <LINE_28_Y4
!byte <LINE_29_Y4
!byte <LINE_30_Y4
!byte <LINE_31_Y4
!byte <LINE_32_Y4
;---
TAB_ADLINE_HI_Y4 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y4
!byte >LINE_01_Y4
!byte >LINE_02_Y4
!byte >LINE_03_Y4
!byte >LINE_04_Y4
!byte >LINE_05_Y4
!byte >LINE_06_Y4
!byte >LINE_07_Y4
!byte >LINE_08_Y4
!byte >LINE_09_Y4
!byte >LINE_10_Y4
!byte >LINE_11_Y4
!byte >LINE_12_Y4
!byte >LINE_13_Y4
!byte >LINE_14_Y4
!byte >LINE_15_Y4
!byte >LINE_16_Y4
!byte >LINE_17_Y4
!byte >LINE_18_Y4
!byte >LINE_19_Y4
!byte >LINE_20_Y4
!byte >LINE_21_Y4
!byte >LINE_22_Y4
!byte >LINE_23_Y4
!byte >LINE_24_Y4
!byte >LINE_25_Y4
!byte >LINE_26_Y4
!byte >LINE_27_Y4
!byte >LINE_28_Y4
!byte >LINE_29_Y4
!byte >LINE_30_Y4
!byte >LINE_31_Y4
!byte >LINE_32_Y4
;------------------------------------
NARZUCAJ_Y5

          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN          

          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y5,Y
          STA START_EOR_LINE_Y5
          LDA TAB_ADLINE_HI_Y5,Y
          STA START_EOR_LINE_Y5+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y5+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y5+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y5
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA WRITEAST
          AND #$F8
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y5 = *+1
          JSR $1111


          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y5


LINE_00_Y5          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y5          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_02_Y5          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_03_Y5          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_04_Y5          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_05_Y5          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_06_Y5          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_07_Y5          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y5          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y5          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_10_Y5          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_11_Y5          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_12_Y5          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_13_Y5          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_14_Y5          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_15_Y5          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y5          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y5          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_18_Y5          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_19_Y5          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_20_Y5          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_21_Y5          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_22_Y5          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_23_Y5          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y5          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y5          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_26_Y5          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_27_Y5          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_28_Y5          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_29_Y5          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_30_Y5          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_31_Y5          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y5          
          NOP

;---
TAB_ADLINE_LO_Y5 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y5
!byte <LINE_01_Y5
!byte <LINE_02_Y5
!byte <LINE_03_Y5
!byte <LINE_04_Y5
!byte <LINE_05_Y5
!byte <LINE_06_Y5
!byte <LINE_07_Y5
!byte <LINE_08_Y5
!byte <LINE_09_Y5
!byte <LINE_10_Y5
!byte <LINE_11_Y5
!byte <LINE_12_Y5
!byte <LINE_13_Y5
!byte <LINE_14_Y5
!byte <LINE_15_Y5
!byte <LINE_16_Y5
!byte <LINE_17_Y5
!byte <LINE_18_Y5
!byte <LINE_19_Y5
!byte <LINE_20_Y5
!byte <LINE_21_Y5
!byte <LINE_22_Y5
!byte <LINE_23_Y5
!byte <LINE_24_Y5
!byte <LINE_25_Y5
!byte <LINE_26_Y5
!byte <LINE_27_Y5
!byte <LINE_28_Y5
!byte <LINE_29_Y5
!byte <LINE_30_Y5
!byte <LINE_31_Y5
!byte <LINE_32_Y5
;---
TAB_ADLINE_HI_Y5 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y5
!byte >LINE_01_Y5
!byte >LINE_02_Y5
!byte >LINE_03_Y5
!byte >LINE_04_Y5
!byte >LINE_05_Y5
!byte >LINE_06_Y5
!byte >LINE_07_Y5
!byte >LINE_08_Y5
!byte >LINE_09_Y5
!byte >LINE_10_Y5
!byte >LINE_11_Y5
!byte >LINE_12_Y5
!byte >LINE_13_Y5
!byte >LINE_14_Y5
!byte >LINE_15_Y5
!byte >LINE_16_Y5
!byte >LINE_17_Y5
!byte >LINE_18_Y5
!byte >LINE_19_Y5
!byte >LINE_20_Y5
!byte >LINE_21_Y5
!byte >LINE_22_Y5
!byte >LINE_23_Y5
!byte >LINE_24_Y5
!byte >LINE_25_Y5
!byte >LINE_26_Y5
!byte >LINE_27_Y5
!byte >LINE_28_Y5
!byte >LINE_29_Y5
!byte >LINE_30_Y5
!byte >LINE_31_Y5
!byte >LINE_32_Y5
;------------------------------------
NARZUCAJ_Y6

          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN          

          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y6,Y
          STA START_EOR_LINE_Y6
          LDA TAB_ADLINE_HI_Y6,Y
          STA START_EOR_LINE_Y6+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y6+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y6+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y6
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA WRITEAST
          AND #$F8
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y6 = *+1
          JSR $1111

          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y6

LINE_00_Y6          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y6          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_02_Y6          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_03_Y6          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_04_Y6          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_05_Y6          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_06_Y6          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_07_Y6          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y6          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y6          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_10_Y6          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_11_Y6          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_12_Y6          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_13_Y6          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_14_Y6          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_15_Y6          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y6          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y6          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_18_Y6          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_19_Y6          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_20_Y6          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_21_Y6          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_22_Y6          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_23_Y6          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y6          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y6          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_26_Y6          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_27_Y6          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_28_Y6          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_29_Y6          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_30_Y6          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_31_Y6          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y6          
          NOP


;---
TAB_ADLINE_LO_Y6 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y6
!byte <LINE_01_Y6
!byte <LINE_02_Y6
!byte <LINE_03_Y6
!byte <LINE_04_Y6
!byte <LINE_05_Y6
!byte <LINE_06_Y6
!byte <LINE_07_Y6
!byte <LINE_08_Y6
!byte <LINE_09_Y6
!byte <LINE_10_Y6
!byte <LINE_11_Y6
!byte <LINE_12_Y6
!byte <LINE_13_Y6
!byte <LINE_14_Y6
!byte <LINE_15_Y6
!byte <LINE_16_Y6
!byte <LINE_17_Y6
!byte <LINE_18_Y6
!byte <LINE_19_Y6
!byte <LINE_20_Y6
!byte <LINE_21_Y6
!byte <LINE_22_Y6
!byte <LINE_23_Y6
!byte <LINE_24_Y6
!byte <LINE_25_Y6
!byte <LINE_26_Y6
!byte <LINE_27_Y6
!byte <LINE_28_Y6
!byte <LINE_29_Y6
!byte <LINE_30_Y6
!byte <LINE_31_Y6
!byte <LINE_32_Y6
;---
TAB_ADLINE_HI_Y6 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y6
!byte >LINE_01_Y6
!byte >LINE_02_Y6
!byte >LINE_03_Y6
!byte >LINE_04_Y6
!byte >LINE_05_Y6
!byte >LINE_06_Y6
!byte >LINE_07_Y6
!byte >LINE_08_Y6
!byte >LINE_09_Y6
!byte >LINE_10_Y6
!byte >LINE_11_Y6
!byte >LINE_12_Y6
!byte >LINE_13_Y6
!byte >LINE_14_Y6
!byte >LINE_15_Y6
!byte >LINE_16_Y6
!byte >LINE_17_Y6
!byte >LINE_18_Y6
!byte >LINE_19_Y6
!byte >LINE_20_Y6
!byte >LINE_21_Y6
!byte >LINE_22_Y6
!byte >LINE_23_Y6
!byte >LINE_24_Y6
!byte >LINE_25_Y6
!byte >LINE_26_Y6
!byte >LINE_27_Y6
!byte >LINE_28_Y6
!byte >LINE_29_Y6
!byte >LINE_30_Y6
!byte >LINE_31_Y6
!byte >LINE_32_Y6
;------------------------------------
NARZUCAJ_Y7
          
          LDX FROM_COLUMN ; KONTROLA ILOSCI NARZUCONYCH KOLUMN

          LDY FROM_LINE                              ; POBRANIE START ADRESU DLA LINII STARTOWEJ
          LDA TAB_ADLINE_LO_Y7,Y
          STA START_EOR_LINE_Y7
          LDA TAB_ADLINE_HI_Y7,Y
          STA START_EOR_LINE_Y7+1

          LDY TO_LINE                              ; POBRANIE ADRESU DLA RTS LINII KONCOWEJ

          LDA TAB_ADLINE_LO_Y7+1,Y
          STA VEC_SELFMOD
          LDA TAB_ADLINE_HI_Y7+1,Y
          STA VEC_SELFMOD+1
          LDA #$60 ;RTS
          LDY #$00
          STA (VEC_SELFMOD),Y


NARZ_BIG_Y7
          LDA READAST
          CLC
          ADC #$40
          STA VEC_2
          LDA READASTHI
          ADC #$01
          STA VEC_2HI

          LDA VEC_2
          ADC #$40
          STA VEC_3
          LDA VEC_2HI
          ADC #$01
          STA VEC_3HI
          
          LDA VEC_3
          ADC #$40
          STA VEC_4
          LDA VEC_3HI
          ADC #$01
          STA VEC_4HI

          LDA WRITEAST
          AND #$F8
          ;CLC
          ADC #$40
          STA VEC2
          LDA WRITEASTHI
          ADC #$01
          STA VEC2HI

          LDA VEC2
          ADC #$40
          STA VEC3
          LDA VEC2HI
          ADC #$01
          STA VEC3HI
          
          LDA VEC3
          ADC #$40
          STA VEC4
          LDA VEC3HI
          ADC #$01
          STA VEC4HI

          LDA VEC4
          ADC #$40
          STA VEC1
          LDA VEC4HI
          ADC #$01
          STA VEC1HI



START_EOR_LINE_Y7 = *+1
          JSR $1111


          CPX TO_COLUMN
          BCC +
          JMP EOF_NARZ3
+:
          INX
          LDA READAST
          ;CLC - CARRY IS CLEAR
          ADC #8
          STA READAST
          BCC +
          CLC
          INC READASTHI
+:
          
          LDA WRITEAST
          ADC #8
          STA WRITEAST
          BCC +
          INC WRITEASTHI
+:
          JMP NARZ_BIG_Y7


LINE_00_Y7          
          LDY #$00
          LDA (READAST),Y
          BEQ +
          EOR (WRITEAST),Y
          STA (WRITEAST),Y
+:
LINE_01_Y7          
          LDY #$01
          LDA (READAST),Y
          BEQ +
          LDY #$00
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_02_Y7          
          LDY #$02
          LDA (READAST),Y
          BEQ +
          LDY #$01
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_03_Y7          
          LDY #$03
          LDA (READAST),Y
          BEQ +
          LDY #$02
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_04_Y7          
          LDY #$04
          LDA (READAST),Y
          BEQ +
          LDY #$03
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_05_Y7          
          LDY #$05
          LDA (READAST),Y
          BEQ +
          LDY #$04
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_06_Y7          
          LDY #$06
          LDA (READAST),Y
          BEQ +
          LDY #$05
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_07_Y7          
          LDY #$07
          LDA (READAST),Y
          BEQ +
          LDY #$06
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_08_Y7          
          LDY #$00
          LDA (VEC_2),Y
          BEQ +
          LDY #$07
          EOR (VEC2),Y
          STA (VEC2),Y
+:
LINE_09_Y7          
          LDY #$01
          LDA (VEC_2),Y
          BEQ +
          LDY #$00
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_10_Y7          
          LDY #$02
          LDA (VEC_2),Y
          BEQ +
          LDY #$01
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_11_Y7          
          LDY #$03
          LDA (VEC_2),Y
          BEQ +
          LDY #$02
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_12_Y7          
          LDY #$04
          LDA (VEC_2),Y
          BEQ +
          LDY #$03
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_13_Y7          
          LDY #$05
          LDA (VEC_2),Y
          BEQ +
          LDY #$04
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_14_Y7          
          LDY #$06
          LDA (VEC_2),Y
          BEQ +
          LDY #$05
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_15_Y7          
          LDY #$07
          LDA (VEC_2),Y
          BEQ +
          LDY #$06
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_16_Y7          
          LDY #$00
          LDA (VEC_3),Y
          BEQ +
          LDY #$07
          EOR (VEC3),Y
          STA (VEC3),Y
+:
LINE_17_Y7          
          LDY #$01
          LDA (VEC_3),Y
          BEQ +
          LDY #$00
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_18_Y7          
          LDY #$02
          LDA (VEC_3),Y
          BEQ +
          LDY #$01
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_19_Y7          
          LDY #$03
          LDA (VEC_3),Y
          BEQ +
          LDY #$02
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_20_Y7          
          LDY #$04
          LDA (VEC_3),Y
          BEQ +
          LDY #$03
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_21_Y7          
          LDY #$05
          LDA (VEC_3),Y
          BEQ +
          LDY #$04
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_22_Y7          
          LDY #$06
          LDA (VEC_3),Y
          BEQ +
          LDY #$05
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_23_Y7          
          LDY #$07
          LDA (VEC_3),Y
          BEQ +
          LDY #$06
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_24_Y7          
          LDY #$00
          LDA (VEC_4),Y
          BEQ +
          LDY #$07
          EOR (VEC4),Y
          STA (VEC4),Y
+:
LINE_25_Y7          
          LDY #$01
          LDA (VEC_4),Y
          BEQ +
          LDY #$00
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_26_Y7          
          LDY #$02
          LDA (VEC_4),Y
          BEQ +
          LDY #$01
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_27_Y7          
          LDY #$03
          LDA (VEC_4),Y
          BEQ +
          LDY #$02
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_28_Y7          
          LDY #$04
          LDA (VEC_4),Y
          BEQ +
          LDY #$03
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_29_Y7          
          LDY #$05
          LDA (VEC_4),Y
          BEQ +
          LDY #$04
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_30_Y7          
          LDY #$06
          LDA (VEC_4),Y
          BEQ +
          LDY #$05
          EOR (VEC1),Y
          STA (VEC1),Y
+:
LINE_31_Y7          
          LDY #$07
          LDA (VEC_4),Y
          BEQ +
          LDY #$06
          EOR (VEC1),Y
          STA (VEC1),Y
+:
          RTS
LINE_32_Y7          
          NOP

;---
TAB_ADLINE_LO_Y7 ; MLODSZY BAJT ADRESU WYKONANIA LINII

!byte <LINE_00_Y7
!byte <LINE_01_Y7
!byte <LINE_02_Y7
!byte <LINE_03_Y7
!byte <LINE_04_Y7
!byte <LINE_05_Y7
!byte <LINE_06_Y7
!byte <LINE_07_Y7
!byte <LINE_08_Y7
!byte <LINE_09_Y7
!byte <LINE_10_Y7
!byte <LINE_11_Y7
!byte <LINE_12_Y7
!byte <LINE_13_Y7
!byte <LINE_14_Y7
!byte <LINE_15_Y7
!byte <LINE_16_Y7
!byte <LINE_17_Y7
!byte <LINE_18_Y7
!byte <LINE_19_Y7
!byte <LINE_20_Y7
!byte <LINE_21_Y7
!byte <LINE_22_Y7
!byte <LINE_23_Y7
!byte <LINE_24_Y7
!byte <LINE_25_Y7
!byte <LINE_26_Y7
!byte <LINE_27_Y7
!byte <LINE_28_Y7
!byte <LINE_29_Y7
!byte <LINE_30_Y7
!byte <LINE_31_Y7
!byte <LINE_32_Y7
;---
TAB_ADLINE_HI_Y7 ; STARSZY BAJT ADRESU WYKONANIA LINII

!byte >LINE_00_Y7
!byte >LINE_01_Y7
!byte >LINE_02_Y7
!byte >LINE_03_Y7
!byte >LINE_04_Y7
!byte >LINE_05_Y7
!byte >LINE_06_Y7
!byte >LINE_07_Y7
!byte >LINE_08_Y7
!byte >LINE_09_Y7
!byte >LINE_10_Y7
!byte >LINE_11_Y7
!byte >LINE_12_Y7
!byte >LINE_13_Y7
!byte >LINE_14_Y7
!byte >LINE_15_Y7
!byte >LINE_16_Y7
!byte >LINE_17_Y7
!byte >LINE_18_Y7
!byte >LINE_19_Y7
!byte >LINE_20_Y7
!byte >LINE_21_Y7
!byte >LINE_22_Y7
!byte >LINE_23_Y7
!byte >LINE_24_Y7
!byte >LINE_25_Y7
!byte >LINE_26_Y7
!byte >LINE_27_Y7
!byte >LINE_28_Y7
!byte >LINE_29_Y7
!byte >LINE_30_Y7
!byte >LINE_31_Y7
!byte >LINE_32_Y7
;------------------------------------


;=====
koniec
