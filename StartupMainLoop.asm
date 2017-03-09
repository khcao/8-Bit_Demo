        org 32768
begin:
        call startup
        ret

startup:
        call clear_background
        ld hl, char_select_p1_c1                                ; Player 1 Char A
        ld (hl), -1
        inc hl
        ld (hl), -1 					                        ; Player 1 Char B
        ld hl, char_select_var                                  ; Character_Select_Var
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
        ld de, menu_third_attr_buf
        ld bc, 256
        ldir

        ;;; fill up player 1 char A stats buffer with character dictionary + 1st char select buffer
        ld hl, char_select_p1_c1
        ld a, (hl)                                              ; try to have char_index to be [0,5] (6 and 7 results in undefined behavior)
        and 7
        ld (hl), a
        ld h, 0                                                 ; take the character index in a and multiply it by 6 to get the byte offset from the beginning of the dictionary to the exact character we want
        ld l, a
        ld de, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld a, l                                                 ; NOTE: any carries are left in h
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
        ld b, 0
        ld c, a
        add hl, bc
        ld de, in_battle_chars                                  ; copy the data from the dictionary char_data into the data structure holding real-time player data
        ld bc, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        ldir

        ;;; fill up player 1 char B stats buffer with character dictionary + 2nd char select buffer
        ld hl, char_select_p1_c2
        ld a, (hl)                                              ; try to have char_index to be [0,5] (6 and 7 results in undefined behavior)
        and 7
        ld (hl), a
        ld h, 0                                                 ; take the character index in a and multiply it by 6 to get the byte offset from the beginning of the dictionary to the exact character we want
        ld l, a
        ld de, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld a, l                                                 ; NOTE: any carries are left in h
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
        ld b, 0
        ld c, a
        add hl, bc
        push hl                                                 ; calculate the address of the second data structure holding real-time player data
        ld hl, in_battle_chars
        ld bc, 8                                                ; NOTE: IF SIZE OF AN ENTRY IN THE in_battle_char STRUCT CHANGES, CHANGE THIS NUMBER TO MATCH IT
        add hl, bc
        ld d, h
        ld e, l
        pop hl                                                  ; copy the data from the dictionary char_data into the data structure holding real-time player data
        ld bc, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        ldir

                                                                ; randomly choose two characters for player 2 char A and B

        ;;; fill up player 2 char A stats buffer with character dictionary + 3rd char select buffer
        ld hl, char_select_p2_c1
        ld a, (hl)                                              ; try to have char_index to be [0,5] (6 and 7 results in undefined behavior)
        and 7
        ld (hl), a
        ld h, 0                                                 ; take the character index in a and multiply it by 6 to get the byte offset from the beginning of the dictionary to the exact character we want
        ld l, a
        ld de, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld a, l                                                 ; NOTE: any carries are left in h
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
        ld b, 0
        ld c, a
        add hl, bc
        push hl                                                 ; calculate the address of the second data structure holding real-time player data
        ld hl, in_battle_chars
        ld bc, 16                                               ; NOTE: IF SIZE OF AN ENTRY IN THE in_battle_char STRUCT CHANGES, CHANGE THIS NUMBER TO MATCH 2x IT
        add hl, bc
        ld d, h
        ld e, l
        pop hl                                                  ; copy the data from the dictionary char_data into the data structure holding real-time player data
        ld bc, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        ldir

        ;;; fill up player 2 char B stats buffer with character dictionary + 4th char select buffer
        ld hl, char_select_p2_c2
        ld a, (hl)                                              ; try to have char_index to be [0,5] (6 and 7 results in undefined behavior)
        and 7
        ld (hl), a
        ld h, 0                                                 ; take the character index in a and multiply it by 6 to get the byte offset from the beginning of the dictionary to the exact character we want
        ld l, a
        ld de, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld a, l                                                 ; NOTE: any carries are left in h
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
        ld b, 0
        ld c, a
        add hl, bc
        push hl                                                 ; calculate the address of the second data structure holding real-time player data
        ld hl, in_battle_chars
        ld bc, 24                                               ; NOTE: IF SIZE OF AN ENTRY IN THE in_battle_char STRUCT CHANGES, CHANGE THIS NUMBER TO MATCH 3x IT
        add hl, bc
        ld d, h
        ld e, l
        pop hl                                                  ; copy the data from the dictionary char_data into the data structure holding real-time player data
        ld bc, 6                                                ; NOTE: IF SIZE OF AN ENTRY IN THE CHARACTER DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        ldir

                                                                ; initialize game states in game state buffer

        call update_data                                        ; read char stat buffers and draw into actual display in the data (top) third (note: only call this again after a call into the animation/actionResolve section)

        call update_menu_buffer                                 ; read menu state and draw into screen buffer of menu (bottom) third (only call this again after an interpretation of input)
        
