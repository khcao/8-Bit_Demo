        org 32768
begin:
        call startup
        ret

startup:
        call clear_background
        ld hl, char_select_p1_c1                                ; Player 1 Char A
        ld (hl), -1
        inc hl
        ld (hl), -1 					        ; Player 1 Char B
        ld hl, char_select_var                                  ; &Character_Select_Var
        ld (hl), 0
        call draw_char_select                     
        ;; jp char_select_loop

char_select_loop:
        call check_input_char_select
        call draw_char_select
        jp char_select_loop

start_battle:
        ld hl, bordered_third_px_buf                            ; draw default background for data (top) third of screen
        ld de, $4000
        ld bc, 2048
        ldir
        ld hl, bordered_third_attr_buf
        ld de, $5800
        ld bc, 256
        ldir

        ld hl, visual_third_px_buf                              ; draw current (default) background for visual third of screen
        ld de, $4800
        ld bc, 2048
        ldir
        ld hl, visual_third_attr_buf
        ld de, $5900
        ld bc, 256
        ldir

        ld hl, bordered_third_px_buf                            ; draw current (default) background for the buffer of menu third of screen
        ld de, menu_third_px_buf
        ld bc, 2048
        ldir
        ld hl, bordered_third_attr_buf
        ld de, $5A00
        ld bc, 256
        ldir

        ;;; fill up player 1 char A stats buffer with character dictionary + 1st char select buffer
        ld hl, char_select_p1_c1
        ld a, (hl)                                              ; try to have char_index to be [0,5] (6 and 7 results in undefined behavior)
        and 7
        ld (hl), a                                              ; multiply by 6 to get the offset from the character dictionary into a
        rlca
        rlca
        add a, (hl)
        add a, (hl)
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
        ld b, 0
        ld c, a
        add hl, bc
        ld de, in_battle_chars                                  ; copy the data from the dictionary char_data into the data structure holding real-time player data
        ld bc, 6
        ldir

        ;;; fill up player 1 char B stats buffer with character dictionary + 2nd char select buffer
        ld hl, char_select_p1_c2
        ld a, (hl)                                              ; try to have char_index to be [0,5] (6 and 7 results in undefined behavior)
        and 7
        ld (hl), a                                              ; multiply by 6 to get the offset from the character dictionary into a
        rlca
        rlca
        add a, (hl)
        add a, (hl)
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
        ld b, 0
        ld c, a
        add hl, bc
        push hl                                                 ; calculate the address of the second data structure holding real-time player data
        ld hl, in_battle_chars
        ld bc, 8
        add hl, bc
        ld d, h
        ld e, l
        pop hl                                                 ; copy the data from the dictionary char_data into the data structure holding real-time player data
        ld bc, 6
        ldir

                                                                ; randomly choose two characters for player 2 char A and B
                                                                ; fill up player 2 char A stats buffer with character dictionary + 3rd char select buffer
                                                                ; fill up player 2 char B stats buffer with character dictionary + 4th char select buffer

                                                                ; initialize game states in game state buffer

                                                                ; read char stat buffers and draw into actual display in the data (top) third (note: only call this again after a call into the animation/actionResolve section)

                                                                ; read menu state and draw into screen buffer of menu (bottom) third (only call this again after an interpretation of input)
        
main_loop:
                                                                ; jump if animateBool is true (to the animation/actionResolve section)

                                                                ; check clock and read sprite idle data to animate visual (middle) third

        call handle_input                                       ; call input handler

        ld hl, visual_third_px_buf                              ; swap screen buffer with actual display
        ld de, $4800
        ld bc, 2048
        ldir
        ; NOTE: fill in part to change attributes for visual third
        ld hl, menu_third_px_buf
        ;;ld de, $5000
        ld bc, 2048
        ldir
        ; NOTE: fill in part to change attributes for menu third

        jp main_loop                                            ; re-call main_loop

; ########################################################################################################
; ############################################## FUNCTIONS ###############################################
; ########################################################################################################

;;; clear pixels and default attributes on the display
clear_background:
        ld hl, $4000
        ld bc, $1800
clear_background_loop_1:
        ld (hl), $00
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, clear_background_loop_1
        ;;ld hl, $5800
        ld bc, $0300
clear_background_loop_2:
        ld (hl), $07
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, clear_background_loop_2
        ret

;;; clear pixels and default attributes on a third of the display
;;; hl must already hold address of pixels of the third we are clearing, de must already hold address of attrbutes of third we are clearing
clear_third:
        ld bc, 2048
clear_third_loop_1:
        ld (hl), $00
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, clear_third_loop_1
        ld bc, 256
        ld h, d
        ld l, e
clear_third_loop_2:
        ld (hl), $07
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, clear_third_loop_2
        ret

draw_char_select:
        ret

check_input_char_select:
        jp start_battle
        ret

;;; called by input handler after system indicates that it has accepted the moves the player has made
;;; will first randomly do moves for the enemy characters
;;; then will loop to calculate the state of the current attack and then call the animation loop
;;; animation loop should ret and then the continue this loop for the next attack
;;; after all 4 attacks have resolved-animated-resolved-animated, we jump back into main_loop
action_resolve:
        ret

