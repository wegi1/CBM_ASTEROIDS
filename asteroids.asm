!to "asteroids.prg" , CBM

;=============================
;     ASTEROIDS ON C-64      =
;   OLD ATARI ARCADE GAME    =
; (C) BY WEGI IN 2012.07.03  =
;     finish 2013.10.11      =
;=============================

;DEFINICJE
;*****
     maximum_kul          = $04
     SPEED_KULA           = $05
     longliveball         = 160/SPEED_KULA
;*****
     many_lives           = 3 ;3 default
     many_started_objects = 4 ;4
     frame_color          = 0 ;0

     firtstast40          = 0 ;0


     ufo_off              = 0 ; disable ufo - normal 0
     changetripufo        = 0 ;0 default

     withoutaster         = 0 ; disable first asterod 1 - 0 - enable
     NOKILLUFO            = 0 ; 0
     nokill               = 0 ; 1 disable ship collision  - 0 (normal) enable
     autofire             = 0 ; 0 disable autofire (normal) - 1 enable
     matrixmode           = 0 ; 1 - no eliminate small object - normal 0
     noobjects            = 0 ; game without asteroids - 0 default

;END DEFINE
;===

     cnt_msx              = $1000
     startheartb          = $1003
     fire_bullet          = $1006
     explosion            = $1009
     extra_life           = $100c
     ufosound             = $100f
     ufostopsound         = $1012
     turn_on_thrust       = $1015
     turn_off_thrust      = $1018
     setfastbeat          = $101b
     getfastbeat          = $101e


     RAMCOLOR             = $6000
     SCREEN               = $4000
     BANKSHIP             = (RAMCOLOR+$0400 - $4000)/64
     SPRIT0               = RAMCOLOR +$03F8
     ASTERY               = $e000 ; ADRES BITMAP ASTEROID�W
     TB_AD_NARZ_LO        = fastcode
     TB_AD_NARZ_HI        = TB_AD_NARZ_LO +8
;===

     TAB_DELTA            = $0200 ; 16 TABLIC DLA KAZDEGO SKRETU STATKU Z 8MIOMA DELTAMI DLA PREDKOSCI W X I Y
     TAB_FAST             = $0300 ; DLA DEKODOWANIA PREDKOSCI

     TBBIT                = $0400 ; DLA PLOTA TABLICA BITOW WG POZYCJI W X
     TABLO                = $0500 ; =II= TABLICA MLODSZYCH BAJTOW ADRESU NA BITMAPIE
     TABHI                = $0600 ; =II= TABLICA STARSZYCH BAJTOW ADRESU NA BITMAPIE
     TABXM                = $0700 ; =II= TABLICA ADRESOW DLA Y WG POZYCJI PLOTA W X MODULO CO 8

;OBIEKT = $0800 ; KOPIA WZORU ASTEROIDA DO NARZUCENIA
;=======
     TBOBJ_M_Y			      = $0900 + 0*50 ; TABLICA SUWU W Y OBIEKTU OD 0 DO 199+max_Y
     TBOBJ_Y 			        = $0900 + 1*50 ; TABLICA EKRANOWYCH Y OBIEKTU
     TBOBJ_MAX_Y		      = $0900 + 2*50 ; MAXYMALNY ROZMIAR W Y OBIEKTU
     TBOBJ_FROM_LINE	  	= $0900 + 3*50 ; NARZUCANIE OD LINII
     TBOBJ_TO_LINE		    = $0900 + 4*50 ; NARZUCANIE DO LINII

     TBOBJ_X_LO   	      = $0a00 + 0*50 ; EKRANOWE X LO BYTE
     TBOBJ_X_HI		        = $0a00 + 1*50 ; EKRANOWE X HI BYTE
     TBOBJ_FROM_COLUMN  	= $0a00 + 2*50 ; NARZUCANIE OD KOLUMNY

     TBOBJ_TO_COLUMN  		= $0a00 + 3*50 ; NARZUCANIE DO KOLUMNY
     TBOBJ_DX			        = $0a00 + 4*50 ; NUMER PODSTAWOWEJ KOPII OBIEKTU
     TBOBJ_DY			        = $0b00 + 0*50 ; DY OBIEKTU
     TBOBJ_NR			        = $0b00 + 1*50 ; NR OBIEKTU
     TBOBJ_SCREEN_LO		  = $0b00 + 2*50 ; NARZUCANIE DO KOLUMNY
     TBOBJ_SCREEN_HI	    = $0b00 + 3*50 ; NUMER PODSTAWOWEJ KOPII OBIEKTU
;=============

     putvec               = $04 ;adr to decrunch rawdata

     XA                   = $10 ; POZ W X PLOTA LO BYTE
     XAHI                 = $11 ; POZ W X PLOTA HI BYTE
     YA                   = $12 ; POZ W Y PLOTA

     STPLOT               = $13 ; VECTOR ADRESU PLOTA
     STPLOTHI             = $14 ; =II=

     IRQCNTR              = $15 ;LICZNIK IRQ

     POZ_SHIP_X_LO        = $16 ;POZYCJA STATKU W X LO BYTE
     POZ_SHIP_X_HI        = $17 ;POZYCJA STATKU W X HI BYTE
     POZ_SHIP_Y           = $18 ;POZYCJA STATKU W Y
     SHIP_SPEED           = $19 ;0 SHIP NOT MOVE <> 0 SHIP SPEED

     SHIP_DX              = $1A ;DELTA X STATKU DLA RUCHU
     SHIP_DY              = $1B ;DELTA Y STATKU DLA RUCHU
     SHIP_STEP_X_SIGN     = $1C	;0 = "+" : 1 = "-" - ZNAK RUCHU W X
     SHIP_STEP_Y_SIGN     = $1D	;0 = "+" : 1 = "-" - ZNAK RUCHU W Y

     SHIP_STEP_X          = $1E ;WIELKOSC KROKU STATKU W X POBRANA ZALEZNIE OD PREDKOSCI
     SHIP_STEP_Y          = $1F ;WIELKOSC KROKU STATKU W Y POBRANA ZALEZNIE OD PREDKOSCI

     SHIP_NR_ROT          = $20 ;NR KIERUNKU STATKU 0 DO $0F
     NEWSHIP_NR_ROT       = $21 ;NR NOWEGO KIERUNKU STATKU 0 DO $0F

     COUNT_WYTR           = $22 ;licznik ilosci wytraca�
     USED_KUL             = $23 ;LICZNIK AKTUALNIE UZYTYCH KUL
     ACT_KULA             = $24 ;AKTUALNIE OBRABIANA KULA
     KULA_KOLIZJA         = $25 ;NR KULI KOLIDUJACEJ

     DAJ_GAZU             = $26 ;WIELKOSC PREDKOSCI - OD 0 DO 96
     WYTRACAJ             = $27 ;WYTRACANIE PREDKOSCI 0 = NIE WYTRACAJ <> 0 ODEJMUJ

     CTRL_DX              = $28 	;DLA PLOTA - RESZTA Z DODAWANIA DX LUB DY
     DX                   = $29		; DX PLOTA
     DY                   = $2A		; DY PLOTA
     DXSIGN               = $2B	; ZNAK DX PLOTA = KIERUNEK (0 W PRAWO <> 0 W LEWO)
     DYSIGN               = $2C	; ZNAK DY PLOTA GORA DOL 0 GORA <> 0 DOL
     CALCSTEP             = $2D	; ILOSC KROKOW PLOTA

     KEYTEST              = $2E  ; DLA ODCZYTANEJ KLAWIATURY
     KEY_OLD              = $2F  ; DLA ODCZYTANEJ KLAWIATURY

     XSTEPS               = $30 ;$30 DO $37 KROKI W X ZALEZNE OD PREDKOSCI I DX tylko w pocz fazie obliczen
     YSTEPS               = $38 ;$38 DO $3F KROKI W Y ZALEZNE OD PREDKOSCI I DY tylko w pocz fazie obliczen
;==============================
     KULA0                = $30 ;kule W UZYCIU - 0 = KULA NIEWYSTRZELONA  <> 0 - WYSTRZELONA

     KULA_X_LO 	          = KULA0 + maximum_kul ;POZ KULI W X LO BYTE
     KULA_X_HI 	          = KULA_X_LO + 1*maximum_kul ;POZ KULI W X HI BYTE
     KULA_Y_LO 	          = KULA_X_LO + 2*maximum_kul ;POZ KULI W Y
     KULA_X_SIGN 	        = KULA_X_LO + 3*maximum_kul ;ZNAK RUCHU KULI W X
     KULA_Y_SIGN  	      = KULA_X_LO + 4*maximum_kul ;ZNAK RUCHU KULI W Y
     KULA_DX		          = KULA_X_LO + 5*maximum_kul ;DX KULI
     KULA_DY		          = KULA_X_LO + 6*maximum_kul ;DY KULI
     KULA_STEP		        = KULA_X_LO + 7*maximum_kul ;LICZNIK KROK�W KULI
;===
     OLDKULA_X_LO 	      = KULA_X_LO + 8*maximum_kul ;STARA POZ KULI W X LO BYTE
     OLDKULA_X_HI 	      = KULA_X_LO + 9*maximum_kul ;STARA POZ KULI W X HI BYTE
     OLDKULA_Y_LO 	      = KULA_X_LO +10*maximum_kul ;STARA POZ KULI W Y
     KULA_NR_ROT 	        = KULA_X_LO +11*maximum_kul ;KIERUNEK KULI

;KONIEC_KUL ($64) = KUULA_X_LO + 8*maximum_kul ;LICZNIK KROK�W KULI
     WYSTRZEL             = $64 ;$54 CZY WYSTRZELIC NOW� KUL� - 0 NIE <> 0 TAK
     IRQ_STRZAL           = $65 ;ILOSC ODWOLAN DO IRQ MUZYKA PO STRZALE

     KOLIZJA_BMP          = $66 ;KOLIZJA SPRAJTA Z BITMAPA (KOPIA $D01F)
     KOLIZJA_SPR          = $67 ;KOLIZJA SPRAJTA ZE SPRAJTEM (KOPIA $D01E)
     IGNORE_KOLIZJA       = $68 ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ) - ROZBIJANIE STATKU, ANIMACJA ITP...
     COUNT_FRAME          = $69 ;DLUGOSC RAMKI ANIMACJI (rozbijanie statku)
     COUNT_FR2            = $6A  ;ZLICZNIE DLUGOSCI RAMKI ANIMACJI (rozbijanie statku)
     COUNT_ANIM           = $6B  ;ZLICZANIE KLATEK ANIMACJI (rozbijanie statku)

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
     TMPR1                = $8c ; ZLICZANIE OBIEKTÓW PODCZAS KOLIZJI Z KULI
     MAXXLO               = $8d ;MAXYMALNA POZYCJA OBIEKTU W X PRZY SZUKANIU KOLIZJI
     MAXXHI               = $8e
     TMPR2                = $8f ; NR NISZCZONEGO OBIEKTU

     MAXIYPOZ             = $90 ; MAXYMALNA POZYCJA W Y DANEGO ASTERA
;=== DLA PROC SZUKANIA KOLIZJI
     FINDAST              = $91 ; WEKTOR PRZY WYSZUKIWANIU KOPII ASTERA PRZY WYKRYWANIU KOLIZJI
     FINDASTHI            = $92 ;;ADRES PLOTA W BITMAPIE ASTEROIDU DO SPRAWDZENIA
     FINDAST_2            = $93 ; ZAPASOWY WEKTOR PRZY WYSZUKIWANIU KOLIZJI
     FINDAST_2HI          = $94 ;ADRES PLOTA W BITMAPIE ASTEROIDU DO SPRAWDZENIA

     PLOX_NOMOD           = $95 ; POZYCJA X PLOTA W BITMAPIE ASTEROIDU DO SPRAWDZENIA PODZCZAS SZUKANIA KOLIZJI
     PLOY_NOMOD           = $96 ; POZYCJA Y PLOTA W BITMAPIE ASTEROIDU DO SPRAWDZENIA PODZCZAS SZUKANIA KOLIZJI
     PLOX_MOD             = $97 ; PRZESUNIĘCIE X PRZY WYSZUKIWANIU PLOTA KOLIDUJĄCEGO W ZWIĄZKU Z PRZESUNIĘCIEM PIXELI W BITMAPACH ASTEROIDOW

     degres_dyx           = $98 ; przerobiona ujemna wartość dy/x do odejmowania
     lives                = $99 ; liczba statkow
     scores               = $9a ; licznik punktow 6 bytes
     cyfra_nr             = $a0 ; aktualnie obrabiana cyfra przy aktualizacji licznika
     ady_cyfra            = $a1 ; adres cyfry obrabianej w counterze
     liczstatki           = $a3 ; zlicza statki do wyswietlenia na sprajtach
     klatkapyl            = $a4 ; 4bytes nr klatki do wyświetlenia na sprajcie gwiezdniego pyłu

;======== uzywane tylko podczas kolizji statku - bardzo rzadko można w trakcie je uzywac
     STARTBMPX           = $a8
     STARTBMPXHI         = $a9
     STARTBMPY           = $aa
     BMPPLOT             = $ab
     BMPPLOTHI           = $ac
;========
; dane do poszukiwania kolizji statku z meteorem

     SPR_XA              = $ad
     spr_from_pixel      = $ae
     spr_to_pixel        = $af
     spr_from_line       = $b0
     spr_to_line         = $b1
;========
     is_UFO              = $b2 ;czy jest aktywne ufo 0 nie 1 tak
     nr_UFO              = $b3
     UFO_kula            = $b4
     rozbij_UFO          = $b5
     UFO_dx              = $b6


     UFO_max_Y           = $b7
     UFO_min_y           = $b8
     UFO_filed_min_Y     = $b9
     UFO_field_max_Y     = $ba
     UFO_field_min_X     = $bb
     UFO_field_max_X     = $bc
     UFO_Y_trip          = $bd
     UFO_dy              = $be
     UFO_poz_in_trip     = $bf

     UFORtrip_adr        = $c0 ;$c0/$c1

;====
     UFO_KULA_X_LO 	          = $c2 ;POZ KULI W X LO BYTE
     UFO_KULA_X_HI 	          = $c3 ;POZ KULI W X HI BYTE
     UFO_KULA_Y_LO 	          = $c4 ;POZ KULI W Y
     UFO_KULA_X_SIGN 	        = $c5 ;ZNAK RUCHU KULI W X
     UFO_KULA_Y_SIGN  	      = $c6 ;ZNAK RUCHU KULI W Y
     UFO_KULA_DX		          = $c7 ;DX KULI
     UFO_KULA_DY		          = $c8 ;DY KULI
     UFO_KULA_STEP		        = $c9 ;LICZNIK KROK�W KULI
;===
     UFO_OLDKULA_X_LO 	      = $ca ;STARA POZ KULI W X LO BYTE
     UFO_OLDKULA_X_HI 	      = $cb ;STARA POZ KULI W X HI BYTE
     UFO_OLDKULA_Y_LO 	      = $cc ;STARA POZ KULI W Y
     UFO_KULA_NR_ROT 	        = $cd ;KIERUNEK KULI

     POZ_UFO_X_LO             = $CE ;POZYCJA STATKU W X LO BYTE
     POZ_UFO_X_HI             = $CF ;POZYCJA STATKU W X HI BYTE
     POZ_UFO_Y                = $D0 ;POZYCJA STATKU W Y

     byl_last                 = $D1 ;czy byl ostatni klocek i wybuch na nim
     jestkolizja              = $D2
     govercount               = $d3
     nmicounter               = $d4
     DELAY_UFO_BALL           = $D5
;===

     pzstlo                   = $d6
     pzsthi                   = $d7
     pzufolo                  = $d8
     pzufohi                  = $d9

     difcalclo                = $da
     difcalchi                = $db

     ypzst                    = $dc
     ypzufo                   = $dd
     ydiff                    = $de

;========
; = $d6
;========
;---  BASICLINE  1680 SYS2049
;========
         *= $0801
     !byte $0b,$08,$00,$00,$9e,$32
     !byte $30,$36,$31,$00,$00,$00
;========
;=
          jmp fromrun ; - odznaczyc
runfrst
          jmp fromcart
unfrez
          jmp refrez
fromrun
          sei
          lda #$35
          sta $01
          JMP STARTGAME
;----------------------
fromcart
          lda #$2c
          sta muzz
          sta nosid
          JMP STARTGAME
;-------------------------
refrez
          jsr rest_dat1

          lda #$60
          sta $e803 ;bez muzyki

          lda #$2c
          sta muzz
          sta nologos ;bez logo
          sta notcoin
          sta restscores


          lda #$4c
          sta zamknijlogo ;bez loga

          bne fromrun

;============
;pominac demogry

;-ustawic difway
;-ustawic fasthartb
;-ustawic lives
;-ustawic ufo_model_poz
;odnowic scores
;odnowic licznik gracza
;===============
rest_dat1
          lda #12
          sta many_start_obj
          lda #0
          sta difway
          lda #8
          sta many_lv
          LDA #$B0
          sta f_beat
          lda #4
          sta ufo_model_poz2
          rts
oldscore
!byte 1,2,3,4,5,0
;==============
AAAINITEND
;***
*= $0c00

;===== tabels start pos asteroids
tbast
;y
!byte $00,120,230,230,$00,230,$00,$00,100,150,$37,$23
;xlo
!byte $00,$3e,200,140,$00,$00,120,220,$00,$00,$00,$00
;xhi
!byte $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
astdx
!If withoutaster = 1{
!byte $00,$ff,$fe,$02,$02,$fc,$01,$01,$01,$02,$ff,$01
} else {
!byte $01,$ff,$fe,$02,$02,$fc,$01,$01,$01,$02,$ff,$01
}
astdy
!If withoutaster = 1{
!byte $00,$ff,$ff,$ff,$ff,$01,$01,$02,$02,$01,$01,$ff
} else {
!byte $01,$ff,$ff,$ff,$ff,$01,$01,$02,$02,$01,$01,$ff
}
!if firtstast40 = 1 {
     !byte 64,64
}
asternr
!byte $00,$08,$10,$18,$00,$08,$10,$18,$00,$08,$10,$18
;===============
;=== ; for calculate bmp adr
ODDAJ_LINIE_LO		!byte $40,$80,$C0,$00
ODDAJ_LINIE_HI		!byte $01,$02,$03,$05
;===
;---
; DELTY X,Y I ICH ZNAKI W ZALEZNOSCI OD POLOZENIA STATKU (16 POZYCJI)
XPOZ !byte 0,10,20,20,20,20,20,10,0,10,20,20,20,20,20,10
YPOZ !byte 20,20,20,10,0,10,20,20,20,20,20,10,0,10,20,20
XSIGN !byte 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1
YSIGN !byte 0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0
;================================================================
;PRZESUNIECIE PIERWSZEJ KULI W SPRAJCIE STATKU W ZALEZNOSCI OD POLOZENIA STATKU
OFF_KULA_X 	!byte 12,17,19,20,20,20,18,15,12,7,4,3,3,3,5,8
OFF_KULA_Y 	!byte 1,1,2,5,9,14,18,19,19,19,18,15,9,6,2,1
;================================================================
; TABLICA ADRESU OFSETOW POZYCJI X,Y PLOTA W SPRAJCIE
TAB_X_SPRAJT	!byte 0,0,0,0,0,0,0,0
			        !byte 1,1,1,1,1,1,1,1
			        !byte 2,2,2,2,2,2,2,2
			
TAB_Y_SPRAJT	!byte 0,3,6,9,12,15,18,21,24,27,30
			        !byte 33,36,39,42,45,48,51,54,57,60

;============
TABSPRAJT !byte 3,5,7,9
TAB_NR_SPR !byte 2,4,8,16
;============
!ALIGN 255,0
TAB_AD_OBJ_LO

*=TAB_AD_OBJ_LO+96
TAB_AD_OBJ_HI
*=TAB_AD_OBJ_LO + 192
;============
TAB_SPRITE_AD_LO
!BYTE <($6400 + 0   * 64)
!BYTE <($6400 + 1   * 64)
!BYTE <($6400 + 2   * 64)
!BYTE <($6400 + 3   * 64)
!BYTE <($6400 + 4   * 64)
!BYTE <($6400 + 5   * 64)
!BYTE <($6400 + 6   * 64)
!BYTE <($6400 + 7   * 64)
!BYTE <($6400 + 8   * 64)
!BYTE <($6400 + 9   * 64)
!BYTE <($6400 + 10  * 64)
!BYTE <($6400 + 11  * 64)
!BYTE <($6400 + 12  * 64)
!BYTE <($6400 + 13  * 64)
!BYTE <($6400 + 14  * 64)
!BYTE <($6400 + 15  * 64)
!BYTE <($6400 + 16  * 64)
!BYTE <($6400 + 17  * 64)
!BYTE <($6400 + 18  * 64)
!BYTE <($6400 + 19  * 64)
!BYTE <($6400 + 20  * 64)
!BYTE <($6400 + 21  * 64)
!BYTE <($6400 + 22  * 64)
!BYTE <($6400 + 23  * 64)
!BYTE <($6400 + 24  * 64)
!BYTE <($6400 + 25  * 64)
!BYTE <($6400 + 26  * 64)
!BYTE <($6400 + 27  * 64)
!BYTE <($6400 + 28  * 64)
!BYTE <($6400 + 29  * 64)
!BYTE <($6400 + 30  * 64)
!BYTE <($6400 + 31  * 64)
TAB_SPRITE_AD_HI
!BYTE >($6400 + 0   * 64)
!BYTE >($6400 + 1   * 64)
!BYTE >($6400 + 2   * 64)
!BYTE >($6400 + 3   * 64)
!BYTE >($6400 + 4   * 64)
!BYTE >($6400 + 5   * 64)
!BYTE >($6400 + 6   * 64)
!BYTE >($6400 + 7   * 64)
!BYTE >($6400 + 8   * 64)
!BYTE >($6400 + 9   * 64)
!BYTE >($6400 + 10  * 64)
!BYTE >($6400 + 11  * 64)
!BYTE >($6400 + 12  * 64)
!BYTE >($6400 + 13  * 64)
!BYTE >($6400 + 14  * 64)
!BYTE >($6400 + 15  * 64)
!BYTE >($6400 + 16  * 64)
!BYTE >($6400 + 17  * 64)
!BYTE >($6400 + 18  * 64)
!BYTE >($6400 + 19  * 64)
!BYTE >($6400 + 20  * 64)
!BYTE >($6400 + 21  * 64)
!BYTE >($6400 + 22  * 64)
!BYTE >($6400 + 23  * 64)
!BYTE >($6400 + 24  * 64)
!BYTE >($6400 + 25  * 64)
!BYTE >($6400 + 26  * 64)
!BYTE >($6400 + 27  * 64)
!BYTE >($6400 + 28  * 64)
!BYTE >($6400 + 29  * 64)
!BYTE >($6400 + 30  * 64)
!BYTE >($6400 + 31  * 64)
;============
fonts1
!binary "gfx\fonty1.PRG",,2
;============
;TABELKA PREDKOSCI W IRQ
TAB_SPEED !byte 0,0,20,50,65,80,195,255
COUNT_AST !byte 0
COUNT_AST_ADR !byte 0
COUNTSLIDE !byte 0
;=================
TAB_AD_LO_AST

      !byte <bmpasters
			!byte <(bmpasters + 32)
			!byte <(bmpasters + 64)
			!byte <(bmpasters + 96)
			!byte <(bmpasters + 128)
			!byte <(bmpasters + 144)
			!byte <(bmpasters + 160)
			!byte <(bmpasters + 176)
			!byte <(bmpasters + 192)
			!byte <(bmpasters + 200)
			!byte <(bmpasters + 208)
			!byte <(bmpasters + 216)
			
						
TAB_AD_HI_AST 	!byte >bmpasters
			!byte >(bmpasters + 32)
			!byte >(bmpasters + 64)
			!byte >(bmpasters + 96)

			!byte >(bmpasters + 128)
			!byte >(bmpasters + 144)
			!byte >(bmpasters + 160)
			!byte >(bmpasters + 176)

			!byte >(bmpasters + 192)
			!byte >(bmpasters + 200)
			!byte >(bmpasters + 208)
			!byte >(bmpasters + 216)