main_loop:
                                                                ; jump if animateBool is true (to the animation/actionResolve section)

                                                                ; check clock and read sprite idle data to animate visual (middle) third

        call handle_input                                       ; call input handler

        ld hl, visual_third_px_buf                              ; swap screen buffer with actual display
        ld de, $4800
        ld bc, 2048
        ldir
        ld hl, visual_third_attr_buf
        ld de, $5900
        ld bc, 256
        ldir

        ld hl, menu_third_px_buf
        ld de, $5000
        ld bc, 2048
        ldir
        ld hl, menu_third_attr_buf
        ld de, $5A00
        ld bc, 256
        ldir

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
;;; after the animation loop returns, update the data third of the screen, then continue this loop for the next attack
;;; after all 4 attacks have resolved-animated-resolved-animated, we jump back into main_loop
action_resolve:
        ret

;;; copies a character sprite onto the menu third (specifically to that buffer)
;;; de - address of the character sprite in ROM; hl - address relative to the px buffer (0-2047) where we want to put the character
;;; de: [$3d00, $3fff]                           hl: [$0000, $07ff]
print_char_to_menu:
        push hl
        push de
        ld a, h                                                 ; ensure hl is capped, h is the number of lines from the top of some cell
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
        pop de
        pop hl
        ret

;;; copies a character sprite onto the data third (since no buffer, addresses to the screen) (can be used in general for display)
;;; (keep in mind, the middle and bottom thirds of the screen during our turn will be replaced by the buffer)
;;; de - address of the character sprite in ROM; hl - address relative to the display [0-2047] where we want to put the character
print_char_to_data:
        push hl
        push de
        ld a, h                                                 ; ensure hl is capped, h is the number of lines from the top of some cell
        and 7
        ld h, a
        ld a, 8                                                 ; check how many lines from bottom of cell
        sub h
        ld c, a                                                 ; load that num lines into bc (NOTE: this is always nonzero so first loop must happen no matter what)
        ld b, 0
        push hl                                                 ; push original num lines from top for use later (top_cell_loop messes with this)
print_char_to_data_top_cell_loop:
        push hl
        push de                                                 ; compensate relative buffer address by adding it to the actual buffer address
        ld de, $4000 ; menu_third_px_buf
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
        jr nz, print_char_to_data_top_cell_loop                 ; if done with top, load remaining num lines in bottom cell
        pop hl                                                  ; pop the original address
        ld b, 0                                                 ; h is the number of lines left in the bottom cell, load that into bc
        ld c, h
        ld a, l                                                 ; move hl's address one cell down, first row of that cell
        add a, 32
        ld l, a
        ld h, 0
print_char_to_data_bot_cell_loop:
        ld a, b                                                 ; check if there are no lines to print in this cell
        or c
        jr nz, print_char_to_data_end                           ; if not print the remaining lines
        push hl
        push de                                                 ; compensate relative buffer address by adding it to the actual buffer address
        ld de, $4000 ; menu_third_px_buf
        add hl, de
        pop de
        ld a, (de)
        ld (hl), a
        pop hl
        inc h
        inc de
        dec bc
        jp print_char_to_data_bot_cell_loop
print_char_to_data_end:
        pop de
        pop hl
        ret

handle_input:
        ld hl, keymap
        ld d, 8                                                 ; load number of rows into d
        ld c, $fe
handle_input_read_rows:
        ld b, (hl)                                              ; grab keyboard port from first column in the keymap
        inc hl                                                  ; move over to the asciis of that port/key-row
        in a, (c)                                               ; read the row of keys
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
        jp z, handle_input_unchanged
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
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld de, $3D00
        jp handle_input_print_char
handle_input_a:
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld a, 0                                                 ; change menu/cursor
        call handle_menu_change
        call short_beep                                         ; beep once
        ld de, $3E08
        jp handle_input_print_char
handle_input_s:
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld a, 1                                                 ; change menu/cursor
        call handle_menu_change
        call short_beep                                         ; beep once
        ld de, $3E98
        jp handle_input_print_char
handle_input_d:
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld a, 0                                                 ; change menu/cursor
        call handle_menu_change
        call short_beep                                         ; beep once
        ld de, $3E20
        jp handle_input_print_char
handle_input_w:
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld a, 1                                                 ; change menu/cursor
        call handle_menu_change
        call short_beep                                         ; beep once
        ld de, $3EB8
        jp handle_input_print_char
handle_input_enter:
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld a, 2                                                 ; change menu/cursor
        call handle_menu_change
        call short_beep                                         ; beep once
        ld de, $3F28
        jp handle_input_print_char
handle_input_shift:
        ld hl, last_input                                       ; record currently read key as last_input
        ld (hl), a
        ld a, 3                                                 ; change menu/cursor
        ;call handle_menu_change
        call short_beep                                         ; beep once
        ld de, $3F98
        jp handle_input_print_char