;;; copies a character sprite onto the menu third (specifically to that buffer)
;;; de - address of the character sprite in ROM; hl - address relative to the px buffer (0-2047) where we want to put the character
;;; de: [$3d00, $3fff]                           hl: [$0000, $07ff]
print_char_to_menu:
        ld a, h                                               ; ensure hl is capped, h is the number of lines from the top of some cell
        and 7
        ld h, a
        ld a, 8                                                 ; check how many lines from bottom of cell
        sub h
        ld c, a                                                 ; load that num lines into bc (NOTE: this is always nonzero so first loop must happen no matter what)
        ld b, 0
        push hl                                                 ; push original num lines from top for use later (top_cell_loop messes with this)
print_char_to_menu_top_cell_loop:
        push hl
        push de                                                 ; compensate relative buffer address by adding it to the actual buffer address
        ld de, menu_third_px_buf
        add hl, de
        pop de
        ld a, (de)                                              ; copy byte from ROM to address into hl (the buffer)
        ld (hl), a
        pop hl
        inc h                                                   ; move the buffer address one line down
        inc de                                                  ; move the ROM address one byte over
        dec bc                                                  ; check if we've finished the print on top cell
        ld a, b
        or c
        jr nz, print_char_to_menu_top_cell_loop                 ; if done with top, load remaining num lines in bottom cell
        pop hl                                                  ; pop the original address
        ld b, 0                                                 ; h is the number of lines left in the bottom cell, load that into bc
        ld c, h
        ld a, l                                                 ; move hl's address one cell down, first row of that cell
        add a, 32
        ld l, a
        ld h, 0
print_char_to_menu_bot_cell_loop:
        ld a, b                                                 ; check if there are no lines to print in this cell
        or c
        jr nz, print_char_to_menu_end                           ; if not print the remaining lines
        push hl
        push de                                                 ; compensate relative buffer address by adding it to the actual buffer address
        ld de, menu_third_px_buf
        add hl, de
        pop de
        ld a, (de)
        ld (hl), a
        pop hl
        inc h
        inc de
        dec bc
        jp print_char_to_menu_bot_cell_loop
print_char_to_menu_end:
        ret

;;; copies a character sprite onto the data third (since no buffer, addresses to the screen) (can be used in general for display)
;;; (keep in mind, the middle and bottom thirds of the screen during our turn will be replaced by the buffer)
;;; de - address of the character sprite in ROM; hl - address relative to the display ($4000-$5800) where we want to put the character
print_char_to_data:
        ret

handle_input:
        ld hl, keymap
        ld d, 8                                                 ; load number of rows into d
        ld c, $fe
handle_input_read_rows:
        ld b, (hl)                                              ; grab keyboard port from first column in the keymap
        inc hl                                                  ; move over to the asciis of that port/key-row
        in a, (c)                                               ; read the row fo keys
        and $1f                                                 ; grab the 5 bits of the read row
        ld e, 5                                                 ; load number of keys in the row into e
handle_input_read_keys_in_row:
        srl a
        jr nc, handle_input_load_read_key                       ; if the bit is 0, we've found our key in a
        inc hl
        dec e
        jr nz, handle_input_read_keys_in_row                    ; loop across the row
        dec d
        jr nz, handle_input_read_rows                           ; loop every single row
        ld a, ' '                                               ; if no key was read, input "blank"
        jp handle_input_end_read
handle_input_load_read_key:
        ld a, (hl)
handle_input_end_read:                                          ; a holds the pressed key
        ld hl, last_input
        cp (hl)
        jr z, handle_input_unchanged
        cp 'A'
        jr z, handle_input_a
        cp 'S'
        jr z, handle_input_s
        cp 'D'
        jr z, handle_input_d
        cp 'W'
        jr z, handle_input_w
        cp 'e'
        jr z, handle_input_enter
        cp 's'
        jr z, handle_input_shift
        ;;cp ' '
        ;;jr z, handle_input_none
handle_input_none:
        ld de, $3D00
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_a:
        call short_beep
        ld de, $3E08
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_s:
        call short_beep
        ld de, $3E98
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_d:
        call short_beep
        ld de, $3E20
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_w:
        call short_beep
        ld de, $3EB8
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_enter:
        call short_beep
        ld de, $3F28
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_shift:
        ld de, $3F98
        ld hl, last_input
        ld (hl), a
        jp handle_input_print_char
handle_input_print_char:
        ld hl, $0045
        call print_char_to_menu
handle_input_unchanged:
        ret


; Beep duration can be increased by increasing value loaded into C
; Beep pitch is increased by decreasing values loaded into B and vice versa
short_beep:
    push af
    push bc
    push de
    push hl
    ld c, 100
    di
loop:
    ld a, $10
    out ($fe), a
    ld b,100
delay1:
    djnz delay1
    xor a
    out ($fe), a
    ld b,100
