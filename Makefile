#----------------------------------------
#
# AsmHook2 Source Code - Makefile
# By RoccoLox Programs and Jacobly
# Copyright 2025 - 2026
# Last Built: September 20, 2026
#
#----------------------------------------

prot:
	fasmg src/main.asm AsmHook2.8xp

unprot:
	fasmg -i "protected equ" src/main.asm AsmHook2_unprot.8xp

all:
	fasmg src/main.asm AsmHook2.8xp
	fasmg -i "protected equ" src/main.asm AsmHook2_unprot.8xp

.PHONEY: all prot unprot