handle_input_print_char:
        ld hl, $0000 ;;$0045
        call print_char_to_menu
handle_input_unchanged:
        ret

handle_menu_change:
        push af                                                 ; save register states
        push hl
        push bc
        push de
        cp 0                                                    ; switch case
        jr z, handle_menu_change_a_d
        cp 1
        jr z, handle_menu_change_w_s
        cp 2
        jr z, handle_menu_change_enter
        cp 3
        jr z, handle_menu_change_shift
        jp handle_menu_change_end
handle_menu_change_a_d:
        ld hl, menu_state_var1                                  ; update the cursor: if on the left (cursor bits either 00 or 10) then change to right (01 or 11) and vice versa
        ld a, (hl)
        xor $01
        ld (hl), a
        call update_menu_buffer                                 ; update menu visuals
        jp handle_menu_change_end
handle_menu_change_w_s:
        ld hl, menu_state_var1                                  ; update the cursor: if on the top (cursor bits either 00 or 01) then change to bottom (10 or 11) and vice versa
        ld a, (hl)
        xor $02
        ld (hl), a
        call update_menu_buffer                                 ; update menu visuals
        jp handle_menu_change_end
handle_menu_change_enter:
        ;ld hl, menu_state_var1                                  ; check menu and cursor and check if action is valid
        ;ld a, (hl)                                              ; check cursor position; save in b
        ;and $03
        ;ld b, a
        ;ld a, (hl)                                              ; check num choices
        ;and $0C
        ;rrca
        ;rrca
        ;cp b                                                    ; if cursor is greater than num choices (i.e. if a < b or this compare results in the c flag set)
        ;jr c, handle_menu_change_end                            ; then do nothing, this is an invalid enter input
        call change_menu_on_enter                               ; else, call the menu enter check thing
        call update_menu_buffer                                 ; update menu visuals
        jp handle_menu_change_end
handle_menu_change_shift:

        ;call update_menu_buffer                                ; update menu visuals
handle_menu_change_end:
        pop de                                                  ; no matter what, restore register states
        pop bc
        pop hl
        pop af
        ret

change_menu_on_enter:
        ld hl, menu_state_var1
        ld a, (hl)
        and $03
        ld b, a
        ld a, (hl)
        and $F0
        rrca
        rrca
        rrca
        rrca
        cp $01                                                 ; if on the act menu
        jr z, change_menu_on_enter_act
        cp $02                                                 ; if on the items menu
        jr z, change_menu_on_enter_item
        cp $03                                                 ; if on the target menu
        jr z, change_menu_on_enter_target
change_menu_on_enter_default:
        ld a, b                                                 ; where is the cursor on the default menu
        cp $00
        jr z, change_menu_on_enter_default0
        cp $01
        jr z, change_menu_on_enter_default1
change_menu_on_enter_default2:
        jp change_menu_on_enter_end
change_menu_on_enter_default0:
        ld hl, menu_state_var1
        ld a, (hl)
        and $FC                                                 ; move cursor to first position
        or $0C                                                  ; act menu always has 4 entries, note the number of entries in that part of the byte
        or $10                                                  ; finally, change the top 4 bits to be 0001
        and $1F                                                 ; while keeping changes from before
        ld (hl), a
        jp change_menu_on_enter_end
change_menu_on_enter_default1:
        ;ld hl, menu_state_var1
        ;ld a, (hl)
        ;and $FC                                                ; move cursor to ;first position
        ;or $0C                                                 ; NOTE: CHANGE THE NUMBER OF ENTRIES HERE, WE DUNNO YET
        ;or $20                                                 ; finally, change ;the top 4 bits to be 0010
        ;and $2F                                                ; while keeping changes from before
        ld (hl), a
        jp change_menu_on_enter_end
change_menu_on_enter_act:
        ld a, b                                                 ; where is the cursor on the act menu
        cp $03
        jr z, change_menu_on_enter_act3                         ; jump to "struggle" if on fourth choice
        ld hl, in_battle_chars
        ld de, 3
        add a, e

change_menu_on_enter_act3:

change_menu_on_enter_act_end:

        jp change_menu_on_enter_end
change_menu_on_enter_item:

        jp change_menu_on_enter_end
change_menu_on_enter_target:

        jp change_menu_on_enter_end
change_menu_on_enter_end:
        
        ret

update_menu_buffer:
        push hl                                                 ; save registers
        push af
        push bc
        push de
        ld hl, bordered_third_attr_buf                          ; clear any changed attributes
        ld de, menu_third_attr_buf
        ld bc, 256
        ldir
        ld b, 0                                                 ; clear all text entries in the menu
        ld hl, $0042
update_menu_buffer_clear_preloop:
        ld c, 10                                                ; b indicates which quadrant of the menu, c is the number of characters to clear out
