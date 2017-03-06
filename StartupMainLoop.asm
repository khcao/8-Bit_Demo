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
        ; NOTE: fill in part to change attributes for data third
        ld hl, visual_third_px_buf                              ; draw current (default) background for visual third of screen
        ;;ld de, $4800
        ld bc, 2048
        ldir
        ; NOTE: fill in part to change attributes for visual third
        ld hl, bordered_third_px_buf                            ; draw current (default) background for menu third of screen
        ld de, menu_third_px_buf
        ld bc, 2048
        ldir
        ; NOTE: fill in part to change attributes for menu third

                                                                ; fill up player 1 char A stats buffer with character dictionary + 1st char select buffer
                                                                ; fill up player 1 char B stats buffer with character dictionary + 2nd char select buffer

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

dummy_fill_display_attributes:
        ld hl, empty_third_attr_buf
        ld de, $5800
        ld bc, 256
        ldir
        ld hl, empty_third_attr_buf
        ld bc, 256
        ldir
        ld hl, empty_third_attr_buf
        ld bc, 256
        ldir
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
        cp (last_input)
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
        ld (last_input), a
        jp handle_input_print_char
handle_input_a:
        ld de, $3E08
        ld (last_input), a
        jp handle_input_print_char
handle_input_s:
        ld de, $3E98
        ld (last_input), a
        jp handle_input_print_char
handle_input_d:
        ld de, $3E20
        ld (last_input), a
        jp handle_input_print_char
handle_input_w:
        ld de, $3EB8
        ld (last_input), a
        jp handle_input_print_char
handle_input_enter:
        ld de, $3F28
        ld (last_input), a
        jp handle_input_print_char
handle_input_shift:
        ld de, $3F98
        ld (last_input), a
        jp handle_input_print_char
handle_input_print_char:
        ;;ld de, $3D80
        ld hl, $0045
        call print_char_to_menu
handle_input_unchanged:
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
last_input:
        defb $00                                                ; buffer to keep track of the input (or lack thereof) of the last frame

;;; Char Dictionary (9 bytes x 6 characters): < HP, Armor, MR, 16 bit memory for move 1, 16 bit memory for move 2, 16 bit memory for move 3>
char_data:  
	defb $50, $00, $14, $00, $00, $00, $00, $00, $00
	defb $5A, $00, $14, $00, $00, $00, $00, $00, $00
	defb $5A, $00, $14, $00, $00, $00, $00, $00, $00
	defb $8C, $00, $00, $00, $00, $00, $00, $00, $00
	defb $96, $00, $00, $00, $00, $00, $00, $00, $00
	defb $96, $00, $00, $00, $00, $00, $00, $00, $00
	
;;; <types: phys, magic, armor, MR, heal, dodge, MR debuff>
;;; < cd, type, value, 10-byte name>
;;; < (13 bytes x 18 skills) In character order >	
move_dictionary:
	defb $01, $07, $02 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $20, $20
	defb $01, $01, $02 ,$20, $20, $4d, $6f, $76, $65, $20, $32, $20, $20
	defb $04, $03, $05 ,$20, $20, $4d, $6f, $76, $65, $20, $33, $20, $20
	defb $01, $05, $02 ,$20, $20, $4d, $6f, $76, $65, $20, $34, $20, $20
	defb $01, $03, $02 ,$20, $20, $4d, $6f, $76, $65, $20, $35, $20, $20
	defb $04, $04, $05 ,$20, $20, $4d, $6f, $76, $65, $20, $36, $20, $20
	defb $04, $05, $04 ,$20, $20, $4d, $6f, $76, $65, $20, $37, $20, $20
	defb $01, $04, $02 ,$20, $20, $4d, $6f, $76, $65, $20, $38, $20, $20
	defb $01, $01, $02 ,$20, $20, $4d, $6f, $76, $65, $20, $39, $20, $20
	defb $04, $05, $05 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $30, $20
	defb $01, $01, $03 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $31, $20
	defb $01, $02, $03 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $32, $20
	defb $04, $02, $08 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $33, $20
	defb $01, $02, $04 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $34, $20
	defb $01, $04, $03 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $35, $20
	defb $02, $01, $05 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $36, $20
	defb $04, $06, $00 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $37, $20
	defb $01, $01, $03 ,$20, $20, $4d, $6f, $76, $65, $20, $31, $38, $20
	
;;; (12 bytes x 4 characters) < HP, Armor, MR, 16 bit memory for move 1, 16 bit memory for move 2, 16 bit memory for move 3. 16 bit queued move, Queued Target>
in_battle_chars:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
move_order:
	defb $00, $00
in_battle_moves: ; <move address (16 bit), subject, target>
	defb $00, $00, $00, $00


empty_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
empty_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

bordered_third_px_buf:
        defs 32, $ff                                            ;          ^ 
        defs 192, $00                                           ;
        defs 32, $ff                                            ;-
        defs 32, $ff                                            ;
        defs 192, $00                                           ;
        defs 32, $ff                                            ;-
        defs 32, $ff                                            ;
        defs 192, $00                                           ;
        defs 32, $ff                                            ;-
        defs 32, $ff                                            ;
        defs 192, $00                                           ;      < pixels >
        defs 32, $ff                                            ;- ((0-31) + (0-7)*256) + (0 or 224)
        defs 32, $ff                                            ;   
        defs 192, $00                                           ;
        defs 32, $ff                                            ;-
        defs 32, $ff                                            ;
        defs 192, $00                                           ;
        defs 32, $ff                                            ;-
        defs 32, $ff                                            ;
        defs 192, $00                                           ;
        defs 32, $ff                                            ;-
        defs 32, $ff                                            ;
        defs 192, $00                                           ;          
        defs 32, $ff                                            ;-         v
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