;============
ufo_model_poz
     !byte 0
ufo_model
     !byte 1,1,1,1,0,0,1,0
     !byte 1,0,0,1,1,0,0,0
     !byte 1,1,0,0,1,1,1,0
     !byte 0,0,0,0,1,0,0,0
     !byte 0,0,1,0,1,0,1,1
     !byte 0,1,0,1,1,0,1,1
     !byte 1,0,0,0,0,0,1,0
     !byte 0,0,0,0,0,0,1,0
;============
UFOdxpoz
     !byte 0
UFOdx
     !byte 0,1,1,0,0,1,0,1
     !byte 0,0,0,1,1,0,1,0
     !byte 1,1,1,0,1,1,0,1
     !byte 0,1,0,1,1,0,0,1

UFOystart
     !byte 55,155,211,90,70,133,210,80
     !byte 222,55,51,81,201,150,141,60
     !byte 99,131,221,220,55,70,110,71
     !byte 220,51,52,221,221,55,86,90

;maxy $f6 	;UFO_max_Y
;miny $21 	;UFO_min_y
;minywpolu $33	;UFO_filed_min_Y
;maxywpolu $e6	;UFO_field_max_Y
;minXwpolu $1d	;UFO_field_min_X
;maxXwpolu $3d	;UFO_field_max_X
;UFO_Y_trip

BIG_UFO_data
	!byte $f6,$21,$33,$e6,$1d,$3d,0,1,0

;male ufo

;maxy $f4 	;UFO_max_Y
;miny $24 	;UFO_min_y
;minywpolu $2d	;UFO_filed_min_Y
;maxywpolu $e5	;UFO_field_max_Y
;minXwpolu $16	;UFO_field_min_X
;maxXwpolu $41	;UFO_field_max_X
;UFO_Y_trip
;UFO_dy

SMALL_UFO_data
	!byte $f4,$24,$32,$e5,$16,$41,0,2,0
;====
trip_nr   !byte 0
;===
trip0
     ;!byte 200,0,200,0
     !byte 70,0,55,1,90,2,100,2,190,1
trip1
     !byte 70,0,55,1,90,2,100,0,190,1
trip2
     !byte 100,0,55,1,35,2,100,0,190,1
trip3
     !byte 100,0,60,1,200,0
trip4
     !byte 100,0,60,2,200,0
trip5
     !byte 170,1,60,2,200,0
trip6
     !byte 170,1,230,2
trip7
     !byte 170,2,230,1
trip8
     !byte 200,1,230,1
trip9
     !byte 200,0,130,0,200,0
trip10
     !byte 200,1,130,2,200,0
trip11
     !byte 120,0,130,1,200,0
trip12
     !byte 120,0,130,2,200,0
trip13
     !byte 160,0,70,2,200,0
trip14
     !byte 60,1,150,0,200,2
trip15
     !byte 100,0,60,1,100,2,200,0

TB_ad_lo_trip

     !byte <trip0
     !byte <trip1
     !byte <trip2
     !byte <trip3
     !byte <trip4
     !byte <trip5
     !byte <trip6
     !byte <trip7
     !byte <trip8
     !byte <trip9
     !byte <trip10
     !byte <trip11
     !byte <trip12
     !byte <trip13
     !byte <trip14
     !byte <trip15


TB_ad_hi_trip

     !byte >trip0
     !byte >trip1
     !byte >trip2
     !byte >trip3
     !byte >trip4
     !byte >trip5
     !byte >trip6
     !byte >trip7
     !byte >trip8
     !byte >trip9
     !byte >trip10
     !byte >trip11
     !byte >trip12
     !byte >trip13
     !byte >trip14
     !byte >trip15
;=======================

end_tables
;========================================================================
          *=$1000
!binary "crd\newplayer.PRG",,$0801

end_msx
;***
;=======

     *= $1c00
youscore
!bin "gfx\yscore.bin",,2
endysc
;=======

;=======

* = $2000
fastcode
;====================================
!bin "hardcode\fastcod.prg" ,,2
endfcode
;=====
bmpasters


*=bmpasters +$0500
eofbmp
;================
nop
nop
CALCDELTA
          LDA #$00
		      STA SHIP_NR_ROT
          sta COUNT_AST
          sta COUNT_AST_ADR
CALCDELTA2
          LDY SHIP_NR_ROT
          LDA XPOZ,Y
          STA SHIP_DX
          LDA YPOZ,Y
          STA SHIP_DY
          LDA XSIGN,Y
          STA SHIP_STEP_X_SIGN
          LDA YSIGN,Y
          STA SHIP_STEP_Y_SIGN

          LDA #$00
          STA SHIP_STEP_X
          STA SHIP_STEP_Y

          LDY SHIP_DX
          CPY SHIP_DY
          TAY
          BCC DY_GORA
          CLC
DX_GORA
          INC SHIP_STEP_X
          ADC SHIP_DY
          CMP SHIP_DX
          BCC DX_GORA2
          SBC SHIP_DX
          INC SHIP_STEP_Y
          CLC
DX_GORA2
          PHA
          LDA SHIP_STEP_X
          STA XSTEPS,Y
          LDA SHIP_STEP_Y
          STA YSTEPS,Y
          PLA
          INY
          CPY #8
          BNE DX_GORA
          BEQ STORE_DELTASHIP
DY_GORA
          INC SHIP_STEP_Y
          ADC SHIP_DX
          CMP SHIP_DY
          BCC DY_GORA2
          SBC SHIP_DY
          INC SHIP_STEP_X
          CLC
DY_GORA2
          PHA
          LDA SHIP_STEP_X
          STA XSTEPS,Y
          LDA SHIP_STEP_Y
          STA YSTEPS,Y
          PLA
          INY
          CPY #8
          BNE DY_GORA
STORE_DELTASHIP
          LDA SHIP_NR_ROT
          ASL
          ASL
          ASL
          ASL
          TAY
          LDX #$00
-
          LDA XSTEPS,X
          STA TAB_DELTA,Y
          INY
          INX
          CPX #$10
          BCC -
		
          LDY SHIP_NR_ROT
          INY
          STY SHIP_NR_ROT
          CPY #$10
          BCS +
          JMP CALCDELTA2
+
          RTS
;=======
;USTAWIENIE ASTEROIDOW W PRZESUNIECIU O PIXEL

CREATEBMPAST
		
          LDX #$1f ;ILE BLOKOW
          LDA #<ASTERY
          STA STPLOT
          STA WRITEAST
          LDA #>ASTERY
          STA STPLOTHI
          STA WRITEASTHI

          LDA #$00
          TAY
-
          STA (WRITEAST),Y
          INY
          BNE -
          INC WRITEASTHI
          DEX
          BNE -
				
          LDA #>ASTERY
          STA WRITEASTHI

          LDX #4
		
          LDY #$08
-
          TXA
          PHA

          LDX COUNT_AST_ADR
          LDA WRITEAST
          STA TAB_AD_OBJ_LO,X
          CLC
          ADC #40
          STA WRITEAST
          LDA WRITEASTHI
          STA TAB_AD_OBJ_HI,X
          ADC #0
          STA WRITEASTHI
          INC COUNT_AST_ADR

          PLA
          TAX
          DEY
          BNE -
          LDY #$08
		
          LDA STPLOT
          CLC
          ADC #<1280
          STA STPLOT
          STA WRITEAST
          LDA STPLOTHI
          ADC #>1280
          STA STPLOTHI
          STA WRITEASTHI
          DEX
          BNE -

          LDX #2

          LDY #13
-
          TXA
          PHA
		
          LDX COUNT_AST_ADR
          LDA WRITEAST
          STA TAB_AD_OBJ_LO,X
          CLC
          ADC #24
          STA WRITEAST
          LDA WRITEASTHI
          STA TAB_AD_OBJ_HI,X
          ADC #0
          STA WRITEASTHI
          INC COUNT_AST_ADR
		
          PLA
          TAX
          DEY
          BNE -
          LDY #13
		
          LDA STPLOT
          CLC
          ADC #<640
          STA STPLOT
          STA WRITEAST
          LDA STPLOTHI
          ADC #>640
          STA STPLOTHI
          STA WRITEASTHI
          DEX
          BNE -

          LDY #6
-
          LDX COUNT_AST_ADR
          LDA WRITEAST
          STA TAB_AD_OBJ_LO,X
          CLC
          ADC #24
          STA WRITEAST
          LDA WRITEASTHI
          STA TAB_AD_OBJ_HI,X
          ADC #0
          STA WRITEASTHI
          INC COUNT_AST_ADR
		
          DEY
          BNE -

          LDY #11
-
          LDX COUNT_AST_ADR
          LDA WRITEAST
          STA TAB_AD_OBJ_LO,X
          CLC
          ADC #16
          STA WRITEAST
          LDA WRITEASTHI
          STA TAB_AD_OBJ_HI,X
          ADC #0
          STA WRITEASTHI
          INC COUNT_AST_ADR

          DEY
          BNE -


          LDA STPLOT
          CLC
          ADC #<(320+18*8)
          STA STPLOT
          STA WRITEAST
          LDA STPLOTHI
          ADC #>(320+18*8)
          STA STPLOTHI
          STA WRITEASTHI

          LDY #11
-
          LDX COUNT_AST_ADR
          LDA WRITEAST
          STA TAB_AD_OBJ_LO,X
          CLC
          ADC #16
          STA WRITEAST
          LDA WRITEASTHI
          STA TAB_AD_OBJ_HI,X
          ADC #0
          STA WRITEASTHI
          INC COUNT_AST_ADR

          DEY
          BNE -


          LDA STPLOT
          CLC
          ADC #176
          STA STPLOT
          STA WRITEAST
          LDA STPLOTHI
          ADC #0
          STA STPLOTHI
          STA WRITEASTHI

          LDY #10
-
          LDX COUNT_AST_ADR
          LDA WRITEAST
          STA TAB_AD_OBJ_LO,X
          CLC
          ADC #16
          STA WRITEAST
          LDA WRITEASTHI
          STA TAB_AD_OBJ_HI,X
          ADC #0
          STA WRITEASTHI
          INC COUNT_AST_ADR

          DEY
          BNE -

          LDA #$00
          STA COUNT_AST_ADR

CRBMP2
          LDX COUNT_AST ;ZAPISANIE ADRESU DO ODCZYTU
          LDA TAB_AD_LO_AST,X
          STA READAST
          LDA TAB_AD_HI_AST,X
          STA READASTHI
		
          LDX COUNT_AST_ADR ;ODCZYTANIE W TABLICY ADRESU OBIEKTU
          LDA TAB_AD_OBJ_LO,X
          STA WRITEAST
          LDA TAB_AD_OBJ_HI,X
          STA WRITEASTHI
          INC COUNT_AST_ADR
		
          LDX #4

          LDY #$00
-
          LDA (READAST),Y
          STA (WRITEAST),Y
          INY
          CPY #32
          BCC -
          LDY #$00
          JSR NEXTPASSASTER
          DEX
          BNE -
          LDA #7
          STA COUNTSLIDE
		
CRBMP3
          LDX COUNT_AST_ADR ;ODCZYTANIE W TABLICY ADRESU OBIEKTU
          DEX
          LDA TAB_AD_OBJ_LO,X
          STA READAST
          LDA TAB_AD_OBJ_HI,X
          STA READASTHI
          INC COUNT_AST_ADR

          INX
          LDA TAB_AD_OBJ_LO,X
          STA WRITEAST
          LDA TAB_AD_OBJ_HI,X
          STA WRITEASTHI

		
          LDX #4
          LDY #$00
		
- 		    LDA (READAST),Y
          LSR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          TYA
          SEC
          SBC #32
          TAY
          INY
          CPY #8
          BCC -
          LDY #$00
          JSR NEXTPASSASTER
          DEX
          BNE -
		
          DEC COUNTSLIDE
          BNE CRBMP3

          INC COUNT_AST
          LDA COUNT_AST
          CMP #4 ;12
          BCS +
          JMP CRBMP2 ;ZAPIZANIE 32CH OBIEKT�W DU�YCH
	;----------------------
+

CRBMP2A

          LDX COUNT_AST ;ZAPISANIE ADRESU DO ODCZYTU
          LDA TAB_AD_LO_AST,X
          STA READAST
          LDA TAB_AD_HI_AST,X
          STA READASTHI
		
          LDX COUNT_AST_ADR ;ODCZYTANIE W TABLICY ADRESU OBIEKTU
          LDA TAB_AD_OBJ_LO,X
          STA WRITEAST
          LDA TAB_AD_OBJ_HI,X
          STA WRITEASTHI
          INC COUNT_AST_ADR

          LDX #2

          LDY #$00
-
          LDA (READAST),Y
          STA (WRITEAST),Y
          INY
          CPY #16
          BCC -
          LDY #$00
          JSR NEXTPASSASTER
          DEX
          BNE -
          LDA #7
          STA COUNTSLIDE
CRBMP3A

	;=========
          LDX COUNT_AST_ADR ;ODCZYTANIE W TABLICY ADRESU OBIEKTU
          DEX
          LDA TAB_AD_OBJ_LO,X
          STA READAST
          LDA TAB_AD_OBJ_HI,X
          STA READASTHI
          INC COUNT_AST_ADR
		
          INX
          LDA TAB_AD_OBJ_LO,X
          STA WRITEAST
          LDA TAB_AD_OBJ_HI,X
          STA WRITEASTHI
	;=========
          LDX #2
          LDY #$00
		
-		    LDA (READAST),Y
          LSR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          TYA
          SEC
          SBC #16
          TAY
          INY
          CPY #8
          BCC -
          LDY #$00
          JSR NEXTPASSASTER
          DEX
          BNE -

          DEC COUNTSLIDE
          BNE CRBMP3A


          INC COUNT_AST
          LDA COUNT_AST
          CMP #8 ;12
          BCS +
          JMP CRBMP2A ;ZAPIZANIE 32CH SREDNICH DU�YCH
	;--------------
+
CRBMP2B

          LDX COUNT_AST ;ZAPISANIE ADRESU DO ODCZYTU
          LDA TAB_AD_LO_AST,X
          STA READAST
          LDA TAB_AD_HI_AST,X
          STA READASTHI
		
          LDX COUNT_AST_ADR ;ODCZYTANIE W TABLICY ADRESU OBIEKTU
          LDA TAB_AD_OBJ_LO,X
          STA WRITEAST
          LDA TAB_AD_OBJ_HI,X
          STA WRITEASTHI
          INC COUNT_AST_ADR

          LDY #$00
-
          LDA (READAST),Y
          STA (WRITEAST),Y
          INY
          CPY #8
          BCC -

          LDA #7
          STA COUNTSLIDE
		
CRBMP3B

	;=========
          LDX COUNT_AST_ADR ;ODCZYTANIE W TABLICY ADRESU OBIEKTU
          DEX
          LDA TAB_AD_OBJ_LO,X
          STA READAST
          LDA TAB_AD_OBJ_HI,X
          STA READASTHI
          INC COUNT_AST_ADR

          INX
          LDA TAB_AD_OBJ_LO,X
          STA WRITEAST
          LDA TAB_AD_OBJ_HI,X
          STA WRITEASTHI
	;=========
          LDY #$00
		
-		    LDA (READAST),Y
          LSR
          STA (WRITEAST),Y
          PHP
          TYA
          CLC
          ADC #8
          TAY
          PLP

          LDA (READAST),Y
          ROR
          STA (WRITEAST),Y
          TYA
          SEC
          SBC #8
          TAY
          INY
          CPY #8
          BCC -

          DEC COUNTSLIDE
          BNE CRBMP3B


          INC COUNT_AST
          LDA COUNT_AST
          CMP #12 ;12
          BCS +
          JMP CRBMP2B ;ZAPIZANIE 32CH MALYCH DU�YCH
          RTS
	;-------
+
          RTS
;=====================
NEXTPASSASTER
          LDA READAST
          CLC
          ADC #$40
          STA READAST
          LDA READASTHI
          ADC #1
          STA READASTHI

          LDA WRITEAST
          CLC
          ADC #$40
          STA WRITEAST
          LDA WRITEASTHI
          ADC #1
          STA WRITEASTHI
          RTS
;=============

emksp
;=============
g_over
!binary "gfx\gameover.bin",,2
coinbmp
!binary "gfx\1coin.bin",,2
hscore
!binary "gfx\hscore.bin",,2
enndcrunchdata


;================
;SPRITE DATA SHIP
;================
* = RAMCOLOR+$0400
adyspr
!binary "gfx\sprites7.PRG",,2
eof_sprites
!byte 0,0
!align 255,0
viewcounter ;2 sprajty na licznik
*=viewcounter+128
sandanim
!binary "gfx\spritplots.PRG",,2
esandan

*= $7980
cset16
!bin "gfx\16pixchar.bmpC64",$500,0
cset8
!binary "gfx\8pixchar.bmpC64",216,0
endrsc
tblo16char
!byte <(cset16 +  0*16)
!byte <(cset16 +  1*16)
!byte <(cset16 +  2*16)
!byte <(cset16 +  3*16)
!byte <(cset16 +  4*16)
!byte <(cset16 +  5*16)
!byte <(cset16 +  6*16)
!byte <(cset16 +  7*16)
!byte <(cset16 +  8*16)
!byte <(cset16 +  9*16)
!byte <(cset16 + 10*16)
!byte <(cset16 + 11*16)
!byte <(cset16 + 12*16)
!byte <(cset16 + 13*16)
!byte <(cset16 + 14*16)
!byte <(cset16 + 15*16)
!byte <(cset16 + 16*16)
!byte <(cset16 + 17*16)
!byte <(cset16 + 18*16)
!byte <(cset16 + 19*16)

!byte <(cset16+640 +  0*16)
!byte <(cset16+640 +  1*16)
!byte <(cset16+640 +  2*16)
!byte <(cset16+640 +  3*16)
!byte <(cset16+640 +  4*16)
!byte <(cset16+640 +  5*16)
!byte <(cset16+640 +  6*16)
!byte <(cset16+640 +  7*16)

tbhi16char
!byte >(cset16 +  0*16)
!byte >(cset16 +  1*16)
!byte >(cset16 +  2*16)
!byte >(cset16 +  3*16)
!byte >(cset16 +  4*16)
!byte >(cset16 +  5*16)
!byte >(cset16 +  6*16)
!byte >(cset16 +  7*16)
!byte >(cset16 +  8*16)
!byte >(cset16 +  9*16)
!byte >(cset16 + 10*16)
!byte >(cset16 + 11*16)
!byte >(cset16 + 12*16)
!byte >(cset16 + 13*16)
!byte >(cset16 + 14*16)
!byte >(cset16 + 15*16)
!byte >(cset16 + 16*16)
!byte >(cset16 + 17*16)
!byte >(cset16 + 18*16)
!byte >(cset16 + 19*16)

!byte >(cset16+640 +  0*16)
!byte >(cset16+640 +  1*16)
!byte >(cset16+640 +  2*16)
!byte >(cset16+640 +  3*16)
!byte >(cset16+640 +  4*16)
!byte >(cset16+640 +  5*16)
!byte >(cset16+640 +  6*16)
!byte >(cset16+640 +  7*16)
;==============================

;===================
sss
;========
          *= $8000
decrunch
!binary "hardcode\decr8000.prg",,2
dcrend
wyniki

wynik1
          !byte 0,0,0,0,2,10,0,19
wynik2
          !byte 0,0,0,2,0,14,1,8
wynik3
          !byte 0,0,0,0,4,7,0,13
wynik4
          !byte 0,0,0,0,6,3,0,13
wynik5
          !byte 0,0,0,0,8,$0b,$14,$0a
wynik6
          !byte 0,0,0,1,0,0,$11,2
wynik7
          !byte 0,0,0,1,2,1,4,$0d
wynik8
          !byte 0,0,0,1,4,12,8,0
wynik9
          !byte 0,0,0,1,6,$0b,$0e,$13
wynik10
          !byte 0,0,0,1,8,$0e,0,$12
wynik11
          !byte 0,0,0,0,3,0,0,0
tbfindscore
          !byte 0,0,0,0,0,0,0,0,0,0,0
manyfind
          !byte 0
mainscores
          !byte 0,0,0,0,0,0,0,0,0,0,0
findplaces
          !byte 0
myplace
          !byte 0
;========

;--
sidinit
          ldx #$1f
          lda #$00
          sta $d400,x
          dex
          bpl *-4
          rts

;===
STARTGAME

          ldx #$ff
          txs

          lda #0
          sta $d020
          sta $d021
          tax
          tay
          TAY

          lda #$0b
          sta $d011

          lda #$C4
          cmp $d012
          bne *-3
          cmp $d012
          beq *-3
          cmp $d012
          bne *-3

          LDA #$10
CLR
          STA RAMCOLOR,Y
          STA RAMCOLOR+$0100,Y
          STA RAMCOLOR+$0200,Y
          STA RAMCOLOR+$0300,Y
          INY
          BNE CLR

          lda #$00
          ldx #$f0
-        sta $01,x
          dex
          bne -
;===
          LDA #>SCREEN
          STA $8E
          LDA #<SCREEN
          STA $8D
CALC
          LDA $8D
          STA $8B
          STA TABLO,Y
          LDA $8E
          STA $8C
          STA TABHI,Y
          INY
          LDX #$07
CALC2
          INC $8B
          BNE *+4
          INC $8C
          LDA $8B
          STA TABLO,Y
          LDA $8C
          STA TABHI,Y
          INY
          DEX
          BNE CALC2
          LDA $8D
          CLC
          ADC #$40
          STA $8D
          LDA $8E
          ADC #$01
          STA $8E
          CPY #0
          BNE CALC
          STY $8B

CALC3
          LDX #$08
          LDA $8B
CALC4
          STA TABXM,Y
          INY
          DEX
          BNE CALC4
          CLC
          ADC #8
          STA $8B
          BCC CALC3
          STX XA
          STX XAHI
          STX YA

          lda $d015
          ora #1
          STA $D015
          lda #1
          STA $D027

          JSR INITPOZSHIP

          LDA #0
          STA IRQCNTR
;============================

;===	ZROBIENIE TABELKI BITOW DLA PLOTA
          LDA #$00
          TAX
          TAY
          SEC
-
          ROR
          BNE +
          ROR
+
          STA TBBIT,X
          INX
          BNE -

;========= ZROBIENIE TABELKI PREDKOSCI
          TXA
-
          TYA
          STA TAB_FAST ,X
          INX

          TXA
          CMP TAB_SPEED+1,Y
          BCC +
          INY
+
          CPX #$00
          BNE -
          lda firstpic
          and #$3f
          tax
          lda secpict
          and #$3f
          tay

          lda #<bmpasters
          sta firstpic,x
          sta secpict,y
          inx
          iny
          lda #>bmpasters
          sta firstpic,x
          sta secpict,y

          ;jsr initvic

          lda #$02
          sta $dd00
          lda #$80
          sta $d018


          sei
          lda #$7f
          sta $dd0d
          LDA #<stopnmi
          STA $FFFa
          LDA #>stopnmi
          STA $FFFb
          lda #$00
          sta $d418
          sta UFO_kula
          sta lives
          sta is_UFO
          STA $D01B
          sta $d015

          ldx #5
-
          sta scores,x
          dex
          bpl -

          jsr bezpylu
          lda ufosound
          sta $0f
          lda UFOSTARTKULA
          sta $0e
          lda #$60
          sta ufosound
          sta UFOSTARTKULA

          lda #$7f
          sta $dd0d
          lda #0
          sta $d01a
          lda #<msxnmi
          ldx #>msxnmi
          sta $fffe
          stx $ffff

          lda #$0b
          sta $d011
          lda #1
          ldx #7
          sta $d027,x
          dex
          bpl *-4

          ldx #$ff
          txs
          lda #<muzyka
          ldy #>muzyka
muzz      jsr decrunch
nosid     jsr sidinit
          lda #$20
          sta muzz
          sta nosid

          lda #$0f
          sta $d418

          bit $d011
          bmi *-3
          bit $d011
          bpl *-3

          lda #$c7 ;c7
          sta $dc04
          lda #$4c
          sta $dc05
          lda #$11
          sta $dc0e
          lda #$81
          sta $dc0d
          bit $dc0d
          lda #0
          sta $d01a
          inc $d019

          cli


          lda #<logos
          ldy #>logos
