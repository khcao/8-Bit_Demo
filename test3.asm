        org 32768
start:
        call preloop
        ret

;; courtesy of http://symbolicdebugger.com/retro-programming/developing-for-sinclair-computers/
;; http://www.animatez.co.uk/computers/zx-spectrum/keyboard/
;; https://skoolkid.github.io/rom/asm/1601.html
preloop:
        ld a, 1         ; channel 1 = "K" for keyboard
        call $1601      ; Select keyboard channel using ROM
readloop:
        ld hl, keymap
        ld d, 8
        ld c, $fe
readloop_step0:
        ld b, (hl)
        inc hl
        in a, (c)
        and $1f
        ld e, 5
readloop_step1:
        srl a
        jr nc, readloop_step2
        inc hl
        dec e
        jr nz, readloop_step1
        dec d
        jr nz, readloop_step0
        and a
        jp readloop     ; If no key found, keep searching
readloop_step2:
        ld c,(hl)
        push bc
        ld hl, 40       ; begin delay
delay:
        halt
        dec hl
        ld a, l
        or a, h
        jr nz, delay
printline:              ; Routine to print out a line
        ld a, 2         ; channel 2 = "S" for screen
        call $1601      ; Select print channel using ROM
        pop bc          ; Get character to print
        ld a, c
        cp '#'          ; See if user entered '#' escape
        jp z,escape     ; We're done if they have
        rst 16          ; Spectrum: Print the character in register a
        jp preloop      ; Loop round
escape:
        ret

line:   
        defb 'Hello, world!',13,'$'

keymap:
        defb $fe, '#', 'Z', 'X', 'C', 'V'
        defb $fd, 'A', 'S', 'D', 'F', 'G'
        defb $fb, 'Q', 'W', 'E', 'R', 'T'
        defb $f7, '1', '2', '3', '4', '5'
        defb $ef, '0', '9', '8', '7', '6'
        defb $df, 'P', 'O', 'I', 'U', 'Y'
        defb $bf, '#', 'L', 'K', 'J', 'H'
        defb $7f, ' ', '#', 'M', 'N', 'B'
