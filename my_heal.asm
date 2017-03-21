        org 32768
start:
       ld bc, 0
       ld hl, $5800
clear_loop:
       ld (hl), $07
       inc hl
       inc bc
       ld a, b
       cp $03
       jp c, clear_loop




       ld hl, $508A





;;; input hl - holds the location in pixel memory of the byte one line above the topmost, leftmost byte of a sprite I want this animation over
heal_animation:
        ld (line_above_sprite), hl

        ld b, 0
        ld c, 0
        ld de, line_width
        push bc
        push de
outer_loop:
        pop hl
        ld d, c
        pop bc
        inc b
        ld a, b
        cp $31                                                   ; outer_loop counter (stops after b-1 times)
        jp z, outer_loop_exit
        push bc
        ld c, d
        push hl
        ld b, (hl)
        ld hl, (line_above_sprite); $5082                                            ; location of the start of the sprites
        push hl
        ld h, $40
        ld a, l
        and $1F
        ld l, a
        halt
        halt
inner_loop:
	ld (hl), b
	ld de, 7
	push hl
	add hl, de
	ld (hl), b
	pop hl ;sbc hl, de                             ; NOTE: might not work if carry flag is set
	;;; move hl down one line
	ld a, h
	and $07
	cp $07
	jp z, change_l_too
	inc h
	jp check_out_of_bounds
change_l_too:
	ld a, h
	and $F8
	ld h, a
	ld a, l
	and $E0
	cp $E0
	jp z, change_h_again
	ld a, l
	add 32
	ld l, a
	jp check_out_of_bounds
change_h_again:
	ld a, l
	and $1F
	ld l, a
	ld a, h
	add 8
	ld h, a
check_out_of_bounds:
	ld a, h
	and $F8
	cp $40
	jp c, inner_loop_exit
	cp $58
	jp nc, inner_loop_exit
        pop de
        push de
        ld a, l
        cp e
        jp c, inner_loop
        ld a, d
        cp h
        jp c, inner_loop_exit
	jp inner_loop
inner_loop_exit:
	pop hl
	inc c
	pop de
	inc de
	ld a, c
	cp $06
	jp z, reset
	push de
	jp outer_loop
reset:
	ld c, 0
	ld de, line_width
	push de
	jp outer_loop

outer_loop_exit:


;;; location in pixel memory of the byte above the leftmost, topmost byte of the sprite
line_above_sprite:
	defb $00, $00
line_width:
	defb $FF, $3C, $18, $18, $7E, $FF