nologos
          jsr decrunch
          lda #$20
          sta nologos


          lda #$3b
          sta $d011



          lda #<firstpic
          ldy #>firstpic
          jsr decrunch

difway=*+1
          lda #$00
          inc difway
          and #$01
          beq +
          lda #<secpict
          ldy #>secpict
          jsr decrunch
+
          JSR CALCDELTA
          JSR ZROB_SPRAJTY
zamknijlogo
          bit closelogo
-
          lda #$ff
          cmp $dc01
          beq +
          cmp $dc01
          bne *-3
          jmp closelogo
+        lda $dc00
          and #$10
          bne -
          lda $dc00
          cmp $dc00
          beq *-3


closelogo
          lda #$2c
          sta zamknijlogo
          lda $0f
          sta ufosound
          lda $0e
          sta UFOSTARTKULA
          lda #$ff
          sta $d01b
          lda #$00
          sta $d015
          jsr sidinit

          lda #$7f
          sta $dd0d
          sta $dc0d
          bit $dc0d
          lda #<NMIEX
          sta $fffa
          lda #>NMIEX
          sta $fffb
          lda #$01
          sta nmicounter
          sta $d01a
          inc $d019
          lda #<IRQ_IDLE
          sta $fffe
          lda #>IRQ_IDLE
          sta $ffff
          lda #$ff ;c7
          sta $dd04
          lda #$ff
          sta $dd05
          sta $dd04
          lda #$11
          sta $dd0e
          lda #$81
          sta $dd0d
          bit $dd0d
          cli


          jsr ufostopsound
          JSR CREATEBMPAST

          LDA #$00
          STA USED_KUL
          sta is_UFO
          sta rozbij_UFO
          sta ufo_model_poz

          LDX #$0F
-
          STA XSTEPS,X
          DEX
          BPL -


          JSR INITPOZSHIP
          lda #0
          sta $d015
          bit $d011
          bpl *-3
          lda #$0b
          sta $d011
          JSR CLEARSCREEN
          lda #$3b
          sta $d011
          lda #$10
-
          sta $6000,x
          sta $6100,x
          sta $6200,x
          sta $6300,x
          inx
          bne -
          stx nmicounter

          jsr startheartb

;************************************


          ;wyzerowanie licznika punktow
          ;i 3 zycia
          lda #0
          sta lives

          ldx #5
-
          lda #0
          sta scores,x
          dex
          bpl -

          jsr bezpylu
;============ bez zerowania licznika i dodawania żyć
          sei
          LDX #$FF
          TXS

          bit $d011
          bpl *-3
          sei

          LDA #$3B
          STA $D011
          INC $D019
          LDA #0
          STA IRQCNTR
          ;sta ufo_model_poz
          inc IRQCNTR
          lda #0
          sta rozbij_UFO
          sta USED_KUL
          ldx #3
-
          sta KULA0,x
          dex
          bpl -
          ;JSR CLEARSCREEN
          ldx #$7f
          lda #$00
-         sta viewcounter,x
          dex
          bpl -
          ldx #$00
          jsr malujscore

          lda #55
          sta $d00b
          sta $d00d
          sta $d00a
          clc
          adc #24
          sta $d00c
          lda $d010
          ora #$60
          eor #$60
          sta $d010
          lda #$d4
          sta SPRIT0+5
          clc
          adc #1
          sta SPRIT0+6
          lda $d015
          ora #$60
          sta $d015

          lda #1
          sta $d02c
          sta $d02d

          SEI
          CLD
          LDX #$FF
          TXS



;JSR INITPOZSHIP ;!!! tu moze sprawdzic co ustawic
;bo czasami statek rusza po restarcie

          lda #many_started_objects
          sta MANY_OBJ
jsr rozstaw_astery
          LDA $D01E ;skasuj znaczniki kolizji
          LDA $D01F
          INC $D019
notcoin
          jmp ustaw_coinirq
          lda #$4c
          sta notcoin

          jsr disable_ufo
          jsr startheartb
f_beat = *+1
          lda #$80
          jsr setfastbeat
          jsr disable_ufo
ufo_model_poz2=*+1
          lda #0
          sta ufo_model_poz
          lda #0
          sta ufo_model_poz2
          lda #1
          sta nmicounter

;************************************
RELOAD
          JSR INITPOZSHIP
          ;wyzerowanie licznika punktow
          ;i 3 zycia
many_lv=*+1
          lda #many_lives
          sta lives
          lda #many_lives
          sta many_lv


          ldx #5
-
          lda #0
          sta scores,x
          dex
          bpl -
restscores
          jmp skip2
          lda #$4c
          sta restscores
          ldx #5
-
          lda oldscore,x
          sta scores,x
          dex
          bpl -

skip2
          jsr bezpylu
;============ bez zerowania licznika i dodawania żyć
SKIP
          sei
          lda MANY_OBJ
          bne +
-        lda many_start_obj
          sta MANY_OBJ
          jsr rozstaw_astery
+        lda MANY_OBJ
          bmi -


          LDX #$FF
          TXS

          bit $d011
          bpl *-3
          sei
          LDA #<IRQ_IDLE
          STA $FFFE
          LDA #>IRQ_IDLE
          STA $FFFF
          LDA #$3B
          STA $D011
          INC $D019
          LDA #0
          STA IRQCNTR
          ;sta ufo_model_poz

          lda #0
          sta rozbij_UFO
          sta USED_KUL
          ldx #3
-
          sta KULA0,x
          dex
          bpl -
          ;JSR CLEARSCREEN
          ldx #$7f
          lda #$00
-         sta viewcounter,x
          dex
          bpl -
          cli
          ldx #$00
          jsr malujscore

          lda #55
          sta $d00b
          sta $d00d
          sta $d00a
          clc
          adc #24
          sta $d00c
          lda $d010
          ora #$60
          eor #$60
          sta $d010
          lda #$d4
          sta SPRIT0+5
          clc
          adc #1
          sta SPRIT0+6
          lda $d015
          ora #$60
          sta $d015

          lda #1
          sta $d02c
          sta $d02d

          SEI
          CLD
          LDX #$FF
          TXS


;JSR INITPOZSHIP ;!!! tu moze sprawdzic co ustawic
;bo czasami statek rusza po restarcie


          LDA $D01E ;skasuj znaczniki kolizji
          LDA $D01F
          INC $D019

          CLI

          ;JMP *

;===
; setasteroids
          sei
          jsr rozstaw_astery
;===
          ldx #0
          lda asternr
          pha
-         lda asternr+1,X
          sta asternr,X
          inx
          cpx #11
          bne -
          pla
          sta asternr+11
-
          lda astdx,X
          eor #$ff
          clc
          adc #1
          sta astdx,X

          lda astdy,X
          eor #$ff
          clc
          adc #1
          sta astdy,X
          dex
          bpl -
;=========
many_start_obj = *+1

          LDA #many_started_objects
          STA MANY_OBJ
          LDA #$00
          STA ACT_OBJ
;--***
!if noobjects = 0 {
          jsr zapal_astery
}

;===
          sei
          lda #<IRQ
          sta $fffe
          lda #>IRQ
          sta $ffff
silent_mode
          jsr getfastbeat
          pha
          jsr startheartb
          pla
          jsr setfastbeat
          cli
;===
!if noobjects = 1 {
          jmp *
}
;===
RETIME

          LDA IRQCNTR
          STA WAIT_IRQ
-
SEI

          LDX ACT_OBJ
          JSR IS_LIVE

          LDX ACT_OBJ
          lda TBOBJ_MAX_Y,x
          clc
          adc #200
          sta MAXIYPOZ

          lda TBOBJ_DY,X
          bpl dy_plus
dy_minus
          eor #$ff
          clc
          adc #1
          sta degres_dyx

          lda TBOBJ_M_Y,X
          sec
          sbc degres_dyx
          bcs +
          adc MAXIYPOZ
          jmp +
dy_plus
          CLC
          adc TBOBJ_M_Y,X


          CMP MAXIYPOZ
          BCC +
          SBC MAXIYPOZ
+        STA TBOBJ_M_Y,X
          lda #0
          sta TBOBJ_FROM_COLUMN,x
          lda TBOBJ_MAX_Y,x
          clc
          adc #1
          lsr
          lsr
          lsr
          sta TBOBJ_TO_COLUMN,x
;===
          lda TBOBJ_DX,x
          bpl dx_plus
dx_minus
          eor #$ff
          clc
          adc #1
          sta degres_dyx
          lda TBOBJ_X_LO,X
          sec
          sbc degres_dyx
          sta TBOBJ_X_LO,x
          lda TBOBJ_X_HI,X
          sbc #0
          sta TBOBJ_X_HI,X
          bpl +
          lda #$40
          clc
          adc TBOBJ_MAX_Y,x
          adc TBOBJ_X_LO,x
          sta TBOBJ_X_LO,x
          lda TBOBJ_X_HI,x
          adc #1
          sta TBOBJ_X_HI,x
          jmp +
dx_plus
          clc
          adc TBOBJ_X_LO,X
          sta TBOBJ_X_LO,X
          lda TBOBJ_X_HI,x
          adc #0
          sta TBOBJ_X_HI,x
+        lda TBOBJ_X_HI,x
          beq no_big_xposs
          lda TBOBJ_MAX_Y ,x
          clc
          adc #$40 ;5555 ;!!! bylo #$41 ale lepiej jest
          cmp TBOBJ_X_LO,x
          bcs +
          lda #0
          sta TBOBJ_X_LO,x
          sta TBOBJ_X_HI,x
          beq no_big_xposs
+        lda TBOBJ_X_HI,x
          beq +
big_x_poss
          lda #$40 ;!! było #$3f ale lepeij jest
          sec
          sbc TBOBJ_X_LO,x
          cmp TBOBJ_MAX_Y,x
          bcs +
          lsr
          lsr
          lsr
          sta TBOBJ_TO_COLUMN,X
;=== dla dużych x powyżej 320
+
          lda TBOBJ_X_LO,X
          sec
          sbc #$40
          bcc no_big_xposs
osos
          lsr
          lsr
          lsr
          sta TBOBJ_FROM_COLUMN,x
          lda TBOBJ_MAX_Y,x
          lsr
          lsr
          lsr
          sbc TBOBJ_FROM_COLUMN,x
          sta TBOBJ_FROM_COLUMN,x
          inc TBOBJ_FROM_COLUMN,x
;777
no_big_xposs
          JSR MOVE_OBJECTS
          INC ACT_OBJ
          LDA ACT_OBJ
          CMP MANY_OBJ
          BNE +
overload
          LDA #$00
          STA ACT_OBJ
          CLI
TIME_WAIT
          LDY WAIT_IRQ
          CPY IRQCNTR
          BEQ TIME_WAIT
          INY
          CPY IRQCNTR
          BEQ TIME_WAIT
          INY
          CPY IRQCNTR
          BEQ TIME_WAIT
          INY
          CPY IRQCNTR
          BEQ TIME_WAIT
          JMP RETIME
+

;cmp #12
;bcs overload
          CLI
          JMP -
;===========
zapal_astery

ldx many_start_obj
lda MANY_OBJ
bne ovld2
-
stx MANY_OBJ
jsr rozstaw_astery
ldx many_start_obj
lda MANY_OBJ
ovld2
bmi -

          ldx MANY_OBJ
          stx ACT_OBJ
-
          LDX ACT_OBJ
          dex
          lda TBOBJ_MAX_Y,x
          clc
          adc #1
          lsr
          lsr
          lsr
          sta TBOBJ_TO_COLUMN,x
          lda #0
          sta TBOBJ_FROM_COLUMN,x

          JSR MOVE_OBJECTS
          DEC ACT_OBJ
          BNE -
          rts
;==========
rozstaw_astery

ldx many_start_obj
lda MANY_OBJ
bne *+4
stx MANY_OBJ

          ldx #11
-
          lda tbast + 0*12,x
          sta TBOBJ_M_Y,x
          lda tbast + 1*12,x
          sta TBOBJ_X_LO,x
          lda tbast + 2*12,x
          sta TBOBJ_X_HI,x
          lda tbast + 3*12,x
          sta TBOBJ_DX,x
          lda tbast + 4*12,x
          sta TBOBJ_DY,x
          lda tbast + 5*12,x
          sta TBOBJ_NR,x
          lda #31
          sta TBOBJ_MAX_Y,x
          dex
          bpl -
          rts
;===========
IRQ_IDLE
          inc $d019
          bit $dc0d

          rti
;===========
MOVE_OBJECTS	;W X NR OBIEKTU
;===
;CONVERT_TO_SCREEN 	; KONWERSJA POZYCJI ASTERA DO WSPOLRZEDNYCH EKRANOWYCH


          LDA TBOBJ_M_Y,X
          CMP TBOBJ_MAX_Y,X
          BCS +
          ;MODYFIKACJA FROM_LINE = (TO_LINE - M_Y) , TO_LINE = MAX_Y , POZYCJA Y = 0
          LDA TBOBJ_MAX_Y,X
          STA TBOBJ_TO_LINE,X
          STA TO_LINE
          SEC
          SBC TBOBJ_M_Y,X
          STA TBOBJ_FROM_LINE,X
          STA FROM_LINE
          LDA #$00
          STA TBOBJ_Y,X
;========
; USTALENIE ADRESU - "COFNIECIE" BITMAPY O ADRES DO FROM_LINE
; TRANSLACJA ADRESU DLA "COFNIECIA ADRESU BITMAPY"
;========

          LDA #<SCREEN
          clc
          LDY TBOBJ_X_LO,X
          ADC TABXM,Y
          STA WRITEAST

          LDA #>SCREEN
          ADC TBOBJ_X_HI,X
          STA WRITEASTHI
;333
          lda TBOBJ_X_HI,X
          beq norefresh
          lda TBOBJ_X_LO,X
          cmp #$40
          bcc norefresh
          lda #<SCREEN
          STA WRITEAST
          lda #>SCREEN
          STA WRITEASTHI
norefresh
          LDA FROM_LINE ; ZMIANA LINII DO ILOSCI WIERSZY LNIA/8
          LSR
          LSR
          LSR
          TAY
          LDA FROM_LINE ; LINIA W NOWYM WIERSZU - RESZTA Z DZIELENIA PRZEZ 8
          AND #$07		; I MODULO 7
          EOR #$07
          ORA WRITEAST
          SEC
          SBC ODDAJ_LINIE_LO,Y
          STA WRITEAST
          STA TBOBJ_SCREEN_LO,X
		
          LDA WRITEASTHI
          SBC ODDAJ_LINIE_HI,Y
          STA WRITEASTHI
          STA TBOBJ_SCREEN_HI,X
go_set_copy
          JMP SET_COPY ;USTALIC GDZIE W PRZYADKU PROCY AUTOMATYCZNEJ
;==
+
          CMP #200
          BCC +
          SBC TBOBJ_MAX_Y,X	; POWYZEJ 200 Y = M_Y-MAX_Y, FROM_L = 0, TO_L = 199 - Y
          STA TBOBJ_Y,X
          LDA #$00
          STA TBOBJ_FROM_LINE,X
          STA FROM_LINE
          LDA #199
          SEC ;- CARY IS SET
          SBC TBOBJ_Y,X
          STA TBOBJ_TO_LINE,X
          STA TO_LINE


          JMP USTAL_SCREEN_AD

+
          SEC		; POMIEDZY MAX NAJCZESTSZY PRZYPADEK Y = M_Y-MAX_Y, FROM_L = 0, TO_L = MAX_Y
          SBC TBOBJ_MAX_Y,X
          STA TBOBJ_Y,X
          LDA TBOBJ_MAX_Y,X
          STA TBOBJ_TO_LINE,X
          STA TO_LINE
          LDA #$00
          STA TBOBJ_FROM_LINE,X
          STA FROM_LINE

USTAL_SCREEN_AD ;USTALENIE ADRESU ZAPISU ASTEROIDY NA EKRAN

          LDY TBOBJ_Y,X

          LDA TABHI,Y
          CLC
          ADC TBOBJ_X_HI,X
          STA WRITEASTHI
          LDA TABLO,Y
          LDY TBOBJ_X_LO,X
          ADC TABXM,Y
          STA WRITEAST
          STA TBOBJ_SCREEN_LO,X
          BCC +
          INC WRITEASTHI
+
          LDA WRITEASTHI
          STA TBOBJ_SCREEN_HI,X

          lda TBOBJ_X_HI,x
          beq SET_COPY
          lda TBOBJ_X_LO,x
          cmp #$40
          bcc SET_COPY

          LDY TBOBJ_Y,X

          LDA TABHI,Y
          STA WRITEASTHI
          STA TBOBJ_SCREEN_HI,X
          LDA TABLO,Y
          STA WRITEAST
          STA TBOBJ_SCREEN_LO,X
          JMP SET_COPY

IS_LIVE
          ;SKOPIOWANIE ADRESU EKRANU (ZA DRUGIM RAZEM PRZY KASOWANIU) !!! POPRAWIC
          LDA TBOBJ_SCREEN_LO,X
          STA WRITEAST
          LDA TBOBJ_SCREEN_HI,X
          STA WRITEASTHI

          LDA TBOBJ_FROM_LINE,X
          STA FROM_LINE
          LDA TBOBJ_TO_LINE,X
          STA TO_LINE
;===
SET_COPY
;===
		     ;USTALENIE ADRESU KOPII WLASCIWEJ DLA X

          LDA TBOBJ_X_LO,X
          AND #$07
          ora TBOBJ_NR,X
          TAY
;!!! 999 experymentalne ust X

          LDA TAB_AD_OBJ_LO,Y
          STA READAST
          LDA TAB_AD_OBJ_HI,Y
          STA READASTHI


          LDA TBOBJ_TO_COLUMN,X;
          STA TO_COLUMN
          lda TBOBJ_X_LO,X
          and #7
          bne *+4
          dec TO_COLUMN ;co 8my pixel 4 kolumny

          ;zliczać prawdziwe kolumny do narzucenia
          lda TBOBJ_X_HI,x
          beq +

          lda TBOBJ_X_LO,x
          cmp #$40
          bcc testkolumny
          lda TBOBJ_MAX_Y,x
          adc #0
          jmp ustal_kolumne
testkolumny
          adc TBOBJ_MAX_Y,x
          cmp #$40
          bcc +
kasuj_kolumne
          lda #$3f
          sec
          sbc TBOBJ_X_LO,x
ustal_kolumne
          lsr
          lsr
          lsr
          sta TO_COLUMN
+

          LDA TBOBJ_FROM_COLUMN,X ; OBLICZENIE POCZATKOWEJ WARTOSCI OFFSETU W X DLA KOLUMNY
          STA FROM_COLUMN
          BEQ +
          ASL
          ASL
          ASL
          CLC ;- CARRY AFTER ASL IS CLEAR
          ADC READAST
          STA READAST
          BCC +
          CLC
          INC READASTHI
+
          LDA WRITEAST
          AND #$07
          TAY

          LDA TB_AD_NARZ_LO,Y
          STA M_AD_CALL
          LDA TB_AD_NARZ_HI,Y
          STA M_AD_CALL+1

M_AD_CALL = *+1
          JMP $1111
;===========
;===== Paragraph @KEYBOARD@ =====

;=== $dc01 read - test bit from Joy Port #2
;AND #$01 GORA - GAZ
;AND #$02 W Dӣ NIEUZYTE
;AND #$04 W LEWO - OBROTY W LEWO
;AND #$08 W PRAWO - OBROTY W LEWO
;AND #$10 FIRE
;===
KEYBOARD
          LDA IRQCNTR
          AND #$0F
          CMP #3
          BEQ KEY5
          CMP #9
          BEQ KEY5
          CMP #14
          BEQ KEY5
          RTS
KEY5
          LDA KEYTEST
          AND #$08 ;RIGT JOY KEY ROTATE SHIP
          BNE KEY6 ;NEXT KIER SPRITE
          LDY SHIP_NR_ROT
          INY
KEY5A
          LDA IGNORE_KOLIZJA ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          BNE KEY5B
          TYA
          AND #$0F
          TAY
          STA SHIP_NR_ROT
          CLC
          ADC #BANKSHIP
          STA SPRIT0
KEY5B
          LDA KEYTEST
          AND #$01 ;GAZ WDUSZONY?
          BEQ +
          JSR SETCHANGESHIP ;JAK GAZ NIEWDUSZONY TO TYLKO ZMIANA POZYCJI STATKU
          JMP KEY7
+
          JSR CHANGESHIP_ALL_SLOW ;GAZ WDUSZONY ZMIANA TRAJEKTORII
          JMP KEY7 ;OMIN KEY6
KEY6
          LDA KEYTEST
          AND #$04	;LEFT JOY KEY ROTATE SHIP
          BNE KEY7
          LDY SHIP_NR_ROT
          DEY
          JMP KEY5A
KEY7
          ;LDA KEYTEST
          LDA $DC01
          AND #$80	;RUN STOP - DOCELOWA DROGA STATKU
          BNE KEY8
          sei

          lda #many_started_objects
          sta many_start_obj
          JMP STARTGAME
KEY8
          RTS


;=================
;=== Paragraph @TABLICE_TRAS_I_OFSETOW_STARTOWYCH_KUL@ -----


!ALIGN 255,0

;====
;===== Paragraph @SETCHANGESHIP@ =====
SETCHANGESHIP
          LDA SHIP_SPEED
          BEQ CHANGESHIP_ALL ;JAK STOI ZMIANA CALKOWITA
          RTS
;===== Paragraph @WDUSZONY GAZ@ =====

WDUSZONY_GAZ
          DEY
          TYA
          AND #$0F
          TAY
          CPY NEWSHIP_NR_ROT; JAK ZMIANA O 1 SKOK - AKTUALIZUJ NATYCHMIAST
          BEQ CHANGESHIP_ALL_SLOW
          CLC
          ADC #$02
          AND #$0F
          TAY
          CPY NEWSHIP_NR_ROT; JAK ZMIANA O 1 SKOK - AKTUALIZUJ NATYCHMIAST
          BEQ CHANGESHIP_ALL_SLOW
          LDA SHIP_SPEED
          BEQ CHANGESHIP_ALL
          LDA #1
          STA WYTRACAJ
          LDY SHIP_NR_ROT
          LDA #7
          STA COUNT_WYTR
          RTS
;=====
;===== Paragraph @CHANGESHIP_ALL_LOW_SPEED@ =====
CHANGESHIP_ALL_SLOW

          lda IRQCNTR
          and #$07
          beq *+3
          rts
          LDA SHIP_SPEED
          CMP #5
          BCC +
          LDX #60
          STX DAJ_GAZU
          LDA TAB_FAST,X
          STA SHIP_SPEED
+
CHANGESHIP_ALL

          LDY SHIP_NR_ROT
          STY NEWSHIP_NR_ROT
          LDA XPOZ,Y
          STA SHIP_DX
          LDA YPOZ,Y
          STA SHIP_DY
          LDA XSIGN,Y
          STA SHIP_STEP_X_SIGN
          LDA YSIGN,Y
          STA SHIP_STEP_Y_SIGN

          TYA
          ASL
          ASL
          ASL
          ASL

          STA OFFS_XSTEP ;ADRES DO DANYCH W TABELCE 256BYTE LOW ADRES
          ADC #8
          STA OFFS_YSTEP
          RTS
;====
;=====
PLOT
          LDX XA
          LDY YA
;========
PLOT2
          LDA TABHI,Y
          CLC
          ADC XAHI
          STA STPLOTHI
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          RTS
;===============================
;========== IRQ LOOP ===========
;===============================
;===

;===
;===== Paragraph @IRQ@ =====
IRQ
          PHA
          INC $D019
          INC IRQCNTR
          STX XREG
          STY YREG
          lda lives
          bne +
          jmp ustaw_silent
+
          lda $d015
          ora #1
          sta $d015

          lda IRQCNTR
          and #$1f
          bne +
          jsr getfastbeat
          cmp #$b8
          bcs +
          adc #1
          jsr setfastbeat