update_menu_buffer_clear_loop:
        ld de, $3D00
        push bc
        call print_char_to_menu
        pop bc
        dec c
        inc hl
        ld a, c                                                 ; loop back for 10 characters
        cp 0
        jr nz, update_menu_buffer_clear_loop
        inc b
        ld a, b                                                 ; loop for all 4 quadrants
        cp 4                                                    ; if quadrant counter b is >= 4, then end the clear_loop
        jr nc, update_menu_buffer_clear_end
        cp 1
        jr z, update_menu_buffer_clear_2nd_quad
        cp 2
        jr z, update_menu_buffer_clear_3rd_quad
        cp 3
        jr z, update_menu_buffer_clear_4th_quad
        jp update_menu_buffer_clear_end
update_menu_buffer_clear_4th_quad:
        ld hl, $00B1
        jp update_menu_buffer_clear_preloop
update_menu_buffer_clear_2nd_quad:
        ld hl, $0051
        jp update_menu_buffer_clear_preloop
update_menu_buffer_clear_3rd_quad:
        ld hl, $00A2
        jp update_menu_buffer_clear_preloop
update_menu_buffer_clear_end:
        ld hl, menu_state_var1                                  ; populate the menu's text entries based on the current characters' turn and the current menu state
        ld a, (hl)                                              ; load the number of entries of the current menu into b
        and $0C
        rrca
        rrca
        ld b, a
        ld a, (hl)                                              ; load the menu index into a
        and $30
        rrca
        rrca
        rrca
        rrca
        cp $00                                                  ; if we're on a default menu
        jr z, update_menu_buffer_default_menu
        cp $01                                                  ; if we're on an act menu
        jr z, update_menu_buffer_act_menu
        cp $02                                                  ; if we're on an item menu
        jr z, update_menu_buffer_item_menu
        cp $03                                                  ; if we're on a target menu
        jr z, update_menu_buffer_target_menu
        jp update_menu_buffer_text_update_end
update_menu_buffer_default_menu:
        ld hl, $0042                                            ; print "act"
        ld de, act_text
        call print_10_to_menu_buf
        ld hl, $0051                                            ; print "items"
        ld de, item_text
        call print_10_to_menu_buf
        jp update_menu_buffer_text_update_end
update_menu_buffer_act_menu:
        call load_act_menu
        jp update_menu_buffer_text_update_end
update_menu_buffer_item_menu:

        jp update_menu_buffer_text_update_end
update_menu_buffer_target_menu:

update_menu_buffer_text_update_end:
        ld hl, menu_state_var1                                  ; update the attributes based on the cursor position
        ld a, (hl)
        and $03
        ld de, menu_third_attr_buf
        cp 0
        jr z, update_menu_buffer_attr0
        cp 1
        jr z, update_menu_buffer_attr1
        cp 2
        jr z, update_menu_buffer_attr2
update_menu_buffer_attr3:
        ld hl, $0090
        ld b, 3                                                 ; b - loop through 3 lines
        ld c, 15                                                ; c - loop through 15 attributes per line
update_menu_buffer_attr3_loop:
        push hl
        add hl, de
        ld a, (hl)
        xor $3F
        ld (hl), a
        pop hl
        inc hl
        dec c
        jr nz, update_menu_buffer_attr3_loop
        ld c, 15
        ld de, 17                                               ; move hl to the beginning of the next line
        add hl, de
        ld de, menu_third_attr_buf
        dec b
        jr nz, update_menu_buffer_attr3_loop
        jp update_menu_buffer_attr_end
update_menu_buffer_attr0:
        ld hl, $0021                                            ; start on the second line on the second character with our attr buf offset
        ld b, 3                                                 ; b - loop through 3 lines
        ld c, 15                                                ; c - loop through 15 attributes per line
update_menu_buffer_attr0_loop:
        push hl
        add hl, de
        ld a, (hl)
        xor $3F
        ld (hl), a
        pop hl
        inc hl
        dec c
        jr nz, update_menu_buffer_attr0_loop
        ld c, 15
        ld de, 17                                               ; move hl to the beginning of the next line
        add hl, de
        ld de, menu_third_attr_buf
        dec b
        jr nz, update_menu_buffer_attr0_loop
        jp update_menu_buffer_attr_end
update_menu_buffer_attr1:
        ld hl, $0030
        ld b, 3                                                 ; b - loop through 3 lines
        ld c, 15                                                ; c - loop through 15 attributes per line
update_menu_buffer_attr1_loop:
        push hl
        add hl, de
        ld a, (hl)
        xor $3F
        ld (hl), a
        pop hl
        inc hl
        dec c
        jr nz, update_menu_buffer_attr1_loop
        ld c, 15
        ld de, 17                                               ; move hl to the beginning of the next line
        add hl, de
        ld de, menu_third_attr_buf
        dec b
        jr nz, update_menu_buffer_attr1_loop
        jp update_menu_buffer_attr_end
