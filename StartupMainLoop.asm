	   EXTERN _main
_main:
       org 32768
begin:
        call startup
        ret

startup:
        call clear_background
        ;ld hl, char_select_p1_c1                                ; Player 1 Char A
        ;ld (hl), -1
        ;inc hl
        ;ld (hl), -1 					                        ; Player 1 Char B
        ;ld hl, char_select_var                                  ; Character_Select_Var
        ;ld (hl), 0
        ;call draw_char_select                     
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

                                                                ; draw current (default) background for visual third of screen
        

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
        ld b, h
        ld c, l
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
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
        ld b, h
        ld c, l
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
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
        ld b, h
        ld c, l
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
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
        ld b, h
        ld c, l
        ld hl, char_data                                        ; add the offset to char_data and put in hl the new address (= char_data + (6*char_index))
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



        ;;; initialize game states in game state buffer



        call update_data                                        ; read char stat buffers and draw into actual display in the data (top) third (note: only call this again after a call into the animation/actionResolve section)

        call update_visual

        call update_menu_buffer                                 ; read menu state and draw into screen buffer of menu (bottom) third (only call this again after an interpretation of input)
        
main_loop:
        ld hl, menu_state_char_turn                             ; jump if current turn is for player 2 char 1 (i.e. menu_state_char_turn is $02) (to the animation/actionResolve section)
        ld a, (hl)
        cp $02                                                  ; if a < $02, then the c flag will be set; it's still our turn and we can't ActionResolve yet
        jr c, main_loop_no_action
        call action_resolve
main_loop_no_action:

                                                                ; check clock and read sprite idle data to animate visual (middle) third

        call handle_input                                       ; call input handler

                                  
        ld hl, menu_third_px_buf                                ; swap screen buffermemory with the buffer
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
        ;call load_random_enemy_attacks
        call load_default_enemy_attacks

        ;;; load the original HP's of all the characters at the start of this turn resolution into the temporary spaces for HP calculation
        ;;; a = p1_c1's HP; b = p1_c2's HP; c = p2_c1's HP; d = p2_c2's HP
        ld de, 8
        ld hl, in_battle_chars
        ld a, (hl)
        add hl, de
        ld b, (hl)
        add hl, de
        ld c, (hl)
        add hl, de
        ld d, (hl)
        ld hl, post_battle_HP
        ld (hl), a
        inc hl
        ld (hl), b
        inc hl
        ld (hl), c
        inc hl
        ld (hl), d

        ;;; TODO: LOAD INTO C THE CHARACTER INDEX, TO THE ORDER OF CHARACTER SPEEDS; and change the check that ends the loop


        ld c, 0                                                 ; counter for "whose action we are calculating"
action_resolve_preloop:
        ld a, c
        cp 4
        jp z, action_resolve_loop_exit
        ld h, 0
        ld l, c
        ld de, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de                                              ; hl points to the character data in in_battle_chars
        
        ;;; check if we skip this person's action because he's dead
        ld a, (hl)
        cp 0                                                    ; if HP is nonzero, go through this iteration in the loop
        jp nz, action_resolve_loop
        jp action_resolve_loop_end                              ; if HP is zero, skip this character's action calculation
