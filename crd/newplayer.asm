!to "newplayer.prg" , CBM


;========
         *= $0801
         !byte $0B,$08,$90,$06,$9E,$32
         !byte $30,$34,$39,$00,$A0,$00
;========
          sei
          lda #$7f
          sta $dc0d
          sta $dd0d
          lda $dc0d
          lda $dd0d
          lda #$35
          sta $01
          lda #$01
          sta $d01a
          lda #$1b
          sta $d011
          lda #$ff
          sta $d012
          lda #<irq
          sta $fffe
          lda #>irq
          sta $ffff
          

          jsr sfx_init
          inc $d019
          cli

     
lp0 
          lda $dc00
          and #$10
          bne *+5
          jsr fire_bullet
          lda $dc01
          cmp #$ff
          beq delly
          tax
          
          and #$10
          bne +
          jsr extra_life
+:


delly
          ldx #$20
          dey
          bne *-1
          dex
          bne *-4
          
          jmp lp0
;===
irq
     pha
     tya
     pha
     txa
     pha
     lda $01
     pha
     lda #$35
     sta $01
     
inc $d020
     jsr $1000
     
     inc $d019
dec $d020
     pla
     sta $01
     pla
     tax
     pla
     tay
     pla
     rti
;===

;=======
*=$1000 ;"SFX PLAY"
          jmp muzak
;========
          jmp sfx_init
          jmp fire_bullet
          jmp explosion
          jmp extra_life
          jmp UFOrun
          jmp sfx_ufooff
          jmp thrust_on
          jmp thrust_off
          jmp set_beater
          lda sfx_chn1_beatpos+1
          rts
          
;========
muzak
sfx_play:
          ldx #$09
          lda #$00
sfx_chn2:
          ldy #$ff
          bmi +
          lda bulletsnd1,y
          ldx bulletsnd2,y
          

          dec sfx_chn2+1
+:        stx $d40b
	        sta $d408
          stx $f1
          sta $f2
          ldx #$84
sfx_chn1:
          ldy #$bf
          iny
sfx_chn1a:
          cpy #$00
          bne +
sfx_chn1b:
          ldy #$bf
+:	      cpy #$c5
          bcc +
sfx_chn1_beatpos:

          ldy #$80
          lda #$00
          sta sfx_d403+1
          lda $f3
          eor #$60
          sta $f3
+:	      sty sfx_chn1+1
          tya
          bmi sfx_chn1_
          stx $d417
          ldx $1280,y
          lda $1200,y
          ldy #$00
          beq +
sfx_chn1_:
          cpy #$c0
          bcs sfx_chn1___
          stx $d417
          ldx $f1
          lda $f2
          ldy #$40
          bne +
sfx_chn1___:
          inx
          stx $d417
          ldx #$51
          ldy $f3
          lda #$03
+:	      sty $d400
	        sta $d401
          stx $d404
sfx_d403:
          lda #$00
          sta $d403
sfx_chn3:
          ldx #$ff
          bpl sfx_chn3_
sfx_thrust:
          lda #$00
          ldy #$81
          bmi +
sfx_chn3_: 
          ldy $12c0,x
          lda $1240,x
          dex
          stx sfx_chn3+1
+:	      sty $d412
          sta $d40f
          lda $f0
          adc #$fa
          cmp #$f0
          bcc +
          lda #$04
+:	      sta $f0
          sta $d416
          rts
;=========
sfx_init:
          lda #0
          sta $f0
          sta $f3
  	      sta $d400
  	      sta $d401
  	      sta $d402
  	      sta $d403
  	      sta $d404
  	      sta $d405
  	      sta $d406
  	      sta $d407
  	      sta $d408
  	      sta $d409
  	      sta $d40a
  	      sta $d40b
  	      sta $d40c
  	      sta $d40d
  	      sta $d40e
  	      sta $d40f
  	      sta $d410
  	      sta $d411
  	      sta $d412
  	      sta $d413
  	      sta $d414
  	      sta $d415
  	      sta $d416
  	      sta $d417
          sta $d418
          lda #$1f
  	      sta $d418
          lda #$f7
          sta $d417
          lda #$ed
          sta $d414
          lda #$09
          sta $d412
          lda #8
          sta $d411
          lda #$09
          ldx #$e9
          stx $d40d
          sta $d40b
          stx $d406
          sta $d404

          lda #$80 ;max $b8
          sta sfx_chn1_beatpos+1
