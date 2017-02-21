extern _main
_main:			; Draws animation in SPRITE at location 400Fh
	org $8000

	call INIT
	nop
	ld hl, 5800h		; Prepare attribute bytes
	ld b,3
OUTERLOOP:
	ld c, 0
LOOP:
	call PAINT
	nop
	ld	a, c
	add a, 1
	ld	c, a
	jr nc, LOOP
	nop
	ld l, 0
	inc h
	djnz OUTERLOOP
	nop
	
	
	ld hl, SPRITE		; Start drawing sprite
	ld de, 400Fh
	exx
	ld d, 8
	ld c, 2
	ld b, 16
	exx
LOOP2:
	call DELAY
	nop; Halt for frames
DRAW2BYTE:
	ld bc, 2
	ldir
	
	inc d
	dec e
	dec e
	
	exx
	dec d
	exx
	
	jp nz, DRAW2BYTE
	nop
	
	ld a, d		; Get next attribute
	ld d, 08h
	sub d
	ld d, a
	
	ld a, e
	ld e, 20h
	add a, e
	ld e, a
	
	
	exx
	ld d, 8
	dec c
	exx
	
	jp nz, DRAW2BYTE
	nop
	ld de, 400Fh
	
	exx
	ld c, 2
	dec b
	exx

	jp nz, LOOP2
	ret

DELAY:
	halt                                    
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	ret
	
INIT:
	ld a, 0		; Load border color
	ld d, $0D
	ld e, $0D
	call $229B	; Set border color via 0x229B
	nop
	ret
PAINT:
	ld a, 01h
	and c
	jp nz, ODD
	nop
EVEN:
	exx
	ld (hl), d ; Paints attribute
	inc l
	ret
ODD:
	exx
	ld (hl), e
	inc l
	ret
	
SPRITE:
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb $FF, $FF, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
defb 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