update_menu_buffer_attr2:
        ld hl, $0081
        ld b, 3                                                 ; b - loop through 3 lines
        ld c, 15                                                ; c - loop through 15 attributes per line
update_menu_buffer_attr2_loop:
        push hl
        add hl, de
        ld a, (hl)
        xor $3F
        ld (hl), a
        pop hl
        inc hl
        dec c
        jr nz, update_menu_buffer_attr2_loop
        ld c, 15
        ld de, 17                                               ; move hl to the beginning of the next line
        add hl, de
        ld de, menu_third_attr_buf
        dec b
        jr nz, update_menu_buffer_attr2_loop
update_menu_buffer_attr_end:
        pop de                                                  ; restore registers
        pop bc
        pop af
        pop hl
        ret

;;; prints the text in the menu corresponding to the current character turn
load_act_menu:
        push af
        push bc
        push de
        push hl
        ld hl, menu_state_char_turn                             ; check whose turn it is
        ld a, (hl)
        and $03
        cp 0
        jr z, load_act_menu_c1
load_act_menu_c2:
        ld hl, in_battle_chars
        ld d, 0
        ld e, 11                                                ; 2nd character so 8 bytes to skip first character, 3 bytes to skip first 3 stats
        add hl, de
        ld b, 0
        ld c, 0
load_act_menu_c2_loop:
        ld a, (hl)                                              ; a = move index for p1_c2
        push hl                                                 ; save the location of the move index in the move list of the character
        ld h, 0                                                 ; each move in the move dictionary is described in 13 bytes; move to the exact byte of the move indexed in a
        ld l, a
        ld de, 13                                               ; NOTE: IF SIZE OF AN ENTRY IN THE MOVE DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld d, h                                                 ; keep the calculated offset in de
        ld e, l
        ld hl, move_dictionary                                  ; add the offset to move_dictionary
        add hl, de                                              ; now hl points to the exact move in the move dictionary that the current character has
        ld d, 0
        ld e, 3
        add hl, de                                              ; move to the "name" section of that move by skipping 3 bytes of stats
        ld d, h
        ld e, l
        ld hl, menu_third_px_buf_text_locations                 ; load the relative location in the pixel buffer of the menu third of the screen where we will print text
        add hl, bc
        ld l, (hl)
        ld h, 0
        ;;;;;;;;;;;;;ld hl, $0042
        call print_10_to_menu_buf
        pop hl                                                  ; regain the location of the move index of one move in the move list
        inc hl                                                  ; move to the next move index on the move list
        inc c                                                   ; check if we've done this three times
        ld a, c
        cp 3
        jr nz, load_act_menu_c2_loop                            ; loop 3 times
        jp load_act_menu_end
load_act_menu_c1:
        ld hl, in_battle_chars
        ld d, 0
        ld e, 3                                                 ; 1st character so just skip 3 bytes of stats
        add hl, de
        ld b, 0
        ld c, 0
load_act_menu_c1_loop:
        ld a, (hl)                                              ; a = move index for p1_c1
        push hl                                                 ; save the location of the move index in the move list of the character
        ld h, 0                                                 ; each move in the move dictionary is described in 13 bytes; move to the exact byte of the move indexed in a
        ld l, a
        ld de, 13                                               ; NOTE: IF SIZE OF AN ENTRY IN THE MOVE DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld d, h                                                 ; keep the calculated offset in de
        ld e, l
        ld hl, move_dictionary                                  ; add the offset to move_dictionary
        add hl, de                                              ; now hl points to the exact move in the move dictionary that the current character has
        ld d, 0
        ld e, 3
        add hl, de                                              ; move to the "name" section of that move by skipping 3 bytes of stats
        ld d, h
        ld e, l
        ld hl, menu_third_px_buf_text_locations                 ; load the relative location in the pixel buffer of the menu third of the screen where we will print text
        add hl, bc
        ld l, (hl)
        ld h, 0
        ;;;;;;;;;;;;;ld hl, $0042
        call print_10_to_menu_buf
        pop hl                                                  ; regain the location of the move index of one move in the move list
        inc hl                                                  ; move to the next move index on the move list
        inc c                                                   ; check if we've done this three times
        ld a, c
        cp 3
        jr nz, load_act_menu_c1_loop                            ; loop 3 times
load_act_menu_end:
        ld hl, move_dictionary                                  ; load in the fourth quadrant, a default attack to any character
        ld bc, 3
        add hl, bc
        ld d, h
        ld e, l
        ld hl, menu_third_px_buf_text_locations
        add hl, bc
        ld l, (hl)
        ld h, 0
        call print_10_to_menu_buf

        pop hl
        pop de
        pop bc
        pop af
        ret