sfx_ufooff:
          ldy sfx_chn1_beatpos+1
         	lda #0
          ldx #0

sfx_initchn1:
          sty sfx_chn1b+1
          sta sfx_d403+1
sfx_init_:
          sty sfx_chn1+1
          stx sfx_chn1a+1
-:        rts
sfx_extralife:
          lda sfx_d403+1
          eor #$08
          beq -
          lda #$0c
          ldy sfx_chn1_beatpos+1
          sta sfx_d403+1
          sty sfx_chn1b+1
          ldy #$10
          ldx #$34
          bne sfx_init_
cdend
;=====
fire_bullet:
          lda #$0a
          sta sfx_chn2+1	
          rts
;=
explosion:
          lda #$2f
          ldx #$f0
          sta sfx_chn3+1
          stx $f0
          rts
;=
extra_life:
          jmp sfx_extralife
;=
UFOrun:
          and #1
          bne +
          ldy #$71
          ldx #$7a
          lda #$08
          jmp sfx_initchn1
+:
;// To turn on UFO (small):
          ldy #$7a
          ldx #$80
          lda #$08
          jmp sfx_initchn1
;=
thrust_on:
          lda #$3f
          sta sfx_thrust+1
          rts
;=
thrust_off:
          lda #$00
          sta sfx_thrust+1
          rts
;=
;// To set the beater:
set_beater
          sta sfx_chn1_beatpos+1
          rts
;========================================
;=====
     ;// FIRE BULLET sound data1:
     *=$1200
bulletsnd1
          !byte $0c,$10,$14,$18,$1c,$20,$24,$28,$2c,$28,$2c
endfb1s
;=====
     ;// EXTRA LIFE sound data:
     *=$1210
extrasound1
          !byte $08,$08,$08,$0c,$0c,$0c,$10,$10,$10,$14,$14,$14
          !byte $18,$18,$18,$1c,$1c,$1c,$20,$20,$20,$1c,$1c,$1c
          !byte $08,$08,$08,$0c,$0c,$0c,$10,$10,$10,$14,$14,$14
endexls
;=====
     ;// EXPLOSION sound data1:
     *=$1240
          !byte $ff,$ff,$ff,$e0
          !byte $d0,$d0,$d0,$c1,$02,$04
          !byte $60,$60,$60,$91,$03,$06
          !byte $d0,$d0,$d0,$02,$03,$06
          !byte $f0,$f0,$f0,$c0,$04,$08
          !byte $90,$90,$90,$03,$04,$08
          !byte $e0,$e0,$e0,$05,$06,$09
          !byte $ff,$ff,$ff,$05,$07,$0b,$ff,$ff
endexpls
;=====
     ;// UFO sound data1:
     *=$1271 
          !byte $35,$4a,$63,$48,$40,$37,$32,$2a,$21
          !byte $30,$3c,$42,$5e,$65,$7c
endufs
;===
     ;// FIRE BULLET sound data2:
     *=$1280
bulletsnd2
          !byte $10,$10,$10,$10,$10,$10,$10,$10,$21,$21,$21
endfb2s
;=====
extrasound2
     ;// EXTRA LIFE sound data2:
     *=$1290
          !byte $41,$41,$41,$41,$41,$41,$41,$41,$41,$41,$41,$41
          !byte $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
          !byte $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
endextls
;=====
     ;// EXPLOSION sound data2:
     *=$12c0
          !byte $80,$80,$80,$80
          !byte $80,$80,$80,$80,$40,$40
          !byte $80,$80,$80,$80,$40,$40
          !byte $80,$80,$80,$10,$40,$40
          !byte $80,$80,$80,$80,$40,$40
          !byte $80,$80,$80,$10,$40,$40
          !byte $80,$80,$80,$10,$40,$40
          !byte $81,$81,$81,$11,$41,$41,$81,$81
enddt1
;=====
     ;// UFO sound data2:     
     *=$12f1
          !byte $41,$21,$11,$21,$21,$21,$21,$41,$41	
          !byte $41,$41,$21,$21,$21,$21
endufs2
;====

;// To INIT the player:
;//	jsr sfx_init

;// To PLAY:
;//	jsr sfx_play