+
          LDA $DC00
          CMP KEYTEST
          BEQ +
          LDX KEYTEST
          STX KEY_OLD
          STA KEYTEST
+
          and #2
          bne ufoservice
          lda IGNORE_KOLIZJA
          bne ufoservice
          jmp makehidden
;============
ufoservice
          JSR KOLIZJA_TEST

          jsr szukajkolizjiufo
          LDA IGNORE_KOLIZJA ;JAK ROZBICIE STATKU NIE MA OBSLUGI GAZU I JAZDY
          BNE +     ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          JSR KEYBOARD
          JSR TEST_GAZ
          JSR MOVESHIP

+
          jsr move_UFO
          JSR TESTSTRZAL
          JSR STARTKULA
          jsr rozbijaj_UFO

          jsr ZAPAL_SPRAJTY ;jeżeli wybuch wstawia animke

          JSR cnt_msx
;===========
          jsr enable_ufo
goback
YREG = *+1
          LDY #$00
XREG = *+1
          LDX #$00
          PLA
          RTI
NMIEX

          pha
          txa
          pha
          bit $dd0d
          inc nmicounter
          jsr getfastbeat
          and #$3f
          tax
          lda tbufofast,x
          sta $dd05
          lda #$ff
          sta $dd04
          pla
          tax
          pla
stopnmi
          RTI
;===
tbufofast
     !byte $ff,$fd,$fa,$f6,$f3,$e0,$ec,$e9
     !byte $e6,$e3,$e0,$dc,$d9,$d6,$d3,$d0
     !byte $cc,$c9,$c6,$c3,$c0,$bc,$b9,$b6
     !byte $b3,$b0,$ac,$a9,$a6,$a3,$a0,$9c
     !byte $96,$93,$90,$8c,$89,$86,$83,$80
     !byte $7c,$79,$76,$73,$70,$6c,$69,$66
     !byte $63,$60,$5c,$56,$53,$50,$50,$4f
     !byte $4f,$ff,$ff,$ff,$ff,$ff,$ff,$ff
;===============================
;======== END IRQ LOOP =========
;===============================
makehidden
          lda $d015
          and #$fe
          sta $d015

          lda $d010
          and #$fe
          sta $d010
          lda $dd04
          tax
          and #1
          ora $d010
          sta $d010
          and #1
          beq lewoufo
          txa
          cmp #$40
          bcc ustawionowx
          lda $d010
          and #$fe
          sta $d010


lewoufo   txa
          cmp #30
          bcs ustawionowx
          adc #30
ustawionowx
          sta $d000
          sta POZ_SHIP_X_LO
          txa
          and #$1f
          tax
          lda UFOystart,x
          sta $d001
          sta POZ_SHIP_Y
          lda $d010
          and #1
          sta POZ_SHIP_X_HI
          LDA #0
          STA SHIP_SPEED
          STA WYTRACAJ
          STA DAJ_GAZU

setirq_h
          lda #<IRQ_hidden
          sta $fffe
          lda #>IRQ_hidden
          sta $ffff
          lda #0
          sta IRQCNTR
          jsr KASUJ_UFO_KULE2
          jsr turn_off_thrust
          jmp goback
;====
IRQ_hidden
          PHA
          txa
          pha
          tya
          pha




          INC $D019
          INC IRQCNTR
          lda $d01e
          lda $d01f
          lda IRQCNTR
          cmp #50
          bcc +

          jmp unmakehidden

+
          lda $d015
          and #$fe
          sta $d015


          LDA #$7f
          CMP KEYTEST
          BEQ +
          LDX KEYTEST
          STX KEY_OLD
          STA KEYTEST
+
;============
          jsr szukajkolizjiufo
          jsr move_UFO
          JSR TESTSTRZAL
          JSR STARTKULA
          jsr rozbijaj_UFO
          jsr ZAPAL_SPRAJTY ;jeżeli wybuch wstawia animke
          JSR cnt_msx
;===========
goback2

          pla
          tay
          pla
          tax
          PLA
          RTI
;=====
unmakehidden
          lda $d015
          ora #1
          sta $d015
          lda #<IRQ
          sta $fffe
          lda #>IRQ
          sta $ffff
          jmp goback2
;===============================

;===== Paragraph @TEST_GAZ@ =====
TEST_GAZ

          lda KEY_OLD
          eor KEYTEST
          and #1
          beq +
          lda KEY_OLD
          ora #1
          sta KEY_OLD
          jsr turn_off_thrust
+

          LDA KEYTEST ;
          AND #$01	;G�RA  - czy wduszony gaz? KOREKCJA TRAJEKTORII
          BEQ TG01	;JAK ZGASZONY BIT TO GAZ WDUSZONY


          lda IRQCNTR
          and #7
          beq +

          DEC COUNT_WYTR
          BPL +
          LDA #$00
          STA WYTRACAJ
          STA COUNT_WYTR
+
          JMP TG2;NIE WCISNIETY GAZ

;wduszony gaz korekcja
TG01
          lda KEY_OLD
          and #1
          beq +
          lda KEY_OLD
          and #$fe
          sta KEY_OLD
          jsr turn_on_thrust
+
          LDA IRQCNTR	;USTAW SPRAJTA DLA KIERUNKU W CO 2GIM IRQ Z OGNIEM
          CLC
          AND #$01
          BNE TG3
          LDA SHIP_NR_ROT
          JMP TG4
TG3
          LDA SHIP_NR_ROT
          ORA #$10
TG4
          ADC #BANKSHIP
          STA SPRIT0
          LDA WYTRACAJ
          BEQ TG00
          LDA DAJ_GAZU
          SEC
          SBC WYTRACAJ
          BCS TGX
          LDA #$00
          STA WYTRACAJ
          STA DAJ_GAZU
          STA SHIP_SPEED
          JMP CHANGESHIP_ALL
TGX
          STA DAJ_GAZU
          TAX
          JMP KOREKCJA
TG00
          LDX DAJ_GAZU
          CPX #195
          BCC +
          RTS
+
          INX
          STX DAJ_GAZU
          LDA TAB_FAST,X
          BNE +
          STA DAJ_GAZU
          JMP CHANGESHIP_ALL
+
          CMP SHIP_SPEED
          BEQ NOTH_DO
          STA SHIP_SPEED
          RTS
NOTH_DO
          LDY SHIP_NR_ROT
          CPY NEWSHIP_NR_ROT
          BEQ NO_DO
          JMP WDUSZONY_GAZ
NO_DO
          RTS

;========
;NIEWCISNIETY GAZ
TG2
          LDA SHIP_NR_ROT
          CLC
          ADC #BANKSHIP
          STA SPRIT0

          LDA SHIP_SPEED
          CMP #6
          BCC +
          LDA #195
          STA DAJ_GAZU
+
          LDA DAJ_GAZU
          BNE +
          STA SHIP_SPEED
          RTS
+
          LDA IRQCNTR
          AND #$07
          CMP #$07
          BEQ +
          RTS
+
          LDA DAJ_GAZU
          SEC
          SBC SHIP_SPEED
          BCS +
          LDA #$00
+
          STA DAJ_GAZU
          TAX
KOREKCJA
          LDA TAB_FAST,X
          STA SHIP_SPEED
          BEQ END_KOREKCJA
          RTS
END_KOREKCJA
          STA DAJ_GAZU
          JMP CHANGESHIP_ALL
;==========
;==========
;===== Paragraph @INITPOZSHIP@ =====

INITPOZSHIP

          LDA #160-12
          STA POZ_SHIP_Y
          LDA #160-12+24
          STA POZ_SHIP_X_LO
          LDA #0
          STA POZ_SHIP_X_HI
          STA SHIP_SPEED
          STA WYTRACAJ
          STA SHIP_NR_ROT
          STA NEWSHIP_NR_ROT
          STA DAJ_GAZU
          STA USED_KUL
          STA IGNORE_KOLIZJA ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          STA WYSTRZEL
          LDY #3
-
          STA KULA0,Y
          DEY
          BPL -
          lda $d015
          ora #$1f
          eor #$1e
          STA $D015

SETSHIP_00
          LDA SHIP_NR_ROT
          AND #$0F
          TAY
          LDA XPOZ,Y
          STA SHIP_DX
          LDA YPOZ,Y
          STA SHIP_DY
          LDA XSIGN,Y
          STA SHIP_STEP_X_SIGN
          LDA YSIGN,Y
          STA SHIP_STEP_Y_SIGN

          JSR CHANGESHIP_ALL
SETSHIP_01
          LDA SHIP_NR_ROT
          AND #$0F
          CLC
          ADC #BANKSHIP
          STA SPRIT0
SETSHIP
          LDA POZ_SHIP_Y
          STA $D001
          LDA POZ_SHIP_X_LO
          STA $D000

          LDA $D010
          AND #$FE
          ORA POZ_SHIP_X_HI
          STA $D010
          RTS
;---
CLEARSCREEN

          LDX #$1F
          LDY #$00

          LDA #>SCREEN
          STA casescr
          STY STPLOT
          TYA
casescr = *+2
-
          STA $4000,Y
          INY
          BNE -
          INC casescr
          DEX
          BNE -
		
          LDY #$3F
-
          STA $5f00,Y
          DEY
          BPL -
          RTS
;===============
;===== Paragraph @MOVESHIP@ =====
MOVESHIP

          LDX SHIP_SPEED
          BNE +
          RTS
+
          DEX
          BNE +
          LDA IRQCNTR
          AND #$03
          CMP #3
          BEQ mvs01
          RTS
+
          DEX
          CPX #1
          BCS +
          LDA IRQCNTR
          AND #$01
          BNE mvs01
          RTS
+
          DEX
mvs01
          CPX #0
          BNE +
          LDA IRQCNTR
          AND #$01
          TAX
+
OFFS_XSTEP = *+1
          LDA TAB_DELTA,X
          STA SHIP_STEP_X
OFFS_YSTEP = *+1
          LDA TAB_DELTA,X
          STA SHIP_STEP_Y
		
          LDA POZ_SHIP_Y
          LDX SHIP_STEP_Y_SIGN
          BEQ + ;SHIPY DODATNIE

          CLC
          ADC SHIP_STEP_Y
          BCS OUT_OF_SCREEN
          CMP #190+50
          BCC STORENEWSHIPY

OUT_OF_SCREEN
          LDA #41
          BNE STORENEWSHIPY
+
          SEC
          SBC SHIP_STEP_Y
          CMP #40
          BCS +
          LDA #189+50
+
STORENEWSHIPY
          STA POZ_SHIP_Y
		
          LDA POZ_SHIP_X_LO
          LDX SHIP_STEP_X_SIGN
          BEQ DODAJ_X
          SEC
          SBC SHIP_STEP_X
          STA POZ_SHIP_X_LO
          BCS +
          DEC POZ_SHIP_X_HI
+
          LDA POZ_SHIP_X_HI
          BMI KORYGUJ_X
          BNE NO_TOWIDTH
          LDA POZ_SHIP_X_LO
          CMP #15
          BCS NO_TOWIDTH
KORYGUJ_X
          LDA #1
          STA POZ_SHIP_X_HI
          LDA #$49
          STA POZ_SHIP_X_LO
          BNE NO_TOWIDTH
DODAJ_X
          CLC
          ADC SHIP_STEP_X
          STA POZ_SHIP_X_LO
          BCC +
          INC POZ_SHIP_X_HI
+
          LDA POZ_SHIP_X_HI
          BEQ NO_TOWIDTH
          LDA POZ_SHIP_X_LO
          CMP #$4b
          BCC NO_TOWIDTH
          DEC POZ_SHIP_X_HI
          LDA #15
          STA POZ_SHIP_X_LO
NO_TOWIDTH
          JMP SETSHIP
          RTS
;==
;=============
;===== Paragraph @TEST_STRZAL@ =====
TESTSTRZAL
          LDA USED_KUL
          BEQ TESTSTARTUKULI

          LDA #maximum_kul-1
          STA ACT_KULA
-
          LDX ACT_KULA
          LDA KULA0,X ;JAK = 0 TO KULA NIEUZYTA
          BEQ CONT_TEST_BUM

          DEC KULA_STEP,X ; licznik kroków kuli
          BNE +
;=== zakończenie żywota jednej kuli i sprawdzenieczy nie wystąpiła na niej kolizja
          lda #0
          sta KULA0,X
          DEC USED_KUL ;zakończony żywot jednej kuli
          bpl bbon1
          ldy #3
          sta USED_KUL
bbon2:    sta KULA0,y
          dey
          bpl bbon2
bbon1:
		      ;zgas ostatniego plota
		      ;W X - NR KULI
          STX KULA_KOLIZJA ;W RAZIE KOLIZJI NR_KULI
          LDY KULA_Y_LO,X
          LDA TABHI,Y
          CLC
          ADC KULA_X_HI,X
          STA STPLOTHI

          LDA KULA_X_LO,X
          TAX
		
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y

CONT_TEST_BUM

          DEC ACT_KULA
          BPL -
;===
;==============================
;===== Paragraph @TEST_STARTU_KULI@ =====
TESTSTARTUKULI

          LDA IGNORE_KOLIZJA ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          BEQ *+3
          RTS

          LDA KEYTEST
          AND #$10
          BEQ *+3
-
          RTS

;DISABLE STILL FIRE
;===
          LDA KEY_OLD
          AND #$10
          BEQ -
          LDA KEY_OLD
          EOR #$10
!if autofire = 0 {
          STA KEY_OLD
}
          INC WYSTRZEL
          RTS
;===
+
          ;ZGAS KULE I DOROBIC SPRAWDZENIE ZGASZENIA
          ;W X - NR KULI
          STX KULA_KOLIZJA ;W RAZIE KOLIZJI NR_KULI
          LDY KULA_Y_LO,X

          LDA TABHI,Y
          CLC
          ADC KULA_X_HI,X
          STA STPLOTHI

          LDA KULA_X_LO,X
          TAX

          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          ;sprawdz kolizje - jak zapalony to kolizja
          AND TBBIT,X
          Beq +
          ;znaleziono kolizję z kuli
          JSR KOLIZJA_Z_KULI
          JMP CONT_TEST_BUM
+
;===
          JSR PRZENIES_KULE
;===

          JMP CONT_TEST_BUM
          RTS

;===== Paragraph @ZAPAL_SPRAJTA@ =====

rozbijaj_UFO
          lda rozbij_UFO
          bne +
          lda is_UFO
          bne +
          lda $d015
          and #$7f
          sta $d015
          rts
+        lda IRQCNTR
          and #2
          beq *+3
          rts
          lda rozbij_UFO
          beq +
          adc #$d6
          sta SPRIT0+7
          lda $d015
          ora #$80
          sta $d015
          inc rozbij_UFO
          lda rozbij_UFO
          cmp #$10
          bcc +
          lda #$00
          sta rozbij_UFO
          lda $d015
          eor #$80
          sta $d015
+        rts
ZAPAL_SPRAJTY

          lda is_UFO
          bne kule_dla_ufo
zpsp2
          lda IRQCNTR
          and #2
          beq *+3
          rts

          LDX #3
-
          lda klatkapyl,X
          cmp #16 ;max klatek
          bcc zapalaj
          ;jak klatka nr 4 zgasic jednorazowo sprajta
          LDA $D015
          ORA TAB_NR_SPR,X
          eor TAB_NR_SPR,X
          STA $D015
          jmp +
zapalaj
          inc klatkapyl,x
          adc #$d6
          sta SPRIT0+1,x
          LDA $D015
          ORA TAB_NR_SPR,X
          STA $D015
          ;!!! USUNAC W GRZE MA BYC CZARNE
          LDA #$01
          STA $D028,X
+        dex
          bpl -
          rts
;===
kule_dla_ufo
		LDX #3
-
     lda KULA0,X
     bne dlugakula

		 LDA $D015
		 ORA TAB_NR_SPR,X
		 eor TAB_NR_SPR,X
		 STA $D015
     jmp liczkule
dlugakula
;====

		LDA TABSPRAJT,X
		TAY
		

		LDA KULA_Y_LO,X
		CLC
		ADC #40
		STA $D000,Y
				
		LDA KULA_X_LO,X
		ADC #14
		STA $CFFF,Y
		
		LDA $D010
		ORA TAB_NR_SPR,X
		BCS +
		LDY KULA_X_HI,X
		BNE +
		EOR TAB_NR_SPR,X
+
		 STA $D010
		 lda KULA_NR_ROT,x
     clc
     adc #BANKSHIP
     adc #$20
     sta SPRIT0+1,x
		 LDA $D015
		 ORA TAB_NR_SPR,X
		 STA $D015

		;!!! USUNAC W GRZE MA BYC CZARNE
		LDA #$00
		STA $D028,X

;====
liczkule
     dex
     bpl -
     rts
;===

set_pos_sand


          lda is_UFO
          beq *+3
          rts

          lda IGNORE_KOLIZJA
          bne sand_ship


          ldx KULA_KOLIZJA
          lda #0
          sta klatkapyl,x
          LDA TABSPRAJT,X
          TAY
          LDA KULA_Y_LO,X
          CLC
          ADC #40
          STA $D000,Y

          LDA KULA_X_LO,X
          ADC #14
          STA $CFFF,Y

          LDA $D010
          ORA TAB_NR_SPR,X
          BCS +
          LDY KULA_X_HI,X
          BNE +
          EOR TAB_NR_SPR,X
+
          STA $D010
sand_ship
          lda IGNORE_KOLIZJA
          beq +
sand_ship2
          lda $d000
          sta $d002
          lda $d001
          sta $d003
          lda $d010
          and #1
          asl
          ora $d010
          sta $d010
          lda $d015
          and #%11100001
          ora #2
          sta $d015

+        RTS
;============
;============
;============
;===== Paragraph @START_KULA@ =====
STARTKULA

          LDA IRQCNTR
          AND #3
          BEQ +
          RTS
+
          LDA IGNORE_KOLIZJA ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          BEQ +
          RTS
+
          LDX WYSTRZEL
          BNE +
          RTS
+
          STA WYSTRZEL

;=== W��CZENIE ODG�OSU WYSTRZELIWANEJ KULI

          ;LDA #$0c ;0c ;03 10000
          ;JSR $1000
          ;LDA #50
          ;STA IRQ_STRZAL
          jsr fire_bullet

          LDA USED_KUL
          CMP #maximum_kul ;MAXIMUM KUL
          BCC +
          RTS
+
          LDX #maximum_kul-1
-
          LDA KULA0,X
          BEQ +
          DEX
          BNE - ;ZAMIAST "BPL -" 4TA KULA SZYBCIEJ BEZ SPRAWDZENIA BO TO MUSI BYC ONA
+
          INC KULA0,X
          INC USED_KUL

          LDY SHIP_NR_ROT
          STY KULA_NR_ROT,X ; ZAPAMIETAJ NR ROTACJI KULI

          LDA POZ_SHIP_X_LO
          CLC
          ADC OFF_KULA_X,Y
          STA KULA_X_LO,X

          LDA POZ_SHIP_X_HI
          ADC #$00
          STA KULA_X_HI,X
		
          LDA KULA_X_LO,X
          SEC
          SBC #24
          STA KULA_X_LO,X
          BCS +
          DEC KULA_X_HI,X
+
          LDA KULA_X_HI,X
          BEQ +
          LDA KULA_X_LO,X
          CMP #$40
          BCC +
          CLC
          LDA #$00
          STA KULA_X_LO,X
          STA KULA_X_HI,X
+
          LDA POZ_SHIP_Y
          CLC
          ADC OFF_KULA_Y,Y
          CMP #50
          BCS +
          LDA #51
+
          SBC #50
          CMP #200
          BCC +
          SBC #200
+
          STA KULA_Y_LO,X

          LDA #longliveball
          STA KULA_STEP,X

          LDA XSIGN,Y
          STA KULA_X_SIGN,X

          LDA YSIGN,Y
          STA KULA_Y_SIGN,X


          TYA
          ASL
          ASL
          ASL
          ASL ;CARRY IS CLEAR
          TAY
		
          LDA TAB_DELTA + SPEED_KULA-1 ,Y
          STA KULA_DX,X
          LDA TAB_DELTA + SPEED_KULA-1 + 8 ,Y
          STA KULA_DY,X



		;zapal pierwszy plot kuli przed statkiem
PLOTKULA ;W X - NR KULI
          STX KULA_KOLIZJA ;W RAZIE KOLIZJI NR_KULI
          LDY KULA_Y_LO,X

          LDA TABHI,Y
          CLC
          ADC KULA_X_HI,X
          STA STPLOTHI

          LDA KULA_X_LO,X
          TAX
		
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          ;tu sprawdzenie kolizji jak zgaszony - kolizja
          AND TBBIT,X
          Beq *+3
          RTS

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          jmp KOLIZJA_Z_KULI
;=============
;===== Paragraph @PRZENIES_KULE@ =====
PRZENIES_KULE

          ldx ACT_KULA
          lda KULA_X_LO,X
          sta OLDKULA_X_LO,x
          lda KULA_X_HI,x
          sta OLDKULA_X_HI,x
          lda KULA_Y_LO,x
          sta OLDKULA_Y_LO,x

          STX KULA_KOLIZJA
          ;PRZEPISANIE DANYCH DLA PLOTOW SZUKANIA KOLIZJI W KULI
          LDA OLDKULA_X_LO,X
          STA XA
          LDA OLDKULA_X_HI,X
          STA XAHI

          LDA OLDKULA_Y_LO,X
          STA YA
          LDA #$00
          STA CTRL_DX	;DO OBLICZEN ZEROWANIE TABELI PRZYROSTU
		
          LDA #SPEED_KULA ;LICZBA PLOTOW DO POSTAWIENIA W SZUKANIU TRASY I KOLIZJI
          STA CALCSTEP

          LDA KULA_X_SIGN,X
          STA DXSIGN
          LDA KULA_Y_SIGN,X
          STA DYSIGN
		
          LDY KULA_NR_ROT,X
          LDA XPOZ,Y
          STA DX
          LDA YPOZ,Y
          STA DY

ZROB_PLOTY_KULI
		
          LDY DX
          CPY DY ;CO JEST WIEKSZE DX CZY DY?
          LDY YA
          BCS +
          JMP PNX_DY_GORA
+
          CLC

PNX_DX_GORA
          LDA DXSIGN
          BEQ +
          JMP PNX_DX_G2
+
          LDA DYSIGN
          BEQ PNX_DX_G0
-
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BCC +
          LDX #$00
          STX XA
          STX XAHI
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA
+
          STA CTRL_DX
          LDY YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
	
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +
		
          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          ;postawienie plota kuli po przesunięciu
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y

          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts
;===
PNX_DX_G0
-
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BNE +
          LDX #$00
          STX XA
          STX XAHI
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
+
          STA CTRL_DX
          LDY YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +
		
          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y
          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts
;----- Paragraph @****@ -----
PNX_DX_G2
          LDA DYSIGN
          BNE PNX_DX_G3
-
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
+
          STA CTRL_DX
          LDX XA
          LDY YA

          LDA TABHI,Y
          CLC
          ADC XAHI
          STA STPLOTHI
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y
          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts
;===
PNX_DX_G3
-
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA
+
          STA CTRL_DX
          LDY YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y
          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts

PNX_DY_GORA
          LDA DYSIGN
          BEQ +
          JMP PNX_DY_G2
+
          LDA DXSIGN
          BNE PNX_DY_G0
-
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BNE +
          LDX #$00
          STX XA
          STX XAHI
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +
		
          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y

          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts

PNX_DY_G0
-
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y
          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts
;===
PNX_DY_G2
          LDA DXSIGN
          BNE PNX_DY_G3
-
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA

          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BNE +
          LDX #$00
          STX XA
          STX XAHI
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y
          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts
;===
PNX_DY_G3
-
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA

          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y

          ldx ACT_KULA
          lda XA
          sta KULA_X_LO,X
          lda XAHI
          sta KULA_X_HI,x
          lda YA
          sta KULA_Y_LO,x
          rts
