        org 32768
begin:
        call startup
        ret

startup:
        call (CLEARING BACKGROUND)
        ld hl, ;; &Player_1_CharA
        ld (hl), -1
        inc hl
        ld (hl), -1 					        ; Player 1 Char B
        ld hl, ;; &Character_Select_Var
        ld (hl), 0
        call (DRAW CHARACTER SELECT SCREEN)                     
        ;; jp char_select_loop

char_select_loop:
        call (ACCEPT INPUT ON CHARACTER SELECT SCREEN)
        call (DRAW CHARACTER SELECT SCREEN)
        jp char_select_loop

start_battle:
        ld hl, menu_third_buf                                   ; draw default background for data (top) third of screen
        ld de, $4000
        ld bc, 2048
        ldir
        ; NOTE: fill in part to change attributes for data third
        ld hl, visual_third_buf                                 ; draw current (default) background for visual third of screen
        ;;ld de, $4800
        ld bc, 2048
        ldir
        ; NOTE: fill in part to change attributes for visual third
        ld hl, menu_third_buf                                   ; draw current (default) background for menu third of screen
        ;;ld de, $5000
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

                                                                ; call input handler

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






empty_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
empty_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

visual_third_px_buf:
        defs 2048, $00                                          ;      < pixels >
visual_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

menu_third_px_buf:
        defs 256, $ff                                           ;          ^
        defs 1536, $00                                          ;      < pixels >
        defs 256, $ff                                           ;          v
menu_third_attr_buf:
        defs 256, $07                                           ;    < attributes >

keymap:
        defb $fe, '#', 'Z', 'X', 'C', 'V'
        defb $fd, 'A', 'S', 'D', 'F', 'G'
        defb $fb, 'Q', 'W', 'E', 'R', 'T'
        defb $f7, '1', '2', '3', '4', '5'
        defb $ef, '0', '9', '8', '7', '6'
        defb $df, 'P', 'O', 'I', 'U', 'Y'
        defb $bf, '#', 'L', 'K', 'J', 'H'
        defb $7f, ' ', '#', 'M', 'N', 'B'