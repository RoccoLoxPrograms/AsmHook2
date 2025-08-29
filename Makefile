#----------------------------------------
#
# AsmHook2 Source Code - Makefile
# By RoccoLox Programs and Jacobly
# Copyright 2025
# Last Built: August 29, 2025
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