;---
;=============
KOLIZJA_Z_KULI_X

          LDX ACT_KULA
          stx KULA_KOLIZJA
          LDA XA		 ;PRZEPISANIE DANYCH KULI Z XA DO KULA,X
          STA KULA_X_LO,X
          LDA YA
          STA KULA_Y_LO,X
          LDA XAHI
          STA KULA_X_HI,X

;===== Paragraph @KOLIZJA_Z_KULI@ =====
KOLIZJA_Z_KULI

          LDX KULA_KOLIZJA
          LDA KULA_X_LO,X
          STA XA
          LDA KULA_X_HI,X
          STA XAHI
          LDA KULA_Y_LO,X
          STA YA

          LDX #0
          LDA MANY_OBJ
          STA TMPR1

FIND_IN_Y

          LDA YA
          CMP TBOBJ_Y,X
          BCC CHECK_NEXT_BALL ;KOLIZJA JEST WYŻEJ NIŻ POCZĄTEK RYSOWANEGO OBIEKTU

          lda TBOBJ_TO_LINE,X
          ;sec ;CARRY =1 AFTER COMPARISION
          sbc TBOBJ_FROM_LINE,X
          beq CHECK_NEXT_BALL
          CLC
          ADC TBOBJ_Y,X
          CMP YA
          BCS FIND_IN_X
;==
CHECK_NEXT_BALL
          INX ; ALBO ZAPAMIETAĆ X NA zp !!!
          DEC TMPR1
          BNE FIND_IN_Y
          JMP UNNAMED_COLLISION ;!!! NIE ZNALEZIONO KOLIZJI KULI !!!
;===
FIND_IN_X

          lda TBOBJ_X_HI,x
          beq +
          lda TBOBJ_X_LO,x
          cmp #$40
          bcc +
          jmp testuj_extra_x ;szukanie kolizji z obiektem przesuniętym w prawo

+        LDA TBOBJ_X_LO,X
          SEC ;CARRY IS SET AFTER COMPARISION
          SBC XA
          tay
          LDA TBOBJ_X_HI,X
          SBC XAHI
          BMI +
          CPY #$00
          BNE CHECK_NEXT_BALL
          CMP #$00
          BNE CHECK_NEXT_BALL
+
          STY MAXXLO
          STA MAXXHI
          LDA TBOBJ_TO_COLUMN,X
          CLC ;TAK CLC BO MA BYĆ WIĘKSZY WYNIK O JEDEN
          ADC #2 ;TU POWIEKSZAMY NASZ WYNIK
          SBC TBOBJ_FROM_COLUMN,X
          asl
          asl
          asl
          adc MAXXLO
          STA MAXXLO
          BCC +
          INC MAXXHI
+        lda MAXXHI
          BNE CHECK_NEXT_BALL
;===
;ODCZYTANIE PLOTA OBIEKTU CZY BYŁA KOLIZJA
CHECK_PLOT_OBJ

          stx TMPR2
          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI

          ldy KULA_KOLIZJA
          lda KULA_Y_LO,y
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+        lda KULA_X_LO,y
          sec
          sbc TBOBJ_X_LO,x
          ;888 - korekta o przesunięcie w prawo obiektu
          sta PLOX_MOD
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x

          lda (FINDAST),y
          and TBBIT,x
          beq +
          jmp skasuj_kule

+        ldx TMPR2
          jmp CHECK_NEXT_BALL
;============
testuj_extra_x
          sbc #$40
          cmp XA
          bcs +
          jmp CHECK_NEXT_BALL
+
          clc
          sbc XA
          sta PLOX_NOMOD
          lda TBOBJ_MAX_Y,x
          sec ;dla poprawnego offsetu !
          sbc PLOX_NOMOD
          sta PLOX_MOD
          stx TMPR2
          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI

          ldy KULA_KOLIZJA
          lda KULA_Y_LO,y
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+
          ;888 - korekta o przesunięcie w prawo obiektu
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x


          lda (FINDAST),y
          and TBBIT,x
          beq +


          jmp skasuj_kule

+        ldx TMPR2
          jmp CHECK_NEXT_BALL
;====

;============
skasuj_kule
          ldx KULA_KOLIZJA
          LDA #$00
          STA KULA0,X
          DEC USED_KUL
          bpl bbon1b
          ldy #3
          sta USED_KUL
bbon2b    sta KULA0,y
          dey
          bpl bbon2b
bbon1b
;kasowanie obiektu z kuli



          ldx TMPR2
          lda TBOBJ_NR,x
          cmp #32
          bcs +
          jmp rozbij_duzy
+   		  cmp #64
          bcs +
          jmp rozbij_sredni
+
          jmp zlikwiduj_obiekt
;===========================
zamien_obiekt
          jsr sand_ship2
          ldx TMPR2
zamien_obiekt3
          lda TBOBJ_NR,x
          cmp #32
          bcs +
          jsr dodaj20
          jmp rozbd2
+   		  cmp #64
          bcs +
          jsr dodaj50
          jmp rozbsr2
+        jsr dodaj100
          jmp zlob2
;======
zamien_obiekt2


          ldx TMPR2
          lda TBOBJ_NR,x
          cmp #64
          bcc zamien_obiekt3
;stamp
          lda MANY_OBJ
          bne loba
          rts
loba
          cmp #2
          bcs zamien_obiekt
          jsr bezpylu
          jsr kasuj_kulki
          ldx many_start_obj
;stamp
          stx MANY_OBJ

          ldx #0
          jsr MOVE_OBJECTS
          jsr kasujstatki2
          lda lives
          pha
		      ;LDA #$FF
          ;JSR $1000 ;MUZYKA ROZBICIA STATKU
          ;LDA #$0D
          ;JSR $1000
          ;LDA #50
          ;STA IRQ_STRZAL
          jsr explosion

;===

          lda #0
          sta klatkapyl

;==

          LDA #$00
          sta WYSTRZEL

          STA SHIP_SPEED ;STATEK NIE RUSZA SIE
          STA DAJ_GAZU
          LDA #BANKSHIP+51
          STA SPRIT0
          LDA #7
          STA COUNT_FRAME
          STA COUNT_FR2
          LDA #7
          STA COUNT_ANIM

          lda #<irq_kasuj
          sta $fffe
          lda #>irq_kasuj
          sta $ffff
          jsr CLEARSCREEN
          inc $d019
          cli

-
          lda COUNT_ANIM
          bne -
          lda is_UFO
          bne -
          sei
          pla
          sta lives
          beq newlevel
repack
          lda #$61
          sta $d015
          jmp next_level
newlevel
          ldx #12
          inc many_start_obj
          lda many_start_obj
          cmp #13
          bcc +
          stx many_start_obj
+         ldx #$ff
          txs
          lda many_start_obj
;stamp
          sta MANY_OBJ
          jsr rozstaw_astery
konczgre  jmp setgameover
;=========
irq_kasuj
          pha
          txa
          pha
          tya
          pha

          inc $d019
          lda $d01f
          lda $d01e
          inc IRQCNTR
          jsr move_UFO
          jsr smallanim
          jsr rozbijaj_UFO
          jsr rozbijaj

          pla
          tay
          pla
          tax
          pla
          rti
;============
smallanim
          lda COUNT_ANIM
          bne *+3
          rts
          DEC COUNT_FR2
          BEQ *+3
          RTS
          INC SPRIT0
          LDA COUNT_FRAME
          STA COUNT_FR2
          DEC COUNT_ANIM
          BEQ *+3
          RTS
;===
          jsr bezpylu
          lda $d015
          and #$e0
          sta $d015
          rts
;=======================
rozbij_sredni
          jsr dodaj50
          jsr set_pos_sand
rozbij_sredni_ufo
;W X musi być nr obiektu lub pobrać go
rozbsr2

jsr explosion

          LDX TMPR2 ;ZAPAMIETAJ NR NISZCZONEGO OBIEKTU
          jsr MOVE_OBJECTS

          LDY TMPR2
          LDx MANY_OBJ
;===========
          LDA TBOBJ_M_Y,Y
          cmp #207
          bcc +
          sbc #8
          STA TBOBJ_M_Y,Y
+        STA TBOBJ_M_Y,X

          LDA TBOBJ_Y,Y
          eor #1
          STA TBOBJ_Y,X

          lda #7
          sta TBOBJ_MAX_Y,Y
          STA TBOBJ_MAX_Y,X
;==================

          lda TBOBJ_X_LO,Y
          STA TBOBJ_X_LO,X

          lda TBOBJ_X_HI,Y
          STA TBOBJ_X_HI,X

          lda #0
          sta TBOBJ_FROM_COLUMN,Y
          STA TBOBJ_FROM_COLUMN,X

          lda #1
          sta TBOBJ_TO_COLUMN,Y
          STA TBOBJ_TO_COLUMN,X

          LDA TBOBJ_DX,Y
          eor #1
          bne +
          lda #2
+        STA TBOBJ_DX,X

          LDA TBOBJ_DY,Y
          eor #1
          bne +
          lda #2
+         STA TBOBJ_DY,X

          LDA TBOBJ_NR,Y
          clc
          adc #32
          STA TBOBJ_NR,y	;NR ASTERA
          eor #$08
          sta TBOBJ_NR,X



          lda TBOBJ_X_LO,Y
          clc
          adc #$04
          sta TBOBJ_X_LO,Y
          eor #1
          STA TBOBJ_X_LO,X

          lda TBOBJ_X_HI,Y
          adc #0
          STA TBOBJ_X_HI,X
          sta TBOBJ_X_HI,Y

          beq no_x_towidth2 ;sprawdzić przekroczenie zakresu w X dla sredniaka
          lda TBOBJ_X_LO,Y
          cmp #$47
          bcc no_x_towidth2
          sbc #$0d
          STA TBOBJ_X_LO,X
          eor #1
          sta TBOBJ_X_LO,Y
;===
no_x_towidth2
          inc MANY_OBJ

          ldx TMPR2
          jsr MOVE_OBJECTS
          ldx MANY_OBJ
          dex
          jsr MOVE_OBJECTS
          ldx #3

          ldx TMPR2
          ldy MANY_OBJ
          RTS
;****
;================
;=======
rozbij_duzy
          jsr dodaj20
          jsr set_pos_sand
rozbij_duzy_ufo
;W X musi być nr obiektu lub pobrać go
rozbd2
jsr explosion
          LDX TMPR2 ;ZAPAMIETAJ NR NISZCZONEGO OBIEKTU
          jsr MOVE_OBJECTS
          LDY TMPR2
          LDx MANY_OBJ
;===========
          LDA TBOBJ_M_Y,Y
          cmp #215
          bcc +
          sbc #16
          STA TBOBJ_M_Y,Y
+        STA TBOBJ_M_Y,X

          LDA TBOBJ_Y,Y
          adc #1
          STA TBOBJ_Y,X

          lda #15
          sta TBOBJ_MAX_Y,Y
          STA TBOBJ_MAX_Y,X
;==================


          lda #0
          sta TBOBJ_FROM_COLUMN,Y
          STA TBOBJ_FROM_COLUMN,X

          lda #2
          sta TBOBJ_TO_COLUMN,Y
          STA TBOBJ_TO_COLUMN,X

          LDA TBOBJ_DX,Y
          eor #$ff
          clc
          adc #1
          bne +
          lda #1
          sta TBOBJ_DX,Y
          lda #$ff
+        STA TBOBJ_DX,X

          LDA TBOBJ_DY,Y
          eor #$ff
          clc
          adc #1
          bne +
          lda #$01
          sta TBOBJ_DY,Y
          lda #$ff
+         STA TBOBJ_DY,X

          LDA TBOBJ_NR,Y
          clc
          adc #32
          STA TBOBJ_NR,y	;NR ASTERA
          eor #$08
          sta TBOBJ_NR,X


          lda TBOBJ_X_LO,Y
          clc
          adc #$08
          sta TBOBJ_X_LO,Y
          eor #1
          STA TBOBJ_X_LO,X

          lda TBOBJ_X_HI,Y
          adc #0
          STA TBOBJ_X_HI,X
          sta TBOBJ_X_HI,Y

          beq no_x_towidth ;sprawdzić przekroczenie zakresu w X dla sredniaka
          lda TBOBJ_X_LO,Y
          cmp #$4f
          bcc no_x_towidth
          sbc #$10
          STA TBOBJ_X_LO,X
          eor #1
          sta TBOBJ_X_LO,Y
no_x_towidth

          inc MANY_OBJ


          ldx TMPR2
          jsr MOVE_OBJECTS
          ldx MANY_OBJ
          dex
          jsr MOVE_OBJECTS

          ldx TMPR2
          ldy MANY_OBJ
          rts
;****
dodaj20
          lda #2
!byte $2c
dodaj50
          lda #5

          ldy #$40
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
          clc
          adc scores+4
          cmp #$0a
          php
          bcc *+4
          sbc #$0a
          sta scores+4

          asl
          asl
          asl
          tax
          ldy #1
-        lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpy #25
          bcc -

          plp
          bcs +
          rts
dodaj200
          ldy #$40
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
          lda #2
          jmp my2stowy
dodaj100
          ldy #$40
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
+        lda #1
my2stowy
          clc
          adc scores+3
          cmp #$0a
          php
          bcc *+4
          sbc #$0a
          sta scores+3
          asl
          asl
          asl
          tax
          ldy #0
-        lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpy #23
          bcc -
          plp
          bcs +
          rts
dodaj1000
          ldy #>viewcounter
          sty ady_cyfra+1
+        ldy #<viewcounter
          sty ady_cyfra
          lda #1
          clc
          adc scores+2
          cmp #$0a
          php
          bcc *+4
          sbc #$0a
          sta scores+2

          asl
          asl
          asl
          tax
          ldy #2
-        lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpy #26
          bcc -
          plp
          bcs +
          rts
+        inc lives
          bne *+4
          dec lives


          lda is_UFO
          beq +
          lda #$20
          sta msxlive
+        lda is_UFO
          bne +
          jsr extra_life
+
          lda lives
          cmp #7
          bcc +
          jmp niedomaluj
+
          sta cyfra_nr
          dec cyfra_nr

          ldy #<viewcounter
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
          lda cyfra_nr
          cmp #3
          bcc +
          ldy #$40
          sty ady_cyfra
          sbc #3
+        clc
          adc #36
          tay
          ldx #80
-        lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpx #88
          bne -
;==
niedomaluj
          ldy #>viewcounter
          sty ady_cyfra+1
          ldy #<viewcounter
          sty ady_cyfra
          lda #1
          clc
          adc scores+1
          cmp #$0a
          php
          bcc *+4
          sbc #$0a
          sta scores+1
          asl
          asl
          asl
          tax
          ldy #1
-        lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpy #25
          bcc -
          plp
          bcs +
          rts
;==
+        lda #1
          clc
          adc scores
          cmp #$0a
          bcc *+4
          sbc #$0a
          sta scores
          asl
          asl
          asl
          tax
          ldy #0
-        lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpy #24
          bcc -
          rts
;================
zlikwiduj_obiekt
;W X musi być nr obiektu lub pobrać go
!if matrixmode = 1 {
     rts
}
          jsr dodaj100
          jsr set_pos_sand
zlikwiduj_obiekt_ufo
!if matrixmode = 1 {
     rts
}
zlob2
jsr explosion
          LDX TMPR2 ;ZAPAMIETAJ NR NISZCZONEGO OBIEKTU
          jsr MOVE_OBJECTS
          LDX TMPR2
          LDY MANY_OBJ
          DEY
;===========
          LDA TBOBJ_M_Y,Y
          STA TBOBJ_M_Y,X

          LDA TBOBJ_Y,Y
          STA TBOBJ_Y,X

          LDA TBOBJ_MAX_Y,Y
          STA TBOBJ_MAX_Y,X

          LDA TBOBJ_FROM_LINE,Y
          STA TBOBJ_FROM_LINE,X

          LDA TBOBJ_TO_LINE,Y
          STA TBOBJ_TO_LINE,X
;==================

          lda TBOBJ_X_LO,Y
          STA TBOBJ_X_LO,X

          lda TBOBJ_X_HI,Y
          STA TBOBJ_X_HI,X

          lda TBOBJ_FROM_COLUMN,Y
          STA TBOBJ_FROM_COLUMN,X

          LDA TBOBJ_TO_COLUMN,Y
          STA TBOBJ_TO_COLUMN,X

          LDA TBOBJ_DX,Y
          STA TBOBJ_DX,X

          LDA TBOBJ_DY,Y
          STA TBOBJ_DY,X

          LDA TBOBJ_NR,Y
          STA TBOBJ_NR,X	;NR ASTERA



          lda TBOBJ_SCREEN_LO,Y
          STA TBOBJ_SCREEN_LO,X


          lda TBOBJ_SCREEN_HI,Y
          STA TBOBJ_SCREEN_HI,X

;stamp
          DEC MANY_OBJ
          beq ovld3
          bmi ovld3
          jmp nielast3
ovld3
          lda is_UFO
          bne oklvs
          jmp konczlevela

;=========
oklvs
;          ldx #12
;          inc many_start_obj
;          lda many_start_obj
;          cmp #13
;          bcc *+5
;          stx many_start_obj
;          lda lives
;          beq ostastidle

;          cli
;-        lda is_UFO
;          bne -
;          sei
;          lda lives
;          beq ostastidle

;          jmp reload_level
          jsr disable_ufo
;===
konczlevela
          jsr turn_off_thrust
          jsr sidinit
          lda lives
          bne +
;==================
          ldx #12
          inc many_start_obj
          lda many_start_obj
          cmp #13
          bcc ostastidle
          stx many_start_obj
ostastidle
;===
          lda $d015
          and #$fe
          sta $d015
          jsr kasuj_kulki
          lda many_start_obj
          sta MANY_OBJ
          jsr rozstaw_astery
          jmp ustaw_coinirq
;==================
next_level
+

          ldx #12
          inc many_start_obj
          lda many_start_obj
          cmp #13
          bcc reload_level
          stx many_start_obj
reload_level
          lda #<irq3sec
          sta $fffe
          lda #>irq3sec
          sta $ffff

          LDA #0
          sta IRQCNTR
          sta UFO_kula
          STA USED_KUL
          sta WYSTRZEL
          ldx #3
-        sta KULA0,X
          dex
          bpl -
          cli
          inx
          lda #$10
-
          sta $6000,x
          sta $6100,x
          sta $6200,x
          sta $62e8,x
          inx
          bne -
          jsr CLEARSCREEN
-         lda IRQCNTR
          cmp #50
          bcc -
          lda #0
          sta $d418


-         lda IRQCNTR
          cmp #250
          bcc -
          sei
          jsr startheartb
          jmp SKIP
;====================
nielast3
          LDA ACT_OBJ
          CMP MANY_OBJ
          BNE +
          LDA #0
          STA ACT_OBJ
+        lda MANY_OBJ ;czy 2 ostatnie obiekty sie pokrywaja?
          cmp #2
          bne noreplic
          lda TBOBJ_NR
          cmp TBOBJ_NR+1
          bne noreplic
          lda TBOBJ_X_LO
          cmp TBOBJ_X_LO+1
          bne noreplic
          lda TBOBJ_X_HI
          cmp TBOBJ_X_HI+1
          bne noreplic
          lda TBOBJ_DX
          cmp TBOBJ_DX+1
          bne noreplic
          lda TBOBJ_DY
          cmp TBOBJ_DY+1
          bne noreplic
          eor #1
          sta TBOBJ_DY
noreplic
          ;jsr kasuj_kulki



          ldx TMPR2
          ldy MANY_OBJ
          RTS
;****
irq3sec
          pha
          txa
          pha
          tya
          pha



          lda lives
          bne +

          lda $d015
          and #$fe
          sta $d015
          lda #0
          sta lives
+        lda lives
          beq +
          lda $d015
          ora #1
          sta $d015
+
          jsr cnt_msx
          lda $d01f
          sta KOLIZJA_BMP
          lda $d01e
          sta KOLIZJA_SPR

          LDA $DC00
          CMP KEYTEST
          BEQ +
          LDX KEYTEST
          STX KEY_OLD
          STA KEYTEST
+
;============

          LDA IGNORE_KOLIZJA ;JAK ROZBICIE STATKU NIE MA OBSLUGI GAZU I JAZDY
          BNE +     ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          JSR KEYBOARD
          JSR TEST_GAZ
          JSR MOVESHIP
+
          jsr rozbijaj
          jsr rozbijaj_UFO
          jsr ZAPAL_SPRAJTY
          inc IRQCNTR

          inc $d019

          pla
          tay
          pla
          tax
          pla
          rti
;=====
;****
kasuj_kulki
          ldx #3
          stx TMPR1

-        ldx TMPR1
          lda KULA0,x
          beq +
          lda KULA_X_HI,x
          sta XAHI
          lda KULA_X_LO,x
          sta XA
          lda KULA_Y_LO,x
          sta YA
          lda #0
          sta KULA0,x
          jsr PLOT

+        dec TMPR1
          bpl -
          jsr KASUJ_UFO_KULE2
          rts
;===
UNNAMED_COLLISION
;===

          ldx KULA_KOLIZJA
          cpx #4
          bcs bbon3a
          lda #0
          sta KULA0,X
          DEC USED_KUL ;zakończony żywot jednej kuli
          bpl bbon3a
          ldy #3
          sta USED_KUL
bbon3:    sta KULA0,y
          dey
          bpl bbon3
bbon3a:
          rts
;===

;****
;=============
;----- Paragraph @KOLIZJA_TEST@ -----
KOLIZJA_TEST
          LDY IGNORE_KOLIZJA ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          BEQ +
          JMP ROZBICIE_STATKU
+
          LDX $D01E
          STX KOLIZJA_SPR
          LDA $D01F
          STA KOLIZJA_BMP
          BNE +
          CPX #$00
          BNE +
		      RTS
;============================================
;TUTAJ POCZ�TEK PROCEDURY ROZBIJANIA STATKU USTAWIENIA PARAMETR�W SPRAWDZENIA KOLIZJI ITP.
+
          AND #$01 ;W ACC $D01F - KOLIZJA SPRAJTA Z BITMAPA
		      BEQ KOL_TST3

!if nokill = 1 {
     rts
}

          jsr szukajkolizjistatku
          lda jestkolizja
          beq *+3
          rts

          ;!ROZBIJAMY STATEK - ALE JESZCZE TRZEBA ZNALEZC POZNIEJ Z CZYM SIE STATEK ROZBIL
          lda #1
          STA IGNORE_KOLIZJA ;ZNACZNIK IGNOROWANIA KLAWIATURY
          jsr turn_off_thrust
          jsr explosion
;===
          jsr bezpylu
;==

          LDA #$00
          sta WYSTRZEL

          STA SHIP_SPEED ;STATEK NIE RUSZA SIE
          STA DAJ_GAZU
          LDA #BANKSHIP+51
          STA SPRIT0
          LDA #7
          STA COUNT_FRAME
          STA COUNT_FR2
          LDA #8
          STA COUNT_ANIM
wegi
          jsr kasujstatki
          lda #<safeirqship
          sta $fffe
          lda #>safeirqship
          sta $ffff
          lda #0
          sta IRQCNTR
          jsr kasuj_kulki
          jsr bezpylu

KOL_TST3
          RTS
rozbijaj
          lda COUNT_ANIM
          bne *+3
          rts
          lda $d015
          ora #1
          sta $d015
          DEC COUNT_FR2
          BEQ *+3
          RTS
          INC SPRIT0
          LDA COUNT_FRAME
          STA COUNT_FR2
          DEC COUNT_ANIM
          BEQ *+3
          RTS
;===

          jsr bezpylu
          JSR INITPOZSHIP
          lda $d015
          and #$fe
          sta $d015
          rts

;====
ROZBICIE_STATKU

          LDA $D01E
          STX KOLIZJA_SPR
          LDA $D01F
          STA KOLIZJA_BMP

          DEC COUNT_FR2
          BEQ *+3
          RTS
          INC SPRIT0
          LDA COUNT_FRAME
          STA COUNT_FR2
          DEC COUNT_ANIM
          BEQ *+3
          RTS
;===
KONCZ_ROZBICIE

          jsr bezpylu
          JSR INITPOZSHIP

          lda lives
          bne +
