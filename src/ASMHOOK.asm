;----------------------------------------
;
; AsmHook2 Source Code - ASMHOOK.asm
; By RoccoLox Programs and Jacobly
; Copyright 2025
; Last Built: August 29, 2025
;
;----------------------------------------

name := 'ASMHOOK2'

clean:	assert	~ti.LoadHLInd_s xor ti.JErrorNo and not $FF
	ex	(sp), hl
	ld	(hl), ti.JErrorNo and $FF
.good:	pop	hl, hl
	res	ti.numOP1, (hl)
	pop	bc, hl
	ld	de, (hl)
	ld	(hl), bc
	pop	hl
	di
	ld	sp, hl
	pop	hl
	ret
	.count := ($ - . + long - 1) / long
asm:	call	ti.ParsePrgmName
	call	ti.CkEndLin
	jr	z, .legal
	ld	(ti.curPC), bc
	cp	a, ti.tRParen
	call	z, ti.CkEndLin
	jp	nz, ti.ErrSyntax
.legal:	call	ti.ChkFindSym
	jp	c, ti.ErrUndefined
	ex	de, hl
	ld	a, b
	ld	b, 1
	cp	a, $D0
	jr	nc, parser.ram
	ld	a, 10
	add	a, c
	ld	c, a
	dec	b
	add	hl, bc
	jr	parser.ram
	db	$83
parser:	or	a, a
	jr	z, begin
	cp	a, 2
	jr	nz, .retz
	ld	a, b
	cp	a, $5D
	jr	z, asm
.retz:	cp	a, a
	ret
.ram:	call	ti.LoadDEInd_s
	ld	a, (hl)
	cp	a, ti.tExtTok
.invld:	jp	nz, ti.ErrInvalid
	inc	hl
	ld	a, (hl)
	cp	a, ti.tAsm84CeCmp
	jr	nz, .invld
.valid:	inc	hl
	dec	de
	dec	de
	djnz	.arc
	add	hl, de
.arc:	ld	bc, ti.LoadHLInd_s
	push	bc
	ld	bc, ti.DelMem
	push	bc, hl, de
	ex	de, hl
	call	ti.ErrNotEnoughMem
	ex	de, hl
	ld	de, ti.userMem
	call	ti.InsertMem
	pop	bc, hl
	push	de
	ld	(ti.asm_prgm_size), bc
	ldir
	ld	hl, -clean.count * long
	add	hl, sp
	ld	sp, hl
	push	hl
	ex	de, hl
	lea	hl, clean + ix - parser
	ld	c, clean.count * long
	ldir
	ex	de, hl
	ex	(sp), hl
	ld	de, ti.asm_prgm_size
	push	de, bc, iy + ti.ParsFlag2
	ex	de, hl
	ld	hl, (clean.count + 2) * long
	add	hl, de
	push	hl
	ex	de, hl
	call	ti.PushErrorHandler
	ld	hl, 11 * long + clean.good - clean
	add	hl, sp
	push	hl
	ld	hl, ti.PopErrorHandler
	push	hl
	jp	ti.userMem
begin:	call	ti.CurFetch
	ld	e, a
	ld	a, (ti.basic_prog + 1)
	cp	a, '#'
	ld	a, e
	jr	z, .eol
	cp	a, ti.tExtTok
	jr	nz, .retz
	dec	hl
	dec	hl
	call	ti.LoadDEInd_s
	inc	hl
	ld	a, (hl)
	cp	a, ti.tAsm84CeCmp
	jr	z, parser.valid
.retz:	cp	a, a
	ret
.rew:	ld	hl, (ti.begPC)
	ld	(ti.curPC), hl
	cp	a, a
	ret
.scan:	call	ti.Isa2ByteTok
	call	z, ti.IncFetch
.next:	call	ti.IncFetch
.cont:	cp	a, ti.tString
	call	z, ti.BufToNextBASICSeparator
	call	ti.CkEndExp
	jr	nz, .scan
	call	ti.IncFetch
	jr	c, .rew
.eol:	cp	a, ti.tProg
	jr	nz, .cont
	push	hl
	dec	hl
	ld	(ti.curPC), hl
	call	ti.ParsePrgmName
	call	ti.ChkFindSym
	pop	hl
.cnext:	jr	c, .next
	ex	de, hl
	ld	a, b
	cp	a, $D0
	jr	nc, .ram
	ld	a, 10
	add	a, c
	ld	c, a
	ld	b, 0
	add	hl, bc
.ram:	ld	a, (hl)
	inc	hl
	add	a, -3
	sbc	a, a
	or	a, (hl)
	jr	z, .next
	inc	hl
	ld	hl, (hl)
	ld	bc, ti.tExtTok or ti.tAsm84CeCmp shl 8
	sbc.s	hl, bc
	jr	nz, .next
	push	de
	ld	l, 2
	call	ti.ErrNotEnoughMem
	ld	hl, (ti.begPC)
	dec	hl
	dec	hl
	ld	bc, (hl)
	inc	bc
	inc	bc
	ld	a, c
	rra
	or	a, b
	jp	z, ti.ErrMemory
	ex	(sp), hl
	push	bc
	inc	hl
	ex	de, hl
	call	ti.InsertMem
	pop	bc, hl
	ld	(hl), bc
	ex	de, hl
	ld	bc, ti.t2ByteTok or ti.tasm shl 8 or ti.tProg shl 16
	dec	hl
	ld	(hl), bc
	ld	hl, (ti.endPC)
	inc	hl
	inc	hl
	ld	(ti.endPC), hl
	scf
	jr	.cnext