action_resolve_loop:
        ld h, 0
        ld l, c
        ld de, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de                                              ; hl points to the character data in in_battle_chars
        ;;; save location of the "queued target" byte onto stack for later (might as well since we're here in memory)
        ld de, 7                                                ; offset into the queued target byte
        add hl, de
        push hl                                                 ; push this location onto the stack for later retrieval

        ;;; check if the target has 0 HP, if so, skip this loop iteration
        ;ld l, (hl)                                              ; grab target byte and index into the character structures
        ;ld h, 0
        ;ld de, 8
        ;call simple_multiply
        ;ld de, in_battle_chars
        ;add hl, de
        ;ld a, (hl)                                              ; grab the HP of the targeted character
        ;cp 0                                                    ; if the HP is zero, skip this turn resolve
        ;jp z, action_resolve_case_end                           ; don't forget to pop if we skipping this iteration
        ;pop hl
        ;push hl

        ;;; start evaluating the actual move choice
        dec hl                                                  ; move to the location of the "queued move" byte
        ld l, (hl)                                              ; used the move index to offset into the move dictionary
        ld h, 0
        ld de, 13
        call simple_multiply
        ld de, move_dictionary
        add hl, de                                              ; hl points to the move structure in the move dictionary

        ;;; set the cooldown
        ld a, (hl)
        and $0F
        ld d, a
        inc a
        sla a
        sla a
        sla a
        sla a
        add d
        ld (hl), a

;;; <types: phys(1), magic(2), armor(3), MR(4), heal(5), dodge(6), MR debuff(7)>
;;; < cd, type, value, 10-byte name (offset from a, $ff = space)>
;;; <status byte: (n/a, n/a, dodge, str_mr, weak_mr, str_arm, weak_arm, mr_debuff)>
        inc hl                                                  ; move to the types
        ld a, (hl)
        cp $01
        jp z, action_resolve_case_phys
        cp $02
        jp z, action_resolve_case_magic
        cp $03
        jp z, action_resolve_case_armor
        cp $04
        jp z, action_resolve_case_MR
        cp $05
        jp z, action_resolve_case_heal
        cp $06
        jp z, action_resolve_case_dodge
action_resolve_case_debuff:
        pop hl                                                  ; grab the location of the target byte
        push hl
        ld e, (hl)                                              ; index into the target's in_battle struct (namely the status byte)
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl                                                  ; increment into the 2nd byte of the struct - the status byte
        ld a, (hl)
        or 1                                                    ; flip on the mr_debuff bit
        ld (hl), a
        jp action_resolve_case_end
action_resolve_case_phys:
        ;;; first grab the value byte while we are here
        inc hl
        ld b, (hl)                                              ; hold the damage of the attack in b
        ;;; grab the queued target byte
        pop hl
        push hl
        ld e, (hl)
        ;;; index into the target's in_battle struct (namely the status byte)
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl
        ld d, (hl)                                              ; hold the status byte in d
        ld a, d                                                 ; clear out the armor buff bits (no matter what, this attack nullifies all armor buffs)
        and $F9
        ld (hl), a
        ld a, d
        and $06                                                 ; check the 2nd and 3rd least significant bits of the target's status byte for the weak armor and strong armor buffs
        ld d, a
        cp $04                                                  ; if ONLY the "strong armor buff" bit is set in the target's status byte, remove 50 damage (max) from the damage kept in b
        jr z, action_resolve_case_phys_strong_buff
        cp 0                                                    ; if no armor buffs are indicated in the target's status byte, remove nothing from the damage
        jr z, action_resolve_case_phys_apply_damage
action_resolve_case_phys_weak_buff:                             ; for all other cases, move into the weak buff damage removal
        ld a, b
        sub 20
        jp m, action_resolve_case_phys_no_damage                ; if the subtraction ends in a negative number, remake the damage to be 0
        ld b, a
        ld a, d                                                 ; check if both armor buff bits are set
        cp $06                                                  ; if not, then skip the strong buff damage reduction calculation
        jp nz, action_resolve_case_phys_apply_damage
action_resolve_case_phys_strong_buff:
        ld a, b
        sub 50
        jp m, action_resolve_case_phys_no_damage                ; if the subtraction ends in a negative number, remake the damage to be 0
        ld b, a
        jr action_resolve_case_phys_apply_damage
action_resolve_case_phys_no_damage:
        ld b, 0
action_resolve_case_phys_apply_damage:
        pop hl
        push hl
        ld l, (hl)                                              ; grab the target byte again
        ld h, 0
        ld de, post_battle_HP
        add hl, de
        ld a, (hl)                                              ; grab the HP of the target
        sub b                                                   ; subtract the damage from the HP, leave it at zero if it becomes negative
        cp $97                                                  ; since our highest HP value (150) has the most significant bit set to 1, we must check "negative numbers" to be anything >= 151; change any value >= 151 to be 0
        jp c, action_resolve_case_phys_end
action_resolve_case_phys_no_life:
        ld a, 0
action_resolve_case_phys_end:
        ;;; replace the target's new HP with e
        ld (hl), a
        ld hl, post_battle_damage
        ld (hl), b
        jp action_resolve_case_end
action_resolve_case_magic:
        ;;; first grab the value byte while we are here
        inc hl
        ld b, (hl)                                              ; hold the damage of the attack in b
        ;;; grab the queued target byte
        pop hl
        push hl
        ld e, (hl)                                              ; index into the target's in_battle struct (namely the status byte)
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl
        ld d, (hl)                                              ; hold the status byte in d
        ld a, d                                                 ; clear out the MR buff bits (no matter what, this attack nullifies all MR buffs) and MR debuff bit
        and $E6
        ld (hl), a
        ;;; check if the debuff applies to the target
        ld a, d
        and $01                                                 ; if the least significant bit is set, then add 20 damage
        cp $01
        jr nz, action_resolve_case_magic_no_debuff
action_resolve_case_magic_apply_debuff:
        ld a, b
        add 20
        ld b, a
action_resolve_case_magic_no_debuff:
        ;;; check if the MR buffs apply to the target
        ld a, d
        and $18                                                 ; check the 4th and 5th least significant bits of the target's status byte for the weak MR and strong MR buffs
        ld d, a
        cp $10                                                  ; if ONLY the "strong MR buff" bit is set in the target's status byte, remove 50 damage (max) from the damage kept in b
        jr z, action_resolve_case_magic_strong_buff
        cp 0                                                    ; if no MR buffs are indicated in the target's status byte, remove nothing from the damage at this point
        jr z, action_resolve_case_magic_apply_inherent_MR
action_resolve_case_magic_weak_buff:                             ; for all other cases, move into the weak buff damage removal
        ld a, b
        sub 20
        jp m, action_resolve_case_magic_no_damage                ; if the subtraction ends in a negative number, remake the damage to be 0
        ld b, a
        ld a, d                                                 ; check if both MR buff bits are set
        cp $18                                                  ; if not, then skip the strong buff damage reduction calculation
        jp nz, action_resolve_case_magic_apply_inherent_MR
action_resolve_case_magic_strong_buff:
        ld a, b
        sub 50
        jp m, action_resolve_case_magic_no_damage                ; if the subtraction ends in a negative number, remake the damage to be 0
        ld b, a
        jr action_resolve_case_magic_apply_inherent_MR
action_resolve_case_magic_apply_inherent_MR:
        ;;; subtract from the damage the inherent MR of the target
        pop hl
        push hl
        ld e, (hl)
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl
        inc hl
        ld e, (hl)
        ld a, b
        sub e
        jp m, action_resolve_case_magic_no_damage
        ld b, a
        jr action_resolve_case_magic_apply_damage
action_resolve_case_magic_no_damage:
        ld b, 0
action_resolve_case_magic_apply_damage:
        pop hl
        push hl
        ld l, (hl)                                              ; grab the target byte again
        ld h, 0
        ld de, post_battle_HP
        add hl, de
        ld a, (hl)                                              ; grab the temp HP of the target
        sub b                                                   ; subtract the damage from the HP, leave it at zero if it becomes negative
        cp $97                                                  ; since our highest HP value (150) has the most significant bit set to 1, we must check "negative numbers" to be anything >= 151; change any value >= 151 to be 0
        jp c, action_resolve_case_magic_end
action_resolve_case_magic_no_life:
        ld a, 0
action_resolve_case_magic_end:
        ;;; replace the target's new HP with e
        ld (hl), a
        ld hl, post_battle_damage
        ld (hl), b
        jp action_resolve_case_end
action_resolve_case_armor:
        ;;; first grab the value byte while we are here
        inc hl
        ld b, (hl)                                              ; hold the buff amount in b
        ;;; grab the target byte again
        pop hl
        push hl
        ld e, (hl)                                              ; index into the target's in_battle struct (namely the status byte)
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl
        ld d, (hl)                                              ; hold the status byte in d
        ld a, b
        cp $32
        jp z, action_resolve_case_armor_strong
action_resolve_case_armor_weak:
        ld a, d
        or $02
        ld (hl), a
        jp action_resolve_case_armor_end
action_resolve_case_armor_strong:
        ld a, d
        or $04
        ld (hl), a
action_resolve_case_armor_end:
        jp action_resolve_case_end
action_resolve_case_MR:
        ;;; first grab the value byte while we are here
        inc hl
        ld b, (hl)                                              ; hold the buff amount in b
        ;;; grab the target byte again
        pop hl
        push hl
        ld e, (hl)                                              ; index into the target's in_battle struct (namely the status byte)
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl
        ld d, (hl)                                              ; hold the status byte in d
        ld a, b
        cp $32
        jp z, action_resolve_case_MR_strong
action_resolve_case_MR_weak:
        ld a, d
        or $08
        ld (hl), a
        jp action_resolve_case_MR_end
action_resolve_case_MR_strong:
        ld a, d
        or $10
        ld (hl), a
action_resolve_case_MR_end:
        jp action_resolve_case_end
action_resolve_case_heal:
        ;;; first grab the value byte while we are here
        inc hl
        ld b, (hl)                                              ; hold the heal amount in b
        ;;; grab the target byte again
        pop hl
        push hl
        ld e, (hl)                                              ; e hold the target index; index into post_battle_HP to grab the current temp HP
        ld d, 0
        ld hl, post_battle_HP
        add hl, de
        ld a, (hl)                                              ; hold the temp, target HP in a
        ;;; check if target's temp HP is already 0
        cp 0                                                    ; do not heal if HP is already 0
        jp z, action_resolve_case_end
        add a, b                                                ; heal otherwise
        ld b, a                                                 ; now throw away the heal amount in b and save the newly healed HP into b
        ;;; check if past max HP
        ld hl, char_select_p1_c1                                ; index into the character choices to find the index into the character dictionary
        add hl, de
        ld e, (hl)                                              ; index into the character dictionary to grab the original MAX HP of the target character
        ld d, 0
        ld hl, 6
        call simple_multiply
        ld de, char_data
        add hl, de
        ld a, (hl)                                              ; load the original max HP of the target into a
        cp b                                                    ; if the temp HP is still less than the max HP then go ahead and end this loop
        jp nc, action_resolve_case_heal_end
        ld b, a
action_resolve_case_heal_end:   
        pop hl
        push hl
        ld e, (hl)
        ld d, 0
        ld hl, post_battle_HP
        add hl, de
        ld (hl), b
        jp action_resolve_case_end
action_resolve_case_dodge:
        ld e, c
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl
        ld a, (hl)
        or $20
        ld (hl), a
action_resolve_case_end:
        pop hl                                                  ; pop the target byte from the stack to "empty" it for now

        ;;; call the animation loop here; pass in whose turn is resolving (held in c; an index of the in_battle_character entries [0 - 3])
        call animation_loop
action_resolve_loop_end:
        inc c
        jp action_resolve_preloop
action_resolve_loop_exit:
action_resolve_check_dodge:
        ;;; check for the dodge case before we finish
        ld c, 0
action_resolve_check_dodge_loop:
        ld a, c                                                 ; check for loop escape
        cp $04
        jp z, action_resolve_check_dodge_loop_exit
        ld e, c                                                 ; otherwise, index into the in_battle_chars structure
        ld d, 0
        ld hl, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        inc hl                                                  ; grab the status byte
        ld a, (hl)
        and $20                                                 ; mask the status for the dodge bit
        cp $00                                                  ; if dodge bit not set, then skip dodge logic
        jr z, action_resolve_check_dodge_no_dodge
        ld a, (hl)
        and $DF
        ld (hl), a
        dec hl                                                  ; if dodge bit is set, grab the "pre action_resolve" HP
        ld a, (hl)
        ld e, c
        ld d, 0
        ld hl, post_battle_HP                                   ; and set our temp HP to be equal to "pre action_resolve" HP
        add hl, de
        ld (hl), a
action_resolve_check_dodge_no_dodge:
        inc c
        jp action_resolve_check_dodge_loop
action_resolve_check_dodge_loop_exit:
        ld hl, post_battle_HP                                   ; apply all post battle HP's to the character stats structure
        ld a, (hl)
        inc hl
        ld b, (hl)
        inc hl
        ld c, (hl)
        inc hl
        ld d, (hl)
        ld hl, in_battle_chars
        ld (hl), a
        ld a, d
        ld de, 8
        add hl, de
        ld (hl), b
        add hl, de
        ld (hl), c
        add hl, de
        ld (hl), a

        ;;; check if game over
        call check_game_over

        ;;; Reset the menu, move choices, and target choices, update the data screen and the menu buffer
        ld hl, in_battle_chars                                  ; clear all targets and actions
        ld de, 6
        add hl, de
        ld (hl), $00
        inc hl
        ld (hl), $00
        inc hl                                                  ; clear for char 2
        add hl, de
        ld (hl), $00
        inc hl
        ld (hl), $00
        inc hl                                                  ; clear for char 3
        add hl, de
        ld (hl), $00
        inc hl
        ld (hl), $00
        inc hl                                                  ; clear for char 4
        add hl, de
        ld (hl), $00
        inc hl
        ld (hl), $00
        inc hl
        ld hl, menu_state_var1                                  ; return the states to the beginning of the turn
        ld (hl), $08
        ;;; check if player 1 char 1's HP is nonzero before changing to it
        ld hl, in_battle_chars
        ld a, (hl)
        cp 0
        jr z, action_resolve_skip_p1_c1_turn
        ld hl, menu_state_char_turn
        ld (hl), $00
        jr action_resolve_do_p1_c1_turn
action_resolve_skip_p1_c1_turn:
        ld hl, menu_state_char_turn                             ; since we already checked game_over, we know one of the characters is alive; if not the first character then the second one is still there
        ld (hl), $01
action_resolve_do_p1_c1_turn:
        call update_data
        call update_visual
        call update_menu_buffer
        call reduce_cooldowns                                   ; reduce the active cooldowns of all moves by 1
        ret

check_game_over:
check_game_over_check_loss:
        ;;; check if we lose
        ;;; if either of our characters' HPs are nonzero, move on to check if we've won (haven't lost yet)
        ld hl, in_battle_chars
        ld a, (hl)
        cp 0
        jr nz, check_game_over_check_win
        ld de, 8
        add hl, de
        ld a, (hl)
        cp 0
        jp nz, check_game_over_check_win
        jp check_game_over_display_loss
check_game_over_check_win:
        ld hl, in_battle_chars
        ld de, 16
        add hl, de
        ld a, (hl)
        cp 0
        jp nz, check_game_over_end
        ld de, 8
        add hl, de
        ld a, (hl)
        cp 0
        jp nz, check_game_over_end
        ;jr check_game_over_display_win
check_game_over_display_win:
        call clear_background
        ld hl, $086C
        ld de, $3EC8
        call print_char_to_data
        inc hl
        ld de, $3E78
        call print_char_to_data
        inc hl
        ld de, $3EA8
        call print_char_to_data
        inc hl
        ld de, $3D00
        call print_char_to_data
        inc hl
        ld de, $3EB8
        call print_char_to_data
        inc hl
        ld de, $3E48
        call print_char_to_data
        inc hl
        ld de, $3E70
        call print_char_to_data
        call infinite_loop
        jr check_game_over_end
check_game_over_display_loss:
        call clear_background
        ld hl, $086C
        ld de, $3E38
        call print_char_to_data
        inc hl
        ld de, $3E08
        call print_char_to_data
        inc hl
        ld de, $3E68
        call print_char_to_data
        inc hl
        ld de, $3E28
        call print_char_to_data
        inc hl
        ld de, $3D00
        call print_char_to_data
        inc hl
        ld de, $3E78
        call print_char_to_data
        inc hl
        ld de, $3EB0
        call print_char_to_data
        inc hl
        ld de, $3E28
        call print_char_to_data
        inc hl
        ld de, $3E90
        call print_char_to_data
        call infinite_loop
check_game_over_end:
        ret

infinite_loop:
        halt
        halt
        halt
        halt
        halt
        jr infinite_loop

reduce_cooldowns:
        ld c, 19
        ld de, 13
        ld hl, move_dictionary
reduce_cooldowns_loop:
        ld a, (hl)
        and $F0
        jr z, reduce_cooldowns_skip
        ld a, (hl)                                              ; else, reduce the active cooldown by 1
        sub $10
        ld (hl), a
reduce_cooldowns_skip:
        add hl, de
        dec c
        jr nz, reduce_cooldowns_loop
        ret

;;; output a - a "random" number"
randomize:
        push bc
        push de
        push hl
        ld hl, (seed)
        ld a, h
        and 31
        ld h, a
        ld a, (hl)
        inc hl
        ld (seed), hl
        pop hl
        pop de
        pop bc
        ret
seed:
        defw 0

;;; This method loads STRUGGLE for each enemy against corresponding ally characters
load_default_enemy_attacks:
        ld hl, in_battle_chars
        ld de, 31
        add hl, de
        ld a, $01
        ld (hl), a
        ret

;;; NOTE: THIS METHOD DISREGARDS ANY COOLDOWN RESTRICTIONS OF ANY SORT FOR THE ENEMIES
;;; TODO: create another method that handles cooldowns when assigning targets and moves
load_random_enemy_attacks:
        ;;; load enemy attacks
        ;;; load targets for the enemies
        call randomize
        and $03
        ld hl, in_battle_chars
        ld de, 23                                               ; (2 chars down * 8 bytes/char) + 7 byte offset till queued target
        add hl, de
        ld (hl), a
        call randomize
        and $03
        ld hl, in_battle_chars
        ld de, 31                                               ; (3 chars down * 8 bytes/char) + 7 byte offset till queued target
        add hl, de
        ld (hl), a
        ;;; load moves for the enemies
        ;;; NOTE: we are able to limit the move choice from 0-4 rather than 0-3 because the 4th indexed byte from the start of the movelist is the queued move byte (which by default is $00) - this can be used to queue the default move
        call randomize
        and $03
        ld hl, in_battle_chars
        ld de, 19                                               ; (2 chars down * 8 bytes/char) + 3 byte offset till movelist
        add hl, de
        ld d, 0
        ld e, a
        add hl, de
        ld a, (hl)
        ld hl, in_battle_chars
        ld de, 22                                               ; (2 chars down * 8 bytes/char) + 6 byte offset till queued move
        add hl, de
        ld (hl), a
        call randomize
        and $03
        ld hl, in_battle_chars
        ld de, 27                                               ; (3 chars down * 8 bytes/char) + 3 byte offset till movelist
        add hl, de
        ld d, 0
        ld e, a
        add hl, de
        ld a, (hl)
        ld hl, in_battle_chars
        ld de, 30                                               ; (3 chars down * 8 bytes/char) + 6 byte offset till queued move
        add hl, de
        ld (hl), a
        ret


;;; copies a character sprite onto the menu third (specifically to that buffer)
;;; de - address of the character sprite in ROM; hl - address relative to the px buffer (0-2047) where we want to put the character
;;; de: [$3d00, $3fff]                           hl: [$0000, $07ff]
print_char_to_menu:
        push bc
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
        pop bc
        ret

;;; copies a character sprite onto the data third (since no buffer, addresses to the screen) (can be used in general for display)
;;; (keep in mind, the middle and bottom thirds of the screen during our turn will be replaced by the buffer)
;;; de - address of the character sprite in ROM; hl - address relative to the display [0-2047] where we want to put the character
print_char_to_data:
        push hl
        push de
        push bc
        push af
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
        pop af
        pop bc
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
        call handle_menu_change
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
        call change_menu_on_shift
        call update_menu_buffer                                 ; update menu visuals
handle_menu_change_end:
        pop de                                                  ; no matter what, restore register states
        pop bc
        pop hl
        pop af
        ret

;;; changes the state variables of the menu based on valid inputs of shift
;;; does NOT CHANGE VISUALS
;;; does NOT RESTORE STATE OF REGISTERS BEFORE CALL
change_menu_on_shift:
        ld hl, menu_state_var1
        ld a, (hl)
        and $F0
        rrca
        rrca
        rrca
        rrca
        cp $01
        jr z, change_menu_on_shift_act
        cp $02
        jr z, change_menu_on_shift_item
        cp $03
        jr z, change_menu_on_shift_target
change_menu_on_shift_default:
        ld hl, menu_state_char_turn                             ; check whose turn it is
        ld a, (hl)
        cp $00                                                  ; if player 1 char 1, don't do anything
        jp z, change_menu_on_shift_end
        ld a, $00                                               ; if not, move back to player 1 char 1's turn
        ld (hl), a
        ld hl, menu_state_var1                                  ; also change the menu back to target and cursor back to position 1
        ld (hl), $3C
        jp change_menu_on_shift_end
change_menu_on_shift_act:
        ld hl, menu_state_var1                                  ; always move menu back to the default menu, regardless of whose turn it is
        ld (hl), $08
        jp change_menu_on_shift_end
change_menu_on_shift_item:
        ld hl, menu_state_var1                                  ; always move menu back to the default menu, regardless of whose turn it is
        ld (hl), $08
        jp change_menu_on_shift_end
change_menu_on_shift_target:
                                                                ; check if the selected attack of our current character is from item or act

        ld hl, menu_state_var1                                  ; move back to that menu while not changing the turn
        ld (hl), $1C                                            ; NOTE: FOR NOW WE ONLY HAVE ACT
change_menu_on_shift_end:
        ret

;;; changes the state variables of the menu based on valid inputs of enter
;;; does NOT CHANGE VISUALS
;;; does NOT RESTORE STATE OF REGISTERS BEFORE CALL
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
        jp z, change_menu_on_enter_act
        cp $02                                                 ; if on the items menu
        jp z, change_menu_on_enter_item
        cp $03                                                 ; if on the target menu
        jp z, change_menu_on_enter_target
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
        ld hl, menu_state_char_turn                             ; check whose turn it is (should be 0 or 1)
        ld a, (hl)
        and $01
        ld de, 0                                                ; if its player 1's turn, don't add 8 to the in_battle_chars memory reference
        cp $00
        jr z, change_menu_on_enter_act0_c1
        ld de, 8                                                ; NOTE: If size of entries in in_battle_chars changes, change this
change_menu_on_enter_act0_c1:
        ld hl, in_battle_chars                                  ; move to either player 1 char 1 or player 1 char 2 in the battle struct
        add hl, de
        push hl                                                 ; save the address of the character entry in in_battle_chars
        ld de, 3                                                ; look up the move list of the character entry by skipping 3 bytes of stats
        add hl, de
        ld e, b                                                 ; offset this address into the move list by adding the cursor to it (ex: if the address points to the first move in the move list and the cursor is in the second position (i.e. $01) then the address moves over to the second move in the move list)
        ld d, 0
        add hl, de
        ld a, (hl)                                              ; grab the move index at the address
        ;;; check the cooldown of the move in case of invalid choice
        push bc
        push af
        ld h, 0                                                 ; each move in the move dictionary is described in 13 bytes; move to the exact byte of the move indexed in a
        ld l, a
        ld de, 13                                               ; NOTE: IF SIZE OF AN ENTRY IN THE MOVE DICTIONARY CHANGES, CHANGE THIS NUMBER TO MATCH IT
        call simple_multiply
        ld d, h                                                 ; keep the calculated offset in de
        ld e, l
        ld hl, move_dictionary                                  ; add the offset to move_dictionary
        add hl, de                                              ; now hl points to the exact move in the move dictionary that the current character has
        ld a, (hl)                                              ; grab the cd byte
        and $F0                                                 ; if the active cooldown is nonzero (the first four bits of the cd byte) don't do anything with the menu
        jp nz, change_menu_on_enter_act_invalid_cooldown
        pop af
        pop bc
        pop hl                                                  ; regain the address of the character entry in in_battle_chars
        ld de, 6                                                ; NOTE: If the distance to the "Queued Move" byte in the entries of in_battle_chars changes, then change this number
        add hl, de                                              ; move to the queued move byte of that character data structure
        ld (hl), a                                              ; queue the move index based on what moves this character had
        jp change_menu_on_enter_act_end
change_menu_on_enter_act3:
        ld hl, menu_state_char_turn                             ; check whose turn it is (should be 0 or 1)
        ld a, (hl)
        and $01
        ld de, 0
        cp $00
        jr z, change_menu_on_enter_act3_c1
        ld de, 8                                                ; NOTE: If size of entries in in_battle_chars changes, change this
change_menu_on_enter_act3_c1:
        ld hl, in_battle_chars                                  ; move to either player 1 char 1 or player 1 char 2
        add hl, de
        ld de, 6                                                ; NOTE: If the distance to the "Queued Move" byte in the entries of in_battle_chars changes, then change this number
        add hl, de                                              ; move to the queued move byte of that character data structure
        ld (hl), $00                                            ; queue the default move
change_menu_on_enter_act_end:
        ld hl, menu_state_var1                                  ; change menu to the target menu
        ld (hl), $3C
        jp change_menu_on_enter_end
change_menu_on_enter_act_invalid_cooldown:
        pop af                                                  ; reduce the stack by 3 in order to keep sanity on the stack after a premature end to the act menu case of the change_menu_on_enter function
        pop bc
        pop hl
        jp change_menu_on_enter_end
change_menu_on_enter_item:

        jp change_menu_on_enter_end
change_menu_on_enter_target:
        ld hl, menu_state_var1                                  ; first, figure out what to save: establish which target based on cursor position
        ld a, (hl)
        and $03
        ld b, a                                                 ; save this in b
        ld hl, menu_state_char_turn                             ; next, figure out whose turn it is and jump to those cases
        ld a, (hl)
        and $03
        cp $01
        jp z, change_menu_on_enter_target_c2
change_menu_on_enter_target_c1:
        ld hl, in_battle_chars                                  ; if its the first character's turn, record his target and then change the menu state to the next character's turn
        ld de, 7                                                ; NOTE: If the distance to the "Queued Target" byte in an entry to in_battle_chars changes, change this number
        add hl, de                                              ; offset the address to point to the "Queued Target" byte of that entry in in_battle_chars
        ld (hl), b                                              ; store into the in_battle_chars entry the queued target specified by the cursor
        ld hl, menu_state_var1                                  ; change the menu to the default menu on default cursor position
        ld (hl), $08
        ;;; check if player 1 char 2's HP is 0
        ld hl, in_battle_chars
        ld de, 8
        add hl, de
        ld a, (hl)
        cp 0
        jr nz, change_menu_on_enter_target_c1_change_turn
        ld hl, menu_state_char_turn                             ; if player 1 char 2's HP is 0, skip and change to enemy's turn
        ld (hl), $02
        jp change_menu_on_enter_target_end
change_menu_on_enter_target_c1_change_turn:
        ld hl, menu_state_char_turn                             ; change to player 1 char 2's turn
        ld (hl), $01
        jp change_menu_on_enter_target_end
change_menu_on_enter_target_c2:                     
        ld hl, in_battle_chars                                  ; if its the second character's turn, record his target and then change the menu state to indicate to the main loop that we need to jump into ActionResolve/AnimationLoop
        ld de, 8                                                ; NOTE: If the size of entries in the in_battle_chars data structure changes, change this number
        add hl, de                                              ; offset the address to point to the second entry (2nd character) of in_battle_chars
        ld de, 7                                                ; NOTE: If the distance to the "Queued Target" byte in an entry to in_battle_chars changes, change this number
        add hl, de                                              ; offset the address to point to the "Queued Target" byte of that entry in in_battle_chars
        ld (hl), b                                              ; store into the in_battle_chars entry the queued target specified by the cursor
        ld hl, menu_state_var1                                  ; change the menu to the default menu on default cursor position
        ld (hl), $08
        ld hl, menu_state_char_turn                             ; change to player 2's turn
        ld (hl), $02
change_menu_on_enter_target_end:
        call update_data
change_menu_on_enter_end:
        ret

;;; updates the screen buffer of the bottom third of the menu, according to the data
;;; held in memory about the state of the menu and cursor
;;; this is called after a valid input
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
        ld a, 10
        call print_n_to_menu_buf
        ld hl, $0051                                            ; print "items"
        ld de, item_text
        call print_n_to_menu_buf
        jp update_menu_buffer_text_update_end
update_menu_buffer_act_menu:
        call load_act_menu
        jp update_menu_buffer_text_update_end
update_menu_buffer_item_menu:

        jp update_menu_buffer_text_update_end
update_menu_buffer_target_menu:
        call load_target_menu
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

;;; prints the text in the menu corresponding to all possible targets
load_target_menu:
        push af
        push bc
        push de
        push hl
        ld hl, $0042                                            ; print "ally1"
        ld de, ally1_text
        ld a, 10
        call print_n_to_menu_buf
        ld hl, $0051                                            ; print "ally2"
        ld de, ally2_text
        call print_n_to_menu_buf
        ld hl, $00A2                                            ; print "enemy1"
        ld de, enemy1_text
        call print_n_to_menu_buf
        ld hl, $00B1                                            ; print "enemy2"
        ld de, enemy2_text
        call print_n_to_menu_buf
        pop hl
        pop de
        pop bc
        pop af
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
        ;;; print the cd of the move
        push hl                                                 ; save the move dictionary location for use later in printing the name of the move
        ld a, (hl)                                              ; grab the cd byte
        push bc
        call hex_byte_to_ROM_char                               ; hl holds the ROM address of the character describing the first hex number of a (4 MSBs)
        pop bc
        ld d, h
        ld e, l
        push de                                                 ; de holds the ROM address of the number representing the remaining turns left before being able to use this move
        ld hl, menu_third_px_buf_text_locations                 ; find the relative location to print onto the menu buffer
        add hl, bc
        ld l, (hl)
        ld h, 0
        ld de, 9                                                ; move 9 tiles down to leave room for the name of the move
        add hl, de
        pop de                                                  ; regain the ROM address
        call print_char_to_menu
        pop hl                                                  ; regain the move dictionary location saved from earlier
        ;;; print the name located 3 bytes from the start of the indexed move in the move dictionary
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
        ld a, 8
        call print_n_to_menu_buf
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
        ;;; print the cd of the move
        push hl                                                 ; save the move dictionary location for use later in printing the name of the move
        ld a, (hl)                                              ; grab the cd byte
        push bc
        call hex_byte_to_ROM_char                               ; hl holds the ROM address of the character describing the first hex number of a (4 MSBs)
        pop bc
        ld d, h
        ld e, l
        push de                                                 ; de holds the ROM address of the number representing the remaining turns left before being able to use this move
        ld hl, menu_third_px_buf_text_locations                 ; find the relative location to print onto the menu buffer
        add hl, bc
        ld l, (hl)
        ld h, 0
        ld de, 9                                                ; move 9 tiles down to leave room for the name of the move
        add hl, de
        pop de                                                  ; regain the ROM address
        call print_char_to_menu
        pop hl                                                  ; regain the move dictionary location saved from earlier
        ;;; print the name located 3 bytes from the start of the indexed move in the move dictionary
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
        ld a, 8
        call print_n_to_menu_buf
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
        ld a, 10
        call print_n_to_menu_buf
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

;;; prints n number of characters sequentially into the menu buffer (if they don't run off the line)
;;; a - the number of characters to print (n)
;;; hl - location of the first character byte to write to in the menu buffer
;;; de - location of the first "offset" byte in a sequence of 10 bytes
;;; "offset" - defined as byte distance from the first byte of the character 'a' or 'A' in ROM
print_n_to_menu_buf:
        push af
        push bc
        push de
        push hl
        ld c, a                                                 ; c = counter for characters printed
print_n_to_menu_buf_loop:
        push de
        push hl
        ld h, d                                                 ; check if byte in de is $ff
        ld l, e
        ld a, (hl)
        pop hl
        cp $ff
        jr z, print_n_to_menu_buf_skip
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
print_n_to_menu_buf_skip:
        pop de
        inc hl                                                  ; move horizontally (hopefully) one character over
        inc de                                                  ; move the character sequence over one byte
        dec c                                                   ; check if we can finish
        jr nz, print_n_to_menu_buf_loop
        pop hl
        pop de
        pop bc
        pop af
        ret

update_data:
        ld de, $4000                                            ; clear the buffer to the data (top) third
        ld hl, bordered_third_px_buf
        ld bc, 2048
        ldir
        ld de, $5800
        ld hl, bordered_third_attr_buf
        ld bc, 256
        ldir
        ld b, 0
        ld c, 0
update_data_preloop:
        ld a, c
        cp 0
        jr z, update_data_preloop_c1
        cp 1
        jr z, update_data_preloop_c2
        cp 2
        jr z, update_data_preloop_c3
        ;cp 3
        ;jr z, update_data_preloop_c4
update_data_preloop_c4:
        ld hl, $00A2                                            ; begin printing E2's stats with "E2:"
        ld de, $3E28
        call print_char_to_data
        inc hl
        ld de, $3D90
        call print_char_to_data
        inc hl
        ld de, $3DD0
        call print_char_to_data
        jp update_data_loop
update_data_preloop_c1:
        ld hl, $0042                                            ; begin printing A1's stats with "A1:"
        ld de, $3E08
        call print_char_to_data
        inc hl
        ld de, $3D88
        call print_char_to_data
        inc hl
        ld de, $3DD0
        call print_char_to_data
        jp update_data_loop
update_data_preloop_c2:
        ld hl, $0062                                            ; begin printing A2's stats with "A2:"
        ld de, $3E08
        call print_char_to_data
        inc hl
        ld de, $3D90
        call print_char_to_data
        inc hl
        ld de, $3DD0
        call print_char_to_data
        jp update_data_loop
update_data_preloop_c3:
        ld hl, $0082                                            ; begin printing E1's stats with "E1:"
        ld de, $3E28
        call print_char_to_data
        inc hl
        ld de, $3D88
        call print_char_to_data
        inc hl
        ld de, $3DD0
        call print_char_to_data
update_data_loop:
        push bc
        ;;; print HP
        inc hl
        inc hl
        inc hl
        ld de, $3E40
        call print_char_to_data
        inc hl
        ld de, $3E80
        call print_char_to_data
        push hl

        ld h, 0
        ld l, c
        ld de, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        ld a, (hl)
        call hex_byte_to_ROM_char
        pop bc                                                  ; grab the relative screen location
        push de

        ld d, h
        ld e, l
        ld h, b
        ld l, c
        inc hl
        inc hl
        call print_char_to_data
        pop de
        inc hl
        call print_char_to_data
        pop bc
        push bc

        inc hl                                                  ; print A1's status
        inc hl
        inc hl
        ld de, $3E98
        call print_char_to_data
        inc hl
        ld de, $3EA0
        call print_char_to_data
        push hl

        ld h, 0
        ld l, c
        ld de, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        ld de, 1
        add hl, de
        ld a, (hl)
        call hex_byte_to_ROM_char
        pop bc
        push de
        ld d, h
        ld e, l
        ld h, b
        ld l, c
        inc hl
        inc hl
        call print_char_to_data
        pop de
        inc hl
        call print_char_to_data
        pop bc

        push bc                                                 ; print the move selection NOTE: FOR DEBUGGING
        push hl
        ld h, 0
        ld l, c
        ld de, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        ld de, 6
        add hl, de
        ld a, (hl)
        call hex_byte_to_ROM_char
        pop bc
        push de
        ld d, h
        ld e, l
        ld h, b
        ld l, c
        inc hl
        inc hl
        inc hl
        call print_char_to_data
        pop de
        inc hl
        call print_char_to_data
        pop bc

        push bc
        push hl                                                 ; print the target selection NOTE: FOR DEBUGGING
        ld h, 0
        ld l, c
        ld de, 8
        call simple_multiply
        ld de, in_battle_chars
        add hl, de
        ld de, 7
        add hl, de
        ld a, (hl)
        call hex_byte_to_ROM_char
        pop bc
        push de
        ld d, h
        ld e, l
        ld h, b
        ld l, c
        inc hl
        inc hl
        call print_char_to_data
        pop de
        inc hl
        call print_char_to_data
        pop bc

        ;;; finish loop by incrementing counter
        inc c
        ld a, c
        cp 4
        jp nz, update_data_preloop
        ret

;;; a = byte we need to change to
;;; output hl = the ROM address of the character described in the first 4 bits (or first hex character) of a
;;; output de = the ROM address of the character described in the last 4 bits (or last hex character) of a
hex_byte_to_ROM_char:
        ld b, a
        and $0F                                                 ; store bottom 4 bits in c
        ld c, a
        ld a, b                                                 ; store top 4 bits in b
        and $F0
        rrca
        rrca
        rrca
        rrca
        ld b, a
        ld hl, 0
        ld de, 0
hex_byte_to_ROM_char_loop:
        cp $00
        jr z, hex_byte_to_ROM_char0
        cp $01
        jr z, hex_byte_to_ROM_char1
        cp $02
        jr z, hex_byte_to_ROM_char2
        cp $03
        jr z, hex_byte_to_ROM_char3
        cp $04
        jr z, hex_byte_to_ROM_char4
        cp $05
        jr z, hex_byte_to_ROM_char5
        cp $06
        jr z, hex_byte_to_ROM_char6
        cp $07
        jr z, hex_byte_to_ROM_char7
        cp $08
        jr z, hex_byte_to_ROM_char8
        cp $09
        jr z, hex_byte_to_ROM_char9
        cp $0A
        jr z, hex_byte_to_ROM_charA
        cp $0B
        jr z, hex_byte_to_ROM_charB
        cp $0C
        jr z, hex_byte_to_ROM_charC
        cp $0D
        jr z, hex_byte_to_ROM_charD
        cp $0E
        jr z, hex_byte_to_ROM_charE
        cp $0F
        jr z, hex_byte_to_ROM_charF
hex_byte_to_ROM_char0:
        ld de, $3D80
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char1:
        ld de, $3D88
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char2:
        ld de, $3D90
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char3:
        ld de, $3D98
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char4:
        ld de, $3DA0
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char5:
        ld de, $3DA8
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char6:
        ld de, $3DB0
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char7:
        ld de, $3DB8
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char8:
        ld de, $3DC0
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_char9:
        ld de, $3DC8
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_charA:
        ld de, $3E08
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_charB:
        ld de, $3E10
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_charC:
        ld de, $3E18
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_charD:
        ld de, $3E20
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_charE:
        ld de, $3E28
        jp hex_byte_to_ROM_char_end
hex_byte_to_ROM_charF:
        ld de, $3E30
hex_byte_to_ROM_char_end:
        ld a, h                                                 ; if hl has already been populated by the ROM address of the pixels of the character representing the top 4 bits, then jump to end
        or l
        jr nz, hex_byte_to_ROM_char_end2
        ld h, d                                                 ; if hl is 0 then save the address stored in de into hl and then do the loop over for the lower 4 bits
        ld l, e
        ld a, c
        jp hex_byte_to_ROM_char_loop
hex_byte_to_ROM_char_end2:
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



;;; animation logic
;;; c = the index of the character that just resolved
animation_loop:
        push af
        push bc
        push de
        push hl
        ld hl, $4000
        ;;;; Clear third
        push bc
        ld bc, 2048
pixel_clear_third:
        ld (hl), $00
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, pixel_clear_third
        ld bc, 256
        ld h, d
        ld l, e
        
        ld d, $38
        call att_set
        pop bc
        
        
        ld a, 1				;;; Check if enemy logic
        cp c
        jp c, enemy_logic
        						;;;;;; Friendly Prep
        
        
        ;;;; print enemy sprites
        ld hl, $1740
        
        ld hl, $1748
        
        
        ld hl, $47E0
        ld a, c
        rlca
        rlca
        rlca
        add a, l
        ld l, a
        
        ld (sprite_loc), hl
        ld (sprite_orig), hl
        
        ld hl, char_colors
        ld d, $00
        ld e, c
        add hl, de
        ld  a ,(hl)
        ld (att), a
        ;;;;;;;;;;;; Branch to animations;;;;;;;;;
        ld a, c			;;; Get offset by rotate
        rlca
        rlca
        rlca
        ld hl, $0000
        ld l, a
        ld de, in_battle_chars       
        add hl, de      ;;;; Offset into in_battle_char
        ld d, $00
        ld e, 6
        add hl, de   ;;; Index into move queued
        ld a, (hl)
        cp 0
        jp z, anim_loop_end
        cp 1
        jp z, heal   ;;;; TENTATIVE
        cp 2
        jp z, tackle2
        cp 3
        jp z, armor
        cp 4
        jp z, heal
        cp 5
        jp z, armor
        cp 6
        jp z, mresist
        cp 7
        jp z, heal
        cp 8
        jp z, mresist
        cp 9
        jp z, tackle2
        cp 10
        jp z, heal
        cp 11
        jp z, tackle
        cp 12
        jp z, fireball
        cp 13
        jp z, fireball
        cp 14
        jp z, fireball
        cp 15
        jp z, armor
        cp 16
        jp z, slash
        cp 17
        jp z, heal
        cp 18
        jp z, tackle
        jp enemy_logic
        
armor:
    ld hl, $47F0
	ld b, 63
	call y_down_loop
	
	ld a, 1
	ld (sprite_half_w), a
	ld (sprite_h), a
	ld (sprite_loc), hl
	exx
	ld b, 62
	exx
wall_loop:
	halt
	ld de, wall
	ld hl, (sprite_loc)
	call draw_sprite
	ld a, (sprite_h)
	inc a
	ld (sprite_h), a
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec b
	exx
	jp nz, wall_loop
	
	ld hl, (sprite_loc)
	call y_fix_down
	ld a, (sprite_h)
	dec a
	ld (sprite_h), a
	ld de, erase
	call draw_sprite
	halt
	ld a, $04
    ld (sprite_half_w), a
    ld a, $40
    ld (sprite_h), a
	jp anim_loop_end
mresist:
    ld hl, $47F0
	ld b, 63
	call y_down_loop
	
	ld a, 1
	ld (sprite_half_w), a
	ld (sprite_h), a
	ld (sprite_loc), hl
	exx
	ld b, 62
	exx
mirror_loop:
	halt
	ld de, mirror
	ld hl, (sprite_loc)
	call draw_sprite
	ld a, (sprite_h)
	inc a
	ld (sprite_h), a
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec b
	exx
	jp nz, mirror_loop
	
	ld hl, (sprite_loc)
	call y_fix_down
	ld a, (sprite_h)
	dec a
	ld (sprite_h), a
	ld de, erase
	call draw_sprite
	halt
	ld a, $04
    ld (sprite_half_w), a
    ld a, $40
    ld (sprite_h), a
	jp anim_loop_end
fireball:
	;;; START FIREBALL ANIMATION
	ld e, $08
	ld d, $00
	
	ld hl, (sprite_orig)
	add hl, de
	ld (sprite_loc), hl

	ld hl, (sprite_orig)
	ld de, mage
	call draw_sprite
	
	ld a, $02
	ld (sprite_half_w), a
	ld a, $18
	ld (sprite_h), a
	
	exx
	ld b, 3
	exx
fireball_charge:
	exx
	ld c, 8
	exx
	ld de, ball11
fireball_loop:
    halt
    halt
    halt
    halt
	ld hl, (sprite_loc)
	call draw_sprite
	exx
	dec c
	exx
	jp nz, fireball_loop
	
	halt
	ld de, ball17
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, ball16
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, ball15
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, ball14
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, ball13
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, ball12
	ld hl, (sprite_loc)
	call draw_sprite
	exx
	dec b
	exx
	jp nz, fireball_charge
	
	halt

	ld hl, ball11
	ld (fireball_base), hl
	exx
	ld b, 7
	exx
fireball_go:
	exx
	ld c, 3
	exx
	ld hl, (fireball_base)
	ld d, h
	ld e, l
fireball_part:
	ld hl, (sprite_loc)
	
	call draw_sprite
	halt
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec c
	exx
	jp nz, fireball_part
	
	
	ld hl, $0060 ;;; Offset to next fireball part animation
	ld d, h
	ld e, l
	ld hl, (fireball_base)
	add hl, de
	ld (fireball_base), hl
	halt
	ld hl, (sprite_loc)
	ld de, erase
	call draw_sprite
	
	ld hl, (sprite_loc)
	inc l
	ld (sprite_loc), hl
	
	
	exx
	dec b
	exx
	jp nz, fireball_go
	
	halt
	ld de, ball19
	ld hl, (sprite_loc)
	call draw_sprite
	
	ld a, $02
	ld (sprite_half_w), a
	ld a, $18
	ld (sprite_h), a
	
	halt
	ld de, erase
	ld hl, (sprite_loc)
	call draw_sprite
	ld a, $04
    ld (sprite_half_w), a
    ld a, $40
    ld (sprite_h), a
    
    jp anim_loop_end
	
;;; Slash Branch
slash:			;;;; Begin imported animation
	exx
	ld b, 4
	exx
knight_move_loop:
	halt
	ld de, knight2
	ld hl, (sprite_loc)
	call draw_sprite
	halt	
	ld de, knight5
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, knight8
	ld hl, (sprite_loc)
	call draw_sprite

	ld a, (sprite_loc)
	inc a
	ld (sprite_loc), a
	
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec b
	exx
	jp nz, knight_move_loop

	

knight_move2:
	exx
	ld b, 7
	exx
knight_move_loop2:
	halt
	ld de, knight2
	ld hl, (sprite_loc)
	call draw_sprite
	
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	
	halt	
	ld de, knight6
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	ld de, erase
	ld hl, (sprite_loc)
	call draw_sprite
	
	ld a, (sprite_loc)
	inc a
	ld (sprite_loc), a
	
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec b
	exx
	jp nz, knight_move_loop2

	ld d, $00
	call att_set
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
	ld d, $38
	call att_set
	halt
	ld d, $00
	call att_set
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt

	ld a, $58
	ld (slash_att+1), a
	ld a, $60
	ld (slash_att), a
	;;ld a, $4b
	ld a, $43
	ld (slash_pix+1), a
	ld a, $60
	ld (slash_pix), a

	call draw_slash
	
	ld d, $38
	call att_set			;;; End of animation
	jp anim_loop_end
	
heal:			;;;; heal branch;;;;
	
     call heal_animation
     jp anim_loop_end

line_above_sprite:			;;; Heal data;;;
	defb $00, $00
line_width:
	defb $FF, $3C, $18, $18, $7E, $FF
	
tackle:						;;;; Tackle Branch::::
;;;; Begin imported animation
	exx
	ld b, 5
	exx
tackle_move_loop:			
	halt
	ld de, knight2
	ld hl, (sprite_loc)
	call draw_sprite
	halt	
	ld de, knight6
	ld hl, (sprite_loc)
	call draw_sprite
	halt	
	ld de, knight8
	ld hl, (sprite_loc)
	call draw_sprite
	
	ld a, (sprite_loc)
	inc a
	ld (sprite_loc), a
	
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec b
	exx
	jp nz, tackle_move_loop

	ld a, (sprite_loc)
	dec a
	ld (sprite_loc), a
	ld hl, (sprite_loc)
	call y_fix_down
	ld de, erase
	call draw_sprite
    
    jp anim_loop_end
tackle2:						;;;; Tackle Branch::::
;;;; Begin imported animation
	exx
	ld b, 6
	exx
tackle_move_loop2:			
	halt
	halt
	ld de, mage
	ld hl, (sprite_loc)
	call draw_sprite
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	ld de, erase
	ld hl, (sprite_loc)
	call draw_sprite
	
	ld a, (sprite_loc)
	inc a
	ld (sprite_loc), a
	
	ld hl, (sprite_loc)
	call y_fix_up
	ld (sprite_loc), hl
	exx
	dec b
	exx
	jp nz, tackle_move_loop2

	ld a, (sprite_loc)
	dec a
	ld (sprite_loc), a
	ld hl, (sprite_loc)
	call y_fix_down
	ld de, erase
	call draw_sprite
    
    jp anim_loop_end

enemy_logic:

anim_loop_end:
		ld hl, $4800
		push bc
        ld bc, 2048
pixel_clear_third2:
        ld (hl), $00
        inc hl
        dec bc
        ld a, b
        or c
        jr nz, pixel_clear_third2
        ld bc, 256
        ld h, d
        ld l, e
        
        ld d, $38
        call att_set
        
        pop bc
        pop hl
        pop de
        pop bc
        pop af
        ret

;;; this method is called to draw the inert sprites into the middle third of the screen
update_visual:

        ret

heal_animation:
		push af
		push bc
		push de
		push hl
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
        defb $04
char_select_p1_c2:
        defb $05
char_select_p2_c1:
        defb $01
char_select_p2_c2:
        defb $03

move_order:
        defb $02, $31

;;; buffer to keep track of the input (or lack thereof) of the last frame
last_input:
        defb $00

;;; Menu State Variables - keeps track of the players turn, what menu to show, and the cursor
menu_state_char_turn:
        defb $00                                                ; 0 = p1_c1, 1 = p1_c2, 2 = p2_c1, 3 = p2_c2
menu_state_var1:
        defb $08                                                ; 4 most sig bits = which menu (by index); 2 least sig bits = cursor position; middle 2 bits = number of choices on the current menu


;;; Char Dictionary (6 bytes x 6 characters): < HP, Status Bits, MR, move1 offset, move2 offset, move3 offset >
char_data:  
	defb $50, $00, $14, $01, $02, $03
	defb $5A, $00, $14, $04, $05, $06
	defb $5A, $00, $14, $07, $08, $09
	defb $8C, $00, $00, $0A, $0B, $0C
	defb $96, $00, $00, $0D, $0E, $0F
	defb $96, $00, $00, $10, $11, $12
	
;;; <types: phys(1), magic(2), armor(3), MR(4), heal(5), dodge(6), MR debuff(7)>
;;; < cd, type, value, 10-byte name (offset from a, $ff = space)>
;;; < (13 bytes x 18 skills) In character order >	
move_dictionary:
        defb $00, $01, $0A, $90, $98, $88, $A0, $30, $30, $58, $20, $ff, $ff     ; default physical attack - STRUGGLE

	defb $01, $07, $14, $10, $A0, $88, $90, $20, $ff, $ff, $ff, $ff, $ff     ; sets "MR Debuff" bit in target; when target is attacked by a magic type attack, add 20 damage and reset bit - CURSE
	defb $01, $01, $14, $B0, $38, $00, $10, $50, $ff, $ff, $ff, $ff, $ff     ; weak physical attack (20 damage) - WHACK
	defb $04, $03, $32, $28, $70, $88, $98, $40, $28, $C0, $ff, $ff, $ff     ; strong armor buff; sets "Strong Armor Buff" bit in target; when target is attacked by a physical attack, remove 50 damage from that attack, and reset bit - FORTIFY

	defb $01, $05, $14, $38, $20, $00, $58, $ff, $ff, $ff, $ff, $ff, $ff     ; heals target for 20 HP - HEAL
	defb $01, $03, $14, $90, $38, $40, $20, $58, $18, $ff, $ff, $ff, $ff     ; sets the "Weak Armor Buff" bit in target; when target is attacked by physical attack, remove 20 damage from that attack, and reset the bit - SHIELD
	defb $04, $04, $32, $08, $58, $20, $90, $90, $ff, $ff, $ff, $ff, $ff     ; sets the "Strong MR Buff" bit; when attacked by Magic type attack, remove 50 damage and reset bit - BLESS

	defb $04, $05, $28, $60, $20, $68, $18, $ff, $ff, $ff, $ff, $ff, $ff     ; heals target for 40 HP - MEND
	defb $01, $04, $14, $A8, $20, $40, $58, $ff, $ff, $ff, $ff, $ff, $ff     ; sets "Weak MR Buff" bit in target; when target is next attacked by magic type attack, remove 20 damage from that attack, and reset the bit - VEIL
	defb $01, $01, $14, $90, $60, $00, $10, $50, $ff, $ff, $ff, $ff, $ff     ; weak physical attack (20 damage)

	defb $04, $05, $32, $88, $20, $90, $98, $70, $88, $20, $ff, $ff, $ff     ; heals target for 50 HP - RESTORE
	defb $01, $01, $1E, $90, $98, $88, $40, $50, $20, $ff, $ff, $ff, $ff     ; physical attack, 30 Damage - STRIKE
	defb $01, $02, $1E, $60, $00, $30, $40, $10, $ff, $ff, $ff, $ff, $ff     ; Magic attack, 30 Damage - MAGIC

	defb $04, $02, $50, $18, $20, $90, $98, $88, $70, $C0, $ff, $ff, $ff     ; Magic attack, 80 Damage - DESTROY
	defb $01, $02, $28, $08, $58, $00, $90, $98, $ff, $ff, $ff, $ff, $ff     ; Magic attack, 40 Damage - BLAST
	defb $01, $04, $14, $A8, $20, $40, $58, $ff, $ff, $ff, $ff, $ff, $ff     ; sets "Weak MR Buff" bit in target; when target is next attacked by magic type attack, remove 20 damage from that attack, and reset the bit - VEIL

	defb $02, $01, $32, $90, $58, $00, $90, $38, $ff, $ff, $ff, $ff, $ff     ; Physical attack 50 damage - SLASH
	defb $04, $06, $00, $88, $20, $30, $20, $68, $ff, $ff, $ff, $ff, $ff     ; sets regenerate, regardless of chosen target, this only works on self - REGEN
	defb $01, $01, $1E, $90, $98, $88, $40, $50, $20, $ff, $ff, $ff, $ff     ; physical attack, 30 damage - STRIKE
	
;;; (8 bytes x 4 characters) < HP, Status Bits, MR, move1 offset, move2 offset, move3 offset. Queued Move, Queued Target>
in_battle_chars:
	defb $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00
post_battle_HP:
        defb $00, $00, $00, $00
post_battle_damage:
        defb $00
char_colors:
        defb $3A, $38, $3C, $39

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

menu_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
menu_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

;;; the relative location in the pixel buffer of the menu third of the screen where text is printed (relative as in offsets from 0)
menu_third_px_buf_text_locations:
        defb $42, $51, $A2, $B1

;;; text, as offsets to the 8byte characters in ROM (starting with A $3E08), $ff being space
act_text:
        defb $00, $10, $98, $ff, $ff, $ff, $ff, $ff, $ff, $ff
item_text:
        defb $40, $98, $20, $60, $90, $ff, $ff, $ff, $ff, $ff
enemy1_text:
        defb $20, $68, $20, $60, $C0, $ff, $00, $ff, $ff, $ff
enemy2_text:
        defb $20, $68, $20, $60, $C0, $ff, $08, $ff, $ff, $ff
ally1_text:
        defb $00, $58, $58, $C0, $ff, $00, $ff, $ff, $ff, $ff
ally2_text:
        defb $00, $58, $58, $C0, $ff, $08, $ff, $ff, $ff, $ff

keymap:
        defb $fe, 's', 'Z', 'X', 'C', 'V'
        defb $fd, 'A', 'S', 'D', 'F', 'G'
        defb $fb, 'Q', 'W', 'E', 'R', 'T'
        defb $f7, '1', '2', '3', '4', '5'
        defb $ef, '0', '9', '8', '7', '6'
        defb $df, 'P', 'O', 'I', 'U', 'Y'
        defb $bf, 'e', 'L', 'K', 'J', 'H'
        defb $7f, ' ', '#', 'M', 'N', 'B'
        
;;; Animation helpers
y_down_loop:
	call y_fix_down
	dec b
	jp nz, y_down_loop
	ret
	
y_up_loop:
	call y_fix_up
	dec b
	jp nz, y_down_loop
	ret
	
fireball_base:
	defb $00, $00
enemy_loc:
	defb $17, $40
sprite_orig:
	defb $00, $00

y_fix_up:
	ld a, $1F
	and l
	ld (tmp_x), a
	
	ld a, h
	and $07
	sub 1
	
	jp c, next_att_up
	nop
	
	dec h		;;; Next line in same attribute
	
	ld a, (tmp_x)
	or l
	ld l, a
	ret
next_att_up:       ;;; Fixes HL for next attribute
	ld a, l
	sub $20                                      
	
	jp c, next_third_up
	
	ld l, a
	
	ld a, $07
	or h
	ld h, a
	ret
next_third_up:

	ld a, h

	ld a, $07
	or h
	sub $08
	ld h, a
	
	ld a, $c0
	or l
	ld l, a
	ret
;;;; IMPORTANT: decrements y value of scrren location in HL and fixes it
y_fix_down:
	ld a, $1F
	and l
	ld (tmp_x), a	

	ld a, h
	or $F8
	add a, 1
	
	jp c, next_att_down
	nop
	
	inc h		;;; Next line in same attribute
	ret
next_att_down:       ;;; Fixes HL for next attribute

	ld a, $F8
	and h
	ld h, a
	
	ld a, $20
	add a, l
	
	jp c, next_third_down
	
	ld l, a
	
	ret
next_third_down:
	ld a, $1F
	and l
	ld l, a
	
	ld a, 8
	add a, h
	ld h, a
	ret
tmp_x:
	defb $00
draw_slash:	;;; Draws slash (top or bottom)
	halt
	ld c, 32        
	ld hl, (slash_att)
att_loop:
	ld (hl), $07
	inc l

	dec c
	jp nz, att_loop	
	
	halt
	ld b, 4
	ld hl, (slash_pix)
	exx
	ld hl, (slash_pix)
	inc h
	exx
slash_loop:
	ld c, 31
	halt
pix_loop:
	ld (hl), $FF
	inc l
	exx
	ld (hl), $FF
	inc l
	exx

	dec c
	jp nz, pix_loop
	
	ld (hl), $FF
	dec h
	ld a, (slash_pix)
	ld l, a
	exx
	ld (hl), $FF
	ld a, (slash_pix)
	ld l, a
	inc h
	exx
	
	dec b
	jp nz, slash_loop
	;;; Erase slash
	
	ld b, 9
slash_loop2:
	halt
	ld c, 31
pix_loop2:
	ld (hl), $00
	inc l

	dec c
	jp nz, pix_loop2
	
	ld (hl), $00
	inc h
	ld a, (slash_pix)
	ld l, a
	
	dec b
	jp nz, slash_loop2
	
	ret
slash_att:
	defb $00, $00
slash_pix:
	defb $00, $00

att_set:
	halt
	ld hl, 5800h
	ld b,2
OUTER_LOOP:
	ld c, 0
LOOP:
	ld (hl), d ; Paints attribute
	inc l
	ld	a, c
	add a, 1
	ld	c, a
	jr nc, LOOP
	nop
	ld l, 0
	inc h
	djnz OUTER_LOOP
	nop
	ret	
	
sprite_loc:
	defb $00, $00	
sprite_line_or: ;;; OR 8 pixel horizontal from DE to HL
	push bc
	ld (spointer), sp   ;;; store SP
	
	ld ixl, e
	ld ixh, d
	ld sp, ix	;;;Load DE into S
	ld a, (sprite_half_w)
	ld c, a
line_inner_or:
	
	pop de
	ld a, (hl)
	or e
	ld e, a
	ld (hl), e
	inc l
	ld a, (hl)
	or d
	ld d, a
	ld (hl), d
	inc l

	dec c
	jp nz, line_inner_or

	ld a, $e0	
	and l
	ld iy, x_axis
	ld l, (iy+0)
	or l
	ld l, a	;;; Restore x-axis
	
	ld ix, $0000
	add ix, sp
	ld d, ixh
	ld e, ixl ;;; Restore DE
	
	ld sp,(spointer)  ;;; Restore SP
	pop bc
	ret   ;;; sprite_line ret

draw_sprite_or: ;;; OR wxh sprite from location DE to HL (no OOB handle)
	push bc
	call draw_att
	
	ld a, $1F
	and l
	ld (x_axis), a
	ld a, (sprite_h)
	ld c, a
loop_line_or:

	call sprite_line_or
	call y_fix_down

	dec c
	jp nz, loop_line_or
	pop bc
	ret ;;; Draw sprite ret

sprite_line: ;;; Draw 8 pixel horizontal from DE to HL
	push bc
	ld (spointer), sp   ;;; store SP
	
	ld ixl, e
	ld ixh, d
	ld sp, ix	;;;Load DE into S
	ld a, h
	ld a, (sprite_half_w)
	ld c, a
line_inner:
	
	pop de
	ld (hl), e
	inc l
	ld (hl), d
	inc l

	dec c
	jp nz, line_inner

	ld a, $e0	
	and l
	ld iy, x_axis
	ld l, (iy+0)
	or l
	ld l, a	;;; Restore x-axis
	
	ld ix, $0000
	add ix, sp
	ld d, ixh
	ld e, ixl ;;; Restore DE
	
	ld sp,(spointer)  ;;; Restore SP
	pop bc
	ret   ;;; sprite_line ret
	
x_axis:
	defb $00
draw_sprite: ;;; Draw wxh sprite from location DE to HL (no OOB handle)
	push bc
	call draw_att
	ld a, $1F
	and l
	ld (x_axis), a
	ld a, (sprite_h)
	ld c, a
loop_line:
	call sprite_line
	call y_fix_down

	dec c
	jp nz, loop_line
	
	pop bc
	ret ;;; Draw sprite ret
	
draw_att:
	push hl
	push de
	;;; Calculate attribute
	ld a, $18
	and h
	srl a
	srl a
	srl a
	ld b, a
	ld a, $58
	or b
	ld h, a
	
	ld a, (sprite_h)
	srl a
	srl a
	srl a
	inc a
	ld b, a		;;; b has sprite height
	
	ld a, (sprite_half_w)
	rlca
	ld c, a   ;;; c has sprite width

att_line_loop:
	ld a, (att)
	ld (hl), a
	inc hl
	
	dec c
	jp nz, att_line_loop
	
	ld a, (sprite_half_w)
	rlca
	ld c, a
	ld a, $20
	sub c
	ld d, $00
	ld e, a
	add hl, de
	
	dec b
	jp nz, att_line_loop
	
	pop de
	pop hl
	ret
sprite_half_w:
    defb $04
sprite_h:
    defb $40
spointer:
	defb $00, $00
att:
	defb $00
att_loc:
	defb $00
        

;;; character sprites
erase:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight2:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $03, $fc, $00, $00, $00, $00, $00, $00, $0e, $04, $00, $00, $00, $00, $00
	defb $00, $18, $03, $00, $00, $00, $00, $00, $00, $30, $03, $80, $00, $00, $00, $00
	defb $00, $20, $02, $ff, $00, $00, $00, $00, $00, $60, $03, $c0, $c0, $00, $00, $00
	defb $00, $40, $0e, $00, $30, $00, $00, $00, $00, $40, $70, $00, $18, $00, $00, $00
	defb $00, $40, $70, $00, $0c, $00, $00, $00, $00, $80, $e0, $00, $06, $00, $00, $00
	defb $07, $80, $c0, $00, $03, $00, $00, $00, $06, $01, $c0, $00, $03, $00, $00, $00
	defb $07, $c1, $80, $00, $0d, $80, $00, $00, $00, $83, $80, $03, $f0, $80, $00, $00
	defb $03, $03, $01, $fc, $04, $80, $00, $00, $1e, $07, $01, $21, $24, $80, $00, $00
	defb $0c, $0f, $01, $21, $24, $80, $00, $00, $06, $3d, $01, $e1, $20, $80, $00, $00
	defb $03, $e1, $00, $18, $03, $80, $07, $c0, $00, $01, $80, $0e, $3f, $80, $08, $40
	defb $00, $00, $80, $01, $ff, $00, $10, $40, $00, $00, $c0, $00, $e2, $00, $20, $40
	defb $00, $00, $60, $00, $02, $00, $40, $40, $00, $00, $30, $00, $04, $00, $80, $80
	defb $00, $00, $78, $00, $0c, $01, $01, $00, $00, $00, $df, $00, $18, $02, $02, $00
	defb $00, $00, $99, $fe, $f0, $04, $04, $00, $00, $00, $f0, $7f, $d0, $08, $08, $00
	defb $00, $00, $60, $3c, $18, $10, $10, $00, $00, $00, $60, $1d, $98, $20, $20, $00
	defb $00, $00, $e0, $30, $78, $40, $40, $00, $00, $00, $e0, $78, $3c, $80, $80, $00
	defb $00, $01, $e0, $c8, $27, $01, $00, $00, $00, $01, $ff, $04, $3d, $82, $00, $00
	defb $00, $03, $fc, $07, $fe, $c4, $00, $00, $00, $06, $3e, $03, $03, $68, $00, $00
	defb $00, $04, $1b, $00, $01, $b0, $00, $00, $00, $0c, $19, $00, $00, $90, $00, $00
	defb $00, $18, $1d, $80, $01, $d8, $00, $00, $00, $60, $1c, $c1, $b3, $28, $00, $00
	defb $00, $c0, $18, $3f, $fe, $38, $00, $00, $03, $80, $18, $0f, $f8, $30, $00, $00
	defb $0e, $00, $1c, $04, $f8, $00, $00, $00, $38, $00, $1f, $fe, $e8, $00, $00, $00
	defb $0c, $00, $1f, $01, $e8, $00, $00, $00, $04, $00, $10, $00, $3c, $00, $00, $00
	defb $04, $00, $30, $00, $0c, $00, $00, $00, $06, $00, $30, $04, $04, $00, $00, $00
	defb $02, $f7, $70, $04, $04, $00, $00, $00, $03, $9d, $f0, $04, $06, $00, $00, $00
	defb $00, $01, $f0, $0c, $06, $00, $00, $00, $00, $01, $f0, $08, $04, $00, $00, $00
	defb $00, $00, $b0, $18, $04, $00, $00, $00, $00, $00, $3d, $ff, $c4, $00, $00, $00
	defb $00, $00, $3f, $ef, $fc, $00, $00, $00, $00, $00, $04, $23, $86, $00, $00, $00
	defb $00, $00, $04, $19, $c6, $00, $00, $00, $00, $00, $06, $08, $fc, $00, $00, $00
	defb $00, $00, $03, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight5:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $7f, $80, $00, $00, $00, $00, $00, $01, $c0, $80, $00, $00, $00, $00
	defb $00, $03, $00, $60, $00, $00, $00, $00, $00, $06, $00, $70, $00, $00, $00, $00
	defb $00, $04, $00, $5f, $e0, $00, $00, $00, $00, $0c, $00, $78, $18, $00, $00, $00
	defb $00, $08, $01, $c0, $06, $00, $00, $00, $00, $08, $0e, $00, $03, $00, $00, $00
	defb $00, $08, $0e, $00, $01, $80, $00, $00, $00, $10, $1c, $00, $00, $c0, $00, $00
	defb $00, $f0, $18, $00, $00, $60, $00, $00, $00, $c0, $38, $00, $00, $60, $00, $00
	defb $00, $f8, $30, $00, $01, $b0, $00, $00, $00, $10, $70, $00, $7e, $10, $00, $00
	defb $00, $60, $60, $3f, $80, $90, $00, $00, $03, $c0, $e0, $24, $24, $90, $00, $00
	defb $01, $81, $e0, $24, $24, $90, $00, $00, $00, $c7, $a0, $3c, $24, $10, $00, $00
	defb $00, $7c, $20, $03, $00, $70, $00, $f8, $00, $00, $30, $01, $c7, $f0, $01, $08
	defb $00, $00, $10, $00, $3f, $e0, $02, $08, $00, $00, $18, $00, $1c, $40, $04, $08
	defb $00, $00, $0c, $00, $00, $40, $08, $08, $00, $00, $06, $00, $00, $80, $10, $10
	defb $00, $00, $0f, $00, $01, $80, $20, $20, $00, $00, $1b, $e0, $03, $00, $40, $40
	defb $00, $00, $13, $3f, $de, $00, $80, $80, $00, $00, $1e, $0f, $fa, $01, $01, $00
	defb $00, $00, $0c, $07, $83, $02, $02, $00, $00, $00, $0c, $03, $b3, $04, $04, $00
	defb $00, $00, $1c, $06, $0f, $08, $08, $00, $00, $00, $1c, $0f, $07, $90, $10, $00
	defb $00, $00, $3c, $19, $04, $e0, $20, $00, $00, $00, $3f, $e0, $87, $b0, $40, $00
	defb $00, $00, $7f, $80, $ff, $d8, $80, $00, $00, $00, $c7, $c0, $60, $6d, $00, $00
	defb $00, $00, $83, $60, $00, $36, $00, $00, $00, $01, $83, $20, $00, $12, $00, $00
	defb $00, $03, $03, $b0, $00, $3b, $00, $00, $00, $0c, $03, $98, $36, $65, $00, $00
	defb $00, $18, $03, $07, $ff, $c7, $00, $00, $00, $70, $03, $01, $ff, $06, $00, $00
	defb $01, $c0, $03, $80, $9f, $00, $00, $00, $07, $00, $03, $ff, $dd, $00, $00, $00
	defb $01, $80, $03, $e0, $3d, $00, $00, $00, $00, $80, $02, $00, $07, $80, $00, $00
	defb $00, $80, $06, $00, $01, $80, $00, $00, $00, $c0, $06, $00, $80, $80, $00, $00
	defb $00, $5e, $ee, $00, $80, $80, $00, $00, $00, $73, $be, $00, $80, $c0, $00, $00
	defb $00, $00, $3e, $01, $80, $c0, $00, $00, $00, $00, $3e, $01, $00, $80, $00, $00
	defb $00, $00, $16, $03, $00, $80, $00, $00, $00, $00, $07, $bf, $f8, $80, $00, $00
	defb $00, $00, $07, $fd, $ff, $80, $00, $00, $00, $00, $00, $84, $70, $c0, $00, $00
	defb $00, $00, $00, $83, $38, $c0, $00, $00, $00, $00, $00, $c1, $1f, $80, $00, $00
	defb $00, $00, $00, $7e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight6:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $3f, $c0, $00, $00, $00, $00, $00, $00, $e0, $40, $00, $00, $00, $00
	defb $00, $01, $80, $30, $00, $00, $00, $00, $00, $03, $00, $38, $00, $00, $00, $00
	defb $00, $02, $00, $2f, $f0, $00, $00, $00, $00, $06, $00, $3c, $0c, $00, $00, $00
	defb $00, $04, $00, $e0, $03, $00, $00, $00, $00, $04, $07, $00, $01, $80, $00, $00
	defb $00, $04, $07, $00, $00, $c0, $00, $00, $00, $08, $0e, $00, $00, $60, $00, $00
	defb $00, $78, $0c, $00, $00, $30, $00, $00, $00, $60, $1c, $00, $00, $30, $00, $00
	defb $00, $7c, $18, $00, $00, $d8, $00, $00, $00, $08, $38, $00, $3f, $08, $00, $00
	defb $00, $30, $30, $1f, $c0, $48, $00, $00, $00, $e0, $70, $12, $12, $48, $00, $00
	defb $00, $c0, $f0, $12, $12, $48, $00, $00, $00, $63, $d0, $1e, $12, $08, $00, $00
	defb $00, $3e, $10, $01, $80, $38, $00, $7c, $00, $00, $18, $00, $e3, $f8, $00, $84
	defb $00, $00, $08, $00, $1f, $f0, $01, $04, $00, $00, $0c, $00, $0e, $20, $02, $04
	defb $00, $00, $06, $00, $00, $20, $04, $04, $00, $00, $03, $00, $00, $40, $08, $08
	defb $00, $00, $07, $80, $00, $c0, $10, $10, $00, $00, $0d, $f0, $01, $80, $20, $20
	defb $00, $00, $09, $9f, $ef, $00, $40, $40, $00, $00, $0f, $07, $fd, $00, $80, $80
	defb $00, $00, $06, $03, $c1, $81, $01, $00, $00, $00, $06, $01, $d9, $82, $02, $00
	defb $00, $00, $0e, $03, $07, $84, $04, $00, $00, $00, $0e, $07, $83, $c8, $08, $00
	defb $00, $00, $1e, $0c, $82, $70, $10, $00, $00, $00, $1f, $f0, $43, $d8, $20, $00
	defb $00, $00, $3f, $c0, $7f, $ec, $40, $00, $00, $00, $63, $e0, $30, $36, $80, $00
	defb $00, $00, $41, $b0, $00, $1b, $00, $00, $00, $00, $c1, $90, $00, $09, $00, $00
	defb $00, $01, $81, $d8, $00, $1d, $80, $00, $00, $06, $01, $cc, $1b, $32, $80, $00
	defb $00, $0c, $01, $83, $ff, $e3, $80, $00, $00, $38, $01, $80, $ff, $83, $00, $00
	defb $00, $e0, $01, $c0, $4f, $80, $00, $00, $00, $80, $01, $ff, $ee, $80, $00, $00
	defb $00, $c0, $01, $f0, $1e, $80, $00, $00, $00, $40, $01, $00, $03, $c0, $00, $00
	defb $00, $40, $03, $00, $00, $c0, $00, $00, $00, $60, $03, $00, $40, $40, $00, $00
	defb $00, $2f, $77, $00, $40, $40, $00, $00, $00, $39, $df, $00, $40, $60, $00, $00
	defb $00, $00, $1f, $00, $c0, $60, $00, $00, $00, $00, $1f, $00, $80, $40, $00, $00
	defb $00, $00, $0b, $01, $80, $40, $00, $00, $00, $00, $03, $df, $fc, $40, $00, $00
	defb $00, $00, $03, $fe, $ff, $c0, $00, $00, $00, $00, $00, $42, $38, $60, $00, $00
	defb $00, $00, $00, $41, $9c, $60, $00, $00, $00, $00, $00, $60, $8f, $c0, $00, $00
	defb $00, $00, $00, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight8:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $0f, $f0, $00, $00, $00, $00, $00, $00, $38, $10, $00, $00, $00, $00
	defb $00, $00, $60, $0c, $00, $00, $00, $00, $00, $00, $c0, $0e, $00, $00, $00, $00
	defb $00, $00, $80, $0b, $fc, $00, $00, $00, $00, $01, $80, $0f, $03, $00, $00, $00
	defb $00, $01, $00, $38, $00, $c0, $00, $00, $00, $01, $01, $c0, $00, $60, $00, $00
	defb $00, $01, $01, $c0, $00, $30, $00, $00, $00, $02, $03, $80, $00, $18, $00, $00
	defb $00, $1e, $03, $00, $00, $0c, $00, $00, $00, $18, $07, $00, $00, $0c, $00, $00
	defb $00, $1f, $06, $00, $00, $36, $00, $00, $00, $02, $0e, $00, $0f, $c2, $00, $00
	defb $00, $0c, $0c, $07, $f0, $12, $00, $00, $00, $78, $1c, $04, $84, $92, $00, $00
	defb $00, $30, $3c, $04, $84, $92, $00, $00, $00, $18, $f4, $07, $84, $82, $00, $00
	defb $00, $0f, $84, $00, $60, $0e, $00, $1f, $00, $00, $06, $00, $38, $fe, $00, $21
	defb $00, $00, $02, $00, $07, $fc, $00, $41, $00, $00, $03, $00, $03, $88, $00, $81
	defb $00, $00, $01, $80, $00, $08, $01, $01, $00, $00, $00, $c0, $00, $10, $02, $02
	defb $00, $00, $01, $e0, $00, $30, $04, $04, $00, $00, $03, $7c, $00, $60, $08, $08
	defb $00, $00, $02, $67, $fb, $c0, $10, $10, $00, $00, $03, $c1, $ff, $40, $20, $20
	defb $00, $00, $01, $80, $f0, $60, $40, $40, $00, $00, $01, $80, $76, $60, $80, $80
	defb $00, $00, $03, $80, $c1, $e1, $01, $00, $00, $00, $03, $81, $e0, $f2, $02, $00
	defb $00, $00, $07, $83, $20, $9c, $04, $00, $00, $00, $07, $fc, $10, $f6, $08, $00
	defb $00, $00, $0f, $f0, $1f, $fb, $10, $00, $00, $00, $18, $f8, $0c, $0d, $a0, $00
	defb $00, $00, $10, $6c, $00, $06, $c0, $00, $00, $00, $30, $64, $00, $02, $40, $00
	defb $00, $00, $60, $76, $00, $07, $60, $00, $00, $01, $80, $73, $06, $cc, $a0, $00
	defb $00, $03, $00, $60, $ff, $f8, $e0, $00, $00, $0e, $00, $60, $3f, $e0, $c0, $00
	defb $00, $38, $00, $70, $13, $e0, $00, $00, $00, $e0, $00, $7f, $fb, $a0, $00, $00
	defb $00, $30, $00, $7c, $07, $a0, $00, $00, $00, $10, $00, $40, $00, $f0, $00, $00
	defb $00, $10, $00, $c0, $00, $30, $00, $00, $00, $18, $00, $c0, $10, $10, $00, $00
	defb $00, $0b, $dd, $c0, $10, $10, $00, $00, $00, $0e, $77, $c0, $10, $18, $00, $00
	defb $00, $00, $07, $c0, $30, $18, $00, $00, $00, $00, $07, $c0, $20, $10, $00, $00
	defb $00, $00, $02, $c0, $60, $10, $00, $00, $00, $00, $00, $f7, $ff, $10, $00, $00
	defb $00, $00, $00, $ff, $bf, $f0, $00, $00, $00, $00, $00, $10, $8e, $18, $00, $00
	defb $00, $00, $00, $10, $67, $18, $00, $00, $00, $00, $00, $18, $23, $f0, $00, $00
	defb $00, $00, $00, $0f, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
mage:
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
knight2_e:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $1f, $e0, $00, $00, $00, $00, $00, $00, $10, $38, $00
	defb $00, $00, $00, $00, $00, $60, $0c, $00, $00, $00, $00, $00, $00, $e0, $06, $00
	defb $00, $00, $00, $00, $7f, $a0, $02, $00, $00, $00, $00, $01, $81, $e0, $03, $00
	defb $00, $00, $00, $06, $00, $38, $01, $00, $00, $00, $00, $0c, $00, $07, $01, $00
	defb $00, $00, $00, $18, $00, $07, $01, $00, $00, $00, $00, $30, $00, $03, $80, $80
	defb $00, $00, $00, $60, $00, $01, $80, $f0, $00, $00, $00, $60, $00, $01, $c0, $30
	defb $00, $00, $00, $d8, $00, $00, $c1, $f0, $00, $00, $00, $87, $e0, $00, $e0, $80
	defb $00, $00, $00, $90, $1f, $c0, $60, $60, $00, $00, $00, $92, $42, $40, $70, $3c
	defb $00, $00, $00, $92, $42, $40, $78, $18, $00, $00, $00, $82, $43, $c0, $5e, $30
	defb $01, $f0, $00, $e0, $0c, $00, $43, $e0, $01, $08, $00, $fe, $38, $00, $c0, $00
	defb $01, $04, $00, $7f, $c0, $00, $80, $00, $01, $02, $00, $23, $80, $01, $80, $00
	defb $01, $01, $00, $20, $00, $03, $00, $00, $00, $80, $80, $10, $00, $06, $00, $00
	defb $00, $40, $40, $18, $00, $0f, $00, $00, $00, $20, $20, $0c, $00, $7d, $80, $00
	defb $00, $10, $10, $07, $bf, $cc, $80, $00, $00, $08, $08, $05, $ff, $07, $80, $00
	defb $00, $04, $04, $0c, $1e, $03, $00, $00, $00, $02, $02, $0c, $dc, $03, $00, $00
	defb $00, $01, $01, $0f, $06, $03, $80, $00, $00, $00, $80, $9e, $0f, $03, $80, $00
	defb $00, $00, $40, $72, $09, $83, $c0, $00, $00, $00, $20, $de, $10, $7f, $c0, $00
	defb $00, $00, $11, $bf, $f0, $1f, $e0, $00, $00, $00, $0b, $60, $60, $3e, $30, $00
	defb $00, $00, $06, $c0, $00, $6c, $10, $00, $00, $00, $04, $80, $00, $4c, $18, $00
	defb $00, $00, $0d, $c0, $00, $dc, $0c, $00, $00, $00, $0a, $66, $c1, $9c, $03, $00
	defb $00, $00, $0e, $3f, $fe, $0c, $01, $80, $00, $00, $06, $0f, $f8, $0c, $00, $e0
	defb $00, $00, $00, $0f, $90, $1c, $00, $38, $00, $00, $00, $0b, $bf, $fc, $00, $0e
	defb $00, $00, $00, $0b, $c0, $7c, $00, $18, $00, $00, $00, $1e, $00, $04, $00, $10
	defb $00, $00, $00, $18, $00, $06, $00, $10, $00, $00, $00, $10, $10, $06, $00, $30
	defb $00, $00, $00, $10, $10, $07, $77, $a0, $00, $00, $00, $30, $10, $07, $dc, $e0
	defb $00, $00, $00, $30, $18, $07, $c0, $00, $00, $00, $00, $10, $08, $07, $c0, $00
	defb $00, $00, $00, $10, $0c, $06, $80, $00, $00, $00, $00, $11, $ff, $de, $00, $00
	defb $00, $00, $00, $1f, $fb, $fe, $00, $00, $00, $00, $00, $30, $e2, $10, $00, $00
	defb $00, $00, $00, $31, $cc, $10, $00, $00, $00, $00, $00, $1f, $88, $30, $00, $00
	defb $00, $00, $00, $00, $07, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight5_e:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $01, $fe, $00, $00, $00, $00, $00, $00, $01, $03, $80, $00
	defb $00, $00, $00, $00, $06, $00, $c0, $00, $00, $00, $00, $00, $0e, $00, $60, $00
	defb $00, $00, $00, $07, $fa, $00, $20, $00, $00, $00, $00, $18, $1e, $00, $30, $00
	defb $00, $00, $00, $60, $03, $80, $10, $00, $00, $00, $00, $c0, $00, $70, $10, $00
	defb $00, $00, $01, $80, $00, $70, $10, $00, $00, $00, $03, $00, $00, $38, $08, $00
	defb $00, $00, $06, $00, $00, $18, $0f, $00, $00, $00, $06, $00, $00, $1c, $03, $00
	defb $00, $00, $0d, $80, $00, $0c, $1f, $00, $00, $00, $08, $7e, $00, $0e, $08, $00
	defb $00, $00, $09, $01, $fc, $06, $06, $00, $00, $00, $09, $24, $24, $07, $03, $c0
	defb $00, $00, $09, $24, $24, $07, $81, $80, $00, $00, $08, $24, $3c, $05, $e3, $00
	defb $1f, $00, $0e, $00, $c0, $04, $3e, $00, $10, $80, $0f, $e3, $80, $0c, $00, $00
	defb $10, $40, $07, $fc, $00, $08, $00, $00, $10, $20, $02, $38, $00, $18, $00, $00
	defb $10, $10, $02, $00, $00, $30, $00, $00, $08, $08, $01, $00, $00, $60, $00, $00
	defb $04, $04, $01, $80, $00, $f0, $00, $00, $02, $02, $00, $c0, $07, $d8, $00, $00
	defb $01, $01, $00, $7b, $fc, $c8, $00, $00, $00, $80, $80, $5f, $f0, $78, $00, $00
	defb $00, $40, $40, $c1, $e0, $30, $00, $00, $00, $20, $20, $cd, $c0, $30, $00, $00
	defb $00, $10, $10, $f0, $60, $38, $00, $00, $00, $08, $09, $e0, $f0, $38, $00, $00
	defb $00, $04, $07, $20, $98, $3c, $00, $00, $00, $02, $0d, $e1, $07, $fc, $00, $00
	defb $00, $01, $1b, $ff, $01, $fe, $00, $00, $00, $00, $b6, $06, $03, $e3, $00, $00
	defb $00, $00, $6c, $00, $06, $c1, $00, $00, $00, $00, $48, $00, $04, $c1, $80, $00
	defb $00, $00, $dc, $00, $0d, $c0, $c0, $00, $00, $00, $a6, $6c, $19, $c0, $30, $00
	defb $00, $00, $e3, $ff, $e0, $c0, $18, $00, $00, $00, $60, $ff, $80, $c0, $0e, $00
	defb $00, $00, $00, $f9, $01, $c0, $03, $80, $00, $00, $00, $bb, $ff, $c0, $00, $e0
	defb $00, $00, $00, $bc, $07, $c0, $01, $80, $00, $00, $01, $e0, $00, $40, $01, $00
	defb $00, $00, $01, $80, $00, $60, $01, $00, $00, $00, $01, $01, $00, $60, $03, $00
	defb $00, $00, $01, $01, $00, $77, $7a, $00, $00, $00, $03, $01, $00, $7d, $ce, $00
	defb $00, $00, $03, $01, $80, $7c, $00, $00, $00, $00, $01, $00, $80, $7c, $00, $00
	defb $00, $00, $01, $00, $c0, $68, $00, $00, $00, $00, $01, $1f, $fd, $e0, $00, $00
	defb $00, $00, $01, $ff, $bf, $e0, $00, $00, $00, $00, $03, $0e, $21, $00, $00, $00
	defb $00, $00, $03, $1c, $c1, $00, $00, $00, $00, $00, $01, $f8, $83, $00, $00, $00
	defb $00, $00, $00, $00, $7e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight6_e:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $03, $fc, $00, $00, $00, $00, $00, $00, $02, $07, $00, $00
	defb $00, $00, $00, $00, $0c, $01, $80, $00, $00, $00, $00, $00, $1c, $00, $c0, $00
	defb $00, $00, $00, $0f, $f4, $00, $40, $00, $00, $00, $00, $30, $3c, $00, $60, $00
	defb $00, $00, $00, $c0, $07, $00, $20, $00, $00, $00, $01, $80, $00, $e0, $20, $00
	defb $00, $00, $03, $00, $00, $e0, $20, $00, $00, $00, $06, $00, $00, $70, $10, $00
	defb $00, $00, $0c, $00, $00, $30, $1e, $00, $00, $00, $0c, $00, $00, $38, $06, $00
	defb $00, $00, $1b, $00, $00, $18, $3e, $00, $00, $00, $10, $fc, $00, $1c, $10, $00
	defb $00, $00, $12, $03, $f8, $0c, $0c, $00, $00, $00, $12, $48, $48, $0e, $07, $80
	defb $00, $00, $12, $48, $48, $0f, $03, $00, $00, $00, $10, $48, $78, $0b, $c6, $00
	defb $3e, $00, $1c, $01, $80, $08, $7c, $00, $21, $00, $1f, $c7, $00, $18, $00, $00
	defb $20, $80, $0f, $f8, $00, $10, $00, $00, $20, $40, $04, $70, $00, $30, $00, $00
	defb $20, $20, $04, $00, $00, $60, $00, $00, $10, $10, $02, $00, $00, $c0, $00, $00
	defb $08, $08, $03, $00, $01, $e0, $00, $00, $04, $04, $01, $80, $0f, $b0, $00, $00
	defb $02, $02, $00, $f7, $f9, $90, $00, $00, $01, $01, $00, $bf, $e0, $f0, $00, $00
	defb $00, $80, $81, $83, $c0, $60, $00, $00, $00, $40, $41, $9b, $80, $60, $00, $00
	defb $00, $20, $21, $e0, $c0, $70, $00, $00, $00, $10, $13, $c1, $e0, $70, $00, $00
	defb $00, $08, $0e, $41, $30, $78, $00, $00, $00, $04, $1b, $c2, $0f, $f8, $00, $00
	defb $00, $02, $37, $fe, $03, $fc, $00, $00, $00, $01, $6c, $0c, $07, $c6, $00, $00
	defb $00, $00, $d8, $00, $0d, $82, $00, $00, $00, $00, $90, $00, $09, $83, $00, $00
	defb $00, $01, $b8, $00, $1b, $81, $80, $00, $00, $01, $4c, $d8, $33, $80, $60, $00
	defb $00, $01, $c7, $ff, $c1, $80, $30, $00, $00, $00, $c1, $ff, $01, $80, $1c, $00
	defb $00, $00, $01, $f2, $03, $80, $07, $00, $00, $00, $01, $77, $ff, $80, $01, $c0
	defb $00, $00, $01, $78, $0f, $80, $03, $00, $00, $00, $03, $c0, $00, $80, $02, $00
	defb $00, $00, $03, $00, $00, $c0, $02, $00, $00, $00, $02, $02, $00, $c0, $06, $00
	defb $00, $00, $02, $02, $00, $ee, $f4, $00, $00, $00, $06, $02, $00, $fb, $9c, $00
	defb $00, $00, $06, $03, $00, $f8, $00, $00, $00, $00, $02, $01, $00, $f8, $00, $00
	defb $00, $00, $02, $01, $80, $d0, $00, $00, $00, $00, $02, $3f, $fb, $c0, $00, $00
	defb $00, $00, $03, $ff, $7f, $c0, $00, $00, $00, $00, $06, $1c, $42, $00, $00, $00
	defb $00, $00, $06, $39, $82, $00, $00, $00, $00, $00, $03, $f1, $06, $00, $00, $00
	defb $00, $00, $00, $00, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
knight8_e:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $0f, $f0, $00, $00, $00, $00, $00, $00, $08, $1c, $00, $00
	defb $00, $00, $00, $00, $30, $06, $00, $00, $00, $00, $00, $00, $70, $03, $00, $00
	defb $00, $00, $00, $3f, $d0, $01, $00, $00, $00, $00, $00, $c0, $f0, $01, $80, $00
	defb $00, $00, $03, $00, $1c, $00, $80, $00, $00, $00, $06, $00, $03, $80, $80, $00
	defb $00, $00, $0c, $00, $03, $80, $80, $00, $00, $00, $18, $00, $01, $c0, $40, $00
	defb $00, $00, $30, $00, $00, $c0, $78, $00, $00, $00, $30, $00, $00, $e0, $18, $00
	defb $00, $00, $6c, $00, $00, $60, $f8, $00, $00, $00, $43, $f0, $00, $70, $40, $00
	defb $00, $00, $48, $0f, $e0, $30, $30, $00, $00, $00, $49, $21, $20, $38, $1e, $00
	defb $00, $00, $49, $21, $20, $3c, $0c, $00, $00, $00, $41, $21, $e0, $2f, $18, $00
	defb $f8, $00, $70, $06, $00, $21, $f0, $00, $84, $00, $7f, $1c, $00, $60, $00, $00
	defb $82, $00, $3f, $e0, $00, $40, $00, $00, $81, $00, $11, $c0, $00, $c0, $00, $00
	defb $80, $80, $10, $00, $01, $80, $00, $00, $40, $40, $08, $00, $03, $00, $00, $00
	defb $20, $20, $0c, $00, $07, $80, $00, $00, $10, $10, $06, $00, $3e, $c0, $00, $00
	defb $08, $08, $03, $df, $e6, $40, $00, $00, $04, $04, $02, $ff, $83, $c0, $00, $00
	defb $02, $02, $06, $0f, $01, $80, $00, $00, $01, $01, $06, $6e, $01, $80, $00, $00
	defb $00, $80, $87, $83, $01, $c0, $00, $00, $00, $40, $4f, $07, $81, $c0, $00, $00
	defb $00, $20, $39, $04, $c1, $e0, $00, $00, $00, $10, $6f, $08, $3f, $e0, $00, $00
	defb $00, $08, $df, $f8, $0f, $f0, $00, $00, $00, $05, $b0, $30, $1f, $18, $00, $00
	defb $00, $03, $60, $00, $36, $08, $00, $00, $00, $02, $40, $00, $26, $0c, $00, $00
	defb $00, $06, $e0, $00, $6e, $06, $00, $00, $00, $05, $33, $60, $ce, $01, $80, $00
	defb $00, $07, $1f, $ff, $06, $00, $c0, $00, $00, $03, $07, $fc, $06, $00, $70, $00
	defb $00, $00, $07, $c8, $0e, $00, $1c, $00, $00, $00, $05, $df, $fe, $00, $07, $00
	defb $00, $00, $05, $e0, $3e, $00, $0c, $00, $00, $00, $0f, $00, $02, $00, $08, $00
	defb $00, $00, $0c, $00, $03, $00, $08, $00, $00, $00, $08, $08, $03, $00, $18, $00
	defb $00, $00, $08, $08, $03, $bb, $d0, $00, $00, $00, $18, $08, $03, $ee, $70, $00
	defb $00, $00, $18, $0c, $03, $e0, $00, $00, $00, $00, $08, $04, $03, $e0, $00, $00
	defb $00, $00, $08, $06, $03, $40, $00, $00, $00, $00, $08, $ff, $ef, $00, $00, $00
	defb $00, $00, $0f, $fd, $ff, $00, $00, $00, $00, $00, $18, $71, $08, $00, $00, $00
	defb $00, $00, $18, $e6, $08, $00, $00, $00, $00, $00, $0f, $c4, $18, $00, $00, $00
	defb $00, $00, $00, $03, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
mage_e:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $0e, $00, $00, $00, $00, $00, $00, $00, $3f, $c0, $00
	defb $00, $00, $00, $00, $00, $f0, $c0, $00, $00, $00, $00, $00, $03, $80, $60, $00
	defb $00, $00, $00, $00, $06, $07, $f0, $00, $00, $00, $00, $00, $0c, $06, $f0, $00
	defb $00, $00, $00, $00, $18, $0e, $30, $00, $00, $00, $00, $00, $30, $1f, $00, $00
	defb $00, $00, $00, $00, $60, $03, $80, $00, $00, $00, $00, $00, $c0, $01, $c0, $00
	defb $00, $00, $00, $07, $80, $00, $70, $00, $00, $00, $00, $1c, $00, $00, $1c, $00
	defb $00, $00, $00, $3f, $00, $00, $3f, $e0, $00, $00, $00, $ff, $f0, $7f, $ff, $fc
	defb $00, $00, $07, $ff, $ff, $ff, $ff, $c6, $00, $00, $1c, $3f, $ff, $ff, $fc, $02
	defb $00, $00, $30, $1f, $ff, $ff, $80, $02, $00, $3f, $20, $03, $ff, $c0, $00, $0e
	defb $00, $e3, $b0, $00, $00, $00, $00, $18, $01, $80, $d8, $00, $00, $00, $01, $f0
	defb $01, $00, $5f, $80, $00, $00, $3f, $00, $01, $00, $40, $e0, $01, $ff, $f8, $00
	defb $01, $00, $60, $ff, $ff, $ff, $f0, $00, $01, $00, $60, $7f, $ff, $fe, $00, $00
	defb $01, $00, $60, $00, $20, $0c, $00, $00, $01, $80, $f0, $00, $20, $1c, $00, $00
	defb $00, $e3, $9c, $00, $20, $1c, $00, $00, $00, $3f, $04, $00, $10, $18, $00, $00
	defb $00, $0f, $06, $00, $1e, $78, $00, $00, $00, $03, $c3, $80, $33, $cc, $00, $00
	defb $00, $01, $e0, $e0, $20, $04, $00, $00, $00, $00, $f8, $70, $60, $04, $00, $00
	defb $00, $00, $3c, $18, $41, $06, $00, $00, $00, $00, $0e, $18, $c1, $06, $00, $00
	defb $00, $00, $07, $8c, $83, $0e, $00, $00, $00, $00, $01, $c6, $82, $0a, $00, $00
	defb $00, $00, $00, $e3, $82, $0b, $00, $00, $00, $00, $00, $71, $84, $09, $00, $00
	defb $00, $00, $00, $38, $c4, $19, $00, $00, $00, $00, $00, $18, $7c, $31, $00, $00
	defb $00, $00, $00, $0c, $e0, $61, $80, $00, $00, $00, $00, $04, $c0, $60, $80, $00
	defb $00, $00, $00, $06, $c0, $60, $80, $00, $00, $00, $00, $03, $80, $60, $80, $00
	defb $00, $00, $00, $01, $81, $b8, $c0, $00, $00, $00, $00, $01, $c3, $8e, $40, $00
	defb $00, $00, $00, $01, $7f, $01, $c0, $00, $00, $00, $00, $01, $07, $c0, $70, $00
	defb $00, $00, $00, $01, $00, $f8, $18, $00, $00, $00, $00, $01, $00, $0e, $0c, $00
	defb $00, $00, $00, $01, $00, $03, $86, $00, $00, $00, $00, $01, $00, $00, $c3, $00
	defb $00, $00, $00, $01, $00, $00, $73, $00, $00, $00, $00, $01, $00, $00, $7f, $00
	defb $00, $00, $00, $01, $00, $00, $40, $00, $00, $00, $00, $01, $80, $00, $c0, $00
	defb $00, $00, $00, $01, $ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball11: ;;; 32 x 24 sprites
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $7e, $00, $00, $00, $81, $00, $00, $03, $18, $c0, $00, $02, $ff, $40, $00
	defb $05, $7e, $a0, $00, $09, $ff, $90, $00, $09, $ff, $90, $00, $0b, $ff, $d0, $00
	defb $0b, $ff, $d0, $00, $09, $ff, $90, $00, $09, $ff, $90, $00, $05, $7e, $a0, $00
	defb $02, $ff, $40, $00, $03, $18, $c0, $00, $00, $81, $00, $00, $00, $7e, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball12:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $7e, $00, $00, $00, $99, $00, $00, $03, $7e, $c0, $00, $02, $ff, $40, $00
	defb $05, $ff, $a0, $00, $0b, $ff, $d0, $00, $0b, $ff, $d0, $00, $0f, $ff, $f0, $00
	defb $0f, $ff, $f0, $00, $0b, $ff, $d0, $00, $0b, $ff, $d0, $00, $05, $ff, $a0, $00
	defb $02, $ff, $40, $00, $03, $7e, $c0, $00, $00, $99, $00, $00, $00, $7e, $00, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball13:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $00
	defb $01, $c3, $80, $00, $02, $7e, $40, $00, $04, $99, $20, $00, $09, $ff, $90, $00
	defb $0b, $ff, $d0, $00, $0d, $ff, $d0, $00, $15, $ff, $a8, $00, $17, $ff, $e8, $00
	defb $17, $ff, $e8, $00, $15, $ff, $a8, $00, $0d, $ff, $d0, $00, $0b, $ff, $d0, $00
	defb $09, $ff, $90, $00, $04, $99, $20, $00, $02, $7e, $40, $00, $01, $c3, $80, $00
	defb $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball14:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $00
	defb $01, $ff, $80, $00, $02, $ff, $40, $00, $07, $ff, $e0, $00, $0b, $ff, $d0, $00
	defb $0f, $ff, $f0, $00, $0f, $ff, $f0, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00
	defb $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $0f, $ff, $f0, $00, $0f, $ff, $f0, $00
	defb $0b, $ff, $d0, $00, $07, $ff, $e0, $00, $02, $ff, $40, $00, $01, $ff, $80, $00
	defb $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball15:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $00, $01, $c3, $80, $00
	defb $02, $7e, $40, $00, $04, $ff, $20, $00, $0b, $ff, $d0, $00, $13, $ff, $c8, $00
	defb $17, $ff, $e8, $00, $1f, $ff, $f8, $00, $2f, $ff, $f4, $00, $2f, $ff, $f4, $00
	defb $2f, $ff, $f4, $00, $2f, $ff, $f4, $00, $1f, $ff, $f8, $00, $17, $ff, $e8, $00
	defb $13, $ff, $c8, $00, $0b, $ff, $d0, $00, $04, $ff, $20, $00, $02, $7e, $40, $00
	defb $01, $c3, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball16:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $00, $01, $ff, $80, $00
	defb $03, $ff, $c0, $00, $07, $ff, $e0, $00, $0f, $ff, $f0, $00, $1f, $ff, $f8, $00
	defb $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $3f, $ff, $fc, $00, $3f, $ff, $fc, $00
	defb $3f, $ff, $fc, $00, $3f, $ff, $fc, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00
	defb $1f, $ff, $f8, $00, $0f, $ff, $f0, $00, $07, $ff, $e0, $00, $03, $ff, $c0, $00
	defb $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball17:
	defb $00, $00, $00, $00, $00, $7e, $00, $00, $01, $bd, $80, $00, $07, $c3, $e0, $00
	defb $0a, $7e, $50, $00, $14, $ff, $28, $00, $1b, $ff, $d8, $00, $33, $ff, $cc, $00
	defb $37, $ff, $ec, $00, $5f, $ff, $fc, $00, $6f, $ff, $f6, $00, $6f, $ff, $f6, $00
	defb $6f, $ff, $f6, $00, $6f, $ff, $f6, $00, $5f, $ff, $fc, $00, $37, $ff, $ec, $00
	defb $33, $ff, $cc, $00, $1b, $ff, $d8, $00, $14, $ff, $28, $00, $0a, $7e, $50, $00
	defb $07, $c3, $e0, $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00
ball18:
	defb $00, $00, $00, $00, $00, $7e, $00, $00, $01, $ff, $80, $00, $07, $ff, $e0, $00
	defb $0f, $ff, $f0, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $3f, $ff, $fc, $00
	defb $3f, $ff, $fc, $00, $7f, $ff, $fc, $00, $7f, $ff, $fe, $00, $7f, $ff, $fe, $00
	defb $7f, $ff, $fe, $00, $7f, $ff, $fe, $00, $7f, $ff, $fc, $00, $3f, $ff, $fc, $00
	defb $3f, $ff, $fc, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $0f, $ff, $f0, $00
	defb $07, $ff, $e0, $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00
ball19:
	defb $00, $00, $00, $00, $00, $7e, $00, $00, $01, $bd, $80, $00, $07, $c3, $e0, $00
	defb $0a, $7e, $50, $00, $14, $ff, $28, $00, $1b, $99, $d8, $00, $33, $ff, $cc, $00
	defb $37, $66, $ec, $00, $5d, $99, $fc, $00, $6d, $a5, $b6, $00, $6f, $5a, $f6, $00
	defb $6f, $5a, $f6, $00, $6d, $a5, $b6, $00, $5d, $99, $fc, $00, $37, $66, $ec, $00
	defb $33, $ff, $cc, $00, $1b, $99, $d8, $00, $14, $ff, $28, $00, $0a, $7e, $50, $00
	defb $07, $c3, $e0, $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00
ball21:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $07, $e0, $00, $00, $08, $10, $00, $00, $31, $8c, $00, $00, $2f, $f4, $00
	defb $00, $57, $ea, $00, $00, $9f, $f9, $00, $00, $9f, $f9, $00, $00, $bf, $fd, $00
	defb $00, $bf, $fd, $00, $00, $9f, $f9, $00, $00, $9f, $f9, $00, $00, $57, $ea, $00
	defb $00, $2f, $f4, $00, $00, $31, $8c, $00, $00, $08, $10, $00, $00, $07, $e0, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball22:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $07, $e0, $00, $00, $09, $90, $00, $00, $37, $ec, $00, $00, $2f, $f4, $00
	defb $00, $5f, $fa, $00, $00, $bf, $fd, $00, $00, $bf, $fd, $00, $00, $ff, $ff, $00
	defb $00, $ff, $ff, $00, $00, $bf, $fd, $00, $00, $bf, $fd, $00, $00, $5f, $fa, $00
	defb $00, $2f, $f4, $00, $00, $37, $ec, $00, $00, $09, $90, $00, $00, $07, $e0, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball23:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $c0, $00
	defb $00, $1c, $38, $00, $00, $27, $e4, $00, $00, $49, $92, $00, $00, $9f, $f9, $00
	defb $00, $bf, $fd, $00, $00, $df, $fd, $00, $01, $5f, $fa, $80, $01, $7f, $fe, $80
	defb $01, $7f, $fe, $80, $01, $5f, $fa, $80, $00, $df, $fd, $00, $00, $bf, $fd, $00
	defb $00, $9f, $f9, $00, $00, $49, $92, $00, $00, $27, $e4, $00, $00, $1c, $38, $00
	defb $00, $03, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball24:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $c0, $00
	defb $00, $1f, $f8, $00, $00, $2f, $f4, $00, $00, $7f, $fe, $00, $00, $bf, $fd, $00
	defb $00, $ff, $ff, $00, $00, $ff, $ff, $00, $01, $ff, $ff, $80, $01, $ff, $ff, $80
	defb $01, $ff, $ff, $80, $01, $ff, $ff, $80, $00, $ff, $ff, $00, $00, $ff, $ff, $00
	defb $00, $bf, $fd, $00, $00, $7f, $fe, $00, $00, $2f, $f4, $00, $00, $1f, $f8, $00
	defb $00, $03, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball25:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $c0, $00, $00, $1c, $38, $00
	defb $00, $27, $e4, $00, $00, $4f, $f2, $00, $00, $bf, $fd, $00, $01, $3f, $fc, $80
	defb $01, $7f, $fe, $80, $01, $ff, $ff, $80, $02, $ff, $ff, $40, $02, $ff, $ff, $40
	defb $02, $ff, $ff, $40, $02, $ff, $ff, $40, $01, $ff, $ff, $80, $01, $7f, $fe, $80
	defb $01, $3f, $fc, $80, $00, $bf, $fd, $00, $00, $4f, $f2, $00, $00, $27, $e4, $00
	defb $00, $1c, $38, $00, $00, $03, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball26:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $c0, $00, $00, $1f, $f8, $00
	defb $00, $3f, $fc, $00, $00, $7f, $fe, $00, $00, $ff, $ff, $00, $01, $ff, $ff, $80
	defb $01, $ff, $ff, $80, $01, $ff, $ff, $80, $03, $ff, $ff, $c0, $03, $ff, $ff, $c0
	defb $03, $ff, $ff, $c0, $03, $ff, $ff, $c0, $01, $ff, $ff, $80, $01, $ff, $ff, $80
	defb $01, $ff, $ff, $80, $00, $ff, $ff, $00, $00, $7f, $fe, $00, $00, $3f, $fc, $00
	defb $00, $1f, $f8, $00, $00, $03, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball27:
	defb $00, $00, $00, $00, $00, $07, $e0, $00, $00, $1b, $d8, $00, $00, $7c, $3e, $00
	defb $00, $a7, $e5, $00, $01, $4f, $f2, $80, $01, $bf, $fd, $80, $03, $3f, $fc, $c0
	defb $03, $7f, $fe, $c0, $05, $ff, $ff, $c0, $06, $ff, $ff, $60, $06, $ff, $ff, $60
	defb $06, $ff, $ff, $60, $06, $ff, $ff, $60, $05, $ff, $ff, $c0, $03, $7f, $fe, $c0
	defb $03, $3f, $fc, $c0, $01, $bf, $fd, $80, $01, $4f, $f2, $80, $00, $a7, $e5, $00
	defb $00, $7c, $3e, $00, $00, $1f, $f8, $00, $00, $03, $c0, $00, $00, $00, $00, $00
ball28:
	defb $00, $00, $00, $00, $00, $07, $e0, $00, $00, $1f, $f8, $00, $00, $7f, $fe, $00
	defb $00, $ff, $ff, $00, $01, $ff, $ff, $80, $01, $ff, $ff, $80, $03, $ff, $ff, $c0
	defb $03, $ff, $ff, $c0, $07, $ff, $ff, $c0, $07, $ff, $ff, $e0, $07, $ff, $ff, $e0
	defb $07, $ff, $ff, $e0, $07, $ff, $ff, $e0, $07, $ff, $ff, $c0, $03, $ff, $ff, $c0
	defb $03, $ff, $ff, $c0, $01, $ff, $ff, $80, $01, $ff, $ff, $80, $00, $ff, $ff, $00
	defb $00, $7f, $fe, $00, $00, $1f, $f8, $00, $00, $03, $c0, $00, $00, $00, $00, $00
ball29:
	defb $00, $00, $00, $00, $00, $07, $e0, $00, $00, $1b, $d8, $00, $00, $7c, $3e, $00
	defb $00, $a7, $e5, $00, $01, $4f, $f2, $80, $01, $b9, $9d, $80, $03, $3f, $fc, $c0
	defb $03, $76, $6e, $c0, $05, $d9, $9f, $c0, $06, $da, $5b, $60, $06, $f5, $af, $60
	defb $06, $f5, $af, $60, $06, $da, $5b, $60, $05, $d9, $9f, $c0, $03, $76, $6e, $c0
	defb $03, $3f, $fc, $c0, $01, $b9, $9d, $80, $01, $4f, $f2, $80, $00, $a7, $e5, $00
	defb $00, $7c, $3e, $00, $00, $1f, $f8, $00, $00, $03, $c0, $00, $00, $00, $00, $00
ball31:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $7e, $00, $00, $00, $81, $00, $00, $03, $18, $c0, $00, $02, $ff, $40
	defb $00, $05, $7e, $a0, $00, $09, $ff, $90, $00, $09, $ff, $90, $00, $0b, $ff, $d0
	defb $00, $0b, $ff, $d0, $00, $09, $ff, $90, $00, $09, $ff, $90, $00, $05, $7e, $a0
	defb $00, $02, $ff, $40, $00, $03, $18, $c0, $00, $00, $81, $00, $00, $00, $7e, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball32:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	defb $00, $00, $7e, $00, $00, $00, $99, $00, $00, $03, $7e, $c0, $00, $02, $ff, $40
	defb $00, $05, $ff, $a0, $00, $0b, $ff, $d0, $00, $0b, $ff, $d0, $00, $0f, $ff, $f0
	defb $00, $0f, $ff, $f0, $00, $0b, $ff, $d0, $00, $0b, $ff, $d0, $00, $05, $ff, $a0
	defb $00, $02, $ff, $40, $00, $03, $7e, $c0, $00, $00, $99, $00, $00, $00, $7e, $00
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball33:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00
	defb $00, $01, $c3, $80, $00, $02, $7e, $40, $00, $04, $99, $20, $00, $09, $ff, $90
	defb $00, $0b, $ff, $d0, $00, $0d, $ff, $d0, $00, $15, $ff, $a8, $00, $17, $ff, $e8
	defb $00, $17, $ff, $e8, $00, $15, $ff, $a8, $00, $0d, $ff, $d0, $00, $0b, $ff, $d0
	defb $00, $09, $ff, $90, $00, $04, $99, $20, $00, $02, $7e, $40, $00, $01, $c3, $80
	defb $00, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball34:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00
	defb $00, $01, $ff, $80, $00, $02, $ff, $40, $00, $07, $ff, $e0, $00, $0b, $ff, $d0
	defb $00, $0f, $ff, $f0, $00, $0f, $ff, $f0, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8
	defb $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $0f, $ff, $f0, $00, $0f, $ff, $f0
	defb $00, $0b, $ff, $d0, $00, $07, $ff, $e0, $00, $02, $ff, $40, $00, $01, $ff, $80
	defb $00, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball35:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $00, $01, $c3, $80
	defb $00, $02, $7e, $40, $00, $04, $ff, $20, $00, $0b, $ff, $d0, $00, $13, $ff, $c8
	defb $00, $17, $ff, $e8, $00, $1f, $ff, $f8, $00, $2f, $ff, $f4, $00, $2f, $ff, $f4
	defb $00, $2f, $ff, $f4, $00, $2f, $ff, $f4, $00, $1f, $ff, $f8, $00, $17, $ff, $e8
	defb $00, $13, $ff, $c8, $00, $0b, $ff, $d0, $00, $04, $ff, $20, $00, $02, $7e, $40
	defb $00, $01, $c3, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball36:
	defb $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $00, $01, $ff, $80
	defb $00, $03, $ff, $c0, $00, $07, $ff, $e0, $00, $0f, $ff, $f0, $00, $1f, $ff, $f8
	defb $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $3f, $ff, $fc, $00, $3f, $ff, $fc
	defb $00, $3f, $ff, $fc, $00, $3f, $ff, $fc, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8
	defb $00, $1f, $ff, $f8, $00, $0f, $ff, $f0, $00, $07, $ff, $e0, $00, $03, $ff, $c0
	defb $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00
ball37:
	defb $00, $00, $00, $00, $00, $00, $7e, $00, $00, $01, $bd, $80, $00, $07, $c3, $e0
	defb $00, $0a, $7e, $50, $00, $14, $ff, $28, $00, $1b, $ff, $d8, $00, $33, $ff, $cc
	defb $00, $37, $ff, $ec, $00, $5f, $ff, $fc, $00, $6f, $ff, $f6, $00, $6f, $ff, $f6
	defb $00, $6f, $ff, $f6, $00, $6f, $ff, $f6, $00, $5f, $ff, $fc, $00, $37, $ff, $ec
	defb $00, $33, $ff, $cc, $00, $1b, $ff, $d8, $00, $14, $ff, $28, $00, $0a, $7e, $50
	defb $00, $07, $c3, $e0, $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00
ball38:
	defb $00, $00, $00, $00, $00, $00, $7e, $00, $00, $01, $ff, $80, $00, $07, $ff, $e0
	defb $00, $0f, $ff, $f0, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $3f, $ff, $fc
	defb $00, $3f, $ff, $fc, $00, $7f, $ff, $fc, $00, $7f, $ff, $fe, $00, $7f, $ff, $fe
	defb $00, $7f, $ff, $fe, $00, $7f, $ff, $fe, $00, $7f, $ff, $fc, $00, $3f, $ff, $fc
	defb $00, $3f, $ff, $fc, $00, $1f, $ff, $f8, $00, $1f, $ff, $f8, $00, $0f, $ff, $f0
	defb $00, $07, $ff, $e0, $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00
ball39:
	defb $00, $00, $00, $00, $00, $00, $7e, $00, $00, $01, $bd, $80, $00, $07, $c3, $e0
	defb $00, $0a, $7e, $50, $00, $14, $ff, $28, $00, $1b, $99, $d8, $00, $33, $ff, $cc
	defb $00, $37, $66, $ec, $00, $5d, $99, $fc, $00, $6d, $a5, $b6, $00, $6f, $5a, $f6
	defb $00, $6f, $5a, $f6, $00, $6d, $a5, $b6, $00, $5d, $99, $fc, $00, $37, $66, $ec
	defb $00, $33, $ff, $cc, $00, $1b, $99, $d8, $00, $14, $ff, $28, $00, $0a, $7e, $50
	defb $00, $07, $c3, $e0, $00, $01, $ff, $80, $00, $00, $3c, $00, $00, $00, $00, $00
wall:  ;;; (2x8 att sprite)
	defb $00, $00, $00, $00, $00, $7c, $00, $8c, $01, $14, $02, $24, $04, $44, $08, $84
	defb $11, $04, $3e, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04
	defb $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04
	defb $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04
	defb $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04
	defb $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04
	defb $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $04, $22, $08, $22, $10
	defb $22, $20, $22, $40, $22, $80, $23, $00, $3e, $00, $00, $00, $00, $00, $00, $00
mirror:
	defb $00, $00, $00, $00, $03, $80, $06, $40, $04, $60, $0c, $20, $08, $30, $18, $10
	defb $10, $18, $30, $08, $30, $08, $60, $08, $60, $04, $60, $04, $60, $04, $60, $04
	defb $60, $04, $60, $04, $60, $04, $60, $04, $60, $04, $c0, $04, $c0, $02, $c0, $02
	defb $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02
	defb $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02, $c0, $02
	defb $c0, $02, $c0, $02, $c0, $02, $c0, $02, $60, $04, $60, $04, $60, $04, $60, $04
	defb $60, $04, $30, $08, $30, $08, $30, $08, $30, $08, $30, $10, $18, $10, $18, $10
	defb $18, $10, $0c, $20, $0c, $60, $03, $c0, $01, $80, $00, $00, $00, $00, $00, $00