;;; multiplies hl by de, does not give a den about carry and overflow, returns result in hl
simple_multiply:
        push af
        push bc
        push de
        ld b, h
        ld c, l
        ld hl, 0
simple_multiply_loop:
        ld a, d                                                 ; check if de is 0
        or e
        jr z, simple_multiply_end                               ; return hl if so
        add hl, bc
        dec de
        jr simple_multiply_loop
simple_multiply_end:
        pop de
        pop bc
        pop af
        ret

;;; prints 10 characters sequentially into the menu buffer (if they don't run off the line)
;;; hl - location of the first character byte to write to in the menu buffer
;;; de - location of the first "offset" byte in a sequence of 10 bytes
;;; "offset" - defined as byte distance from the first byte of the character 'a' or 'A' in ROM
print_10_to_menu_buf:
        push af
        push bc
        push de
        push hl
        ld c, 10                                                ; c = counter for characters printed
print_10_to_menu_buf_loop:
        push de
        push hl
        ld h, d                                                 ; check if byte in de is $ff
        ld l, e
        ld a, (hl)
        pop hl
        cp $ff
        jr z, print_10_to_menu_buf_skip
        push hl
        ld hl, $3E08                                            ; calculate the location in ROM for the sprite based on the offset in de
        ld a, (de)
        ld d, 0
        ld e, a
        add hl, de
        ld d, h                                                 ; put ROM location of sprite of character into de
        ld e, l
        pop hl                                                  ; regain the location to write to in the menu buffer
        push bc
        call print_char_to_menu
        pop bc
print_10_to_menu_buf_skip:
        pop de
        inc hl                                                  ; move horizontally (hopefully) one character over
        inc de                                                  ; move the character sequence over one byte
        dec c                                                   ; check if we can finish
        jr nz, print_10_to_menu_buf_loop
        pop hl
        pop de
        pop bc
        pop af
        ret

update_data:
        ld hl, $4000
        ld de, $5800
        call clear_third

        ld hl, $0042
        ld de, $3D08
        call print_char_to_data


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
        defb $01
char_select_p2_c1:
        defb $02
char_select_p2_c2:
        defb $03

;;; buffer to keep track of the input (or lack thereof) of the last frame
last_input:
        defb $00

;;; Menu State Variables - keeps track of the players turn, what menu to show, and the cursor
menu_state_char_turn:
        defb $00                                                ; 0 = p1_c1, 1 = p1_c2, 2 = p2_c1, 3 = p2_c2
menu_state_var1:
        defb $08                                                ; 4 most sig bits = which menu (by index); 2 least sig bits = cursor position; middle 2 bits = number of choices on the current menu


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
	defb $01, $07, $02 ,$ff, $60, $70, $a8, $20, $ff, $00, $ff, $ff, $ff
	defb $01, $01, $02 ,$ff, $60, $70, $a8, $20, $ff, $08, $ff, $ff, $ff
	defb $04, $03, $05 ,$ff, $60, $70, $a8, $20, $ff, $10, $ff, $ff, $ff
	defb $01, $05, $02 ,$ff, $60, $70, $a8, $20, $ff, $18, $ff, $ff, $ff
	defb $01, $03, $02 ,$ff, $60, $70, $a8, $20, $ff, $20, $ff, $ff, $ff
	defb $04, $04, $05 ,$ff, $60, $70, $a8, $20, $ff, $28, $ff, $ff, $ff
	defb $04, $05, $04 ,$ff, $60, $70, $a8, $20, $ff, $30, $ff, $ff, $ff
	defb $01, $04, $02 ,$ff, $60, $70, $a8, $20, $ff, $38, $ff, $ff, $ff
	defb $01, $01, $02 ,$ff, $60, $70, $a8, $20, $ff, $40, $ff, $ff, $ff
	defb $04, $05, $05 ,$ff, $60, $70, $a8, $20, $ff, $48, $ff, $ff, $ff
	defb $01, $01, $03 ,$ff, $60, $70, $a8, $20, $ff, $50, $ff, $ff, $ff
	defb $01, $02, $03 ,$ff, $60, $70, $a8, $20, $ff, $58, $ff, $ff, $ff
	defb $04, $02, $08 ,$ff, $60, $70, $a8, $20, $ff, $60, $ff, $ff, $ff
	defb $01, $02, $04 ,$ff, $60, $70, $a8, $20, $ff, $68, $ff, $ff, $ff
	defb $01, $04, $03 ,$ff, $60, $70, $a8, $20, $ff, $70, $ff, $ff, $ff
	defb $02, $01, $05 ,$ff, $60, $70, $a8, $20, $ff, $78, $ff, $ff, $ff
	defb $04, $06, $00 ,$ff, $60, $70, $a8, $20, $ff, $80, $ff, $ff, $ff
	defb $01, $01, $03 ,$ff, $60, $70, $a8, $20, $ff, $88, $ff, $ff, $ff
	
;;; (8 bytes x 4 characters) < HP, Armor, MR, move1 offset, move2 offset, move3 offset. Queued Move, Queued Target>
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
        defs 256, $07                                           ;    < attributes >

visual_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
visual_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

menu_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
menu_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

;;; the relative location in the pixel buffer of the menu third of the screen where text is printed (relative as in offsets from 0)
menu_third_px_buf_text_locations:
        defb $42, $51, $A2, $B1

;;; text, as offsets to the 8byte characters in ROM (starting with A $3E08), $ff being space
act_text:
        defb $ff, $00, $10, $98, $ff, $ff, $ff, $ff, $ff, $ff
item_text:
        defb $ff, $40, $98, $20, $60, $90, $ff, $ff, $ff, $ff
enemy1_text:
        defb $ff, $20, $68, $20, $60, $C0, $ff, $00, $ff, $ff
enemy2_text:
        defb $ff, $20, $68, $20, $60, $C0, $ff, $08, $ff, $ff

keymap:
        defb $fe, 's', 'Z', 'X', 'C', 'V'
        defb $fd, 'A', 'S', 'D', 'F', 'G'
        defb $fb, 'Q', 'W', 'E', 'R', 'T'
        defb $f7, '1', '2', '3', '4', '5'
        defb $ef, '0', '9', '8', '7', '6'
        defb $df, 'P', 'O', 'I', 'U', 'Y'
        defb $bf, 'e', 'L', 'K', 'J', 'H'
        defb $7f, ' ', '#', 'M', 'N', 'B'
;;; character sprites
mage:
	; line based output of pixel data (8 attribute x 8 attribute: 64x64 pixels):
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $70, $00, $00, $00, $00, $00, $00, $03, $fc, $00, $00, $00, $00, $00
	defb $00, $03, $0f, $00, $00, $00, $00, $00, $00, $06, $01, $c0, $00, $00, $00, $00
	defb $00, $0f, $e0, $60, $00, $00, $00, $00, $00, $0f, $60, $30, $00, $00, $00, $00
	defb $00, $0c, $70, $18, $00, $00, $00, $00, $00, $00, $f8, $0c, $00, $00, $00, $00
	defb $00, $01, $c0, $06, $00, $00, $00, $00, $00, $03, $80, $03, $00, $00, $00, $00
	defb $00, $0e, $00, $01, $e0, $00, $00, $00, $00, $38, $00, $00, $38, $00, $00, $00
	defb $07, $fc, $00, $00, $fc, $00, $00, $00, $3f, $ff, $fe, $0f, $ff, $00, $00, $00
	defb $63, $ff, $ff, $ff, $ff, $e0, $00, $00, $40, $3f, $ff, $ff, $fc, $38, $00, $00
	defb $40, $01, $ff, $ff, $f8, $0c, $7e, $00, $70, $00, $03, $ff, $c0, $04, $c3, $00
	defb $18, $00, $00, $00, $00, $0d, $00, $80, $0f, $80, $00, $00, $00, $1a, $00, $40
	defb $00, $fc, $00, $00, $01, $fa, $00, $40, $00, $1f, $ff, $80, $07, $02, $00, $40
	defb $00, $0f, $ff, $ff, $ff, $06, $00, $40, $00, $00, $7f, $ff, $fe, $06, $00, $40
	defb $00, $00, $30, $04, $00, $06, $00, $c0, $00, $00, $38, $04, $00, $0f, $00, $80
	defb $00, $00, $38, $04, $00, $39, $c3, $80, $00, $00, $18, $08, $00, $20, $fe, $00
	defb $00, $00, $1e, $78, $00, $60, $f8, $00, $00, $00, $33, $cc, $01, $c3, $c0, $00
	defb $00, $00, $20, $04, $07, $07, $80, $00, $00, $00, $20, $06, $0e, $1f, $00, $00
	defb $00, $00, $60, $82, $18, $3c, $00, $00, $00, $00, $60, $83, $18, $70, $00, $00
	defb $00, $00, $70, $c1, $31, $e0, $00, $00, $00, $00, $50, $41, $63, $80, $00, $00
	defb $00, $00, $d0, $41, $c7, $00, $00, $00, $00, $00, $90, $21, $8e, $00, $00, $00
	defb $00, $00, $98, $23, $1c, $00, $00, $00, $00, $00, $8c, $3e, $18, $00, $00, $00
	defb $00, $01, $86, $07, $30, $00, $00, $00, $00, $01, $06, $03, $20, $00, $00, $00
	defb $00, $01, $06, $03, $60, $00, $00, $00, $00, $01, $06, $01, $c0, $00, $00, $00
	defb $00, $03, $1d, $81, $80, $00, $00, $00, $00, $02, $71, $c3, $80, $00, $00, $00
	defb $00, $03, $80, $fe, $80, $00, $00, $00, $00, $0e, $03, $e0, $80, $00, $00, $00
	defb $00, $18, $1f, $00, $80, $00, $00, $00, $00, $30, $70, $00, $80, $00, $00, $00
	defb $00, $61, $c0, $00, $80, $00, $00, $00, $00, $c3, $00, $00, $80, $00, $00, $00
	defb $00, $ce, $00, $00, $80, $00, $00, $00, $00, $fe, $00, $00, $80, $00, $00, $00
	defb $00, $02, $00, $00, $80, $00, $00, $00, $00, $03, $00, $01, $80, $00, $00, $00
	defb $00, $01, $ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight:
	; line based output of pixel data: (8 attribute x 8 attribute: 64x64 pixels):
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $ff, $00, $00, $00, $00, $00, $00, $03, $81, $00, $00, $00, $00, $00
	defb $00, $06, $00, $c0, $00, $00, $00, $00, $00, $0c, $00, $e0, $00, $00, $00, $00
	defb $00, $08, $00, $bf, $c0, $00, $00, $00, $00, $18, $00, $f0, $30, $00, $00, $00
	defb $00, $10, $03, $80, $0c, $00, $00, $00, $00, $10, $1c, $00, $06, $00, $00, $00
	defb $00, $10, $1c, $00, $03, $00, $00, $00, $00, $20, $38, $00, $01, $80, $00, $00
	defb $01, $e0, $30, $00, $00, $c0, $00, $00, $01, $80, $70, $00, $00, $c0, $00, $00
	defb $01, $f0, $60, $00, $03, $60, $00, $00, $00, $20, $e0, $00, $fc, $20, $00, $00
	defb $00, $c0, $c0, $7f, $01, $20, $00, $00, $07, $81, $c0, $48, $49, $20, $00, $00
	defb $03, $03, $c0, $48, $49, $20, $00, $00, $01, $8f, $40, $78, $48, $20, $00, $00
	defb $00, $f8, $40, $06, $00, $e0, $01, $f0, $00, $00, $60, $03, $8f, $e0, $02, $10
	defb $00, $00, $20, $00, $7f, $c0, $04, $10, $00, $00, $30, $00, $38, $80, $08, $10
	defb $00, $00, $18, $00, $00, $80, $10, $10, $00, $00, $0c, $00, $01, $00, $20, $20
	defb $00, $00, $1e, $00, $03, $00, $40, $40, $00, $00, $37, $c0, $06, $00, $80, $80
	defb $00, $00, $26, $7f, $bc, $01, $01, $00, $00, $00, $3c, $1f, $f4, $02, $02, $00
	defb $00, $00, $18, $0f, $06, $04, $04, $00, $00, $00, $18, $07, $66, $08, $08, $00
	defb $00, $00, $38, $0c, $1e, $10, $10, $00, $00, $00, $38, $1e, $0f, $20, $20, $00
	defb $00, $00, $78, $32, $09, $c0, $40, $00, $00, $00, $7f, $c1, $0f, $60, $80, $00
	defb $00, $00, $ff, $01, $ff, $b1, $00, $00, $00, $01, $8f, $80, $c0, $da, $00, $00
	defb $00, $01, $06, $c0, $00, $6c, $00, $00, $00, $03, $06, $40, $00, $24, $00, $00
	defb $00, $06, $07, $60, $00, $76, $00, $00, $00, $18, $07, $30, $6c, $ca, $00, $00
	defb $00, $30, $06, $0f, $ff, $8e, $00, $00, $00, $e0, $06, $03, $fe, $0c, $00, $00
	defb $03, $80, $07, $01, $3e, $00, $00, $00, $0e, $00, $07, $ff, $ba, $00, $00, $00
	defb $03, $00, $07, $c0, $7a, $00, $00, $00, $01, $00, $04, $00, $0f, $00, $00, $00
	defb $01, $00, $0c, $00, $03, $00, $00, $00, $01, $80, $0c, $01, $01, $00, $00, $00
	defb $00, $bd, $dc, $01, $01, $00, $00, $00, $00, $e7, $7c, $01, $01, $80, $00, $00
	defb $00, $00, $7c, $03, $01, $80, $00, $00, $00, $00, $7c, $02, $01, $00, $00, $00
	defb $00, $00, $2c, $06, $01, $00, $00, $00, $00, $00, $0f, $7f, $f1, $00, $00, $00
	defb $00, $00, $0f, $fb, $ff, $00, $00, $00, $00, $00, $01, $08, $e1, $80, $00, $00
	defb $00, $00, $01, $06, $71, $80, $00, $00, $00, $00, $01, $82, $3f, $00, $00, $00
	defb $00, $00, $00, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