ustaw_silent
          lda #<silentirq
          sta $fffe
          lda #>silentirq
          sta $ffff
          lda $d015
          and #$fe
          sta $d015
          ldx #$ff
          txs
;stamp
          lda MANY_OBJ
          bne gotosilent
;========
          ldx many_start_obj
          inx
          cpx #12
          bcc nomaxi
          ldx #12
nomaxi    stx MANY_OBJ
          stx ACT_OBJ
          lda lives
          beq +
          jsr CLEARSCREEN
+
;========
gotosilent
          lda $d015
          and #$fe
          sta $d015
          jmp silent_mode
;===== wyczekanie na pokazanie statku

donesilent
          lda $d015
          and #$fe
          sta $d015
          lda #<safeirqship
          sta $fffe
          lda #>safeirqship
          sta $ffff
          lda #0
          sta IRQCNTR
          ldx #$ff
          txs
          bit $d011
          bpl *-3
          inc $d019
          lda $d01e
          lda $d01f

          jmp silent_mode
;====
safeirqship

          pha
          txa
          pha
          tya
          pha

          inc $d019
          lda $d01f
          sta KOLIZJA_BMP
          lda $d01e
          sta KOLIZJA_SPR
jsr cnt_msx
          inc IRQCNTR
          jsr szukajkolizjiufo
          jsr move_UFO
          jsr rozbijaj_UFO
          jsr enable_ufo
          jsr rozbijaj

          lda IGNORE_KOLIZJA
          beq test_exitsafe
          jmp safeirqexit
test_exitsafe
         ; lda IRQCNTR
         ; cmp #50
         ; bcc +
         ; lda $dc00
         ; and #$10
         ; beq wybor_koniecsafe
;+

;======================================================
          LDX #0
          LDA MANY_OBJ
          STA TMPR1
y_check
          lda TBOBJ_Y,X
          cmp #130
          bcs y_check2

          adc TBOBJ_MAX_Y,x
          cmp #80
          bcc y_check2
          jmp x_check

y_check2
          inx
          dec TMPR1
          bne y_check
          jmp last_check_ufo
x_check
          lda TBOBJ_X_HI,x
          bne y_check2
          lda TBOBJ_X_LO,x
          cmp #196
          bcs y_check2
          adc TBOBJ_MAX_Y,x
          cmp #124
          bcc y_check2
          jmp safeirqexit
last_check_ufo
          lda is_UFO
          bne +
          jmp wybor_koniecsafe
+
          jmp safeirqexit


wybor_koniecsafe
          lda #$10
          ldx #$00
-
          sta $6000,x
          sta $6100,x
          sta $6200,x
          sta $62e8,x
          inx
          bne -
          stx UFO_kula
          jsr CLEARSCREEN
          jsr zapal_astery

          lda #<IRQ
          sta $fffe
          lda #>IRQ
          sta $ffff



          lda $d015
          ora #$1f
          eor #$1e
          sta $d015
          jsr bezpylu
          jmp silent_mode

safeirqexit

          pla
          tay
          pla
          tax
          pla
          rti
;====
silentirq
          pha
          txa
          pha
          tya
          pha


          lda lives
          bne +

          lda $d015
          and #$fe
          sta $d015
          lda #0
          sta lives
          ;bmi -
+
          jsr cnt_msx
          lda $d01f
          sta KOLIZJA_BMP
          lda $d01e
          sta KOLIZJA_SPR
          jsr enable_ufo
          jsr szukajkolizjiufo
          jsr move_UFO
          jsr rozbijaj
          jsr rozbijaj_UFO
          inc IRQCNTR
          ;bit $dc0d
          ;bit $dd0d
          inc $d019
          lda $dc00
          and #$10
          beq repete
          lda #$ef
          cmp $dc01
          bne +
repete    lda is_UFO
          bne +
          jsr CLEARSCREEN
          lda #many_started_objects
          sta many_start_obj
          jmp RELOAD
+
          pla
          tay
          pla
          tax
          pla
          rti
;====
kasujstatki
          jsr kasujstatki2
          lda lives
          bne nogameover
setgameover
-        lda #0
          sta lives
          sta UFO_kula
          lda #<g_over
          ldy #>g_over
          jsr decrunch
setgameover2
          jsr zapal_astery
          jmp ustaw_goverirq

nogameover
          bmi -
          rts
niekasujstatkow
          lda lives
          beq *+4
          dec lives
          rts
;=====
kasujstatki2
          lda lives
          cmp #7
          bcs niekasujstatkow
          lda lives
          beq *+4
          dec lives
          sta cyfra_nr
          dec cyfra_nr

          ldy #<viewcounter
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
          lda cyfra_nr
          cmp #3
          bcc +
          ldy #$40
          sty ady_cyfra
          sbc #3
+        clc
          adc #36
          tay
          ldx #8
          lda #0
-        sta (ady_cyfra),y
          iny
          iny
          iny
          dex
          bne -
          rts
;=====
ustaw_goverirq
          lda #<gover_irq
          sta $fffe
          lda #>gover_irq
          sta $ffff
          lda $d015
          and #$fe
          sta $d015
          ldx #$ff
          txs
;stamp
          lda MANY_OBJ
          bne gotosilent2

;========
          ldx many_start_obj
          inx
          cpx #12
          bcc nomaxi2
          ldx #12
nomaxi2
          stx MANY_OBJ
          stx ACT_OBJ
          lda lives
          beq +
          jsr CLEARSCREEN
+
;========
gotosilent2
          lda $d015
          and #$fe
          sta $d015
          lda #0
          sta govercount
          jmp silent_mode
;===================
gover_irq
          pha
          txa
          pha
          tya
          pha

          inc govercount
          lda govercount
          cmp #150
          bcc +

          jmp ustaw_yscoreirq

+        lda lives
          bne +

          lda $d015
          and #$fe
          sta $d015
          lda #0
          sta lives

+
          jsr cnt_msx
          lda $d01f
          sta KOLIZJA_BMP
          lda $d01e
          sta KOLIZJA_SPR
          jsr enable_ufo
          jsr szukajkolizjiufo
          jsr move_UFO
          jsr rozbijaj
          jsr rozbijaj_UFO
          inc IRQCNTR
          inc $d019

          pla
          tay
          pla
          tax
          pla
          rti
;=====
ustaw_coinirq
          jsr startheartb
          lda #<coinbmp
          ldy #>coinbmp
          jsr decrunch
          jsr zapal_astery
          lda #<coin_irq
          sta $fffe
          lda #>coin_irq
          sta $ffff
          lda $d015
          and #$fe
          sta $d015
          ldx #$ff
          txs
;stamp
          lda MANY_OBJ
          bne gotosilent3
;========
          ldx many_start_obj
          inx
          cpx #12
          bcc nomaxi3
          ldx #12
nomaxi3
          stx MANY_OBJ
          stx ACT_OBJ
          lda lives
          beq +
          jsr CLEARSCREEN
+
;========
gotosilent3
          lda $d015
          and #$fe
          sta $d015
          lda #0
          sta UFO_kula
          sta govercount
          jmp silent_mode
;===================
coin_irq
          pha
          txa
          pha
          tya
          pha
          jsr KEY7
          lda #$90
          jsr setfastbeat
cntufo= *+1
          lda #$01
          and #$07
          bne +
          lda #$80
          sta nmicounter
          jmp ustaw_hscoresirq

+        lda lives
          bne +

          lda $d015
          and #$fe
          sta $d015
          lda #0
          sta lives
          lda is_UFO
          bne +
          lda rozbij_UFO
          bne +
          lda IRQCNTR
          and #$3f
          bne +
          jsr enufo2
          jsr ufostopsound
          inc cntufo

+
          jsr cnt_msx
          lda $d01f
          sta KOLIZJA_BMP
          lda $d01e
          sta KOLIZJA_SPR
          jsr szukajkolizjiufo
          jsr move_UFO
          jsr rozbijaj
          jsr rozbijaj_UFO
          inc IRQCNTR
          inc $d019
          lda $dc00
          and #$10
          beq repete3
          lda #$ef
          cmp $dc01
          bne +
repete3

          jsr disable_ufo
          jsr CLEARSCREEN
          lda #many_started_objects
          sta many_start_obj
          lda #0
          sta ufo_model_poz
          jmp RELOAD
+        pla
          tay
          pla
          tax
          pla
          rti
;=====
ustaw_yscoreirq
          sei
          jsr findhigh11
          lda myplace
          bpl +
          jmp ustaw_coinirq
+
          jsr disable_ufo
          bit $d011
          bpl *-3
          lda #$0b
          sta $d011
          lda #$60
          sta $d015
          lda #0
          sta $d418

;===
          lda #<youscore
          ldy #>youscore
          jsr decrunch

          lda #$3b
          sta $d011


          ldx #2
-        lda #26
          sta initials,x
          jsr writeletter
          dex
          bpl -
lopgetdata
          inx
          cpx #3
          bcc +
          jmp rewriteinitials
+        lda #$00
          sta initials,x
getletter
          lda initials,x
          jsr writeletter
          jsr KEY7

          ldy $dc00
          tya
          and #$02
          bne +
          jsr smalldelay
          cpy $dc00
          beq *-3
          jsr smalldelay
          jmp lopgetdata
+        tya
          and #$04
          bne +
          dec initials,x
          bpl *+7
          lda #26
          sta initials,x
          jsr smalldelay
          jmp getletter

+        tya
          and #$08
          bne +

          inc initials,x
          lda initials,x
          cmp #27
          bcc *+7
          lda #0
          sta initials,x
          jsr smalldelay
+        jmp getletter
;===========
smalldelay
          pha
          txa
          pha
          tya
          pha
          ldx #0
          dey
          bne *-1
          dex
          bne *-4
          pla
          tay
          pla
          tax
          pla
          rts
;===
rewriteinitials
          lda #<wyniki
          sta VEC1
          lda #>wyniki
          sta VEC1HI
          ldx #9
-         lda mainscores,x
          cmp myplace
          beq +
          dex
          bne -
+        txa
          asl
          asl
          asl
          adc VEC1
          sta VEC1
          lda VEC1HI
          adc #0
          sta VEC1HI

          ldy #$05
-
          lda dtwrite,y
          sta (VEC1),y
          iny
          cpy #8
          bcc -
;===

          ldx #$ff
          txs
          lda #$80
          sta nmicounter
          jsr startheartb
          inc $d019
          jmp ustaw_hscoresirq
;====
dtwrite
     !byte 0,0,0,0,0
initials
     !byte 0,0,0
;====
writeletter
          pha
          jsr setadletter
          pla
          tay
          lda tblo16char,y
          sta VEC1
          lda tbhi16char,y
          sta VEC1HI

          ldy #$0f
-
          lda (VEC1),y
          sta (STPLOT),y
          dey
          bpl -

          lda VEC1
          clc
          adc #$40
          sta VEC1
          lda VEC1HI
          adc #1
          sta VEC1HI
          lda STPLOT
          adc #$40
          sta STPLOT
          lda STPLOTHI
          adc #1
          sta STPLOTHI

          ldy #$0f
-
          lda (VEC1),y
          sta (STPLOT),y
          dey
          bpl -


          rts
;===
setadletter
          txa
          pha
          ldy #160
          ldx #150
          LDA TABLO,Y
          clc
          adc TABXM,x
          STA STPLOT
          LDA TABHI,Y
          adc #0
          STA STPLOTHI
          pla
          pha
          asl
          asl
          asl
          asl
          adc STPLOT
          sta STPLOT
          lda STPLOTHI
          adc #0
          sta STPLOTHI
          pla
          tax
          rts
;=========================
ustaw_hscoresirq

          lda #<hscoresirq
          sta $fffe
          lda #>hscoresirq
          sta $ffff

          lda #<coinbmp
          ldy #>coinbmp
          jsr decrunch
          lda #<hscore
          ldy #>hscore
          jsr decrunch
          jsr startheartb
          jsr disable_ufo
          ldx #$ff
          txs
          lda #0
          sta $d418
          sta UFO_kula
          cli
          jsr findhigh10
          lda #$00
          sta XAHI
          sta myplace

          lda #56
          sta YA
          lda #112
          sta XA

          LDX XA
          LDY YA
;========


          LDA TABLO,Y
          clc
          adc TABXM,x
          STA STPLOT
          LDA TABHI,Y
          adc #0
          STA STPLOTHI

lopscores
          lda myplace
          sec
          adc #0
          asl
          asl
          asl
          tax

          ldy #0
-         lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #8
          bne -

          ldy #$0e
          lda #$40
          sta (STPLOT),y

          lda #<wyniki
          sta VEC1
          lda #>wyniki
          sta VEC1HI

          ldx #9
-         lda mainscores,x
          cmp myplace
          beq +
          dex
          bne -
+        txa
          asl
          asl
          asl
          adc VEC1
          sta VEC1
          lda VEC1HI
          adc #0
          sta VEC1HI

          lda #0
          sta VEC2

          ldy #0
          lda (VEC1),y
          beq +
          asl
          asl
          asl
          tax
          ldy #16
          inc VEC2
-        lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #24
          bne -



+        ldy #1
          lda (VEC1),y
          asl
          asl
          asl
          tax
          lda VEC2
          bne *+5
          txa
          beq +
          ldy #24
          inc VEC2
-        lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #32
          bne -

+        ldy #2
          lda (VEC1),y
          asl
          asl
          asl
          tax
          lda VEC2
          bne *+5
          txa
          beq +
          ldy #32
          inc VEC2
-        lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #40
          bne -

+        ldy #3
          lda (VEC1),y
          asl
          asl
          asl
          tax
          lda VEC2
          bne *+5
          txa
          beq +
          ldy #40
          inc VEC2
-        lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #48
          bne -

+        ldy #4
          lda (VEC1),y
          asl
          asl
          asl
          tax
          lda VEC2
          bne *+5
          txa
          beq +
          ldy #48
-        lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #56
          bne -

+        ldy #56
          ldx #0
-        lda fonts1,x
          sta (STPLOT),y
          iny
          inx
          cpy #64
          bne -

          ldy #5
          lda (VEC1),y
          asl
          asl
          asl
          tax
          ldy #72
-
          lda cset8,x
          sta (STPLOT),y
          iny
          inx
          cpy #80
          bne -

          ldy #6
          lda (VEC1),y
          asl
          asl
          asl
          tax
          ldy #80
-
          lda cset8,x
          sta (STPLOT),y
          iny
          inx
          cpy #88
          bne -

          ldy #7
          lda (VEC1),y
          asl
          asl
          asl
          tax
          ldy #88
-
          lda cset8,x
          sta (STPLOT),y
          iny
          inx
          cpy #96
          bne -


          lda STPLOT
          clc
          adc #$40
          sta STPLOT
          lda STPLOTHI
          adc #1
          sta STPLOTHI
          inc myplace
          lda myplace
          cmp #10
          beq +
          jmp lopscores
+        lda STPLOT
          sec
          sbc #$40
          sta STPLOT
          lda STPLOTHI
          sbc #1
          sta STPLOTHI

          ldy #0
-        lda fonts1,y
          sta (STPLOT),y
          iny
          cpy #8
          bne -
          lda STPLOT
          sec
          sbc #8
          sta STPLOT
          lda STPLOTHI
          sbc #0
          sta STPLOTHI
          ldy #0
-        lda fonts1+8,y
          sta (STPLOT),y
          iny
          cpy #8
          bne -

          cli
          jmp *
;===================
hscoresirq
          pha
          txa
          pha
          tya
          pha

          inc $d019
          jsr KEY7
          lda nmicounter
          cmp #$a0
          bne +
          inc cntufo
          jsr startheartb
          jmp ustaw_coinirq
+


          lda $dc00
          and #$10
          beq repete3b
          lda #$ef
          cmp $dc01
          bne +
repete3b
          lda is_UFO
          bne +
          jsr CLEARSCREEN
          lda #many_started_objects
          sta many_start_obj
          lda #0
          sta ufo_model_poz
          jsr startheartb
          jmp RELOAD


+        pla
          tay
          pla
          tax
          pla
          rti
;===================
;== Paragraph @ZROB_SPRAJTY@ =====

ZROB_SPRAJTY
		
          LDA #$10
          STA SHIP_NR_ROT
KIO
          DEC SHIP_NR_ROT
          BPL +
          RTS
+
          LDY SHIP_NR_ROT

          LDA #$00
          STA STPLOTHI
          TYA
          ASL
          ASL
          ASL
          ASL
		
          ASL
          ROL STPLOTHI
          ASL
          ROL STPLOTHI

          STA STPLOT
		      LDA #$6C
		      CLC
          ADC STPLOTHI
          STA STPLOTHI

          LDA XPOZ,Y
          STA DX
          LDA YPOZ,Y
          STA DY
          LDA XSIGN,Y
          STA DXSIGN
          LDA YSIGN,Y
          STA DYSIGN

          LDA #0
          STA XAHI
          STA CTRL_DX

          LDA #10
          STA XA
          STA YA

          LDA #SPEED_KULA -1
          STA CALCSTEP

          LDY DX
          CPY DY
          TAY
          BCC NX_DY_GORA
          CLC

NX_DX_GORA
          LDA DXSIGN
          BNE NX_DX_G2
          LDA DYSIGN
          BEQ NX_DX_G0
-
          INC XA
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          INC YA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
          JMP KIO

NX_DX_G0

-
          INC XA
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          DEC YA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
          JMP KIO

NX_DX_G2
          LDA DYSIGN
          BNE NX_DX_G3
-
          DEC XA
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          DEC YA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
          JMP KIO

NX_DX_G3

-
          DEC XA
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          INC YA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
          JMP KIO



NX_DY_GORA
          LDA DYSIGN
          BNE NX_DY_G2
          LDA DXSIGN
          BNE NX_DY_G0
-
          DEC YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          INC XA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
		
          JMP KIO
NX_DY_G0

-
          DEC YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          DEC XA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
		
          JMP KIO


NX_DY_G2
          LDA DXSIGN
          BNE NX_DY_G3
-
          INC YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          INC XA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
          JMP KIO

NX_DY_G3

-
          INC YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          DEC XA
+
          STA CTRL_DX
          JSR PLOT_SPRAJT
          DEC CALCSTEP
          BNE -
          JMP KIO
;---
;=== silna proca do plota na sprajcie
PLOT_SPRAJT
		
          LDX YA
          LDA TAB_Y_SPRAJT,X
          LDX XA
          CLC
          ADC TAB_X_SPRAJT,X
          TAY
          LDA (STPLOT),Y
          ORA TBBIT,X
          STA (STPLOT),Y
          RTS
;==================================
szukajkolizjistatku
          lda #1
          sta jestkolizja

          lda SPRIT0
          sec
          sbc #$90
          and #$1f
          tax

          lda TAB_SPRITE_AD_LO,x
          sta SPR_PLOT
          lda TAB_SPRITE_AD_HI,x
          sta SPR_PLOTHI


          lda $d010
          and #1
          bne +
          lda $d000
          cmp #24
          bcs +
          lda #0
          sta STARTBMPX
          sta STARTBMPXHI
          jmp nosub1
+        LDA $D000
          sec
          sbc #24
          STA STARTBMPX
          LDA $D010
          AND #1
          SBC #0
          STA STARTBMPXHI
nosub1
          LDA $D001
          sec
          sbc #50
          bcs +
zero_scr  lda #0
+        sta STARTBMPY

;jsr PLOT
;ok zlapaliśmy baze pierwszego plota na bitmapie
;teraz trzeba szukac bazy pierwszego plota na sprajcie

          lda $d001
          cmp #50
          bcs frline0
          lda #50
          sec
          sbc $d001
     !byte $2c
frline0   lda #$00
          sta spr_from_line
          sta linebase

          lda $d001
          cmp #229
          bcc toline0
          lda #250
          sbc $d001
     !byte $2c
toline0   lda #21
          sta spr_to_line

          lda $d010
          and #1
          bne frompixel0
          lda $d000
          cmp #24
          bcs frompixel0
          lda #24
          sbc $d000
     !byte $2c
frompixel0
          lda #$00
          sta spr_from_pixel

          lda $d010
          and #1
          beq topixel24
          lda $d000
          cmp #$41
          bcc topixel24
          lda #$40+24
          sbc $d000
     !byte $2c
topixel24
          lda #24
          sta spr_to_pixel



testsprajta0
;CO NOWĄ LINIE TU WRACAĆ
          LDA spr_from_pixel
          STA SPR_XA

testsprajta01

          LDX spr_from_line
          LDA TAB_Y_SPRAJT,X
          LDX SPR_XA
          CLC
          ADC TAB_X_SPRAJT,X
          TAY
          LDA (SPR_PLOT),Y
          BEQ next8bit
          and TBBIT,X
          beq next1bit

          lda spr_from_line
          sec
linebase=*+1
          sbc #$00
          clc
          adc STARTBMPY
          tay

          lda SPR_XA
          sec
          sbc spr_from_pixel
          clc
          adc STARTBMPX
          tax
;========
          LDA TABHI,Y
          ADC STARTBMPXHI

          STA BMPPLOTHI
          LDA TABLO,Y
          STA BMPPLOT
          LDY TABXM,X

          LDA (BMPPLOT),Y
          and TBBIT,X
          bne findedplot

;===
          jmp next1bit
;===

next8bit  lda SPR_XA
          ora #7
          sta SPR_XA
next1bit  inc SPR_XA
          lda SPR_XA
          cmp spr_to_pixel
          beq nast_linia
          bcc testsprajta01
nast_linia
          inc spr_from_line
          lda spr_from_line
          cmp spr_to_line
          bne testsprajta0
          rts
;===

findedplot

          lda spr_from_line
          sec
          sbc linebase
          clc
          adc STARTBMPY
          sta STARTBMPY
          tay

          lda SPR_XA
          sec
          sbc spr_from_pixel
          clc
          adc STARTBMPX

          tax

          LDA TABLO,Y
          clc
          adc TABXM,X
          sta BMPPLOT
          bcc +
          inc BMPPLOTHI
+

          lda BMPPLOT
          sec
          sbc TABLO,y
          sta STARTBMPX
          lda BMPPLOTHI
          sbc TABHI,y
          sta STARTBMPXHI
          lda STARTBMPX
          txa
          and #7
          ora STARTBMPX
          sta STARTBMPX

;========

          lda STARTBMPX
          STA XA
          lda STARTBMPY
          STA YA
          lda STARTBMPXHI
          STA XAHI
;========


          LDX #0
          LDA MANY_OBJ
          STA TMPR1

szukaj_w_y

          LDA YA
          CMP TBOBJ_Y,X
          BCC testuj_next_obj ;KOLIZJA JEST WYŻEJ NIŻ POCZĄTEK RYSOWANEGO OBIEKTU

          lda TBOBJ_TO_LINE,X
          ;sec ;CARRY =1 AFTER COMPARISION
          sbc TBOBJ_FROM_LINE,X
          beq testuj_next_obj
          CLC
          ADC TBOBJ_Y,X
          CMP YA
          BCS szukaj_w_x
;==
testuj_next_obj
          INX ; ALBO ZAPAMIETAĆ X NA zp !!!
          DEC TMPR1
          BNE szukaj_w_y
;          rts ;!!! NIE ZNALEZIONO KOLIZJI KULI !!!

          lda UFO_kula
          bne *+3
szukk2a
          rts
          lda UFO_KULA_Y_LO
          cmp STARTBMPY
          bne szukk2a
          lda UFO_KULA_X_LO
          cmp STARTBMPX
          bne szukk2a
          lda UFO_KULA_X_HI
          cmp STARTBMPXHI
          bne szukk2a
          lda #0
          sta UFO_kula
          sta jestkolizja

          LDX STARTBMPX
          LDY STARTBMPY
;========
          LDA TABHI,Y
          CLC
          ADC STARTBMPXHI
          STA SPR_PLOTHI
          LDA TABLO,Y
          STA SPR_PLOT
          LDY TABXM,X

          LDA (SPR_PLOT),Y
          EOR TBBIT,X
          STA (SPR_PLOT),Y
          rts
;===
szukaj_w_x

          lda TBOBJ_X_HI,x
          beq +
          lda TBOBJ_X_LO,x
          cmp #$40
          bcc +
          jmp extra_x_test ;szukanie kolizji z obiektem przesuniętym w prawo