delay2:
    djnz delay2
    dec c
    jp nz, loop
    ei
    pop hl
    pop de
    pop bc
    pop af
    ret 

; ########################################################################################################
; ################################################ DATA ##################################################
; ########################################################################################################


char_select_var:
        defb $00
char_select_p1_c1:
        defb $00
char_select_p1_c2:
        defb $00
char_select_p2_c1:
        defb $00
char_select_p2_c2:
        defb $00

;;; buffer to keep track of the input (or lack thereof) of the last frame
last_input:
        defb $00

;;; Menu State Variables - keeps track of the players turn, what menu to show, and the cursor
menu_state_char_turn:
        defb $00                                                ; 0 = p1_c1, 1 = p1_c2, 2 = p2_c1, 3 = p2_c2
menu_state_var1:
        defb $00                                                ; 4 most sig bits = which menu (by index); 4 least sig bits = cursor


;;; Char Dictionary (6 bytes x 6 characters): < HP, Armor, MR, move1 offset, move2 offset, move3 offset >
char_data:  
	defb $50, $00, $14, $00, $01, $02
	defb $5A, $00, $14, $03, $04, $05
	defb $5A, $00, $14, $06, $07, $08
	defb $8C, $00, $00, $09, $0a, $0b
	defb $96, $00, $00, $0c, $0d, $0e
	defb $96, $00, $00, $0f, $10, $11
	
;;; <types: phys, magic, armor, MR, heal, dodge, MR debuff>
;;; < cd, type, value, 10-byte name (offset from a-8, ff = space)>
;;; < (13 bytes x 18 skills) In character order >	
move_dictionary:
	defb $01, $07, $02 ,$ff, $68, $78, $b0, $28, $78, $08, $ff, $ff, $ff
	defb $01, $01, $02 ,$ff, $68, $78, $b0, $28, $78, $10, $ff, $ff, $ff
	defb $04, $03, $05 ,$ff, $68, $78, $b0, $28, $78, $18, $ff, $ff, $ff
	defb $01, $05, $02 ,$ff, $68, $78, $b0, $28, $78, $20, $ff, $ff, $ff
	defb $01, $03, $02 ,$ff, $68, $78, $b0, $28, $78, $28, $ff, $ff, $ff
	defb $04, $04, $05 ,$ff, $68, $78, $b0, $28, $78, $30, $ff, $ff, $ff
	defb $04, $05, $04 ,$ff, $68, $78, $b0, $28, $78, $38, $ff, $ff, $ff
	defb $01, $04, $02 ,$ff, $68, $78, $b0, $28, $78, $40, $ff, $ff, $ff
	defb $01, $01, $02 ,$ff, $68, $78, $b0, $28, $78, $48, $ff, $ff, $ff
	defb $04, $05, $05 ,$ff, $68, $78, $b0, $28, $78, $50, $ff, $ff, $ff
	defb $01, $01, $03 ,$ff, $68, $78, $b0, $28, $78, $58, $ff, $ff, $ff
	defb $01, $02, $03 ,$ff, $68, $78, $b0, $28, $78, $60, $ff, $ff, $ff
	defb $04, $02, $08 ,$ff, $68, $78, $b0, $28, $78, $68, $ff, $ff, $ff
	defb $01, $02, $04 ,$ff, $68, $78, $b0, $28, $78, $70, $ff, $ff, $ff
	defb $01, $04, $03 ,$ff, $68, $78, $b0, $28, $78, $78, $ff, $ff, $ff
	defb $02, $01, $05 ,$ff, $68, $78, $b0, $28, $78, $80, $ff, $ff, $ff
	defb $04, $06, $00 ,$ff, $68, $78, $b0, $28, $78, $88, $ff, $ff, $ff
	defb $01, $01, $03 ,$ff, $68, $78, $b0, $28, $78, $90, $ff, $ff, $ff
	
;;; (12 bytes x 4 characters) < HP, Armor, MR, move1 offset, move2 offset, move3 offset. Queued Move, Queued Target>
in_battle_chars:
	defb $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00
move_order:
	defb $00, $00
in_battle_moves: ; <move address (16 bit), subject, target>
	defb $00, $00, $00, $00

bordered_third_px_buf:
        defs 33, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff 
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 66, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 2, $ff
        defs 30, $00
        defs 33, $ff
bordered_third_attr_buf:
        defs 256, $04                                           ;    < attributes >

visual_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
visual_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

menu_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
menu_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

keymap:
        defb $fe, 's', 'Z', 'X', 'C', 'V'
        defb $fd, 'A', 'S', 'D', 'F', 'G'
        defb $fb, 'Q', 'W', 'E', 'R', 'T'
        defb $f7, '1', '2', '3', '4', '5'
        defb $ef, '0', '9', '8', '7', '6'
        defb $df, 'P', 'O', 'I', 'U', 'Y'
        defb $bf, 'e', 'L', 'K', 'J', 'H'
        defb $7f, ' ', '#', 'M', 'N', 'B'
