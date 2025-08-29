;----------------------------------------
;
; AsmHook2 Source Code - main.asm
; By RoccoLox Programs and Jacobly
; Copyright 2025
; Last Built: August 29, 2025
;
;----------------------------------------

include 'include/ez80.inc'
include 'include/tiformat.inc'
format ti archived executable protected program 'ASMHOOK2'
include 'include/app.inc'
include 'include/ti84pceg.inc'

macro relocate? name, address* ; macro by MateoConLechuga
    name.source? := $
    name.destination? := address
    org name.destination?
    macro name.copy?
        ld hl, name.source?
        ld de, name.destination?
        ld bc, name.length?
        ldir
    end macro
    macro name.run
        name.copy
        jp name.destination?
    end macro
    macro name.call
        name.copy
        call name.destination?
        end macro
        macro end?.relocate?
        name.length? := $ - name.destination?
        org name.source? + name.length?
        purge end?.relocate?
        end macro
end macro

include 'installer.asm'

app_start 'AsmHook2', '(C)  2025 RoccoLox and jacobly', 0

installHook:
    di
    call ti.RunIndicOn
    ld hl, parser - 1
    call ti.SetParserHook
    call ti.ClrScrn
    call ti.HomeUp
    ld hl, success
    call ti.PutS
    call ti.GetKey
    ld a, ti.kClear
    jp ti.JForceCmd

include 'ASMHOOK.asm'

app_data

success:
    db "Installation successful!", 0