+        LDA TBOBJ_X_LO,X
          SEC ;CARRY IS SET AFTER COMPARISION
          SBC XA
          tay
          LDA TBOBJ_X_HI,X
          SBC XAHI
          BMI +
          CPY #$00
          BNE testuj_next_obj
          CMP #$00
          BNE testuj_next_obj
+
          STY MAXXLO
          STA MAXXHI
          LDA TBOBJ_TO_COLUMN,X
          CLC ;TAK CLC BO MA BYĆ WIĘKSZY WYNIK O JEDEN
          ADC #2 ;TU POWIEKSZAMY NASZ WYNIK
          SBC TBOBJ_FROM_COLUMN,X
          asl
          asl
          asl
          adc MAXXLO
          STA MAXXLO
          BCC +
          INC MAXXHI
+        lda MAXXHI
          beq testuj_plot_obj
          jmp testuj_next_obj
;===
;ODCZYTANIE PLOTA OBIEKTU CZY BYŁA KOLIZJA
testuj_plot_obj

          stx TMPR2

          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI


          lda YA
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+        lda XA
          sec
          sbc TBOBJ_X_LO,x
          ;888 - korekta o przesunięcie w prawo obiektu
          sta PLOX_MOD
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x

          lda (FINDAST),y
          and TBBIT,x
          beq +
          lda #0
          sta jestkolizja
          jmp zamien_obiekt2


+        ldx TMPR2
          jmp testuj_next_obj
;============
extra_x_test
          sbc #$40
          cmp XA
          bcs +
          jmp testuj_next_obj
+
          clc
          sbc XA
          sta PLOX_NOMOD
          lda TBOBJ_MAX_Y,x
          sec ;dla poprawnego offsetu !
          sbc PLOX_NOMOD
          sta PLOX_MOD
          stx TMPR2
          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI


          lda YA
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+
          ; - korekta o przesunięcie w prawo obiektu
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x


          lda (FINDAST),y
          and TBBIT,x
          beq +

          lda #0
          sta jestkolizja
          jmp zamien_obiekt2


+        ldx TMPR2
          jmp testuj_next_obj
;============
szukajkolizjiufo
!IF NOKILLUFO = 1 {
     RTS
}
          lda is_UFO
          bne *+3
          rts
;=== kolizja ufo ze statkiem
          ldx KOLIZJA_SPR
          txa
          and #$81
          cmp #$81
          bne +
          jmp ufoistatekcoll
;=============
;zestrzelony statek przez ufo
+        txa
          and #$41
          cmp #$41
          bne +
          jmp ufoshutdownship
;=== - zestrzelone ufo przez statek
+        txa
          bpl +
          ;and #$c0
          cmp #$c0
          beq +
          jsr ubij_ufo
          jsr explosion
          jmp disable_ufo
;=========
+
          lda KOLIZJA_BMP
          and #$80
          bmi +
          rts
;========
+
          lda SPRIT0+7
          and #1
          bne +
          lda #$80
     !byte $2c
+         lda #$40


          sta SPR_PLOT
          lda #$70
          sta SPR_PLOTHI

          lda $d010
          bmi +
          lda $d00e
          cmp #24
          bcs +
          lda #0
          sta STARTBMPX
          sta STARTBMPXHI
          jmp ufo_nosub1
+        LDA $d00e
          sec
          sbc #24
          STA STARTBMPX
          php
          LDA $D010
          asl
          rol
          AND #1
          plp
          SBC #0
          STA STARTBMPXHI
ufo_nosub1
          LDA $d00f
          sec
          sbc #50
          bcs +
ufo_zero_scr  lda #0
+        sta STARTBMPY


;ok zlapaliśmy baze pierwszego plota na bitmapie
;teraz trzeba szukac bazy pierwszego plota na sprajcie

          lda $d00f
          cmp #50
          bcs ufo_frline0
          lda #50
          sec
          sbc $d00f
     !byte $2c
ufo_frline0   lda #$00
          sta spr_from_line
          sta ufo_linebase

          lda $d00f
          cmp #229
          bcc ufo_toline0
          lda #250
          sbc $d00f
     !byte $2c
ufo_toline0   lda #21
          sta spr_to_line

          lda $d010
          bmi ufo_frompixel0
          lda $d00e
          cmp #24
          bcs ufo_frompixel0
          lda #24
          sbc $d00e
     !byte $2c
ufo_frompixel0
          lda #$00
          sta spr_from_pixel

          lda $d010
          bpl ufo_topixel24
          lda $d00e
          cmp #$41
          bcc ufo_topixel24
          lda #$40+24
          sbc $d00e
     !byte $2c
ufo_topixel24
          lda #24
          sta spr_to_pixel



ufo_testsprajta0
;CO NOWĄ LINIE TU WRACAĆ
          LDA spr_from_pixel
          STA SPR_XA

ufo_testsprajta01

          LDX spr_from_line
          LDA TAB_Y_SPRAJT,X
          LDX SPR_XA
          CLC
          ADC TAB_X_SPRAJT,X
          TAY
          LDA (SPR_PLOT),Y
          BEQ ufo_next8bit
          and TBBIT,X
          beq ufo_next1bit

          lda spr_from_line
          sec
ufo_linebase=*+1
          sbc #$00
          clc
          adc STARTBMPY
          tay

          lda SPR_XA
          sec
          sbc spr_from_pixel
          clc
          adc STARTBMPX
          tax
;========
          LDA TABHI,Y
          ADC STARTBMPXHI

          STA BMPPLOTHI
          LDA TABLO,Y
          STA BMPPLOT
          LDY TABXM,X

          LDA (BMPPLOT),Y
          and TBBIT,X
          bne ufo_findedplot

;===
          jmp ufo_next1bit
;===

ufo_next8bit  lda SPR_XA
          ora #7
          sta SPR_XA
ufo_next1bit  inc SPR_XA
          lda SPR_XA
          cmp spr_to_pixel
          beq ufo_nast_linia
          bcc ufo_testsprajta01
ufo_nast_linia
          inc spr_from_line
          lda spr_from_line
          cmp spr_to_line
          bne ufo_testsprajta0
          ;jsr disable_ufo !!! nie ma kolizji nie kasujemy
          rts
;===

ufo_findedplot

          lda spr_from_line
          sec
          sbc ufo_linebase
          clc
          adc STARTBMPY
          sta STARTBMPY
          tay

          lda SPR_XA
          sec
          sbc spr_from_pixel
          clc
          adc STARTBMPX

          tax

          LDA TABLO,Y
          clc
          adc TABXM,X
          sta BMPPLOT
          bcc +
          inc BMPPLOTHI
+

          lda BMPPLOT
          sec
          sbc TABLO,y
          sta STARTBMPX
          lda BMPPLOTHI
          sbc TABHI,y
          sta STARTBMPXHI
          lda STARTBMPX
          txa
          and #7
          ora STARTBMPX
          sta STARTBMPX

;========

          lda STARTBMPX
          STA XA
          lda STARTBMPY
          STA YA
          lda STARTBMPXHI
          STA XAHI
;========


          LDX #0
          LDA MANY_OBJ
          STA TMPR1

ufo_szukaj_w_y

          LDA YA
          CMP TBOBJ_Y,X
          BCC ufo_testuj_next_obj ;KOLIZJA JEST WYŻEJ NIŻ POCZĄTEK RYSOWANEGO OBIEKTU

          lda TBOBJ_TO_LINE,X
          ;sec ;CARRY =1 AFTER COMPARISION
          sbc TBOBJ_FROM_LINE,X
          beq ufo_testuj_next_obj
          CLC
          ADC TBOBJ_Y,X
          CMP YA
          BCS ufo_szukaj_w_x
;==
ufo_testuj_next_obj
          INX ; ALBO ZAPAMIETAĆ X NA zp !!!
          DEC TMPR1
          BNE ufo_szukaj_w_y
          ;;;jmp UFOK_UNNAMED_COLLISION
          ;rts ;!!! NIE ZNALEZIONO KOLIZJI z meteorem wiec kolizja z kula statku
          ;jsr ustaw_ufo_sand
szukajkuli
;!!! tu dorobić poszukiwania i wyłączenie kuli ze statku

          lda USED_KUL
          bne *+3
          rts
          ldx #3
-
          lda KULA0,x
          beq szukk2
          lda KULA_Y_LO,x
          cmp STARTBMPY
          bne szukk2
          lda KULA_X_LO,x
          cmp STARTBMPX
          bne szukk2
          lda KULA_X_HI,x
          cmp STARTBMPXHI
          bne szukk2
          lda #0
          sta KULA0,x
          dec USED_KUL

          lda SPR_PLOT
          bmi plus200
          jsr dodaj1000
          jmp +
plus200   jsr dodaj200
+
          LDX STARTBMPX
          LDY STARTBMPY
;========
          LDA TABHI,Y
          CLC
          ADC STARTBMPXHI
          STA SPR_PLOTHI
          LDA TABLO,Y
          STA SPR_PLOT
          LDY TABXM,X

          LDA (SPR_PLOT),Y
          EOR TBBIT,X
          STA (SPR_PLOT),Y
          jmp disable_ufo
szukk2    dex
          bpl -

          rts

;===
ufo_szukaj_w_x

          lda TBOBJ_X_HI,x
          beq +
          lda TBOBJ_X_LO,x
          cmp #$40
          bcc +
          jmp ufo_extra_x_test ;szukanie kolizji z obiektem przesuniętym w prawo

+        LDA TBOBJ_X_LO,X
          SEC ;CARRY IS SET AFTER COMPARISION
          SBC XA
          tay
          LDA TBOBJ_X_HI,X
          SBC XAHI
          BMI +
          CPY #$00
          BNE ufo_testuj_next_obj
          CMP #$00
          BNE ufo_testuj_next_obj
+
          STY MAXXLO
          STA MAXXHI
          LDA TBOBJ_TO_COLUMN,X
          CLC ;TAK CLC BO MA BYĆ WIĘKSZY WYNIK O JEDEN
          ADC #2 ;TU POWIEKSZAMY NASZ WYNIK
          SBC TBOBJ_FROM_COLUMN,X
          asl
          asl
          asl
          adc MAXXLO
          STA MAXXLO
          BCC +
          INC MAXXHI
+        lda MAXXHI
          beq ufo_testuj_plot_obj
          jmp ufo_testuj_next_obj
;===
;ODCZYTANIE PLOTA OBIEKTU CZY BYŁA KOLIZJA
;===
ufo_testuj_plot_obj

          stx TMPR2
          ;jmp zufo_amien_obiekt

          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI


          lda YA
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+        lda XA
          sec
          sbc TBOBJ_X_LO,x
          ;888 - korekta o przesunięcie w prawo obiektu
          sta PLOX_MOD
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x

          lda (FINDAST),y
          and TBBIT,x
          beq +
          jmp ufo_zamien_obiekt


+        ldx TMPR2
          jmp ufo_testuj_next_obj
;============
ufo_extra_x_test
          sbc #$40
          cmp XA
          bcs +
          jmp ufo_testuj_next_obj
+
          clc
          sbc XA
          sta PLOX_NOMOD
          lda TBOBJ_MAX_Y,x
          sec ;dla poprawnego offsetu !
          sbc PLOX_NOMOD
          sta PLOX_MOD
          stx TMPR2
          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI


          lda YA
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+
          ; - korekta o przesunięcie w prawo obiektu
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x


          lda (FINDAST),y
          and TBBIT,x
          beq +


          jmp ufo_zamien_obiekt


+        ldx TMPR2
          jmp ufo_testuj_next_obj
;============
ufo_zamien_obiekt
          ldx TMPR2
          lda TBOBJ_NR,x
          cmp #32
          bcs +
          jsr disable_ufo
          jsr rozbij_duzy_ufo
ustaw_ufo_sand
          lda #1
          sta rozbij_UFO
          rts
+   		  cmp #64
          bcs +
          jsr disable_ufo
          jsr rozbij_sredni_ufo
          jmp ustaw_ufo_sand
+        jsr disable_ufo
          jsr ustaw_ufo_sand
          jmp zlikwiduj_obiekt_ufo
;===============================
ufoistatekcoll
          lda SPRIT0+7
          and #1
          beq *+8
          jsr dodaj1000
          jmp *+6
          jsr dodaj200
          jsr disable_ufo
          lda #1
          sta rozbij_UFO
          jsr ubijstatek
          jsr kasuj_kulki
;stamp
          lda MANY_OBJ
          beq +
reufo
          lda lives
          bne reufo2
reufo4
          jmp setgameover
;===
reufo2
          lda #0
          sta IRQCNTR
          lda #<safeirqship
          sta $fffe
          lda #>safeirqship
          sta $ffff
          rts
;===
          lda $d015
          and #$fe
          sta $d015
          jsr INITPOZSHIP
          lda #0
          sta COUNT_ANIM
          sta IGNORE_KOLIZJA
          lda $d015
          and #$fe
          sta $d015
          rts
;======================
+
;===
          ldx #12
          inc many_start_obj
          lda many_start_obj
          cmp #13
          bcc +
          stx many_start_obj
+        lda many_start_obj
          sta MANY_OBJ
          lda lives
          bne +
          jmp setgameover
+
sandal
          lda $d015
          ora #1
          sta $d015
          jmp reload_level
;===

;======================
ubijstatek
          lda #1
          ;!ROZBIJAMY STATEK - ALE JESZCZE TRZEBA ZNALEZC POZNIEJ Z CZYM SIE STATEK ROZBIL
          STA IGNORE_KOLIZJA ;ZNACZNIK IGNOROWANIA KLAWIATURY
          jsr turn_off_thrust
          jsr explosion
          jsr bezpylu
;===
          lda #0
          sta klatkapyl
;==

          LDA #$00
          sta WYSTRZEL

          STA SHIP_SPEED ;STATEK NIE RUSZA SIE
          STA DAJ_GAZU
          LDA #BANKSHIP+51
          STA SPRIT0
          LDA #7
          STA COUNT_FRAME
          STA COUNT_FR2
          LDA #7
          STA COUNT_ANIM

          jsr kasujstatki2
          lda #0
          sta KULA_KOLIZJA
          lda $d000
          sta $d002
          lda $d001
          sta $d003
          lda $d010
          and #1
          asl
          ora $d010
          sta $d010

          rts
ufoshutdownship
          jsr ubijstatek
          jsr disable_ufo
;ubijkuleufo
          LDA lives
          BNE +
          JMP setgameover
+
;stamp

          lda MANY_OBJ
          beq +
          rts
+
          jsr CLEARSCREEN
          jmp next_level
;=======
bezpylu
          pha
          lda #$10
          sta klatkapyl
          sta klatkapyl+1
          sta klatkapyl+2
          sta klatkapyl+3
          pla
          rts
ubij_ufo
          jsr bezpylu
          ldy #1
          sty rozbij_UFO
          txa
          ldx #$ff
          sec
          ror

-         inx
          lsr
          bcc -

          lda USED_KUL
          bne +
          rts
+        dec USED_KUL
          lda #0
          stx KULA_KOLIZJA
          sta KULA0,X
          lda KULA_X_LO,X
          sta XA
          lda KULA_X_HI,X
          sta XAHI
          lda KULA_Y_LO,X
          sta YA
          LDX XA
          LDY YA
;========

          LDA TABHI,Y
          CLC
          ADC XAHI
          STA STPLOTHI
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y

          lda SPRIT0+7
          and #1
          beq *+8
          jsr dodaj1000
          jmp *+6
          jsr dodaj200
          rts
;====
malujscore
;w x powinno być 0
          lda scores,x
          bne zapiszcyfre
          inx
          cpx #5
          bne malujscore
zapiszcyfre
          stx cyfra_nr
          ldy #<viewcounter
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
          cpx #3
          bcc +
          ldy #$40
          sty ady_cyfra
          dex
          dex
          dex
+        pha
          txa
          tay
          pla
          asl
          asl
          asl
          tax

-         lda fonts1,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          txa
          and #7
          bne -

          ldx cyfra_nr
          cpx #5
          beq malujscore2
niepisz1  inx
          lda scores,x
          jmp zapiszcyfre
malujscore2

          lda lives
          beq niemalujstatkow
          cmp #7
          bcc *+4
          lda #6
          sta liczstatki
          lda #0
          sta cyfra_nr
malujstatki
          ldy #<viewcounter
          sty ady_cyfra
          ldy #>viewcounter
          sty ady_cyfra+1
          lda cyfra_nr
          cmp #3
          bcc +
          ldy #$40
          sty ady_cyfra
          sbc #3
+        clc
          adc #36
          tay
          ldx #0
-        lda fonts1+80,x
          sta (ady_cyfra),y
          iny
          iny
          iny
          inx
          cpx #8
          bcc -
          inc cyfra_nr
          dec liczstatki
          bne malujstatki

niemalujstatkow
          rts
;===
enable_ufo
!if ufo_off = 1 {
     rts
}
          lda is_UFO
          beq +
          rts
+        lda nmicounter
          beq +
          rts
enufo2
+        lda #1
          sta is_UFO
          lda #0
          sta UFO_kula

          lda $dd04
          and #$1f
          tax
          lda UFOystart,x
          sta $d00f
          lda UFOdx,x
          sta UFO_dx
          bne +
          sta $d00e
          lda $d010
          and #$7f
          sta $d010
          jmp setdy_ufo
+        lda $d010
          ora #$80
          sta $d010
          lda #$40+24
          sta $d00e
setdy_ufo
          ;może tu trasy pobierać

          lda ufo_model_poz
          inc ufo_model_poz
          and #$3f
          tax
          lda ufo_model,x
          and #1
          sta nr_UFO
          clc
          adc #$c1
          sta SPRIT0+7

          ldx #8
          lda nr_UFO
          beq +
-        lda BIG_UFO_data,x
          sta UFO_max_Y,x
          dex
          bpl -
          bmi ufowrote
+
-        lda SMALL_UFO_data,x
          sta UFO_max_Y,x
          dex
          bpl -

ufowrote

          lda trip_nr
          and #$1f
          tax
!if changetripufo = 0 {
          inc trip_nr
}
          lda TB_ad_lo_trip,x
          sta UFORtrip_adr
          lda TB_ad_hi_trip,x
          sta UFORtrip_adr+1

          lda $d015
          and #$01
          ora #$80
          sta $d015
          lda #1
          sta $d02e
          lda #0
          sta $d02d

          lda nr_UFO
          eor #1
          tax
          jsr ufosound
          jsr bezpylu
          rts
;===
disable_ufo ;don't touch registers
          pha ;safe acc
          txa
          pha
          tya
          pha
          jsr bezpylu
          lda #0
          sta is_UFO
          JSR KASUJ_UFO_KULE2
          lda $d015
          and #1
          sta $d015
          lda #55
          sta $d00b
          sta $d00d
          sta $d00a
          clc
          adc #24
          sta $d00c
          lda $d010
          ora #$60
          eor #$60
          sta $d010
          lda #$d4
          sta SPRIT0+5
          clc
          adc #1
          sta SPRIT0+6

          ldx #$7f
          lda #$00
-         sta viewcounter,x
          dex
          bpl -
          ldx #$00
          jsr malujscore

          lda $d015
          ora #$60
          sta $d015

          lda #1
          sta $d02c
          sta $d02d
          lda #1
          ;sta nmicounter

          lda MANY_OBJ
          bne +
-        lda many_start_obj
          sta MANY_OBJ
          jsr rozstaw_astery
+        lda MANY_OBJ
          bmi -


          jsr ufostopsound
msxlive
          bit extra_life
          lda #$2c
          sta msxlive

          pla
          tay
          pla
          tax
          pla ;restore acc
          rts
;=====
KASUJ_UFO_KULE2



          LDA UFO_kula
          BNE +
          RTS
+        LDA #0
          STA UFO_kula
          LDA $D015
          AND #%10111111
          STA $D015
          LDY UFO_KULA_Y_LO
          LDA TABHI,Y
          CLC
          ADC UFO_KULA_X_HI
          STA STPLOTHI

          LDA UFO_KULA_X_LO
          TAX

          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          RTS
;=====
move_UFO
          lda is_UFO
          bne +
          rts
+        lda UFO_dx
          beq +
          jmp ufowlewo
;=== ufo w prawo
+
          inc $d00e
          bne +
          lda $d010
          ora #$80
          sta $d010
+        lda $d010
          bpl +
          lda $d00e
          cmp #$40+24
          bcc +
          jmp disable_ufo
+        jmp ufomove_y
;===
ufowlewo
          dec $d00e
          lda $d00e
          cmp #$ff
          bne +
          lda $d010
          and #$7f
          sta $d010
          jmp ufomove_y
+        lda $d00e
          bne +
          lda $d010
          bmi +
          jmp disable_ufo
+        jmp ufomove_y
;===
;======================================
ufomove_y

          lda UFO_Y_trip
          bne +
          ldy UFO_poz_in_trip
          lda (UFORtrip_adr),y
          sta UFO_Y_trip
          iny
          lda (UFORtrip_adr),y
          sta UFO_dy
          iny
          sty UFO_poz_in_trip

+        dec UFO_Y_trip

          lda UFO_dy
          bne +
          jmp UFOSTARTKULA
+        cmp #1
          beq ufo_y_dodaj
          jmp ufo_y_ujmij
ufo_y_dodaj

          lda $d00f
          clc
          adc #1
          cmp UFO_max_Y
          bcc +
          lda UFO_min_y
+        sta $d00f

          jmp UFOSTARTKULA
;=====
ufo_y_ujmij

          lda $d00f
          sec
          sbc #1
          cmp UFO_min_y
          bcs +
          lda UFO_max_Y
+        sta $d00f


          jmp UFOSTARTKULA
;=====
UFOSTARTKULA

          lda UFO_kula
          beq +
          jmp UFO_PRZENIES_KULE
+
          LDA IRQCNTR
          AND #3
          BEQ +
          RTS
+
          LDA IGNORE_KOLIZJA ;CZY IGNOROWA� KOLIZJE (0 = NIE <> 0 = IGNORUJ)
          BEQ +
          RTS
+
          INC DELAY_UFO_BALL
          lda nr_UFO
          beq +
          LDA DELAY_UFO_BALL
          AND #$07
          BEQ dajglos
          RTS
+

          LDA DELAY_UFO_BALL
          AND #$01
          BEQ dajglos
          RTS
dajglos

          lda $d00e
          sta POZ_UFO_X_LO
          lda $d010
          and #$80
          asl
          rol
          sta POZ_UFO_X_HI

          lda $d00f
          sta POZ_UFO_Y

          cmp UFO_filed_min_Y
          bcs +
          rts
+        cmp UFO_field_max_Y
          bcc +
          rts
+
          lda POZ_UFO_X_HI
          bne +
          lda POZ_UFO_X_LO
          cmp UFO_field_min_X
          bcs +
          rts
+        lda POZ_UFO_X_HI
          beq +
          lda POZ_UFO_X_LO
          cmp UFO_field_max_X
          bcc +
          rts
+
          ;LDA #$09
          ;JSR $1000
          ;LDA #50
          ;STA IRQ_STRZAL
          jsr fire_bullet

          inc UFO_kula
          lda $dd04

          and #$0f
          tay
          STY UFO_KULA_NR_ROT ; ZAPAMIETAJ NR ROTACJI KULI
          lda nr_UFO
          bne +
          jsr testpoz
          and #$0f
          tay
          sta UFO_KULA_NR_ROT
+
          LDA POZ_UFO_X_LO
          CLC
          ADC OFF_KULA_X,Y
          STA UFO_KULA_X_LO

          LDA POZ_UFO_X_HI
          ADC #$00
          STA UFO_KULA_X_HI
		
          LDA UFO_KULA_X_LO
          SEC
          SBC #24
          STA UFO_KULA_X_LO
          BCS +
          DEC UFO_KULA_X_HI
+
          LDA UFO_KULA_X_HI
          BEQ +
          LDA UFO_KULA_X_LO
          CMP #$40
          BCC +
          CLC
          LDA #$00
          STA UFO_KULA_X_LO
          STA UFO_KULA_X_HI
+
          LDA POZ_UFO_Y
          CLC
          ADC OFF_KULA_Y,Y
          CMP #50
          BCS +
          LDA #51
+
          SBC #50
          CMP #200
          BCC +
          SBC #200
+
          STA UFO_KULA_Y_LO

          LDA #longliveball
          STA UFO_KULA_STEP

          LDA XSIGN,Y
          STA UFO_KULA_X_SIGN

          LDA YSIGN,Y
          STA UFO_KULA_Y_SIGN


          TYA
          ASL
          ASL
          ASL
          ASL ;CARRY IS CLEAR
          TAY
		
          LDA TAB_DELTA + SPEED_KULA-1 ,Y
          STA UFO_KULA_DX
          LDA TAB_DELTA + SPEED_KULA-1 + 8 ,Y
          STA UFO_KULA_DY



		;zapal pierwszy plot kuli UFO
		

          LDY UFO_KULA_Y_LO

          LDA TABHI,Y
          CLC
          ADC UFO_KULA_X_HI
          STA STPLOTHI

          LDX UFO_KULA_X_LO

		
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          ;tu sprawdzenie kolizji jak zgaszony - kolizja
          AND TBBIT,X
          bne UFO_ZAPAL_SPRAJTA
                         ;first_ufo_ball_col
          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          jmp UFO_KOLIZJA_Z_KULI
;=====
UFO_ZAPAL_SPRAJTA
;====
          ;!!! USUNAC W GRZE MA BYC CZARNE
          LDA #$00
          STA $D02d

          LDA UFO_KULA_Y_LO
          CLC
          ADC #40
          STA $D00d
				
          LDA UFO_KULA_X_LO
          ADC #14
          STA $d00c
		
          LDA $D010
          ORA #64
          BCS +
          LDY UFO_KULA_X_HI
          BNE +
          EOR #64
+
          STA $D010
          lda UFO_KULA_NR_ROT
          clc
          adc #BANKSHIP
          adc #$20
          sta SPRIT0+6
          LDA $D015
          ORA #64
          STA $D015
          RTS
;=============
KASUJ_UFO_KULE
          LDA $D015
          AND #%10111111
          STA $D015

          LDA UFO_kula
          BNE +
          RTS
+        LDA #0
          STA UFO_kula
          LDY UFO_KULA_Y_LO
          LDA TABHI,Y
          CLC
          ADC UFO_KULA_X_HI
          STA STPLOTHI

          LDA UFO_KULA_X_LO
          TAX

          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          ;sprawdz kolizje - jak zapalony to kolizja
          AND TBBIT,X
          Beq +
          ;znaleziono kolizję z kuli
          JMP UFO_KOLIZJA_Z_KULI
+        RTS
;============
UFO_PRZENIES_KULE

          DEC UFO_KULA_STEP
          BEQ KASUJ_UFO_KULE

          LDY UFO_KULA_Y_LO
          LDA TABHI,Y
          CLC
          ADC UFO_KULA_X_HI
          STA STPLOTHI

          LDA UFO_KULA_X_LO
          TAX

          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          EOR TBBIT,X
          STA (STPLOT),Y
          ;sprawdz kolizje - jak zapalony to kolizja
          AND TBBIT,X
          Beq +

          LDA (STPLOT),Y
          EOR TBBIT,X
          ;STA (STPLOT),Y
          ;znaleziono kolizję z kuli
          JMP UFO_KOLIZJA_Z_KULI
+

          lda UFO_KULA_X_LO
          sta UFO_OLDKULA_X_LO
          lda UFO_KULA_X_HI
          sta UFO_OLDKULA_X_HI
          lda UFO_KULA_Y_LO
          sta UFO_OLDKULA_Y_LO

          LDA UFO_OLDKULA_X_LO
          STA XA
          LDA UFO_OLDKULA_X_HI
          STA XAHI

          LDA UFO_OLDKULA_Y_LO
          STA YA
          LDA #$00
          STA CTRL_DX	;DO OBLICZEN ZEROWANIE TABELI PRZYROSTU
		
          LDA #SPEED_KULA ;LICZBA PLOTOW DO POSTAWIENIA W SZUKANIU TRASY I KOLIZJI
          STA CALCSTEP

          LDA UFO_KULA_X_SIGN
          STA DXSIGN
          LDA UFO_KULA_Y_SIGN
          STA DYSIGN
		
          LDY UFO_KULA_NR_ROT
          LDA XPOZ,Y
          STA DX
          LDA YPOZ,Y
          STA DY

;ZROB_PLOTY_KULI
		
          LDY DX
          CPY DY ;CO JEST WIEKSZE DX CZY DY?
          LDY YA
          BCS +
          JMP UFO_PNX_DY_GORA
+
          CLC

UFO_PNX_DX_GORA
          LDA DXSIGN
          BEQ +
          JMP UFO_PNX_DX_G2
+
          LDA DYSIGN
          BEQ UFO_PNX_DX_G0
-
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BCC +
          LDX #$00
          STX XA
          STX XAHI
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA
+
          STA CTRL_DX
          LDY YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
	
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +
		
          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          ;postawienie plota kuli po przesunięciu
          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DX_G0
-
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BNE +
          LDX #$00
          STX XA
          STX XAHI
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
+
          STA CTRL_DX
          LDY YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +
		
          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DX_G2
          LDA DYSIGN
          BNE UFO_PNX_DX_G3
-
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
+
          STA CTRL_DX
          LDX XA
          LDY YA

          LDA TABHI,Y
          CLC
          ADC XAHI
          STA STPLOTHI
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -

          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DX_G3
-
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          LDA CTRL_DX
          CLC
          ADC DY
          CMP DX
          BCC +
          SBC DX
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA
+
          STA CTRL_DX
          LDY YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -

          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DY_GORA
          LDA DYSIGN
          BEQ +
          JMP UFO_PNX_DY_G2
+
          LDA DXSIGN
          BNE UFO_PNX_DY_G0
-
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BNE +
          LDX #$00
          STX XA
          STX XAHI
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +
		
          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DY_G0
-
          LDY YA
          BNE *+4
          LDY #200
          DEY
          STY YA
          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DY_G2
          LDA DXSIGN
          BNE UFO_PNX_DY_G3
-
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA

          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          INC XA
          BNE *+6
          INC XAHI
          BNE +
          LDX XAHI
          BEQ +
          LDX XA
          CPX #$40
          BNE +
          LDX #$00
          STX XA
          STX XAHI
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X
          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
          JMP SET_NEW_UFO_BALL
;===
UFO_PNX_DY_G3
-
          LDY YA
          INY
          CPY #200
          BCC *+4
          LDY #0
          STY YA

          LDA CTRL_DX
          CLC
          ADC DX
          CMP DY
          BCC +
          SBC DY
          LDX XA
          BNE *+16
          LDX XAHI
          BNE *+10
          INC XAHI
          LDX #$3F
          STX XA
          BNE +
          DEC XAHI
          DEC XA
+
          STA CTRL_DX
          ;LDY YA ;JEST JUZ W Y YA
          LDA XAHI
          CLC
          ADC TABHI,Y
          STA STPLOTHI
          LDX XA
          LDA TABLO,Y
          STA STPLOT
          LDY TABXM,X

          LDA (STPLOT),Y
          AND TBBIT,X
          Beq +

          ;JEST KOLIZJA!
          JMP UFO_KOLIZJA_Z_KULI_X
+
          DEC CALCSTEP
          BNE -
;===
SET_NEW_UFO_BALL
;===
          lda (STPLOT),Y
          eor TBBIT,x
          STA (STPLOT),Y
          lda XA
          sta UFO_KULA_X_LO
          lda XAHI
          sta UFO_KULA_X_HI
          lda YA
          sta UFO_KULA_Y_LO
          JMP UFO_ZAPAL_SPRAJTA
;---
;=============
          rts
;=====
UFO_KOLIZJA_Z_KULI_X

          LDA XA		 ;PRZEPISANIE DANYCH KULI Z XA DO KULA,X
          STA UFO_KULA_X_LO
          LDA YA
          STA UFO_KULA_Y_LO
          LDA XAHI
          STA UFO_KULA_X_HI

UFO_KOLIZJA_Z_KULI

          LDA UFO_KULA_X_LO
          STA XA
          LDA UFO_KULA_X_HI
          STA XAHI
          LDA UFO_KULA_Y_LO
          STA YA

          LDX #0
          LDA MANY_OBJ
          STA TMPR1

UFOK_FIND_IN_Y

          LDA YA
          CMP TBOBJ_Y,X
          BCC UFOK_CHECK_NEXT_BALL ;KOLIZJA JEST WYŻEJ NIŻ POCZĄTEK RYSOWANEGO OBIEKTU

          lda TBOBJ_TO_LINE,X
          ;sec ;CARRY =1 AFTER COMPARISION
          sbc TBOBJ_FROM_LINE,X
          beq UFOK_CHECK_NEXT_BALL
          CLC
          ADC TBOBJ_Y,X
          CMP YA
          BCS UFOK_FIND_IN_X
;==
UFOK_CHECK_NEXT_BALL
          INX ; ALBO ZAPAMIETAĆ X NA zp !!!
          DEC TMPR1
          BNE UFOK_FIND_IN_Y
          JMP UFOK_UNNAMED_COLLISION ;!!! NIE ZNALEZIONO KOLIZJI KULI !!!
;===
UFOK_FIND_IN_X

          lda TBOBJ_X_HI,x
          beq +
          lda TBOBJ_X_LO,x
          cmp #$40
          bcc +
          jmp UFOK_testuj_extra_x ;szukanie kolizji z obiektem przesuniętym w prawo

+        LDA TBOBJ_X_LO,X
          SEC ;CARRY IS SET AFTER COMPARISION
          SBC XA
          tay
          LDA TBOBJ_X_HI,X
          SBC XAHI
          BMI +
          CPY #$00
          BNE UFOK_CHECK_NEXT_BALL
          CMP #$00
          BNE UFOK_CHECK_NEXT_BALL
+
          STY MAXXLO
          STA MAXXHI
          LDA TBOBJ_TO_COLUMN,X
          CLC ;TAK CLC BO MA BYĆ WIĘKSZY WYNIK O JEDEN
          ADC #2 ;TU POWIEKSZAMY NASZ WYNIK
          SBC TBOBJ_FROM_COLUMN,X
          asl
          asl
          asl
          adc MAXXLO
          STA MAXXLO
          BCC +
          INC MAXXHI
+        lda MAXXHI
          BNE UFOK_CHECK_NEXT_BALL
;===
;ODCZYTANIE PLOTA OBIEKTU CZY BYŁA KOLIZJA
UFOK_CHECK_PLOT_OBJ

          stx TMPR2
          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI

          lda UFO_KULA_Y_LO
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+        lda UFO_KULA_X_LO
          sec
          sbc TBOBJ_X_LO,x
          ;888 - korekta o przesunięcie w prawo obiektu
          sta PLOX_MOD
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x

          lda (FINDAST),y
          and TBBIT,x
          beq +
          jmp UFOK_skasuj_kule


+        ldx TMPR2
          jmp UFOK_CHECK_NEXT_BALL
;============
UFOK_testuj_extra_x
          sbc #$40
          cmp XA
          bcs +
          jmp UFOK_CHECK_NEXT_BALL
+
          clc
          sbc XA
          sta PLOX_NOMOD
          lda TBOBJ_MAX_Y,x
          sec ;dla poprawnego offsetu !
          sbc PLOX_NOMOD
          sta PLOX_MOD
          stx TMPR2
          ;w X nr obiektu
          lda TBOBJ_X_LO,X
          and #7
          ora TBOBJ_NR,x
          TAY
          LDA TAB_AD_OBJ_LO,Y
          STA FINDAST
          LDA TAB_AD_OBJ_HI,Y
          STA FINDASTHI


          lda UFO_KULA_Y_LO
          sec
          sbc TBOBJ_Y,x
          sta FROM_LINE
          lda TBOBJ_FROM_LINE,x
          beq +
          adc FROM_LINE
          sta FROM_LINE
+
          ;888 - korekta o przesunięcie w prawo obiektu
          lda TBOBJ_X_LO,x
          and #7
          clc
          adc PLOX_MOD

          tax
          ldy FROM_LINE
          lda TABLO,Y
          clc
          adc FINDAST
          sta FINDAST

          lda TABHI,y
          adc FINDASTHI
          sec
          sbc #$40
          sta FINDASTHI

          ldy PLOX_MOD
          ldy TABXM,x


          lda (FINDAST),y
          and TBBIT,x
          beq +


          jmp UFOK_skasuj_kule

+        ldx TMPR2
          jmp UFOK_CHECK_NEXT_BALL
;====

;============
UFOK_skasuj_kule

          LDA #$00
          STA UFO_kula
;kasowanie obiektu z kuli
;UWAGA TU PRZEROBIC NA WERSJE DLA UFO
          ldx TMPR2
          lda TBOBJ_NR,x
          cmp #32
          bcs +
          jmp rozbij_duzy_ufo
+   		  cmp #64
          bcs +
          jmp rozbij_sredni_ufo
+
          jmp zlikwiduj_obiekt_ufo
;===========================
          rts
;=======
UFOK_UNNAMED_COLLISION
          lda #0
          sta UFO_kula

          RTS
;===
;===================
findhigh11
          lda #$ff
          sta myplace
          ldx #10
          lda #0
-        sta tbfindscore,x
          dex
          bpl -
          ldx #4
-        lda scores,x
          sta wynik11,x
          dex
          bpl -
          jsr findh02
          lda mainscores+10
          bpl +
          clc
          rts
+        sta myplace
          ldy #9
-        lda mainscores,y
          bmi +
          dey
          bne -

+        tya
          asl
          asl
          asl
          tay
          ldx #0
-
          lda wynik11,x
          sta wyniki,y
          iny
          inx
          cpx #8
          bcc -


          jsr findhigh10
          lda myplace
          sec
          rts

findhigh10
          ldx #10
          lda #0
-        sta wynik11,x
          sta tbfindscore,x
          dex
          bpl -
findh02
          lda #0
          sta findplaces
          ldy #10
          lda #$ff
-        sta mainscores,y
          dey
          bpl -
findh03
          ldx #0
          jsr findcyfra
          lda findplaces
          sta mainscores,y
          ldy #10
          lda #0
-         sta tbfindscore,y
          dey
          bpl -
          ldy #10
-        lda mainscores,y
          bmi +
          lda #$ff
          sta tbfindscore,y
+        dey
          bpl -
          inc findplaces
          lda findplaces
          cmp #10
          bcc findh03
          rts

;============
findcyfra
          lda #0
          sta manyfind
          lda #9

findcloop
          ldy tbfindscore
          bmi +
          cmp wynik1,x
          bne +
          inc tbfindscore
          inc manyfind
+
          ldy tbfindscore+1
          bmi +
          cmp wynik2,x
          bne +
          inc tbfindscore+1
          inc manyfind
+
          ldy tbfindscore+2
          bmi +
          cmp wynik3,x
          bne +
          inc tbfindscore+2
          inc manyfind
+
          ldy tbfindscore+3
          bmi +
          cmp wynik4,x
          bne +
          inc tbfindscore+3
          inc manyfind
+
          ldy tbfindscore+4
          bmi +
          cmp wynik5,x
          bne +
          inc tbfindscore+4
          inc manyfind
+
          ldy tbfindscore+5
          bmi +
          cmp wynik6,x
          bne +
          inc tbfindscore+5
          inc manyfind
+
          ldy tbfindscore+6
          bmi +
          cmp wynik7,x
          bne +
          inc tbfindscore+6
          inc manyfind
+
          ldy tbfindscore+7
          bmi +
          cmp wynik8,x
          bne +
          inc tbfindscore+7
          inc manyfind
+
          ldy tbfindscore+8
          bmi +
          cmp wynik9,x
          bne +
          inc tbfindscore+8
          inc manyfind
+
          ldy tbfindscore+9
          bmi +
          cmp wynik10,x
          bne +
          inc tbfindscore+9
          inc manyfind
+
          ldy tbfindscore+10
          bmi +
          cmp wynik11,x
          bne +
          inc tbfindscore+10
          inc manyfind
+        pha
;============
          lda manyfind
          bne +
          jmp decrase
+        cmp #1
          bne +
          pla
          jmp ourfind
+        pla
          ldy #10
-        lda tbfindscore,y
          bmi +
          bne +
          lda #$ff
          sta tbfindscore,y
+        dey
          bpl -
          ldy #10
-        lda tbfindscore,y
          bmi +
          lda #$00
          sta tbfindscore,y
+        dey
          bpl -
          inx
          jmp findcyfra
;============

decrase
          pla
          tay
          dey
          tya
          beq +
          jmp findcloop
+        inx
          jmp findcyfra
ourfind
          ldy #0
-        lda tbfindscore,y
          bne +
          iny
          bne -
+        bpl gotta
          iny
          bne -
gotta
          rts
;===================


;=========================================
testpoz
          lda $d000
          sta pzstlo
          lda $d010
          and #1
          sta pzsthi

          lda $d00e
          sta pzufolo
          lda $d010
          and #$80
          asl
          rol
          sta pzufohi

          lda $d001
          sta ypzst
          lda $d00f
          sta ypzufo

          lda pzufolo
          sec
          sbc pzstlo
          sta difcalclo
          lda pzufohi
          sbc pzsthi
          sta difcalchi
          bne nothissamex
          lda difcalclo
          bne nothissamex
;=
thissamex
          lda ypzufo
          sec
          sbc ypzst
          bcs ufohigher
ufolower
          eor #$ff
          adc #1
          cmp #100
          bcc +
          lda #0
          rts
+        lda #8
          rts
ufohigher
          cmp #100
          bcc +
          lda #8
          rts
+        lda #0
          rts
;=
;X coord are diferents
nothissamex

          lda ypzufo
          sec
          sbc ypzst
          sta ydiff
          bne nothissamey
;=========
;Y coord are this same
thissamey
          lda difcalchi
          bmi ufofromleft
          bne +
;ufo from rightside
          lda difcalclo
          cmp #160
          bcs +
          lda #12
          rts
+        lda #4
          rts
;===============
;yes ufo is from left side
ufofromleft
          cmp #$fe
          beq +
          cmp #$fd
          beq +
          lda difcalclo
          eor #$ff
          sec
          adc #0
          beq +
          cmp #160
          bcs +
          lda #4
          rts
+        lda #12
          rts
;=============
nothissamey

          bpl +
          jmp checkquarter_1_2
+
checkquarter_3_4
          lda difcalchi
          bmi wegottaquarter4
;====================
wegottaquarter3


          lda difcalchi
          bne q3xbigger

          lda difcalclo
          sec
          sbc ydiff
          bmi q3ybigger
          jmp q3xb2 ;!!!
q3ybigger
          jsr dividey_by_x
          cpx #1
          bne +
          lda #14
          rts
+        cpx #4
          bcs +
          lda #15
          rts
+        lda #0
          rts

;=====
q3xbigger
          sec
          ror difcalclo
          lsr ydiff
          bne q3xb2
          lda #12
          rts
q3xb2     jsr dividex_by_y
          cpx #5
          bcc +
          lda #12
          rts
+        cpx #15
          bne +
          lda #14
          rts
+        lda #13
          rts
;==========

;================
wegottaquarter4
          lda pzstlo
          sec
          sbc pzufolo
          sta difcalclo
          lda pzsthi
          sbc pzufohi

          sta difcalchi
          bne q4xbigger

          lda difcalclo
          sec
          sbc ydiff
          bmi q4ybigger
          jmp q4xb2 ;!!!
q4ybigger
          jsr dividey_by_x
          cpx #1
          bne +
          lda #2
          rts
+        cpx #4
          bcs +
          lda #1
          rts
+        lda #0
          rts

;=====
q4xbigger
          sec
          ror difcalclo
          lsr ydiff
          bne q4xb2
          lda #4
          rts
q4xb2     jsr dividex_by_y
          cpx #5
          bcc +
          lda #4
          rts
+        cpx #1
          bne +
          lda #2
          rts
+        lda #3
          rts
;==========
;==========================
checkquarter_1_2
          eor #$ff
          clc
          adc #1
          sta ydiff
          lda difcalchi
          bmi wegottaquarter1
;============
wegottaquarter2

          lda difcalchi
          bne q2xbigger

          lda difcalclo
          sec
          sbc ydiff
          bmi q2ybigger
          jmp q2xb2 ;!!!
q2ybigger
          jsr dividey_by_x
          cpx #1
          bne +
          lda #10
          rts
+        cpx #4
          bcs +
          lda #9
          rts
+        lda #8
          rts

;=====
q2xbigger
          sec
          ror difcalclo
          lsr ydiff
          bne q2xb2
          lda #12
          rts
q2xb2     jsr dividex_by_y
          cpx #5
          bcc +
          lda #12
          rts
+        cpx #1
          bne +
          lda #10
          rts
+        lda #11
          rts
          rts
;=====================
wegottaquarter1
          lda pzstlo
          sec
          sbc pzufolo
          sta difcalclo
          lda pzsthi
          sbc pzufohi

          sta difcalchi
          bne q1xbigger

          lda difcalclo
          sec
          sbc ydiff
          bmi q1ybigger
          jmp q1xb2 ;!!!
q1ybigger
          jsr dividey_by_x
          cpx #1
          bne +
          lda #6
          rts
+        cpx #4
          bcs +
          lda #7
          rts
+        lda #8
          rts

;=====
q1xbigger
          sec
          ror difcalclo
          lsr ydiff
          bne q1xb2
          lda #4
          rts
q1xb2     jsr dividex_by_y
          cpx #5
          bcc +
          lda #4
          rts
+        cpx #1
          bne +
          lda #6
          rts
+        lda #5
          rts
;==========
dividex_by_y

          lda #$00
          ldx #$07
          clc
-        rol difcalclo
          rol
          cmp ydiff
          bcc +
          sbc ydiff
+        dex
          bpl -
          rol difcalclo
          ldx difcalclo
          rts
;==========
dividey_by_x

          lda #$00
          ldx #$07
          clc
-        rol ydiff
          rol
          cmp difcalclo
          bcc +
          sbc difcalclo
+        dex
          bpl -
          rol ydiff
          ldx ydiff
          rts

;===============================
msxnmi
          pha
          txa
          pha
          tya
          pha

lda $dc0d


          ;jsr $f006
          jsr $e803
          inc IRQCNTR
          lda is_UFO
          bne +
          lda rozbij_UFO
          bne +
          jsr enufo2

+
          jsr move_UFO
          lda is_UFO
          bne +
          lda $d015
          and #%00111111
          sta $d015
+
          jsr zpsp2
          jsr setzapal
          lda $dc0d
          inc $d019
          pla
          tay
          pla
          tax
          pla
          rti
;===

setzapal
          lda klatkapyl
          cmp #$10
          bcs +
          rts
+
          lda pozfire
          inc pozfire
          and #7
          tax

          lda $dd04
          and #$0f
          clc
          adc tbfirey,x
          sta KULA_Y_LO

          lda $dd04
          and #$3f
          clc
          adc tbfirex,x
          sta KULA_X_LO
          lda #0
          adc #0
          sta KULA_X_HI




          ldx #0
mysandal
          lda #0
          sta klatkapyl,x
          LDA TABSPRAJT,X
          TAY
          LDA KULA_Y_LO,X
          CLC
          ADC #40
          STA $D000,Y

          LDA KULA_X_LO,X
          ADC #14
          STA $CFFF,Y

          LDA $D010
          ORA TAB_NR_SPR,X
          BCS +
          LDY KULA_X_HI,X
          BNE +
          EOR TAB_NR_SPR,X
+
          STA $D010
          rts
;===
pozfire   !byte 0
tbfirey
          !byte 25,180,180,160,140,70,70,100
tbfirex
          !byte 50,250,50,160,30,50,200,150
;===============

;================================================================
EOF_CODE
;================================================================
firstpic
!binary "gfx\1stpic.bin",,2
secpict
!binary "gfx\2ndpic.bin",,2
logos
!binary "logo\logo.bin",,2
endlogos
;====
muzyka
!binary "msx\rabbit.bin",,2
;=====
koniec 