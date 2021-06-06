; z80dasm 1.1.3
; command line: ./z80dasm -a -l -S dump.sym -s dump.sym1 -o dump.mac -b dump.blocks.txt DUMP.COM

	org	00100h
__argc_:	equ 0x2d11

;==========================================================================
; 0	
;==========================================================================
	ld hl,(00006h)		;0100 base address of fdos
	ld sp,hl		;0103 stack grows downwards
	ld de,__Hdata		;0104 end of initialized data
	scf			;0107
	sbc hl,de		;0108
	ld c,l			;010a
	ld b,h			;010b
	dec bc			;010c
	ld l,e			;010d
	ld h,d			;010e
	inc de			;010f
	ld (hl),000h		;0110
	ldir			;0112 clear memory
	ld hl,data		;0114
	push hl			;0117
	ld hl,00080h		;0118
	ld c,(hl)		;011b
	inc hl			;011c
	ld b,000h		;011d
	add hl,bc		;011f
	ld (hl),000h		;0120 zero terminate it
	ld hl,00081h		;0122
	push hl			;0125
	call startup		;0126
	pop bc			;0129 unjunk stack
	pop bc			;012a
	push hl			;012b
	ld hl,(__argc_)		;012c
	push hl			;012f
	call main		;0130
	push hl			;0133
	call exit		;0134
	jp 00000h		;0137
;==========================================================================
; 1	main
;==========================================================================
main:
	call csv		;013a	main(int argc, char **argv) {
	push bc			;013d	    char **l1;
	ld de,00001h		;013e
	ld l,(ix+006h)		;0141
	ld h,(ix+007h)	;argc	;0144
	or a			;0147
	sbc hl,de	;hl-de	;0148
	jr nz,l0167h		;014a	    if(argc != 1) goto m1;
	ld de,msg_l_obj		;014c
	ld l,(ix+008h)		;014f
	ld h,(ix+009h)	;argv2	;0152
	inc hl			;0155
	inc hl			;0156
	ld (hl),e		;0157
	inc hl			;0158
	ld (hl),d		;0159	    *(++argv) = "l.obj"
	ld l,(ix+006h)		;015a
	ld h,(ix+007h)	;argc	;015d
	inc hl			;0160
	ld (ix+006h),l		;0161
	ld (ix+007h),h	;argc	;0164	    ++argc;
l0167h:				;	m1:
	ld l,(ix+008h)		;0167
	ld h,(ix+009h)	;argv	;016a
	inc hl			;016d
	inc hl			;016e
	ld (ix-002h),l		;016f
	ld (ix-001h),h	;l1	;0172	    l1 = ++argv
	jr l01c0h		;0175	    goto m4;
l0177h:				;	m2:
	ld (l2905h),hl		;0177	    l2905h = 0;
	ld hl,l2751h	;stdin	;017a
	push hl		;\3	;017d
	ld hl,msg_rb		;017e
	push hl		;\2	;0181
	ld l,(ix-002h)		;0182
	ld h,(ix-001h)	;l1	;0185
	ld c,(hl)		;0188
	inc hl			;0189
	ld b,(hl)		;018a
	ld (__Hdata),bc	;\1	;018b	    name = *l1;
	push bc			;018f
	call _freopen		;0190
	pop bc			;0193
	pop bc			;0194
	pop bc			;0195
	ld a,l			;0196
	or h			;0197
	jr nz,l01a2h		;0198	    if(freopen(name, "rb", stdin) != 0) goto m3;
	ld hl,msg_cannot_open	;019a
	push hl			;019d	    error("cannot open");
	call error		;019e
	pop bc			;01a1
l01a2h:				;	m3:
	ld hl,(__Hdata)		;01a2
	push hl			;01a5
	ld hl,l259fh		;01a6
	push hl			;01a9
	call printf		;01aa	    printf("%s\n", name);
	pop bc			;01ad
	pop bc			;01ae
	call sub_01e4h		;01af	    sub_01e4h();
	ld l,(ix-002h)		;01b2
	ld h,(ix-001h)	;l1	;01b5
	inc hl			;01b8
	inc hl			;01b9
	ld (ix-002h),l		;01ba
	ld (ix-001h),h	;l1	;01bd	    ++l1;
l01c0h:				;	m4:
	ld e,(ix+008h)		;01c0
	ld d,(ix+009h)	;argv	;01c3
	ld l,(ix+006h)		;01c6
	ld h,(ix+007h)	;argc	;01c9
	add hl,hl		;01cc
	add hl,de		;01cd
	ex de,hl		;01ce
	ld l,(ix-002h)		;01cf
	ld h,(ix-001h)	;l1	;01d2
	or a			;01d5
	sbc hl,de		;01d6
	ld hl,00000h		;01d8
	jr c,l0177h		;01db	    if(l1 < argv[argc]) goto m2;
	push hl			;01dd	    exit(0);
	call exit		;01de	}
	jp cret			;01e1
;--------------------------------------------------------------------------
; 2	sub_01e4h
;--------------------------------------------------------------------------
sub_01e4h:				;sub_01e4h() {
	call csv		;01e4	;    register struct aaa * st;
l01e7h:				;	;m1:
	call sub_0226h		;01e7	;
	ld a,l			;01ea	;
	or a			;01eb	;
	jp z,cret		;01ec	;    if(sub_0226h() == 0) return;
	ld de,struct_24aa	;01ef	;
	ld a,(l2907h)		;01f2	;
	ld l,a			;01f5	;
	ld h,000h ;hl=(uchar)	;01f6	;
	add hl,hl		;01f8	;
	add hl,hl		;01f9	;
	add hl,de		;01fa	;
	push hl			;01fb	;
	pop iy			;01fc	;st = &struct_24aa[(uchar)l2907h]
	ld l,(iy+000h)		;01fe	;
	ld h,(iy+001h)		;0201	;
	push hl			;0204	;
	ld hl,(l2905h)		;0205	;
	push hl			;0208	;
	ld hl,l25a3h		;0209	;
	push hl			;020c	;
	call printf		;020d	;    printf("\t%d\t%s\n", l2905h, st->name);
	pop bc			;0210	;
	pop bc			;0211	;
	pop bc			;0212	;
	ld l,(iy+002h)		;0213	;
	ld h,(iy+003h)		;0216	;
	call indir		;0219	;    (*st->fun_ptr)();
	ld a,(l2907h)		;021c	;
	cp 006h			;021f	;
	jr nz,l01e7h		;0221	;    if(l2907h != 6) goto m1;
	jp cret			;0223	;}
;--------------------------------------------------------------------------
; 3	sub_0226h
;--------------------------------------------------------------------------
sub_0226h:			;	;sub_0226h() {
	call	csv		;0226	;
	ld	hl,l2751h ;stdin;0229	;
	push	hl		;022c	;
	ld	hl,3		;022d	;
	push	hl		;0230	;
	ld	hl,1		;0231	;
	push	hl		;0234	;
	ld	hl,l290ah	;0235	;
	push	hl		;0238	;
	call	_fread		;0239	;
	pop	bc		;023c	;
	pop	bc		;023d	;
	pop	bc		;023e	;
	pop	bc		;023f	;
	ld	de,00003h	;0240	;
	or	a		;0243	;
	sbc	hl,de		;0244	;
	jr	z,l024eh	;0246	;    if(fread(l290ah, 1, 3, stdin) == 3) goto m1;
	ld	hl,00000h	;0248	;
	jp	cret		;024b	;    return (0);
l024eh:				;	;m1:
	ld	hl,(l2905h)	;024e	;
	inc	hl		;0251	;
	ld	(l2905h),hl	;0252	;    ++l2905h;
	ld	b,8		;0255	;
	ld	hl,l290bh	;0257	;
	ld	l,(hl)		;025a	;
	ld	h,0		;025b	;
	call	shll		;025d	;
	ex	de,hl		;0260	;
	ld	a,(l290ah)	;0261	;
	ld	l,a		;0264	;
	ld	h,0		;0265	;
	add	hl,de		;0267	;
	ld	(l2908h),hl	;0268	;    l2908h = (uint)l290ah[0] + (uint)l290ah[1] << 8;
	ld	hl,l290ch	;026b	;
	ld	a,(hl)		;026e	;
	ld	(l2907h),a	;026f	;    l2907h = l290ah[2];
	or	a		;0272	;
	jr	z,l0280h	;0273	;    if(l2907h == 0) goto m2;
	ld	e,a		;0275	;
	ld	d,0		;0276	;
	ld	hl,00009h	;0278	;
	or	a		;027b	;
	sbc	hl,de		;027c	;
	jr	nc,l028dh	;027e	;    if(l2907h >= 9) goto m3;
l0280h:				;	;m2:
	ld	l,a		;0280	;
	ld	h,0		;0281	;
	push	hl		;0283	;
	ld	hl,msg_u_r_type	;0284	;
	push	hl		;0287	;
	call	error		;0288	;    error("unknown record type: %d", l2907h);
	pop	bc		;028b	;
	pop	bc		;028c	;
l028dh:				;	;m3:
	ld	de,(l2908h)	;028d	;
	ld	hl,00200h	;0291	;
	or	a		;0294	;
	sbc	hl,de		;0295	;
	jp	p,l02bdh	;0297	;    if(0x200 >= l2908h) goto m4;
	ld	l,e		;029a
	ld	h,d		;029b	; /* hl = l2908h */
	push	hl	;\	;029c
	ld	de,struct_24aa	;029d	; /* de = struct_24aa */
	ld	a,(l2907h)	;02a0
	ld	l,a		;02a3
	ld	h,0		;02a4	; /* hl = (uint)l2907h */
	add	hl,hl		;02a6
	add	hl,hl		;02a7
	add	hl,de		;02a8	; /* hl = struct_24aa */
	ex	de,hl		;02a9	; /* de = struct_24aa[(uint)l2907h] */
	push	bc	;\	;02aa
	push	bc	;\	;02ab
	ex	de,hl		;02ac
	ld	bc,4		;02ad
	ldir			;02b0	; struct_24aa[(uint)l2907h] = struct_24aa;
	ld	hl,msg_r_t_l	;02b2
	push	hl		;02b5
	call	error		;02b6	;    error("%s record too long: %d");
	pop	bc		;02b9	;
	pop	bc		;02ba	;
	pop	bc		;02bb	;
	pop	bc		;02bc	;
l02bdh:				;	;m4:
	ld	hl,l2751h ;stdin;02bd	;
	push	hl		;02c0	;
	ld	hl,(l2908h)	;02c1	;
	push	hl		;02c4	;
	ld	hl,1		;02c5	;
	push	hl		;02c8	;
	ld	hl,l290ah	;02c9	;
	push	hl		;02cc	;
	call	_fread		;02cd	;
	pop	bc		;02d0	;
	pop	bc		;02d1	;
	pop	bc		;02d2	;
	pop	bc		;02d3	;
	ld	de,(l2908h)	;02d4	;
	or	a		;02d8	;
	sbc	hl,de		;02d9	;
	jr	z,l02f1h	;02db	;    if(fread(l290ah, 1, l2908h, stdin) == l2908h) goto m5;
	ld	l,e		;02dd	;
	ld	h,d		;02de	;
	push	hl	   ;\3	;02df	;
	ld	a,(l2907h)	;02e0	;
	ld	l,a		;02e3	;
	ld	h,0		;02e4	;
	push	hl	   ;\2	;02e6	;
	ld	hl,msg_i_r	;02e7	;
	push	hl	   ;\1	;02ea	;
	call	error		;02eb	;    error("incomplete record: type = %d, length = %d",(uchar)l2907h, l2908h);
	pop	bc		;02ee	;
	pop	bc		;02ef	;
	pop	bc		;02f0	;
l02f1h:				;	;m5:
	ld	hl,00001h	;02f1	;return (1)
	jp	cret		;02f4	;}
;--------------------------------------------------------------------------
; 4	cod_TEXT
;--------------------------------------------------------------------------
cod_TEXT:				;void cod_TEXT() {
					;    long  l1;	/* ix-001h ix-002h ix-003h ix-004h */
					;    int   l3;	/* ix-005h ix-006h */
	call csv		;02f7	;    char  l4;	/* ix-007h	   */
	ld hl,0fff5h	;-11	;02fa	;    char *l5;	/* ix-008h ix-009h */
	add hl,sp		;02fd	;    char *l6;	/* ix-00ah ix-00bh */
	ld sp,hl		;02fe	;
	ld hl,l290ah		;02ff	;
	push hl			;0302	;
	call sub_088eh		;0303	;
	pop bc			;0306	;	
	ld (ix-004h),e		;0307	;
	ld (ix-003h),d		;030a	;	
	ld (ix-002h),l		;030d	;	
	ld (ix-001h),h	;l1	;0310	;    l1 = sub_088eh(l290ah);
	ld hl,l290eh		;0313	;	
	ld (ix-00bh),l		;0316	;	
	ld (ix-00ah),h		;0319	;
	ld (ix-009h),l		;031c	;
	ld (ix-008h),h		;031f	;    l5 = l6 = l290eh;
	jr l0331h		;0322	;    goto m2;
l0324h:				;	;m1:
	ld l,(ix-009h)	;l5	;0324	;
	ld h,(ix-008h)		;0327	;
	inc hl			;032a	;
	ld (ix-009h),l		;032b	;
	ld (ix-008h),h	;l5	;032e	;    ++l5;
l0331h:				;	;m2:
	ld l,(ix-009h)		;0331	;
	ld h,(ix-008h)	;l5	;0334	;
	ld a,(hl)		;0337	;
	or a			;0338	;
	jr nz,l0324h		;0339	;    if(*l5 != 0) goto m1;
	inc hl			;033b	;    l5++;
	ld (ix-009h),l		;033c	;
	ld (ix-008h),h	;l5	;033f	;
	ld l,(ix-00bh)		;0342	;
	ld h,(ix-00ah)	;l6	;0345	;
	push hl			;0348	;
	call _strlen		;0349	;
	pop bc			;034c	;
	ex de,hl		;034d	;
	ld hl,00005h		;034e	;
	add hl,de		;0351	;
	ex de,hl		;0352	;
	ld hl,(l2908h)		;0353	;
	or a			;0356	;
	sbc hl,de		;0357	;
	ld (ix-006h),l		;0359	;
	ld (ix-005h),h	;l3	;035c	;    l3 = l2908h + 5 + strlen(l6)
	bit 7,(ix-005h)		;035f	;
	push hl			;0363	;
	jr z,l0375h		;0364	;    if(bittst(l3, 7) == 0) goto m3;
	ld hl,msg_t_r_l_s	;0366	;
	push hl			;0369	;
	call error		;036a	;    error("text record has length too small: %d", l3);
	pop bc			;036d	;
	ld l,(ix-006h)		;036e	;
	ld h,(ix-005h)	;l3	;0371	;
	ex (sp),hl	;\	;0374	;
l0375h:				;	;m3:
	ld e,(ix-004h)		;0375	;
	ld d,(ix-003h)		;0378	;
	ld l,(ix-002h)		;037b	;
	ld h,(ix-001h)	;l1	;037e	;
	push hl			;0381	;
	push de			;0382	;
	ld l,(ix-00bh)		;0383	;
	ld h,(ix-00ah)	;l6	;0386	;
	push hl			;0389	;
	ld hl,l2629h		;038a	;
	push hl			;038d	;
	call printf		;038e	;    printf("\t\t%s\t%D\t%d\n", l6, l1, l3;
	ld hl,0000ah		;0391	;
	add hl,sp		;0394	;
	ld sp,hl		;0395	;
	jr l03edh		;0396	;    goto m8;
l0398h:				;	;m4:
	ld hl,l2635h		;0398	;
	push hl			;039b	;
	call printf		;039c	;    printf("\t\t");
	pop bc			;039f	;
	ld (ix-007h),015h	;03a0	;    l4 = 0x15;
	jr l03d2h		;03a4	;    goto m6;
l03a6h:				;	;m5:
	ld l,(ix-009h)		;03a6	;
	ld h,(ix-008h)	;l5	;03a9	;
	inc hl			;03ac	;
	ld (ix-009h),l		;03ad	;
	ld (ix-008h),h	;l5	;03b0	;
	dec hl			;03b3	;
	ld l,(hl)		;03b4	;
	ld h,000h		;03b5	;
	push hl			;03b7	;
	ld hl,l2638h		;03b8	;
	push hl			;03bb	;
	call printf		;03bc	;    printf("%02x ", *l5++);
	pop bc			;03bf	;
	pop bc			;03c0	;
	dec (ix-007h)		;03c1	;    --l4;
	ld l,(ix-006h)		;03c4	;
	ld h,(ix-005h)		;03c7	;
	dec hl			;03ca	;
	ld (ix-006h),l		;03cb	;
	ld (ix-005h),h		;03ce	;    l3--;
	inc hl			;03d1	;
l03d2h:				;	;m6:
	ld a,(ix-007h)	;l4	;03d2	;
	or a			;03d5	;
	jr z,l03e0h		;03d6	;    if(l4 == 0) goto m7;
	ld a,(ix-006h)		;03d8	;
	or (ix-005h)	;l3	;03db	;
	jr nz,l03a6h		;03de	;    if(l3 != 0) goto m5;
l03e0h:				;	;m7:
	ld hl,l2759h	;stdout	;03e0	;
	push hl			;03e3	;
	ld hl,0000ah		;03e4	;
	push hl			;03e7	;
	call _fputc		;03e8	;    fputc('\n', stdout);
	pop bc			;03eb	;
	pop bc			;03ec	;
l03edh:				;	;m8:
	ld a,(ix-006h)		;03ed	;
	or (ix-005h)	;l3	;03f0	;
	jr nz,l0398h		;03f3	;    if(l3 != 0) goto m4;
	jp cret			;03f5	;}
;--------------------------------------------------------------------------
; 5	cod_PSECT
;--------------------------------------------------------------------------
cod_PSECT:				;void  cod_PSECT() {
	call csv		;03f8	;
	push bc			;03fb	;
	dec sp			;03fc	;
	ld hl,l290ch		;03fd	;
	ld a,(hl)		;0400	;
	or a			;0401	;
	jr nz,l0409h		;0402	;    if(*l290ch != 0) goto m1;
	ld hl,msg_abs_0		;0404	;    HL = "(abs)"
	jr l040ch		;0407	;    goto m2;
l0409h:				;	;m1:
	ld hl,l290ch		;0409	;    HL = &l290ah[2]
l040ch:				;	;m2:
	push hl			;040c	;
	ld hl,l263eh		;040d	;
	push hl			;0410	;
	call printf		;0411	;    printf("\t\t%s", HL);
	pop bc			;0414	;
	ld hl,l290ah		;0415	;
	ex (sp),hl		;0418	;
	call sub_0860h		;0419	;
	pop bc			;041c	;
	srl h			;041d	;
	rr l			;041f	;
	srl h			;0421	;
	rr l			;0423	;
	srl h			;0425	;
	rr l			;0427	;
	srl h			;0429	;
	rr l			;042b	;
	ld (ix-002h),l		;042d	;
	ld (ix-001h),h	;l1	;0430	;    l1 = sub_0860h(l290ah) >> 4;
	ld (ix-003h),0 	;l2	;0433	;    l2 = 0;
	jr l047ch		;0437	;    goto m6;
l0439h:				;	;m3:
	bit 0,(ix-002h)	;l1	;0439	;
	jr z,l046fh		;043d	;    if(bittst(l1,0) == 0) goto m5;
	ld a,(ix-003h)	;l2	;043f	;
	cp 4			;0442	;
	jr c,l0458h		;0444	;    if(l2 < ARRAY_SIZE(l24ceh)) goto m4;
	ld l,a			;0446	;
	ld b,l			;0447	;
	ld hl,1			;0448	;
	call shll		;044b	;
	push hl			;044e	;
	ld hl,msg_u_p_f		;044f	;
	push hl			;0452	;
	call error		;0453	;    error("unknown psect flag: 0X%x", 1 << l2);
	pop bc			;0456	;
	pop bc			;0457	;
l0458h:				;	;m4:
	ld de,l24ceh		;0458	;
	ld l,(ix-003h) 	;l2	;045b	;
	ld h,0			;045e	;
	add hl,hl		;0460	;
	add hl,de		;0461	;
	ld c,(hl)		;0462	;
	inc hl			;0463	;
	ld b,(hl)		;0464	;
	push bc			;0465	;
	ld hl,l2662h		;0466	;
	push hl			;0469	;
	call printf		;046a	;    printf("\t%s", l24ceh[l2]);
	pop bc			;046d	;
	pop bc			;046e	;
l046fh:				;	;m5:
	ld b,1			;046f	;
	push ix			;0471	;
	pop hl			;0473	;
	dec hl			;0474	;
	dec hl			;0475	;
	call sub_20d6h		;0476	;    l1 <<= 1;
	inc (ix-003h) 	;l2	;0479	;    l2++;
l047ch:				;	;m6:
	ld a,(ix-002h)		;047c	;
	or (ix-001h)	;l1	;047f	;
	jr nz,l0439h		;0482	;    if(l1 != 0) goto m3;
	ld hl,l2759h		;0484	;
	push hl			;0487	;
	ld hl,0000ah		;0488	;
	push hl			;048b	;
	call _fputc		;048c	;    fputc('\n', stdout);
	jp cret			;048f	;}
;--------------------------------------------------------------------------
; 6	cod_RELOC
;--------------------------------------------------------------------------
cod_RELOC:				;void  cod_RELOC() {
	call csv		;0492	;    uchar   l1;
	push bc			;0495	;    uchar * l2;
	dec sp			;0496	;
	ld hl,l290ah		;0497	;
	ld (ix-003h),l		;049a	;
	ld (ix-002h),h	;l2	;049d	;    l2 = l290ah;
	jp l0537h		;04a0	;    goto m3;
l04a3h:				;	;m1:
	ld l,(ix-003h)		;04a3	;
	ld h,(ix-002h)	;l2	;04a6	;
	inc hl			;04a9	;
	inc hl			;04aa	;
	ld a,(hl)		;04ab	;
	ld l,a			;04ac	;
	rla			;04ad	;
	ld a,l			;04ae	;
	and 0f0h		;04af	;
	ld l,a			;04b1	;
	xor a			;04b2	;
	ld h,a			;04b3	;
	sra h			;04b4	;
	rr l			;04b6	;
	sra h			;04b8	;
	rr l			;04ba	;
	sra h			;04bc	;
	rr l			;04be	;
	sra h			;04c0	;
	rr l			;04c2	;
	ld (ix-001h),l	;l1	;04c4	; l1 = (*(l2+2) & 0xF0) >> 4;
	ld a,l			;04c7	;
	cp 007h			;04c8	;
	jr c,l04d8h		;04ca	;    if(l1 < 7) goto m2;
	ld h,000h		;04cc	;
	push hl			;04ce	;
	ld hl,msg_unkn_reln_typ	;04cf	;
	push hl			;04d2	;
	call error		;04d3	;    error("unknown relocation type: 0X%x0", l1);
	pop bc			;04d6	;
	pop bc			;04d7	;
l04d8h:				;	;m2:
	ld l,(ix-003h)		;04d8	;
	ld h,(ix-002h)	;l2	;04db	;
	inc hl			;04de	;
	inc hl			;04df	;
	ld a,(hl)		;04e0	;
	and 00fh		;04e1	;
	ld l,a			;04e3	;
	rla			;04e4	;
	sbc a,a			;04e5	;
	ld h,a			;04e6	;
	push hl		;\5	;04e7	;
	ld l,(ix-003h)		;04e8	;
	ld h,(ix-002h)	;l2	;04eb	;
	inc hl			;04ee	;
	inc hl			;04ef	;
	inc hl			;04f0	;
	push hl		;\4	;04f1	;
	ld de,l24d6h		;04f2	;
	ld l,(ix-001h)	;l1	;04f5	;
	ld h,0			;04f8	;
	add hl,hl		;04fa	;
	add hl,de		;04fb	;
	ld c,(hl)		;04fc	;
	inc hl			;04fd	;
	ld b,(hl)		;04fe	;
	push bc		;\3	;04ff	;
	ld l,(ix-003h)		;0500	;
	ld h,(ix-002h)	;l2	;0503	;
	push hl			;0506	;
	call sub_0860h		;0507	;
	ex (sp),hl	;\2	;050a	;
	ld hl,l2685h		;050b	;
	push hl		;\1	;050e	;
	call printf		;050f	;    printf("\t\t%d\t%s\t%s\t%d\n", sub_0860h(l2), l24d6h[l1], l2+3, *(l2+2) & 0xF0);
	ld hl,0000ah		;0512	;
	add hl,sp		;0515	;
	ld sp,hl		;0516	;
	ld l,(ix-003h)		;0517	;
	ld h,(ix-002h)	;l2	;051a	;
	inc hl			;051d	;
	inc hl			;051e	;
	inc hl			;051f	;
	push hl			;0520	;
	call _strlen		;0521	;
	pop bc			;0524	;
	ex de,hl;de=strlen(l2+3);0525	;
	inc de			;0526	;
	inc de			;0527	;
	inc de			;0528	;
	inc de			;0529	;
	ld l,(ix-003h)		;052a	;
	ld h,(ix-002h)	;l2	;052d	;
	add hl,de		;0530	;
	ld (ix-003h),l		;0531	;
	ld (ix-002h),h	;l2	;0534	;    l2 = l2 + strlen(l2+3) + 4;
l0537h:				;	;m3:
	ld de,(l2908h)		;0537	;
	ld hl,l290ah		;053b	;
	add hl,de		;053e	;
	ex de,hl		;053f	;
	ld l,(ix-003h)		;0540	;
	ld h,(ix-002h)	;l2	;0543	;
	or a			;0546	;
	sbc hl,de		;0547	;
	jp c,l04a3h		;0549	;    if(l2 < l290ah[l2908h]) goto m1;
	jp cret			;054c	;}
;--------------------------------------------------------------------------
; 7	cod_SYM
;--------------------------------------------------------------------------
cod_SYM:				;void cod_SYM() {
	call csv		;054f	;    char *l1;
	push bc			;0552	;    char *l2;
	push bc			;0553	;    char *l3;
	push bc			;0554	;    int   l4;
	push bc			;0555	;
	ld hl,l290ah		;0556	;
	ld (ix-002h),l		;0559	;
	ld (ix-001h),h	;l1	;055c	;    l1 = l290ah;
	jp l0668h		;055f	;    goto m9;
l0562h:				;	;m1:
	ld e,(ix-002h)		;0562	;
	ld d,(ix-001h)	;l1	;0565	;
	ld hl,6			;0568	;
	add hl,de		;056b	;
	ld (ix-004h),l		;056c	;
	ld (ix-003h),h	;l2	;056f	;
	ld (ix-006h),l		;0572	;
	ld (ix-005h),h	;l3	;0575	;    l3 = (l2 = l1 + 6);
	jr l0587h		;0578	;    goto m3;
l057ah:				;	;m2:
	ld l,(ix-006h)		;057a	;
	ld h,(ix-005h)	;l3	;057d	;
	inc hl			;0580	;
	ld (ix-006h),l		;0581	;
	ld (ix-005h),h	;l3	;0584	;    ++l3;
l0587h:				;	;m3:
	ld l,(ix-006h)		;0587	;
	ld h,(ix-005h)	;l3	;058a	;
	ld a,(hl)		;058d	;
	or a			;058e	;
	jr nz,l057ah		;058f	;    if(*l3 != 0) goto m2;
	inc hl			;0591	;    l3++;
	ld (ix-006h),l		;0592	;
	ld (ix-005h),h	;l3	;0595	;
	ld l,(ix-002h)		;0598	;
	ld h,(ix-001h)	;l1	;059b	;
	inc hl			;059e	;
	inc hl			;059f	;
	inc hl			;05a0	;
	inc hl			;05a1	;
	push hl			;05a2	;
	call sub_0860h		;05a3	;
	ld (ix-008h),l		;05a6	;
	ld (ix-007h),h	;l4	;05a9	;    l4 = sub_0860h(l1+4)
	ld l,(ix-002h)		;05ac	;
	ld h,(ix-001h)	;l1	;05af	;
	ex (sp),hl		;05b2	;
	call sub_088eh		;05b3	;
	pop bc			;05b6	;
	push hl		;\	;05b7	;	
	push de		;\3	;05b8	;	
	ld l,(ix-004h)		;05b9	;
	ld h,(ix-003h)	;l2	;05bc	;
	ld a,(hl)		;05bf	;
	or a			;05c0	;
	jr nz,l05d9h		;05c1	;    if(*l2 != 0) goto m5;
	ld a,(ix-008h)	;l4	;05c3	;
	and 6			;05c6	;
	ld l,a			;05c8	;
	xor a			;05c9	;
	ld h,a			;05ca	;
	ld a,l			;05cb	;
	or h			;05cc	;
	jr nz,l05d4h		;05cd	;    if(((uchar)l4&6) != 0) goto m4;
	ld hl,msg_abs_1		;05cf	;    /* HL = "(abs)"; */
	jr l05dfh		;05d2	;    goto m6;
l05d4h:				;	;m4:
	ld hl,l269fh		;05d4	;    /* HL = ""; */
	jr l05dfh		;05d7	;    goto m6;
l05d9h:				;	;m5:
	ld l,(ix-004h)		;05d9	;
	ld h,(ix-003h)	;l2	;05dc	;    /* HL = l2; */
l05dfh:				;	;m6:
	push hl		;\2	;05df	;
	ld l,(ix-006h)		;05e0	;
	ld h,(ix-005h)	;l3	;05e3	;
	push hl			;05e6	;
	ld hl,l2694h	;\1	;05e7	;
	push hl			;05ea	;
	call printf		;05eb	;    printf("\t\t%s\t%s\t%D", HL, sub_088eh(l1));
	ld hl,0ah		;05ee	;
	add hl,sp		;05f1	;
	ld sp,hl		;05f2	;
	bit 4,(ix-008h)	;l4	;05f3	;
	jr z,l0601h		;05f7	;    if(bittst(l4,4) == 0) goto m7;
	ld hl,l26a6h		;05f9	;
	push hl			;05fc	;
	call printf		;05fd	;    printf("\tGLOBAL");
	pop bc			;0600	;
l0601h:				;	;m7:
	ld de,7			;0601	;
	ld a,(ix-008h)	;l4	;0604	;
	and 00fh		;0607	;
	ld l,a			;0609	;
	xor a			;060a	;
	ld h,a			;060b	;
	ld (ix-008h),l		;060c	;
	ld (ix-007h),h	;l4	;060f	;
	or a			;0612	;
	sbc hl,de		;0613	;
	jr c,l0627h		;0615	;    if((l4 = (l4 & 0xF)) < 7) goto m8;
	ld l,(ix-008h)		;0617	;
	ld h,(ix-007h)	;l4	;061a	;
	push hl			;061d	;
	ld hl,msg_u_s_t		;061e	;
	push hl			;0621	;
	call error		;0622	;    error("unknown symbol type %d", l4);
	pop bc			;0625	;
	pop bc			;0626	;
l0627h:				;	;m8:
	ld de,l24e4h		;0627	;
	ld l,(ix-008h)		;062a	;
	ld h,(ix-007h)	;l4	;062d	;
	add hl,hl		;0630	;
	add hl,de		;0631	;
	ld c,(hl)		;0632	;
	inc hl			;0633	;
	ld b,(hl)		;0634	;
	push bc			;0635	;
	ld hl,l26c5h		;0636	;
	push hl			;0639	;
	call printf		;063a	;    printf("\t%s\n", l24e4h[l4]);
	pop bc			;063d	;
	ld l,(ix-006h)		;063e	;
	ld h,(ix-005h)	;l3	;0641	;
	ex (sp),hl		;0644	;
	call _strlen		;0645	;
	ex (sp),hl	;\	;0648	;
	ld l,(ix-004h)		;0649	;
	ld h,(ix-003h)	;l2	;064c	;
	push hl			;064f	;
	call _strlen		;0650	;
	pop bc			;0653	;
	pop de		;/	;0654	;
	add hl,de		;0655	;
	ld de,8			;0656	;
	add hl,de		;0659	;
	ex de,hl		;065a	;
	ld l,(ix-002h)		;065b	;
	ld h,(ix-001h)	;l1	;065e	;
	add hl,de		;0661	;
	ld (ix-002h),l		;0662	;
	ld (ix-001h),h	;l1	;0665	;    l1 += strlen(l2) + strlen(l3) + 8
l0668h:				;	;m9:
	ld de,(l2908h)		;0668	;
	ld hl,l290ah		;066c	;
	add hl,de		;066f	;
	ex de,hl		;0670	;
	ld l,(ix-002h)		;0671	;
	ld h,(ix-001h)	;l1	;0674	;
	or a			;0677	;
	sbc hl,de		;0678	;
	jp c,l0562h		;067a	;    if(l1 < l290ah[l2908h]) goto m1;
	jp cret			;067d	:}
;--------------------------------------------------------------------------
; 8	cod_START ok++
;--------------------------------------------------------------------------
cod_START:				;cod_START() {
	call csv		;0680	;
	ld hl,l290ah		;0683	;/*
	push hl			;0686	;
	call sub_088eh		;0687	;    sub_088eh(l290ah) ;
	pop bc			;068a	;
	push hl		;	;068b	;
	push de		;\3	;068c	;
	ld hl,l290eh		;068d	;
	ld a,(hl)		;0690	;    l290ah[4] != 0 ? l290ah+4 : "(abs)" ;
	or a			;0691	;
	jr nz,l0699h		;0692	;    if(l290ah[4] != 0) goto m2;
	ld hl,msg_abs_2		;0694	;    HL = "(abs)" ;
	jr l069ch		;0697	;    goto m2;
l0699h:				;	;m1:
	ld hl,l290eh		;0699	;    HL = l290ah+4 ;
l069ch:				;	;m2:
	push hl		;\2	;069c	;
	ld hl,l26cah		;069d	;
	push hl		;\1	;06a0	;            1   2   3    =  2'                                   3'      */
	call printf		;06a1	;    printf("\t\t%s\t%lu\n", l290ah[4] != 0 ? l290ah+4 : "(abs)", sub_088eh(l290ah));
	jp cret			;06a4	;}
;--------------------------------------------------------------------------
; 9	cod_END ok+
;--------------------------------------------------------------------------
cod_END:				;cod_END() {
	call csv		;06a7	;
	ld hl,l2759h		;06aa	;
	push hl			;06ad	;
	ld hl,0000ah		;06ae	;
	push hl			;06b1	;    fputc('\n', stdin);
	call _fputc		;06b2	;
	jp cret			;06b5	;}
;--------------------------------------------------------------------------
; 10	cod_IDENT ok++
;--------------------------------------------------------------------------
cod_IDENT:				;void  cod_IDENT() {
	call csv		;06b8	;char l1;
	dec sp			;06bb	;
	ld hl,l2910h		;06bc	;
	push hl			;06bf	;
	ld hl,msg_Machine	;06c0	;
	push hl			;06c3	;
	call printf		;06c4	;    printf("\t\tMachine\t\t= %s\n", &l290ah[6]);
	pop bc			;06c7	;
	ld hl,l290dh ;l290ah[3]	;06c8	;
	ld a,(hl)		;06cb	;
	ld l,a			;06cc	;
	rla			;06cd	;
	sbc a,a			;06ce	;
	ld h,a			;06cf	;
	ex (sp),hl	;\5	;06d0	;
	ld hl,l290ch ;l290ah[2]	;06d1	;
	ld a,(hl)		;06d4	;
	ld l,a			;06d5	;
	rla			;06d6	;
	sbc a,a			;06d7	;
	ld h,a			;06d8	;
	push hl		;\4	;06d9	;
	ld hl,l290bh ;l290ah[1]	;06da	;
	ld a,(hl)		;06dd	;
	ld l,a			;06de	;
	rla			;06df	;
	sbc a,a			;06e0	;
	ld h,a			;06e1	;
	push hl		;\3	;06e2	;
	ld a,(l290ah) ;l290ah[0];06e3	;
	ld l,a			;06e6	;
	rla			;06e7	;
	sbc a,a			;06e8	;
	ld h,a			;06e9	;
	push hl		;\2	;06ea	;
	ld hl,msg_32_bit_order	;06eb	;
	push hl		;\1	;06ee 	;
	call printf		;06ef	;    printf("\t\t32 bit order\t= %d %d %d %d\n", l290ah[0], l290ah[1], l290ah[2], l290ah[3]);
	ld hl,0000ah		;06f2	;
	add hl,sp		;06f5	;
	ld sp,hl		;06f6	;
	ld (ix-001h),000h ;l1	;06f7	;    l1 = 0;
	jr l070fh		;06fb	;    goto m2;
l06fdh:				;	;m1:
	ld e,(ix-001h)	;l1	;06fd	;
	ld d,000h		;0700	;
	ld hl,l290ah		;0702	;
	add hl,de		;0705	;
	ld a,(hl)		;0706	;
	ld hl,l24a4h		;0707	;
	add hl,de		;070a	;
	ld (hl),a		;070b	;    l24a4h[l1] = l290ah[l1];
	inc (ix-001h)	;l1	;070c	;    ++l1;
l070fh:				;	;m2:
	ld a,(ix-001h)	;l1	;070f	;
	cp 4			;0712	;
	jr c,l06fdh		;0714	;    if(l1 < 4) goto m1;
	ld hl,l290fh ;l290ah[5]	;0716	;
	ld a,(hl)		;0719	;
	ld l,a			;071a	;
	rla			;071b	;
	sbc a,a			;071c	;
	ld h,a			;071d	;
	push hl		;\3	;071e	;
	ld hl,l290eh ;l290ah[4]	;071f	;
	ld a,(hl)		;0722	;
	ld l,a			;0723	;
	rla			;0724	;
	sbc a,a			;0725	;
	ld h,a			;0726	;
	push hl		;\2	;0727	;
	ld hl,msg_16_bit_order	;0728	;
	push hl		;\1	;072b	;
	call printf		;072c	;    printf("\t\t16 bit order\t= %d %d\n", l290ah[5], l290ah[4]);
	ld hl,l290eh		;072f	;
	ld a,(hl)		;0732	;
	ld (l24a8h),a		;0733	;    l24a8h = l290ah[4];
	ld hl,l290fh		;0736	;
	ld a,(hl)		;0739	;
	ld hl,l24a9h		;073a	;
	ld (hl),a		;073d	;    l24a9h = l290ah[5];
	jp cret			;073e	;}
;--------------------------------------------------------------------------
; 11	cod_XPSECT
;--------------------------------------------------------------------------
cod_XPSECT:				;void  cod_XPSECT() {
	call csv		;0741	;
	ld hl,l2916h		;0744	;/* 
	ld a,(hl)		;0747	; (l290ah[12] != 0) ? "(abs)" : &l290ah[12]
	or a			;0748	;
	jr nz,l0750h		;0749	; if(l290ah[12] != 0) goto m1;
	ld hl,msg_abs_3		;074b	;    HL = "(abs)"
	jr l0753h		;074e	;    goto m2;
l0750h:				;	;m1:
	ld hl,l2916h		;0750	;    HL = &l290ah[12]
l0753h:				;	;m2:
	push hl			;0753	;*/
	ld hl,l2721h		;0754	;
	push hl			;0757	;
	call printf		;0758	;    printf("\t\t%s", (l290ah[12] != 0) ? "(abs)" : &l290ah[12];
	pop bc			;075b	;
	ld hl,l290ah		;075c	;
	ex (sp),hl		;075f	;
	call sub_088eh		;0760	;
	pop bc			;0763	;
	ld a,e			;0764	;
	or d			;0765	;
	or l			;0766	;
	or h			;0767	;
	jr z,l077dh		;0768	;    if(sub_088eh(l290ah) == 0) goto m3;
	ld hl,l290ah		;076a	;
	push hl			;076d	;
	call sub_088eh		;076e	;
	ex (sp),hl		;0771	;
	push de			;0772	;
	ld hl,msg_size_		;0773	;
	push hl			;0776	;
	call printf		;0777	;    printf("\tsize=%lu", sub_088eh(l290ah));
	pop bc			;077a	;
	pop bc			;077b	;
	pop bc			;077c	;
l077dh:				;	;m3:
	ld hl,l290eh		;077d	;
	push hl			;0780	;
	call sub_0860h		;0781	;
	pop bc			;0784	;
	ld a,l			;0785	;
	or h			;0786	;
	jr z,l079ah		;0787	;    if(sub_0860h(l290ah[4]) == 0) goto m4;
	ld hl,l290eh		;0789	;
	push hl			;078c	;
	call sub_0860h		;078d	;
	ex (sp),hl		;0790	;
	ld hl,msg_reloc_	;0791	;
	push hl			;0794	;
	call printf		;0795	;    printf("\treloc=%u", (long)l290ah[4]);
	pop bc			;0798	;
	pop bc			;0799	;
l079ah:				;	;m4:
	ld hl,l2759h		;079a	;
	push hl			;079d	;
	ld hl,0000ah		;079e	;
	push hl			;07a1	;
	call _fputc		;07a2	;    fputc('\n', stdin);
	jp cret			;07a5	;}

;--------------------------------------------------------------------------
;   	sub_07a8h
;--------------------------------------------------------------------------
sub_07a8h:				;void sub_07a8h(p1, p2, p3, p4, p5) {
	call csv		;07a8	;
	ld hl,l2759h	;stdin	;07ab	;
	push hl			;07ae	;
	ld hl,0000ah		;07af	;
	push hl			;07b2	;
	call _fputc		;07b3	;    fputc('\n', stdin);
	pop bc			;07b6	;
	ld hl,l2759h		;07b7	;
	ex (sp),hl		;07ba	;
	call _fflush		;07bb	;    fflush(stdin);
	pop bc			;07be	;
	ld hl,(__Hdata)		;07bf	;
	ld a,l			;07c2	;
	or h			;07c3	;
	jr z,l07d5h		;07c4	;    if(__Hdata == 0) goto m1;
	push hl			;07c6	;
	ld hl,l2740h		;07c7	;
	push hl			;07ca	;
	ld hl,l2761h		;07cb	;
	push hl			;07ce	;
	call fprintf		;07cf	;    fprintf(stdout, "%s: ", __Hdata);
	pop bc			;07d2	;
	pop bc			;07d3	;
	pop bc			;07d4	;
l07d5h:				;	;m1:
	ld hl,(l2905h)		;07d5	;
	ld a,l			;07d8	;
	or h			;07d9	;
	jr z,l07ebh		;07da	;    if(l2905h == 0) goto m2;
	push hl			;07dc	;
	ld hl,l2745h		;07dd	;
	push hl			;07e0	;
	ld hl,l2761h		;07e1	;
	push hl			;07e4	;
	call fprintf		;07e5	;    fprintf(stdout, "%d: ", l2905h);
	pop bc			;07e8	;
	pop bc			;07e9	;
	pop bc			;07ea	;
l07ebh:				;	;m2:
	ld l,(ix+00eh)		;07eb	;
	ld h,(ix+00fh)		;07ee	;
	push hl			;07f1	;
	ld l,(ix+00ch)		;07f2	;
	ld h,(ix+00dh)		;07f5	;
	push hl			;07f8	;
	ld l,(ix+00ah)		;07f9	;
	ld h,(ix+00bh)		;07fc	;
	push hl			;07ff	;
	ld l,(ix+008h)		;0800	;
	ld h,(ix+009h)		;0803	;
	push hl			;0806	;
	ld l,(ix+006h)		;0807	;
	ld h,(ix+007h)		;080a	;
	push hl			;080d	;
	ld hl,l2761h		;080e	;
	push hl			;0811	;
	call fprintf		;0812	;    fprintf(stdout, p1, p2, p3, p4, p5);
	ld hl,0000ch		;0815	;
	add hl,sp		;0818	;
	ld sp,hl		;0819	;
	ld hl,l2761h		;081a	;
	push hl			;081d	;
	ld hl,0000ah		;081e	;
	push hl			;0821	;
	call _fputc		;0822	;    fputc('\n', stdout);
	jp cret			;0825	;}
;--------------------------------------------------------------------------
; 12	error:
;--------------------------------------------------------------------------
error:					;void error(p1, p2, p3, p4, p5) {
	call csv		;0828	;
	ld l,(ix+00eh)		;082b	;
	ld h,(ix+00fh)	;p5	;082e	;
	push hl			;0831	;
	ld l,(ix+00ch)		;0832	;
	ld h,(ix+00dh)	;p4	;0835	;
	push hl			;0838	;
	ld l,(ix+00ah)		;0839	;
	ld h,(ix+00bh)	;p3	;083c	;
	push hl			;083f	;
	ld l,(ix+008h)		;0840	;
	ld h,(ix+009h)	;p2	;0843	;
	push hl			;0846	;
	ld l,(ix+006h)		;0847	;
	ld h,(ix+007h)	;p1	;084a	;
	push hl			;084d	;
	call sub_07a8h		;084e	;    sub_07a8h(p1,p2, p3, p4, p5);
	ld hl,0000ah		;0851	;
	add hl,sp		;0854	;
	ld sp,hl		;0855	;
	ld hl,00001h		;0856	;
	push hl			;0859	;
	call exit		;085a	;    exit(1);
	jp cret			;085d	; }
;--------------------------------------------------------------------------
; 13	sub_0860h
;--------------------------------------------------------------------------
sub_0860h:				;sub_0860h(char *p1) {
	call csv		;0860
	ld e,(ix+006h)		;0863
	ld d,(ix+007h)	;p1	;0866 de = p1;
	ld a,(l24a8h)		;0869
	ld l,a			;086c
	ld h,000h		;086d hl = (uchar)l24a8h;
	add hl,de		;086f hl = (uchar)l24a8h + p1;
	ld e,(hl)		;0870
	ld d,000h		;0871 de = (uchar)*((uchar)l24a8h + p1)
	push de		\	;0873
	ld b,008h		;0874
	ld e,(ix+006h)		;0876
	ld d,(ix+007h)	;p1	;0879 de = p1
	ld hl,l24a9h		;087c hl = l24a9h
	ld l,(hl)		;087f
	ld h,000h		;0880 hl = (uchar)*l24a9h
	add hl,de		;0882 hl = (uchar)*l24a9h + p1
	ld l,(hl)		;0883
	ld h,000h		;0884 hl = (uchar)*((uchar)*l24a9h + p1)
	call shll		;0886 hl = (uchar)*((uchar)*l24a9h + p1) << 8
	pop de			;0889
	add hl,de		;088a	;    return (uchar)*((uchar)l24a8h + p1) + (uchar)*((uchar)*l24a9h + p1) << 8;
	jp cret			;088b	;}
;--------------------------------------------------------------------------
; 14	sub_088eh
;--------------------------------------------------------------------------
sub_088eh:				;long sub_088eh(p1) int p1; {
	call csv		;088e	;    long l1;
	push bc			;0891	;    char l2;
	push bc			;0892	;
	dec sp			;0893	;
	ld (ix-005h),004h ;l2	;0894	;    l2 = 4;
	ld (ix-004h),000h	;0898	;
	ld (ix-003h),000h	;089c	;
	ld (ix-002h),000h	;08a0	;
	ld (ix-001h),000h ;l1	;08a4	;    l1 = 0;
	jr l08dbh		;08a8	;    goto m2;
l08aah:				;	;m1:
	ld l,(ix-005h)	;l2	;08aa
	ld h,000h		;08ad hl = (uchar)l2
	add hl,hl		;08af
	add hl,hl		;08b0
	add hl,hl		;08b1
	ex de,hl		;08b2 de = (uchar)l2*8
	ld b,e			;08b3 b  = e
	ld e,(ix-005h)	;l2	;08b4
	ld d,000h		;08b7 de = (uchar)l2
	ld hl,l24a4h		;08b9 hl = tbl_24a4
	add hl,de		;08bc
	ld l,(hl)		;08bd
	ld h,d			;08be hl = tbl_24a4[(uchar)l2]
	ld e,(ix+006h)		;08bf
	ld d,(ix+007h)	;p1	;08c2 de = p1
	add hl,de		;08c5
	ld e,(hl)		;08c6
	ld d,000h		;08c7 de = p1[tbl_24a4[(uchar)l2]]
	ld hl,00000h		;08c9
	call allsh		;08cc	; p1[tbl_24a4[(uchar)l2]] << (uchar)l2*8
	push hl			;08cf
	push de			;08d0
	push ix			;08d1
	pop hl			;08d3
	dec hl			;08d4
	dec hl			;08d5
	dec hl			;08d6
	dec hl			;08d7
	call asaladd		;08d8	;    l1 += p1[tbl_24a4[(uchar)l2]] << (uchar)l2*8;
l08dbh:				;	;m2:
	ld a,(ix-005h)		;08db	;
	dec (ix-005h)	;l2	;08de	;
	or a			;08e1	;
	jr nz,l08aah		;08e2	;    if(l2-- != 0) goto m1;
	ld e,(ix-004h)		;08e4	;
	ld d,(ix-003h)		;08e7	;
	ld l,(ix-002h)		;08ea	;
	ld h,(ix-001h)	;l1	;08ed	;    return l1;
	jp cret			;08f0	;}
;==========================================================================
;	#           #    #####   #####     ##    #####    #   #
;	#           #    #    #  #    #   #  #   #    #    # #
;	#           #    #####   #    #  #    #  #    #     #
;	#           #    #    #  #####   ######  #####      #
;	#           #    #    #  #   #   #    #  #   #      #
;	#######     #    #####   #    #  #    #  #    #     #
;==========================================================================
; 15	printf
;==========================================================================
printf:
	call csv		;08f3
	push ix			;08f6
	pop de			;08f8
	ld hl,00008h		;08f9
	add hl,de		;08fc
	push hl			;08fd
	ld l,(ix+006h)		;08fe
	ld h,(ix+007h)		;0901
	push hl			;0904
	ld hl,l2759h		;0905
	push hl			;0908
	call __doprnt		;0909
	pop bc			;090c
	pop bc			;090d
	pop bc			;090e
	jp cret			;090f
;==========================================================================
; 16	fprintf
;==========================================================================
fprintf:
	call csv		;0912
	push ix			;0915
	pop de			;0917
	ld hl,0000ah		;0918
	add hl,de		;091b
	push hl			;091c
	ld l,(ix+008h)		;091d
	ld h,(ix+009h)		;0920
	push hl			;0923
	ld l,(ix+006h)		;0924
	ld h,(ix+007h)		;0927
	push hl			;092a
	call __doprnt		;092b
	pop bc			;092e
	pop bc			;092f
	pop bc			;0930
	jp cret			;0931
;==========================================================================
; 17	pputc
;==========================================================================
_pputc:
	call csv		;0934
	ld hl,(_ffile)		;0937	0x2b0d
	push hl			;093a
	ld a,(ix+006h)		;093b
	ld l,a			;093e
	rla			;093f
	sbc a,a			;0940
	ld h,a			;0941
	push hl			;0942
	call _fputc		;0943
	jp cret			;0946
;==========================================================================
; 18	icvt
;==========================================================================
_icvt:
	call csv		;0949
	ld c,(ix+006h)		;094c
	ld b,(ix+007h)		;094f
	push bc			;0952
	pop iy			;0953
	push bc			;0955
	call _atoi		;0956
	pop bc			;0959
	ld a,l			;095a
	ld (_ival),a		;095b
	jr l0962h		;095e
l0960h:
	inc iy			;0960
l0962h:
	ld l,(iy+000h)		;0962
	ld h,000h		;0965
	push hl			;0967
	call _isdigit		;0968
	pop bc			;096b
	ld a,l			;096c
	or h			;096d
	jr nz,l0960h		;096e
	push iy			;0970
	pop hl			;0972
	jp cret			;0973
;==========================================================================
; 19	__doprnt
;==========================================================================
__doprnt:			;	__doprnt:
	call csv		;0976	;	call	csv
	ld hl,0fff7h		;0979	;	ld	hl,-9
	add hl,sp		;097c	;	add	hl,sp
	ld sp,hl		;097d	;	ld	sp,hl
	ld c,(ix+008h)		;097e	;	ld	c,(ix+8)
	ld b,(ix+009h)		;0981	;	ld	b,(ix+9)
	push bc			;0984	;	push	bc
	pop iy			;0985	;	pop	iy
	ld l,(ix+006h)		;0987	;	ld	l,(ix+6)
	ld h,(ix+007h)		;098a	;	ld	h,(ix+7)
	ld (_ffile),hl		;098d	;	ld	(_ffile),hl
	jp l0c14h		;0990	;	jp	l78
l0993h:				;	;l79:
	ld a,(ix-001h)		;0993	;	ld	a,(ix+-1)
	cp 025h		;'%'	;0996	;	cp	37
	jr z,l09a6h		;0998	;	jp	z,l81
	ld l,a			;099a 	;	ld	l,a
	rla			;099b 	;	rla
	sbc a,a			;099c 	;	sbc	a,a
	ld h,a			;099d 	;	ld	h,a
	push hl			;099e 	;	push	hl
	call _pputc		;099f 	;	call	_pputc
	pop bc			;09a2 	;	pop	bc
	jp l0c14h		;09a3 	;	jp	l78
l09a6h:				;	;l81:
	ld (ix-005h),00ah	;09a6 	;	ld	(ix+-5),10
	ld (ix-006h),000h	;09aa 	;	ld	(ix+-6),0
	ld (ix-008h),000h	;09ae 	;	ld	(ix+-8),0
	ld (ix-003h),000h	;09b2 	;	ld	(ix+-3),0
	ld (ix-009h),001h	;09b6 	;	ld	(ix+-9),1
	ld a,(iy+000h)		;09ba 	;	ld	a,(iy+0)
	cp 02dh			;09bd 	;	cp	45
	jr nz,l09c6h		;09bf 	;	jp	nz,l83
	inc iy			;09c1 	;	inc	iy
	inc (ix-003h)		;09c3 	;	inc	(ix+-3)
l09c6h:				;	;l83:
	ld a,(iy+000h)		;09c6 	;	ld	a,(iy+0)
	cp 030h			;09c9 	;	cp	48
	ld hl,00001h		;09cb 	;	ld	hl,1
	jr z,l09d1h		;09ce 	;	jp	z,L22
	dec hl			;09d0 	;	dec	hl
l09d1h:				;	;L22:
	ld (ix-002h),l		;09d1 	;	ld	(ix+-2),l
	ld l,(iy+000h)		;09d4 	;	ld	l,(iy+0)
	ld h,000h		;09d7 	;	ld	h,0
	push hl			;09d9 	;	push	hl
	call _isdigit		;09da 	;	call	_isdig
	pop bc			;09dd 	;	pop	bc
	ld a,l			;09de 	;	ld	a,l
	or h			;09df 	;	or	h
	jr z,l09f3h		;09e0 	;	jp	z,l84
	push iy			;09e2 	;	push	iy
	call _icvt		;09e4 	;	call	_icvt
	pop bc			;09e7 	;	pop	bc
	push hl			;09e8 	;	push	hl
	pop iy			;09e9 	;	pop	iy
	ld a,(_ival)	;0x2b0a	;09eb 	;	ld	a,(_ival)
	ld (ix-006h),a		;09ee 	;	ld	(ix+-6),a
	jr l0a0eh		;09f1 	;	jp	l85
l09f3h:				;	;l84:
	ld a,(iy+000h)		;09f3	;	ld	a,(iy+0)
	cp 02ah			;09f6	;	cp	42
	jr nz,l0a0eh		;09f8	;	jp	nz,l85
	ld l,(ix+00ah)		;09fa	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;09fd	;	ld	h,(ix+11)
	ld a,(hl)		;0a00	;	ld	a,(hl)
	inc hl			;0a01	;	inc	hl
	inc hl			;0a02	;	inc	hl
	ld (ix+00ah),l		;0a03	;	ld	(ix+10),l
	ld (ix+00bh),h		;0a06	;	ld	(ix+11),h
	ld (ix-006h),a		;0a09	;	ld	(ix+-6),a
	inc iy			;0a0c	;	inc	iy
l0a0eh:				;	;l85:
	ld a,(iy+000h)		;0a0e	;	ld	a,(iy+0)
	cp 02eh			;0a11 	;	cp	46
	jr nz,l0a45h		;0a13 	;	jp	nz,l87
	inc iy			;0a15 	;	inc	iy
	ld a,(iy+000h)		;0a17 	;	ld	a,(iy+0)
	cp 02ah			;0a1a 	;	cp	42
	jr nz,l0a34h		;0a1c 	;	jp	nz,l88
	ld l,(ix+00ah)		;0a1e 	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;0a21 	;	ld	h,(ix+11)
	ld a,(hl)		;0a24 	;	ld	a,(hl)
	inc hl			;0a25 	;	inc	hl
	inc hl			;0a26 	;	inc	hl
	ld (ix+00ah),l		;0a27 	;	ld	(ix+10),l
	ld (ix+00bh),h		;0a2a 	;	ld	(ix+11),h
	ld (ix-007h),a		;0a2d 	;	ld	(ix+-7),a
	inc iy			;0a30 	;	inc	iy
	jr l0a58h		;0a32 	;	jp	l90
l0a34h:				;	;l88:
	push iy			;0a34 	;	push	iy
	call _icvt		;0a36 	;	call	_icvt
	pop bc			;0a39 	;	pop	bc
	push hl			;0a3a 	;	push	hl
	pop iy			;0a3b 	;	pop	iy
	ld a,(_ival)		;0a3d 	;	ld	a,(_ival)
	ld (ix-007h),a		;0a40 	;	ld	(ix+-7),a
	jr l0a58h		;0a43 	;	jp	l90
l0a45h:				;	;l87:
	ld a,(ix-002h)		;0a45 	;	ld	a,(ix+-2)
	or a			;0a48 	;	or	a
	jr nz,l0a50h		;0a49 	;	jp	nz,L21
	ld hl,00000h		;0a4b 	;	ld	hl,0
	jr l0a55h		;0a4e 	;	jp	L20
l0a50h:				;	;L21:
	ld l,(ix-006h)		;0a50 	;	ld	l,(ix+-6)
	ld h,000h		;0a53 	;	ld	h,0
l0a55h:				;	;L20:
	ld (ix-007h),l		;0a55 	;	ld	(ix+-7),l
l0a58h:				;	;l90:
	ld a,(iy+000h)		;0a58 	;	ld	a,(iy+0)
	cp 06ch			;0a5b 	;	cp	108
	jr nz,l0a65h		;0a5d 	;	jp	nz,l93
	inc iy			;0a5f 	;	inc	iy
	ld (ix-009h),002h	;0a61 	;	ld	(ix+-9),2
l0a65h:				;	;l93: 
	ld a,(iy+000h)		;0a65 	;	ld	a,(iy+0)
	inc iy			;0a68 	;	inc	iy
	ld (ix-001h),a		;0a6a 	;	ld	(ix+-1),a
	or a			;0a6d 	;	or	a
	jp z,cret		;0a6e 	;	jp	z,cret
	cp 044h			;0a71 	;	cp	68
	jp z,l0af4h		;0a73 	;	jp	z,l98
	cp 04fh			;0a76 	;	cp	79
	jr z,l0a9dh		;0a78 	;	jp	z,l96
	cp 058h			;0a7a 	;	cp	88
	jp z,l0afah		;0a7c 	;	jp	z,l100
	cp 063h			;0a7f 	;	cp	99
	jp z,l0ba0h		;0a81 	;	jp	z,l118
	cp 064h			;0a84 	;	cp	100
	jp z,l0af4h		;0a86 	;	jp	z,l98
	cp 06fh			;0a89 	;	cp	111
	jr z,l0a9dh		;0a8b 	;	jp	z,l96
	cp 073h			;0a8d 	;	cp	115
	jp z,l0b00h		;0a8f 	;	jp	z,l101
	cp 075h			;0a92 	;	cp	117
	jr z,l0aa1h		;0a94 	;	jp	z,l92
	cp 078h		;'x'	;0a96 	;	cp	120
	jr z,l0afah		;0a98 	;	jp	z,l100
	jp l0bb2h		;0a9a 	;	jp	l119
l0a9dh:				;	;l96:
	ld (ix-005h),008h	;0a9d 	;	ld	(ix+-5),8
l0aa1h:				;	;l92:
	ld a,(ix-003h)		;0aa1 	;	ld	a,(ix+-3)
	or a			;0aa4 	;	or	a
	jr z,l0ab1h		;0aa5 	;	jp	z,l121
	ld a,(ix-006h)		;0aa7 	;	ld	a,(ix+-6)
	ld (ix-003h),a		;0aaa 	;	ld	(ix+-3),a
	ld (ix-006h),000h	;0aad 	;	ld	(ix+-6),0
l0ab1h:				;	;l121:
	ld a,(ix-001h)		;0ab1 	;	ld	a,(ix+-1)
	ld l,a			;0ab4 	;	ld	l,a
	rla			;0ab5 	;	rla
	sbc a,a			;0ab6 	;	sbc	a,a
	ld h,a			;0ab7 	;	ld	h,a
	push hl			;0ab8 	;	push	hl
	call _isupper		;0ab9 	;	call	_isupper
	pop bc			;0abc 	;	pop	bc
	ld a,l			;0abd 	;	ld	a,l
	or h			;0abe 	;	or	h
	jr z,l0ac5h		;0abf 	;	jp	z,l122
	ld (ix-009h),002h	;0ac1 	;	ld	(ix+-9),2
l0ac5h:				;	;l122:
	ld hl,_pputc		;0ac5 	;	ld	hl,_pputc
	push hl			;0ac8 	;	push	hl
	ld l,(ix-005h)		;0ac9 	;	ld	l,(ix+-5)
	ld h,000h		;0acc 	;	ld	h,0
	push hl			;0ace 	;	push	hl
	ld l,(ix-008h)		;0acf 	;	ld	l,(ix+-8)
	push hl			;0ad2 	;	push	hl
	ld l,(ix-006h)		;0ad3 	;	ld	l,(ix+-6)
	push hl			;0ad6 	;	push	hl
	ld l,(ix-007h)		;0ad7 	;	ld	l,(ix+-7)
	push hl			;0ada 	;	push	hl
	ld a,(ix-009h)		;0adb 	;	ld	a,(ix+-9)
	cp 001h			;0ade 	;	cp	1
	jp z,l0bc0h		;0ae0 	;	jp	z,L19
	ld l,(ix+00ah)		;0ae3 	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;0ae6 	;	ld	h,(ix+11)
	ld e,(hl)		;0ae9 	;	ld	e,(hl)
	inc hl			;0aea 	;	inc	hl
	ld d,(hl)		;0aeb 	;	ld	d,(hl)
	inc hl			;0aec 	;	inc	hl
	ld a,(hl)		;0aed 	;	ld	a,(hl)
	inc hl			;0aee 	;	inc	hl
	ld h,(hl)		;0aef 	;	ld	h,(hl)
	ld l,a			;0af0 	;	ld	l,a
	jp l0bdbh		;0af1 	;	jp	L16
l0af4h:				;	;l98:
	ld (ix-008h),001h	;0af4 	;	ld	(ix+-8),1
	jr l0aa1h		;0af8 	;	jp	l92
l0afah:				;	;l100:
	ld (ix-005h),010h	;0afa 	;	ld	(ix+-5),16
	jr l0aa1h		;0afe 	;	jp	l92
l0b00h:				;	;l101:
	ld l,(ix+00ah)		;0b00 	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;0b03 	;	ld	h,(ix+11)
	ld c,(hl)		;0b06 	;	ld	c,(hl)
	inc hl			;0b07 	;	inc	hl
	ld b,(hl)		;0b08 	;	ld	b,(hl)
	inc hl			;0b09 	;	inc	hl
	ld (ix+00ah),l		;0b0a 	;	ld	(ix+10),l
	ld (ix+00bh),h		;0b0d 	;	ld	(ix+11),h
	ld (_x),bc		;0b10 	;	ld	(_x),bc
	ld a,c			;0b14 	;	ld	a,c
	or b			;0b15 	;	or	b
	jr nz,l0b1eh		;0b16 	;	jp	nz,l102
	ld hl,msg_null		;0b18 	;	ld	hl,449f
	ld (_x),hl	;0x2b0b	;0b1b 	;	ld	(_x),hl
l0b1eh:				;	;l102:
	ld hl,(_x)		;0b1e 	;	ld	hl,(_x)
	push hl			;0b21 	;	push	hl
	call _strlen		;0b22 	;	call	_strlen
	pop bc			;0b25 	;	pop	bc
	ld (ix-004h),l		;0b26 	;	ld	(ix+-4),l
l0b29h:				;	;l103:
	ld a,(ix-007h)		;0b29 	;	ld	a,(ix+-7)
	or a			;0b2c 	;	or	a
	jr z,l0b37h		;0b2d 	;	jp	z,l104
				 	;
					;	ld	e,(ix+-4)
					;	ld	d,0
					;	ld	l,a
					;	ld	h,d
					;	or	a
					;	sbc	hl,de
					;	jp	nc,l104
					;	ld	(ix+-4),a
					;
	cp (ix-004h)		;0b2f 	;
	jr nc,l0b37h		;0b32 	;
	ld (ix-004h),a		;0b34 	;
l0b37h:				;     	;l104:
	ld a,(ix-004h)		;0b37 	;	ld	e,(ix+-6)
	cp (ix-006h)		;0b3a 	;	ld	d,0
	jr nc,l0b4ah		;0b3d 	;	ld	l,(ix+-4)
	ld a,(ix-006h)		;0b3f 	;	ld	h,d
	sub (ix-004h)		;0b42	;	or	a
	ld (ix-006h),a		;0b45 	;	sbc	hl,de
	jr l0b4eh		;0b48 	;	jp	nc,l105
					;	ld	a,e
					;	sub	(ix+-4)
					;	ld	(ix+-6),a
					;	jp	l106
					;
l0b4ah:				;     	;l105:
	ld (ix-006h),000h	;0b4a 	;	ld	(ix+-6),0
l0b4eh:				;     	;l106:
	ld a,(ix-003h)		;0b4e 	;	ld	a,(ix+-3)
	or a			;0b51 	;	or	a
	jr nz,l0b7ah		;0b52 	;	jp	nz,l111
	jr l0b5eh		;0b54 	;	jp	l108
l0b56h:				;     	;l109:
	ld hl,00020h		;0b56 	;	ld	hl,32
	push hl			;0b59	;	push	hl
	call _pputc		;0b5a 	;	call	_pputc
	pop bc			;0b5d	;	pop	bc
l0b5eh:				;     	;l108:
	ld a,(ix-006h)		;0b5e 	;	ld	a,(ix+-6)
	dec (ix-006h)		;0b61 	;	dec	(ix+-6)
	or a			;0b64 	;	or	a
	jr nz,l0b56h		;0b65	;	jp	nz,l109
	jr l0b7ah		;0b67 	;	jp	l111
l0b69h:				;     	;l112:
	ld hl,(_x)		;0b69 	;	ld	hl,(_x)
	ld a,(hl)		;0b6c 	;	ld	a,(hl)
	inc hl			;0b6d	;	inc	hl
	ld (_x),hl		;0b6e 	;	ld	(_x),hl
	ld l,a			;0b71 	;	ld	l,a
	rla			;0b72 	;	rla
	sbc a,a			;0b73 	;	sbc	a,a
	ld h,a			;0b74 	;	ld	h,a
	push hl			;0b75	;	push	hl
	call _pputc		;0b76 	;	call	_pputc
	pop bc			;0b79 	;	pop	bc
l0b7ah:				;     	;l111:
	ld a,(ix-004h)		;0b7a 	;	ld	a,(ix+-4)
	dec (ix-004h)		;0b7d 	;	dec	(ix+-4)
	or a			;0b80 	;	or	a
	jr nz,l0b69h		;0b81 	;	jp	nz,l112
	ld a,(ix-003h)		;0b83 	;	ld	a,(ix+-3)
	or a			;0b86 	;	or	a
	jp z,l0c14h		;0b87 	;	jp	z,l78
	jr l0b94h		;0b8a 	;	jp	l115
l0b8ch:				;	;l116:
	ld hl,00020h		;0b8c 	;	ld	hl,32
	push hl			;0b8f 	;	push	hl
	call _pputc		;0b90 	;	call	_pputc
	pop bc			;0b93 	;	pop	bc
l0b94h:				;     	;l115:
	ld a,(ix-006h)		;0b94 	;	ld	a,(ix+-6)
	dec (ix-006h)		;0b97 	;	dec	(ix+-6)
	or a			;0b9a 	;	or	a
	jr nz,l0b8ch		;0b9b	;	jp	nz,l116
	jp l0c14h		;0b9d	;	jp	l78
l0ba0h:				;     	;l118:
	ld l,(ix+00ah)		;0ba0 	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;0ba3 	;	ld	h,(ix+11)
	ld a,(hl)		;0ba6	;	ld	a,(hl)
	inc hl			;0ba7 	;	inc	hl
	inc hl			;0ba8 	;	inc	hl
	ld (ix+00ah),l		;0ba9 	;	ld	(ix+10),l
	ld (ix+00bh),h		;0bac 	;	ld	(ix+11),h
	ld (ix-001h),a		;0baf 	;	ld	(ix+-1),a
l0bb2h:				;	;l119:
	push ix			;0bb2 	;	push	ix
	pop hl			;0bb4 	;	pop	hl
	dec hl			;0bb5 	;	dec	hl
	ld (_x),hl		;0bb6 	;	ld	(_x),hl
	ld (ix-004h),001h	;0bb9 	;	ld	(ix+-4),1
	jp l0b29h		;0bbd 	;	jp	l103
l0bc0h:				;     	;L19:
	ld a,(ix-008h)		;0bc0 	;	ld	a,(ix+-8)
	or a			;0bc3	;	or	a
	ld l,(ix+00ah)		;0bc4 	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;0bc7 	;	ld	h,(ix+11)
	ld e,(hl)		;0bca 	;	ld	e,(hl)
	jr nz,l0bd4h		;0bcb 	;	inc	hl
	inc hl			;0bcd 	;	ld	d,(hl)
	ld d,(hl)		;0bce 	;	jp	nz,L23
	ld hl,00000h		;0bcf	;	ld	hl,0
	jr l0bdbh		;0bd2 	;	jp	L16
l0bd4h:				;     	;L23:
	inc hl			;0bd4 	;	ld	a,d
	ld d,(hl)		;0bd5 	;	rla
	ld a,d			;0bd6 	;	sbc	a,a
	rla			;0bd7 	;	ld	l,a
	sbc a,a			;0bd8 	;	ld	h,a
	ld l,a			;0bd9 	;
	ld h,a			;0bda 	;
l0bdbh:				;     	;L16:
	push hl			;0bdb	;	push	hl
	push de			;0bdc 	;	push	de
	call __pnum		;0bdd 	;	call	__pnum
	exx			;0be0 	;	exx
	ld hl,0000eh		;0be1 	;	ld	hl,14
	add hl,sp		;0be4 	;	add	hl,sp
	ld sp,hl		;0be5	;	ld	sp,hl
	exx			;0be6 	;	exx
	ld (ix-006h),l		;0be7 	;	ld	(ix+-6),l
	ld l,(ix-009h)		;0bea 	;	ld	l,(ix+-9)
	ld h,000h		;0bed 	;	ld	h,0
	add hl,hl		;0bef 	;	add	hl,hl
	ex de,hl		;0bf0 	;	ex	de,hl
	ld l,(ix+00ah)		;0bf1 	;	ld	l,(ix+10)
	ld h,(ix+00bh)		;0bf4 	;	ld	h,(ix+11)
	add hl,de		;0bf7 	;	add	hl,de
	ld (ix+00ah),l		;0bf8 	;	ld	(ix+10),l
	ld (ix+00bh),h		;0bfb 	;	ld	(ix+11),h
	jr l0c08h		;0bfe 	;	jp	l123
l0c00h:				;     	;l124:
	ld hl,00020h		;0c00 	;	ld	hl,32
	push hl			;0c03 	;	push	hl
	call _pputc		;0c04 	;	call	_pputc
	pop bc			;0c07 	;	pop	bc
l0c08h:				;     	;l123:
	ld e,(ix-003h)		;0c08 	;	ld	a,(ix+-3)
	dec (ix-003h)		;0c0b	;	dec	(ix+-3)
	ld a,(ix-006h)		;0c0e 	;	ld	e,a
	cp e			;0c11 	;	ld	d,0
	jr c,l0c00h		;0c12 	;	ld	l,(ix+-6)
l0c14h:				;     	;	ld	h,d
	ld a,(iy+000h)		;0c14	;	or	a
	inc iy			;0c17 	;	sbc	hl,de
	ld (ix-001h),a		;0c19 	;	jp	c,l124
	or a			;0c1c 	;	l78:
	jp nz,l0993h		;0c1d 	;	ld	a,(iy+0)
	jp cret			;0c20 	;	inc	iy
				      	;	ld	(ix+-1),a
				      	;	or	a
				      	;	jp	nz,l79
				      	;	jp	cret
;==========================================================================
; 20	fputc
;==========================================================================
_fputc:
	pop de			;0c23
	pop bc			;0c24
	ld b,000h		;0c25
	ex (sp),iy		;0c27
	bit 1,(iy+006h)		;0c29
	jr z,l0c76h		;0c2d
	bit 7,(iy+006h)		;0c2f
	jr nz,l0c49h		;0c33
	ld a,c			;0c35
	cp 00ah			;0c36
	jr nz,l0c49h		;0c38
	push bc			;0c3a
	push de			;0c3b
	push iy			;0c3c
	ld hl,0000dh		;0c3e
	push hl			;0c41
	call _fputc		;0c42
	pop hl			;0c45
	pop bc			;0c46
	pop de			;0c47
	pop bc			;0c48
l0c49h:
	ld l,(iy+002h)		;0c49
	ld h,(iy+003h)		;0c4c
	ld a,l			;0c4f
	or h			;0c50
	jr z,l0c6fh		;0c51
	dec hl			;0c53
	ld (iy+002h),l		;0c54
	ld (iy+003h),h		;0c57
	ld l,(iy+000h)		;0c5a
	ld h,(iy+001h)		;0c5d
	ld (hl),c		;0c60
	inc hl			;0c61
	ld (iy+000h),l		;0c62
	ld (iy+001h),h		;0c65
l0c68h:
	ex (sp),iy		;0c68
	push bc			;0c6a
	push de			;0c6b
	ld l,c			;0c6c
	ld h,b			;0c6d
	ret			;0c6e
l0c6fh:
	ex (sp),iy		;0c6f
	push bc			;0c71
	push de			;0c72
	jp __flsbuf		;0c73
l0c76h:
	ld bc,0ffffh		;0c76
	jr l0c68h		;0c79
;==========================================================================
; 21	_flsbuf
;==========================================================================
__flsbuf:
	call csv		;0c7b
	ld c,(ix+008h)		;0c7e
	ld b,(ix+009h)		;0c81
	push bc			;0c84
	pop iy			;0c85
	bit 1,(iy+006h)		;0c87
	jp z,l0d0eh		;0c8b
	ld a,(iy+004h)		;0c8e
	or (iy+005h)		;0c91
	jr nz,l0cd0h		;0c94
	ld (iy+002h),000h	;0c96
	ld (iy+003h),000h	;0c9a
	ld hl,00001h		;0c9e
	push hl			;0ca1
	push ix			;0ca2
	pop de			;0ca4
	ld hl,00006h		;0ca5
	add hl,de		;0ca8
	push hl			;0ca9
	ld l,(iy+007h)		;0caa
	ld h,000h		;0cad
	push hl			;0caf
	call _write		;0cb0
	pop bc			;0cb3
	pop bc			;0cb4
	pop bc			;0cb5
	ld de,00001h		;0cb6
	or a			;0cb9
	sbc hl,de		;0cba
	jr nz,l0cc6h		;0cbc
	ld l,(ix+006h)		;0cbe
	ld h,000h		;0cc1
	jp cret			;0cc3
l0cc6h:
	set 5,(iy+006h)		;0cc6
	ld hl,0ffffh		;0cca
	jp cret			;0ccd
l0cd0h:
	ld hl,00200h		;0cd0
	push hl			;0cd3
	ld l,(iy+004h)		;0cd4
	ld h,(iy+005h)		;0cd7
	push hl			;0cda
	ld l,(iy+007h)		;0cdb
	ld h,000h		;0cde
	push hl			;0ce0
	call _write		;0ce1
	pop bc			;0ce4
	pop bc			;0ce5
	pop bc			;0ce6
	ld de,00200h		;0ce7
	or a			;0cea
	sbc hl,de		;0ceb
	jr z,l0cf3h		;0ced
	set 5,(iy+006h)		;0cef
l0cf3h:
	ld (iy+002h),0ffh	;0cf3
	ld (iy+003h),001h	;0cf7
	ld a,(ix+006h)		;0cfb
	ld l,(iy+004h)		;0cfe
	ld h,(iy+005h)		;0d01
	ld (hl),a		;0d04
	inc hl			;0d05
	ld (iy+000h),l		;0d06
	ld (iy+001h),h		;0d09
	jr l0d1ah		;0d0c
l0d0eh:
	set 5,(iy+006h)		;0d0e
	ld (iy+002h),000h	;0d12
	ld (iy+003h),000h	;0d16
l0d1ah:
	bit 5,(iy+006h)		;0d1a
	jr z,l0d26h		;0d1e
	ld hl,0ffffh		;0d20
	jp cret			;0d23
l0d26h:
	ld l,(ix+006h)		;0d26
	ld h,000h		;0d29
	jp cret			;0d2b
;==========================================================================
; 22	freopen
;==========================================================================
_freopen:
	call csv		;0d2e
	dec sp			;0d31
	ld c,(ix+00ah)		;0d32
	ld b,(ix+00bh)		;0d35
	push bc			;0d38
	pop iy			;0d39
	push bc			;0d3b
	call _fclose		;0d3c
	pop bc			;0d3f
	ld (ix-001h),000h	;0d40
	ld a,(iy+006h)		;0d44
	and 004h		;0d47
	ld (iy+006h),a		;0d49
	ld l,(ix+008h)		;0d4c
	ld h,(ix+009h)		;0d4f
	ld a,(hl)		;0d52
	cp 061h			;0d53
	jr z,l0d62h		;0d55
	cp 072h			;0d57
	jr z,l0d65h		;0d59
	cp 077h			;0d5b
	jr nz,l0d75h		;0d5d
	inc (ix-001h)		;0d5f
l0d62h:
	inc (ix-001h)		;0d62
l0d65h:
	ld l,(ix+008h)		;0d65
	ld h,(ix+009h)		;0d68
	inc hl			;0d6b
	ld a,(hl)		;0d6c
	cp 062h			;0d6d
	jr nz,l0d75h		;0d6f
	ld (iy+006h),080h	;0d71
l0d75h:
	ld a,(ix-001h)		;0d75
	cp 002h			;0d78
	jr nz,l0d8ch		;0d7a
	ld l,(ix+006h)		;0d7c
	ld h,(ix+007h)		;0d7f
	push hl			;0d82
	call creat		;0d83
	pop bc			;0d86
	ld (iy+007h),l		;0d87
	jr l0da1h		;0d8a
l0d8ch:
	ld l,(ix-001h)		;0d8c
	ld h,000h		;0d8f
	push hl			;0d91
	ld l,(ix+006h)		;0d92
	ld h,(ix+007h)		;0d95
	push hl			;0d98
	call _open		;0d99
	pop bc			;0d9c
	pop bc			;0d9d
	ld (iy+007h),l		;0d9e
l0da1h:
	ld a,(iy+007h)		;0da1
	or a			;0da4
	jp p,l0daeh		;0da5
	ld hl,00000h		;0da8
	jp cret			;0dab
l0daeh:
	ld a,(iy+006h)		;0dae
	and 00ch		;0db1
	or a			;0db3
	jr nz,l0dbfh		;0db4
	call __bufallo		;0db6
	ld (iy+004h),l		;0db9
	ld (iy+005h),h		;0dbc
l0dbfh:
	ld l,(iy+004h)		;0dbf
	ld h,(iy+005h)		;0dc2
	ld (iy+000h),l		;0dc5
	ld (iy+001h),h		;0dc8
	ld (iy+002h),000h	;0dcb
	ld (iy+003h),000h	;0dcf
	ld a,(ix-001h)		;0dd3
	or a			;0dd6
	jr z,l0ddfh		;0dd7
	set 1,(iy+006h)		;0dd9
	jr l0de3h		;0ddd
l0ddfh:
	set 0,(iy+006h)		;0ddf
l0de3h:
	ld a,(ix-001h)		;0de3
	cp 001h			;0de6
	jr nz,l0dfeh		;0de8
	ld hl,00002h		;0dea
	push hl			;0ded
	ld de,00000h		;0dee
	ld l,e			;0df1
	ld h,d			;0df2
	push hl			;0df3
	push de			;0df4
	push iy			;0df5
	call _fseek		;0df7
	pop bc			;0dfa
	pop bc			;0dfb
	pop bc			;0dfc
	pop bc			;0dfd
l0dfeh:
	ld a,(iy+004h)		;0dfe
	or (iy+005h)		;0e01
	jr z,l0e14h		;0e04
	ld a,(ix-001h)		;0e06
	or a			;0e09
	jr z,l0e14h		;0e0a
	ld (iy+002h),000h	;0e0c
	ld (iy+003h),002h	;0e10
l0e14h:
	push iy			;0e14
	pop hl			;0e16
	jp cret			;0e17
;==========================================================================
; 23	_ssize
;==========================================================================
__ssize:
	call csv		;0e1a
	ld hl,0ff78h		;0e1d
	add hl,sp		;0e20
	ld sp,hl		;0e21
	ld c,(ix+006h)		;0e22
	ld b,(ix+007h)		;0e25
	push bc			;0e28
	pop iy			;0e29
	bit 7,(iy+006h)		;0e2b
	jr z,l0e3eh		;0e2f
	ld l,(iy+007h)		;0e31
	ld h,000h		;0e34
	push hl			;0e36
	call __fsize		;0e37
	pop bc			;0e3a
	jp cret			;0e3b
l0e3eh:
	ld de,0002ah		;0e3e
	ld l,(iy+007h)		;0e41
	ld h,000h		;0e44
	call amul		;0e46
	ld de,__fcb		;0e49
	add hl,de		;0e4c
	ld (ix-008h),l		;0e4d
	ld (ix-007h),h		;0e50
	ex de,hl		;0e53
	ld hl,00024h		;0e54
	add hl,de		;0e57
	ld a,(hl)		;0e58
	ld (ix-001h),a		;0e59
	ld hl,00024h		;0e5c
	add hl,de		;0e5f
	ld (hl),001h		;0e60
	ld a,(iy+006h)		;0e62
	ld (ix-002h),a		;0e65
	bit 1,a			;0e68
	jr z,l0e72h		;0e6a
	push iy			;0e6c
	call _fflush		;0e6e
	pop bc			;0e71
l0e72h:
	set 0,(iy+006h)		;0e72
	ld a,(iy+006h)		;0e76
	and 0fdh		;0e79
	ld (iy+006h),a		;0e7b
	ld hl,00002h		;0e7e
	push hl			;0e81
	ld de,0ff80h		;0e82
	ld hl,0ffffh		;0e85
	push hl			;0e88
	push de			;0e89
	ld l,(iy+007h)		;0e8a
	ld h,000h		;0e8d
	push hl			;0e8f
	call _lseek		;0e90
	pop bc			;0e93
	pop bc			;0e94
	pop bc			;0e95
	pop bc			;0e96
	ld (iy+002h),000h	;0e97
	ld (iy+003h),000h	;0e9b
	push iy			;0e9f
	ld hl,00080h		;0ea1
	push hl			;0ea4
	ld hl,00001h		;0ea5
	push hl			;0ea8
	push ix			;0ea9
	pop de			;0eab
	ld hl,0ff78h		;0eac
	add hl,de		;0eaf
	push hl			;0eb0
	call _fread		;0eb1
	pop bc			;0eb4
	pop bc			;0eb5
	pop bc			;0eb6
	pop bc			;0eb7
	push iy			;0eb8
	call _ftell		;0eba
	pop bc			;0ebd
	ld (ix-006h),e		;0ebe
	ld (ix-005h),d		;0ec1
	ld (ix-004h),l		;0ec4
	ld (ix-003h),h		;0ec7
	ld a,(ix-001h)		;0eca
	ld e,(ix-008h)		;0ecd
	ld d,(ix-007h)		;0ed0
	ld hl,00024h		;0ed3
	add hl,de		;0ed6
	ld (hl),a		;0ed7
	ld a,(ix-002h)		;0ed8
	ld (iy+006h),a		;0edb
	bit 1,(iy+006h)		;0ede
	jr z,l0ef8h		;0ee2
	ld (iy+002h),000h	;0ee4
	ld (iy+003h),002h	;0ee8
	ld l,(iy+004h)		;0eec
	ld h,(iy+005h)		;0eef
	ld (iy+000h),l		;0ef2
	ld (iy+001h),h		;0ef5
l0ef8h:
	ld e,(ix-006h)		;0ef8
	ld d,(ix-005h)		;0efb
	ld l,(ix-004h)		;0efe
	ld h,(ix-003h)		;0f01
	jp cret			;0f04
;==========================================================================
; 24	fseek
;==========================================================================
_fseek:
	call csv		;0f07
	push bc			;0f0a
	push bc			;0f0b
	ld c,(ix+006h)		;0f0c
	ld b,(ix+007h)		;0f0f
	push bc			;0f12
	pop iy			;0f13
	ld a,(iy+004h)		;0f15
	or (iy+005h)		;0f18
	jr nz,l0f56h		;0f1b
	ld de,0ffffh		;0f1d
	ld l,e			;0f20
	ld h,d			;0f21
	push hl			;0f22
	push de			;0f23
	ld l,(ix+00ch)		;0f24
	ld h,000h		;0f27
	push hl			;0f29
	ld e,(ix+008h)		;0f2a
	ld d,(ix+009h)		;0f2d
	ld l,(ix+00ah)		;0f30
	ld h,(ix+00bh)		;0f33
	push hl			;0f36
	push de			;0f37
	ld l,(iy+007h)		;0f38
	ld h,000h		;0f3b
	push hl			;0f3d
	call _lseek		;0f3e
	pop bc			;0f41
	pop bc			;0f42
	pop bc			;0f43
	pop bc			;0f44
	call lrelop		;0f45
	jr nz,l0f50h		;0f48
	ld hl,0ffffh		;0f4a
	jp cret			;0f4d
l0f50h:
	ld hl,00000h		;0f50
	jp cret			;0f53
l0f56h:
	ld a,(ix+00ch)		;0f56
	or a			;0f59
	jr z,l0f7ch		;0f5a
	cp 001h			;0f5c
	jr z,l0f6ah		;0f5e
	cp 002h			;0f60
	jr z,l0fabh		;0f62
	ld hl,0ffffh		;0f64
	jp cret			;0f67
l0f6ah:
	push iy			;0f6a
	call _ftell		;0f6c
	pop bc			;0f6f
	push hl			;0f70
	push de			;0f71
	push ix			;0f72
	pop de			;0f74
	ld hl,00008h		;0f75
	add hl,de		;0f78
	call asaladd		;0f79
l0f7ch:
	push iy			;0f7c
	call _ftell		;0f7e
	pop bc			;0f81
	push hl			;0f82
	push de			;0f83
	ld e,(ix+008h)		;0f84
	ld d,(ix+009h)		;0f87
	ld l,(ix+00ah)		;0f8a
	ld h,(ix+00bh)		;0f8d
	call alsub		;0f90
	ld (ix-004h),e		;0f93
	ld (ix-003h),d		;0f96
	ld (ix-002h),l		;0f99
	ld (ix-001h),h		;0f9c
	ld a,e			;0f9f
	or d			;0fa0
	or l			;0fa1
	or h			;0fa2
	jr nz,l0fbfh		;0fa3
	ld hl,00000h		;0fa5
	jp cret			;0fa8
l0fabh:
	push iy			;0fab
	call __ssize		;0fad
	pop bc			;0fb0
	push hl			;0fb1
	push de			;0fb2
	push ix			;0fb3
	pop de			;0fb5
	ld hl,00008h		;0fb6
	add hl,de		;0fb9
	call asaladd		;0fba
	jr l0f7ch		;0fbd
l0fbfh:
	bit 0,(iy+006h)		;0fbf
	jr z,l1012h		;0fc3
	bit 7,(ix-001h)		;0fc5
	jr nz,l1012h		;0fc9
	ld e,(ix-004h)		;0fcb
	ld d,(ix-003h)		;0fce
	ld l,(ix-002h)		;0fd1
	ld h,(ix-001h)		;0fd4
	push hl			;0fd7
	push de			;0fd8
	ld e,(iy+002h)		;0fd9
	ld d,(iy+003h)		;0fdc
	ld a,d			;0fdf
	rla			;0fe0
	sbc a,a			;0fe1
	ld l,a			;0fe2
	ld h,a			;0fe3
	call lrelop		;0fe4
	jp m,l1012h		;0fe7
	ld e,(ix-004h)		;0fea
	ld d,(ix-003h)		;0fed
	ld l,(iy+002h)		;0ff0
	ld h,(iy+003h)		;0ff3
	or a			;0ff6
	sbc hl,de		;0ff7
	ld (iy+002h),l		;0ff9
	ld (iy+003h),h		;0ffc
	ld l,(iy+000h)		;0fff
	ld h,(iy+001h)		;1002
	add hl,de		;1005
	ld (iy+000h),l		;1006
	ld (iy+001h),h		;1009
	ld hl,00000h		;100c
	jp cret			;100f
l1012h:
	bit 1,(iy+006h)		;1012
	jr z,l1020h		;1016
	push iy			;1018
	call _fflush		;101a
	pop bc			;101d
	jr l1028h		;101e
l1020h:
	ld (iy+002h),000h	;1020
	ld (iy+003h),000h	;1024
l1028h:
	ld de,0ffffh		;1028
	ld l,e			;102b
	ld h,d			;102c
	push hl			;102d
	push de			;102e
	ld hl,00000h		;102f
	push hl			;1032
	ld e,(ix+008h)		;1033
	ld d,(ix+009h)		;1036
	ld l,(ix+00ah)		;1039
	ld h,(ix+00bh)		;103c
	push hl			;103f
	push de			;1040
	ld a,(iy+007h)		;1041
	ld l,a			;1044
	rla			;1045
	sbc a,a			;1046
	ld h,a			;1047
	push hl			;1048
	call _lseek		;1049
	pop bc			;104c
	pop bc			;104d
	pop bc			;104e
	pop bc			;104f
	call lrelop		;1050
	jr nz,l105bh		;1053
	ld hl,0ffffh		;1055
	jp cret			;1058
l105bh:
	ld hl,00000h		;105b
	jp cret			;105e
;==========================================================================
; 25	ftell
;==========================================================================
_ftell:
	call csv		;1061
	push bc			;1064
	push bc			;1065
	ld c,(ix+006h)		;1066
	ld b,(ix+007h)		;1069
	push bc			;106c
	pop iy			;106d
	ld hl,00001h		;106f
	push hl			;1072
	ld de,00000h		;1073
	ld l,e			;1076
	ld h,d			;1077
	push hl			;1078
	push de			;1079
	ld a,(iy+007h)		;107a
	ld l,a			;107d
	rla			;107e
	sbc a,a			;107f
	ld h,a			;1080
	push hl			;1081
	call _lseek		;1082
	pop bc			;1085
	pop bc			;1086
	pop bc			;1087
	pop bc			;1088
	ld (ix-004h),e		;1089
	ld (ix-003h),d		;108c
	ld (ix-002h),l		;108f
	ld (ix-001h),h		;1092
	bit 7,(iy+003h)		;1095
	jr z,l10a3h		;1099
	ld (iy+002h),000h	;109b
	ld (iy+003h),000h	;109f
l10a3h:
	ld a,(iy+004h)		;10a3
	or (iy+005h)		;10a6
	jr z,l10c3h		;10a9
	bit 1,(iy+006h)		;10ab
	jr z,l10c3h		;10af
	ld de,00200h		;10b1
	ld hl,00000h		;10b4
	push hl			;10b7
	push de			;10b8
	push ix			;10b9
	pop hl			;10bb
	dec hl			;10bc
	dec hl			;10bd
	dec hl			;10be
	dec hl			;10bf
	call asaladd		;10c0
l10c3h:
	ld e,(iy+002h)		;10c3
	ld d,(iy+003h)		;10c6
	ld a,d			;10c9
	rla			;10ca
	sbc a,a			;10cb
	ld l,a			;10cc
	ld h,a			;10cd
	push hl			;10ce
	push de			;10cf
	ld e,(ix-004h)		;10d0
	ld d,(ix-003h)		;10d3
	ld l,(ix-002h)		;10d6
	ld h,(ix-001h)		;10d9
	call alsub		;10dc
	jp cret			;10df
;==========================================================================
; 26	fread
;==========================================================================
_fread:
	call csv		;10e2
	push bc			;10e5
	push bc			;10e6
	ld c,(ix+006h)		;10e7
	ld b,(ix+007h)		;10ea
	push bc			;10ed
	pop iy			;10ee
	ld e,(ix+00ah)		;10f0
	ld d,(ix+00bh)		;10f3
	ld l,(ix+008h)		;10f6
	ld h,(ix+009h)		;10f9
	call amul		;10fc
	ld (ix-002h),l		;10ff
	ld (ix-001h),h		;1102
	jr l1135h		;1105
l1107h:
	ld l,(ix+00ch)		;1107
	ld h,(ix+00dh)		;110a
	push hl			;110d
	call _fgetc		;110e
	pop bc			;1111
	ld (ix-004h),l		;1112
	ld (ix-003h),h		;1115
	ld de,0ffffh		;1118
	or a			;111b
	sbc hl,de		;111c
	jr z,l113dh		;111e
	ld l,(ix-002h)		;1120
	ld h,(ix-001h)		;1123
	add hl,de		;1126
	ld (ix-002h),l		;1127
	ld (ix-001h),h		;112a
	ld a,(ix-004h)		;112d
	ld (iy+000h),a		;1130
	inc iy			;1133
l1135h:
	ld a,(ix-002h)		;1135
	or (ix-001h)		;1138
	jr nz,l1107h		;113b
l113dh:
	ld e,(ix+008h)		;113d
	ld d,(ix+009h)		;1140
	ld l,(ix-002h)		;1143
	ld h,(ix-001h)		;1146
	add hl,de		;1149
	ld de,0ffffh		;114a
	add hl,de		;114d
	ld e,(ix+008h)		;114e
	ld d,(ix+009h)		;1151
	call adiv		;1154
	ex de,hl		;1157
	ld l,(ix+00ah)		;1158
	ld h,(ix+00bh)		;115b
	or a			;115e
	sbc hl,de		;115f
	jp cret			;1161
;==========================================================================
; 27	fgetc
;==========================================================================
_fgetc:
	pop de			;1164
	ex (sp),iy		;1165
	ld a,(iy+006h)		;1167
	bit 0,a			;116a
	jr z,l11c0h		;116c
	bit 4,a			;116e
	jr nz,l11c0h		;1170
l1172h:
	ld l,(iy+002h)		;1172
	ld h,(iy+003h)		;1175
	ld a,l			;1178
	or h			;1179
	jr z,l11cbh		;117a
	dec hl			;117c
	ld (iy+002h),l		;117d
	ld (iy+003h),h		;1180
	ld l,(iy+000h)		;1183
	ld h,(iy+001h)		;1186
	ld a,(hl)		;1189
	inc hl			;118a
	ld (iy+000h),l		;118b
	ld (iy+001h),h		;118e
l1191h:
	bit 7,(iy+006h)		;1191
	jr z,l119eh		;1195
l1197h:
	ld l,a			;1197
	ld h,000h		;1198
	ex (sp),iy		;119a
	push de			;119c
	ret			;119d
l119eh:
	cp 00dh			;119e
	jr z,l1172h		;11a0
	cp 01ah			;11a2
	jr nz,l1197h		;11a4
	ld l,(iy+002h)		;11a6
	ld h,(iy+003h)		;11a9
	inc hl			;11ac
	ld (iy+002h),l		;11ad
	ld (iy+003h),h		;11b0
	ld l,(iy+000h)		;11b3
	ld h,(iy+001h)		;11b6
	dec hl			;11b9
	ld (iy+000h),l		;11ba
	ld (iy+001h),h		;11bd
l11c0h:
	set 4,(iy+006h)		;11c0
	ld hl,0ffffh		;11c4
	ex (sp),iy		;11c7
	push de			;11c9
	ret			;11ca
l11cbh:
	bit 6,(iy+006h)		;11cb
	jr nz,l11c0h		;11cf
	push de			;11d1
	push iy			;11d2
	call __filbuf		;11d4
	ld a,l			;11d7
	pop bc			;11d8
	pop de			;11d9
	bit 7,h			;11da
	jr nz,l11c0h		;11dc
	jr l1191h		;11de
;==========================================================================
; 28	_filbuf
;==========================================================================
__filbuf:
	call csv		;11e0
	dec sp			;11e3
	ld c,(ix+006h)		;11e4
	ld b,(ix+007h)		;11e7
	push bc			;11ea
	pop iy			;11eb
	ld (iy+002h),000h	;11ed
	ld (iy+003h),000h	;11f1
	bit 0,(iy+006h)		;11f5
	jr nz,l1201h		;11f9
	ld hl,0ffffh		;11fb
	jp cret			;11fe
l1201h:
	ld a,(iy+004h)		;1201
	or (iy+005h)		;1204
	jr nz,l1240h		;1207
	ld (iy+002h),000h	;1209
	ld (iy+003h),000h	;120d
	ld hl,00001h		;1211
	push hl			;1214
	push ix			;1215
	pop hl			;1217
	dec hl			;1218
	push hl			;1219
	ld l,(iy+007h)		;121a
	ld h,000h		;121d
	push hl			;121f
	call _read		;1220
	pop bc			;1223
	pop bc			;1224
	pop bc			;1225
	ld de,00001h		;1226
	or a			;1229
	sbc hl,de		;122a
	jr nz,l1236h		;122c
	ld l,(ix-001h)		;122e
	ld h,000h		;1231
	jp cret			;1233
l1236h:
	set 4,(iy+006h)		;1236
	ld hl,0ffffh		;123a
	jp cret			;123d
l1240h:
	ld hl,00200h		;1240
	push hl			;1243
	ld l,(iy+004h)		;1244
	ld h,(iy+005h)		;1247
	push hl			;124a
	ld l,(iy+007h)		;124b
	ld h,000h		;124e
	push hl			;1250
	call _read		;1251
	pop bc			;1254
	pop bc			;1255
	pop bc			;1256
	ex de,hl		;1257
	ld (iy+002h),e		;1258
	ld (iy+003h),d		;125b
	ld hl,00000h		;125e
	or a			;1261
	sbc hl,de		;1262
	jp m,l127dh		;1264
	ld a,e			;1267
	or (iy+003h)		;1268
	jr nz,l1273h		;126b
	set 4,(iy+006h)		;126d
	jr l1277h		;1271
l1273h:
	set 5,(iy+006h)		;1273
l1277h:
	ld hl,0ffffh		;1277
	jp cret			;127a
l127dh:
	ld l,(iy+004h)		;127d
	ld h,(iy+005h)		;1280
	ld (iy+000h),l		;1283
	ld (iy+001h),h		;1286
	ld l,(iy+002h)		;1289
	ld h,(iy+003h)		;128c
	dec hl			;128f
	ld (iy+002h),l		;1290
	ld (iy+003h),h		;1293
	ld l,(iy+000h)		;1296
	ld h,(iy+001h)		;1299
	inc hl			;129c
	ld (iy+000h),l		;129d
	ld (iy+001h),h		;12a0
	dec hl			;12a3
	ld l,(hl)		;12a4
	ld h,000h		;12a5
	jp cret			;12a7
;==========================================================================
; 29	cpm_clean
;==========================================================================
_cpm_clean:
	call csv		;12aa
	dec sp			;12ad
	ld (ix-001h),008h	;12ae
	ld iy,l2751h	;stdin	;12b2
l12b6h:
	push iy			;12b6
	call _fclose		;12b8
	pop bc			;12bb
	ld de,00008h		;12bc
	add iy,de		;12bf
	ld a,(ix-001h)		;12c1
	add a,0ffh		;12c4
	ld (ix-001h),a		;12c6
	or a			;12c9
	jr nz,l12b6h		;12ca
	jp cret			;12cc
;==========================================================================
; 30	fclose
;==========================================================================
_fclose:
	call csv		;12cf
	ld c,(ix+006h)		;12d2
	ld b,(ix+007h)		;12d5
	push bc			;12d8
	pop iy			;12d9
	ld a,(iy+006h)		;12db
	and 003h		;12de
	or a			;12e0
	jr nz,l12e9h		;12e1
	ld hl,0ffffh		;12e3
	jp cret			;12e6
l12e9h:
	push iy			;12e9
	call _fflush		;12eb
	pop bc			;12ee
	ld a,(iy+006h)		;12ef
	and 0f8h		;12f2
	ld (iy+006h),a		;12f4
	ld a,(iy+004h)		;12f7
	or (iy+005h)		;12fa
	jr z,l1318h		;12fd
	bit 3,(iy+006h)		;12ff
	jr nz,l1318h		;1303
	ld l,(iy+004h)		;1305
	ld h,(iy+005h)		;1308
	push hl			;130b
	call __buffree		;130c
	pop bc			;130f
	ld (iy+004h),000h	;1310
	ld (iy+005h),000h	;1314
l1318h:
	ld l,(iy+007h)		;1318
	ld h,000h		;131b
	push hl			;131d
	call _close		;131e
	pop bc			;1321
	ld de,0ffffh		;1322
	or a			;1325
	sbc hl,de		;1326
	jr z,l1330h		;1328
	bit 5,(iy+006h)		;132a
	jr z,l1336h		;132e
l1330h:
	ld hl,0ffffh		;1330
	jp cret			;1333
l1336h:
	ld hl,00000h		;1336
	jp cret			;1339
;==========================================================================
; 31	fflush
;==========================================================================
_fflush:
	call csv		;133c
	push bc			;133f
	ld c,(ix+006h)		;1340
	ld b,(ix+007h)		;1343
	push bc			;1346
	pop iy			;1347
	bit 1,(iy+006h)		;1349
	jr z,l136dh		;134d
	ld a,(iy+004h)		;134f
	or (iy+005h)		;1352
	jr z,l136dh		;1355
	ld e,(iy+002h)		;1357
	ld d,(iy+003h)		;135a
	ld hl,00200h		;135d
	or a			;1360
	sbc hl,de		;1361
	ld (ix-002h),l		;1363
	ld (ix-001h),h		;1366
	ld a,l			;1369
	or h			;136a
	jr nz,l1373h		;136b
l136dh:
	ld hl,00000h		;136d
	jp cret			;1370
l1373h:
	ld l,(ix-002h)		;1373
	ld h,(ix-001h)		;1376
	push hl			;1379
	ld l,(iy+004h)		;137a
	ld h,(iy+005h)		;137d
	push hl			;1380
	ld l,(iy+007h)		;1381
	ld h,000h		;1384
	push hl			;1386
	call _write		;1387
	pop bc			;138a
	pop bc			;138b
	pop bc			;138c
	ld e,(ix-002h)		;138d
	ld d,(ix-001h)		;1390
	or a			;1393
	sbc hl,de		;1394
	jr z,l139ch		;1396
	set 5,(iy+006h)		;1398
l139ch:
	ld (iy+002h),000h	;139c
	ld (iy+003h),002h	;13a0
	ld l,(iy+004h)		;13a4
	ld h,(iy+005h)		;13a7
	ld (iy+000h),l		;13aa
	ld (iy+001h),h		;13ad
	bit 5,(iy+006h)		;13b0
	jr z,l13bch		;13b4
	ld hl,0ffffh		;13b6
	jp cret			;13b9
l13bch:
	ld hl,00000h		;13bc
	jp cret			;13bf
;==========================================================================
; 32	_bufallo
;==========================================================================
__bufallo:
	call csv		;13c2
	ld iy,(_freep)		;13c5 0x2d0fh
	push iy			;13c9
	pop hl			;13cb
	ld a,l			;13cc
	or h			;13cd
	jr z,l13dbh		;13ce
	ld l,(iy+000h)		;13d0
	ld h,(iy+001h)		;13d3
	ld (_freep),hl		;13d6
	jr l13e6h		;13d9
l13dbh:
	ld hl,00200h		;13db
	push hl			;13de
	call _sbrk		;13df
	pop bc			;13e2
	push hl			;13e3
	pop iy			;13e4
l13e6h:
	push iy			;13e6
	pop hl			;13e8
	jp cret			;13e9
;==========================================================================
; 33	_buffree
;==========================================================================
__buffree:
	call csv		;13ec
	ld l,(ix+006h)		;13ef
	ld h,(ix+007h)		;13f2
	push hl			;13f5
	pop iy			;13f6
	ld hl,(_freep)		;13f8
	ld (iy+000h),l		;13fb
	ld (iy+001h),h		;13fe
	ld (_freep),iy		;1401
	jp cret			;1405
;==========================================================================
; 34	
;==========================================================================
exit:
	call csv		;1408
	call _cpm_clean		;140b
	ld l,(ix+006h)		;140e
	ld h,(ix+007h)		;1411
	push hl			;1414
	call __exit		;1415
	jp cret			;1418
;==========================================================================
; 35	startup
;==========================================================================
startup:
	jp __getargs		;141b
;==========================================================================
; 36	_getargs
;==========================================================================
__getargs:
	pop hl			;141e
	exx			;141f
	pop hl			;1420
	pop hl			;1421
	ld a,(00080h)		;1422
	inc a			;1425
	neg			;1426
	ld l,a			;1428
	ld h,0ffh		;1429
	add hl,sp		;142b
	ld sp,hl		;142c
	ld bc,00000h		;142d
	push bc			;1430
	ld hl,00080h		;1431
	ld c,(hl)		;1434
	ld b,000h		;1435
	add hl,bc		;1437
	ld b,c			;1438
	ex de,hl		;1439
	ld hl,(00006h)		;143a
	ld c,001h		;143d
	dec hl			;143f
	ld (hl),000h		;1440
	inc b			;1442
	jr l1450h		;1443
l1445h:
	ld a,(de)		;1445
	cp 020h			;1446
	dec de			;1448
	jr nz,l144eh		;1449
	xor a			;144b
	push hl			;144c
	inc c			;144d
l144eh:
	dec hl			;144e
	ld (hl),a		;144f
l1450h:
	djnz l1445h		;1450
	ld (__argc_),bc		;1452
	ld hl,nularg		;1456
	push hl			;1459
	ld hl,00000h		;145a
	add hl,sp		;145d
	exx			;145e
	push de			;145f
	push de			;1460
	push hl			;1461
	exx			;1462
	ret			;1463
;==========================================================================
; 37	open
;==========================================================================
_open:
	call csv		;1464
	dec sp			;1467
	ld e,(ix+008h)		;1468
	ld d,(ix+009h)		;146b
	inc de			;146e
	ld (ix+008h),e		;146f
	ld (ix+009h),d		;1472
	ld hl,00003h		;1475
	or a			;1478
	sbc hl,de		;1479
	jp p,l1486h		;147b
	ld (ix+008h),003h	;147e
	ld (ix+009h),000h	;1482
l1486h:
	call _getfcb		;1486
	push hl			;1489
	pop iy			;148a
	ld a,l			;148c
	or h			;148d
	jr nz,l1496h		;148e
l1490h:
	ld hl,0ffffh		;1490
	jp cret			;1493
l1496h:
	ld l,(ix+006h)		;1496
	ld h,(ix+007h)		;1499
	push hl			;149c
	push iy			;149d
	call _setfcb		;149f
	pop bc			;14a2
	pop bc			;14a3
	ld a,l			;14a4
	or h			;14a5
	jr nz,l14e8h		;14a6
	call _getuid		;14a8
	ld (ix-001h),l		;14ab
	ld l,(iy+029h)		;14ae
	ld h,000h		;14b1
	push hl			;14b3
	call _setuid		;14b4
	pop bc			;14b7
	push iy			;14b8
	ld hl,0000fh		;14ba
	push hl			;14bd
	call _bdos		;14be
	pop bc			;14c1
	pop bc			;14c2
	ld a,l			;14c3
	cp 0ffh			;14c4
	jr nz,l14d8h		;14c6
	ld (iy+024h),000h	;14c8
	ld l,(ix-001h)		;14cc
	ld h,000h		;14cf
	push hl			;14d1
	call _setuid		;14d2
	pop bc			;14d5
	jr l1490h		;14d6
l14d8h:
	ld l,(ix-001h)		;14d8
	ld h,000h		;14db
	push hl			;14dd
	call _setuid		;14de
	pop bc			;14e1
	ld a,(ix+008h)		;14e2
	ld (iy+024h),a		;14e5
l14e8h:
	ld de,__fcb		;14e8
	push iy			;14eb
	pop hl			;14ed
	or a			;14ee
	sbc hl,de		;14ef
	ld de,0002ah		;14f1
	call adiv		;14f4
	jp cret			;14f7
;==========================================================================
; 38	read
;==========================================================================
_read:
	call csv		;14fa
	ld hl,0ff77h		;14fd
	add hl,sp		;1500
	ld sp,hl		;1501
	ld (ix-005h),000h	;1502
	ld (ix-004h),000h	;1506
	ld a,(ix+006h)		;150a
	cp 008h			;150d
	jr c,l1517h		;150f
	ld hl,0ffffh		;1511
	jp cret			;1514
l1517h:
	ld de,0002ah		;1517
	ld l,(ix+006h)		;151a
	ld h,000h		;151d
	call amul		;151f
	ld de,__fcb		;1522
	add hl,de		;1525
	push hl			;1526
	pop iy			;1527
	ld a,(iy+024h)		;1529
	cp 001h			;152c
	jp z,l1634h		;152e
	cp 003h			;1531
	jp z,l1634h		;1533
	cp 004h			;1536
	jr z,l1595h		;1538
	cp 005h			;153a
	jp nz,l1775h		;153c
	ld l,(ix+00ah)		;153f
	ld h,(ix+00bh)		;1542
	ld (ix-005h),l		;1545
	ld (ix-004h),h		;1548
l154bh:
	ld a,(ix+00ah)		;154b
	or (ix+00bh)		;154e
	jr nz,l1565h		;1551
l1553h:
	ld e,(ix+00ah)		;1553
	ld d,(ix+00bh)		;1556
	ld l,(ix-005h)		;1559
	ld h,(ix-004h)		;155c
	or a			;155f
	sbc hl,de		;1560
	jp cret			;1562
l1565h:
	ld l,(ix+00ah)		;1565
	ld h,(ix+00bh)		;1568
	dec hl			;156b
	ld (ix+00ah),l		;156c
	ld (ix+00bh),h		;156f
	ld hl,00003h		;1572
	push hl			;1575
	call _bdos		;1576
	pop bc			;1579
	ld a,l			;157a
	rla			;157b
	sbc a,a			;157c
	ld a,l			;157d
	and 07fh		;157e
	ld l,(ix+008h)		;1580
	ld h,(ix+009h)		;1583
	inc hl			;1586
	ld (ix+008h),l		;1587
	ld (ix+009h),h		;158a
	dec hl			;158d
	ld (hl),a		;158e
	cp 00ah			;158f
	jr nz,l154bh		;1591
	jr l1553h		;1593
l1595h:
	ld e,(ix+00ah)		;1595
	ld d,(ix+00bh)		;1598
	ld hl,00080h		;159b
	or a			;159e
	sbc hl,de		;159f
	jr nc,l15abh		;15a1
	ld (ix+00ah),080h	;15a3
	ld (ix+00bh),000h	;15a7
l15abh:
	ld a,(ix+00ah)		;15ab
	push ix			;15ae
	pop de			;15b0
	ld hl,0ff77h		;15b1
	add hl,de		;15b4
	ld (hl),a		;15b5
	push ix			;15b6
	pop de			;15b8
	ld hl,0ff77h		;15b9
	add hl,de		;15bc
	push hl			;15bd
	ld hl,0000ah		;15be
	push hl			;15c1
	call _bdos		;15c2
	pop bc			;15c5
	pop bc			;15c6
	push ix			;15c7
	pop de			;15c9
	ld hl,0ff78h		;15ca
	add hl,de		;15cd
	ld l,(hl)		;15ce
	ld h,000h		;15cf
	ld (ix-005h),l		;15d1
	ld (ix-004h),h		;15d4
	ld e,(ix+00ah)		;15d7
	ld d,(ix+00bh)		;15da
	ld h,(ix-004h)		;15dd
	or a			;15e0
	sbc hl,de		;15e1
	jr nc,l160fh		;15e3
	ld hl,0000ah		;15e5
	push hl			;15e8
	ld hl,00002h		;15e9
	push hl			;15ec
	call _bdos		;15ed
	pop bc			;15f0
	pop bc			;15f1
	push ix			;15f2
	pop de			;15f4
	ld l,(ix-005h)		;15f5
	ld h,(ix-004h)		;15f8
	add hl,de		;15fb
	ld de,0ff79h		;15fc
	add hl,de		;15ff
	ld (hl),00ah		;1600
	ld l,(ix-005h)		;1602
	ld h,(ix-004h)		;1605
	inc hl			;1608
	ld (ix-005h),l		;1609
	ld (ix-004h),h		;160c
l160fh:
	ld l,(ix-005h)		;160f
	ld h,(ix-004h)		;1612
	push hl			;1615
	ld l,(ix+008h)		;1616
	ld h,(ix+009h)		;1619
	push hl			;161c
	push ix			;161d
	pop de			;161f
	ld hl,0ff79h		;1620
	add hl,de		;1623
	push hl			;1624
	call _bmove		;1625
	pop bc			;1628
	pop bc			;1629
	pop bc			;162a
	ld l,(ix-005h)		;162b
	ld h,(ix-004h)		;162e
	jp cret			;1631
l1634h:
	call _getuid		;1634
	ld (ix-003h),l		;1637
	ld l,(ix+00ah)		;163a
	ld h,(ix+00bh)		;163d
	ld (ix-005h),l		;1640
	ld (ix-004h),h		;1643
	jp l1750h		;1646
l1649h:
	call __sigchk		;1649
	ld l,(iy+029h)		;164c
	ld h,000h		;164f
	push hl			;1651
	call _setuid		;1652
	pop bc			;1655
	ld de,00080h		;1656
	ld hl,00000h		;1659
	push hl			;165c
	push de			;165d
	ld e,(iy+025h)		;165e
	ld d,(iy+026h)		;1661
	ld l,(iy+027h)		;1664
	ld h,(iy+028h)		;1667
	call aldiv		;166a
	ld (ix-007h),e		;166d
	ld (ix-006h),d		;1670
	ld a,(iy+025h)		;1673
	and 07fh		;1676
	ld (ix-002h),a		;1678
	ld l,a			;167b
	ld e,l			;167c
	ld a,080h		;167d
	sub e			;167f
	ld (ix-001h),a		;1680
	ld e,a			;1683
	ld d,000h		;1684
	ld l,(ix+00ah)		;1686
	ld h,(ix+00bh)		;1689
	or a			;168c
	sbc hl,de		;168d
	jr nc,l1697h		;168f
	ld a,(ix+00ah)		;1691
	ld (ix-001h),a		;1694
l1697h:
	ld l,(ix-007h)		;1697
	ld h,(ix-006h)		;169a
	ld (iy+021h),l		;169d
	ld (iy+022h),h		;16a0
	ld (iy+023h),000h	;16a3
	ld a,(ix-001h)		;16a7
	cp 080h			;16aa
	jr nz,l16d0h		;16ac
	ld l,(ix+008h)		;16ae
	ld h,(ix+009h)		;16b1
	push hl			;16b4
	ld hl,0001ah		;16b5
	push hl			;16b8
	call _bdos		;16b9
	pop bc			;16bc
	pop bc			;16bd
	push iy			;16be
	ld hl,00021h		;16c0
	push hl			;16c3
	call _bdos		;16c4
	pop bc			;16c7
	pop bc			;16c8
	ld a,l			;16c9
	or a			;16ca
	jr z,l1711h		;16cb
	jp l1759h		;16cd
l16d0h:
	push ix			;16d0
	pop de			;16d2
	ld hl,0ff77h		;16d3
	add hl,de		;16d6
	push hl			;16d7
	ld hl,0001ah		;16d8
	push hl			;16db
	call _bdos		;16dc
	pop bc			;16df
	pop bc			;16e0
	push iy			;16e1
	ld hl,00021h		;16e3
	push hl			;16e6
	call _bdos		;16e7
	pop bc			;16ea
	pop bc			;16eb
	ld a,l			;16ec
	or a			;16ed
	jr nz,l1759h		;16ee
	ld l,(ix-001h)		;16f0
	ld h,000h		;16f3
	push hl			;16f5
	ld l,(ix+008h)		;16f6
	ld h,(ix+009h)		;16f9
	push hl			;16fc
	push ix			;16fd
	pop de			;16ff
	ld l,(ix-002h)		;1700
	ld h,000h		;1703
	add hl,de		;1705
	ld de,0ff77h		;1706
	add hl,de		;1709
	push hl			;170a
	call _bmove		;170b
	pop bc			;170e
	pop bc			;170f
	pop bc			;1710
l1711h:
	ld e,(ix-001h)		;1711
	ld d,000h		;1714
	ld l,(ix+008h)		;1716
	ld h,(ix+009h)		;1719
	add hl,de		;171c
	ld (ix+008h),l		;171d
	ld (ix+009h),h		;1720
	ld hl,00000h		;1723
	ld d,l			;1726
	push hl			;1727
	push de			;1728
	push iy			;1729
	pop de			;172b
	ld hl,00025h		;172c
	add hl,de		;172f
	call asaladd		;1730
	ld e,(ix-001h)		;1733
	ld d,000h		;1736
	ld l,(ix+00ah)		;1738
	ld h,(ix+00bh)		;173b
	or a			;173e
	sbc hl,de		;173f
	ld (ix+00ah),l		;1741
	ld (ix+00bh),h		;1744
	ld l,(ix-003h)		;1747
	ld h,d			;174a
	push hl			;174b
	call _setuid		;174c
	pop bc			;174f
l1750h:
	ld a,(ix+00ah)		;1750
	or (ix+00bh)		;1753
	jp nz,l1649h		;1756
l1759h:
	ld l,(ix-003h)		;1759
	ld h,000h		;175c
	push hl			;175e
	call _setuid		;175f
	pop bc			;1762
	ld e,(ix+00ah)		;1763
	ld d,(ix+00bh)		;1766
	ld l,(ix-005h)		;1769
	ld h,(ix-004h)		;176c
	or a			;176f
	sbc hl,de		;1770
	jp cret			;1772
l1775h:
	ld hl,0ffffh		;1775
	jp cret			;1778
;==========================================================================
; 39	write
;==========================================================================
_write:
	call csv		;177b
	ld hl,0ff77h		;177e
	add hl,sp		;1781
	ld sp,hl		;1782
	ld a,(ix+006h)		;1783
	cp 008h			;1786
	jr c,l1790h		;1788
l178ah:
	ld hl,0ffffh		;178a
	jp cret			;178d
l1790h:
	ld de,0002ah		;1790
	ld l,(ix+006h)		;1793
	ld h,000h		;1796
	call amul		;1798
	ld de,__fcb		;179b
	add hl,de		;179e
	push hl			;179f
	pop iy			;17a0
	ld (ix-002h),002h	;17a2
	ld l,(ix+00ah)		;17a6
	ld h,(ix+00bh)		;17a9
	ld (ix-009h),l		;17ac
	ld (ix-008h),h		;17af
	ld a,(iy+024h)		;17b2
	cp 002h			;17b5
	jp z,l1866h		;17b7
	cp 003h			;17ba
	jp z,l1866h		;17bc
	cp 004h			;17bf
	jp z,l1852h		;17c1
	cp 006h			;17c4
	jr z,l17edh		;17c6
	cp 007h			;17c8
	jr z,l1808h		;17ca
	jr l178ah		;17cc
l17ceh:
	call __sigchk		;17ce
	ld l,(ix+008h)		;17d1
	ld h,(ix+009h)		;17d4
	ld a,(hl)		;17d7
	inc hl			;17d8
	ld (ix+008h),l		;17d9
	ld (ix+009h),h		;17dc
	ld l,a			;17df
	rla			;17e0
	sbc a,a			;17e1
	ld h,a			;17e2
	push hl			;17e3
	ld hl,00004h		;17e4
	push hl			;17e7
	call _bdos		;17e8
	pop bc			;17eb
	pop bc			;17ec
l17edh:
	ld l,(ix+00ah)		;17ed
	ld h,(ix+00bh)		;17f0
	dec hl			;17f3
	ld (ix+00ah),l		;17f4
	ld (ix+00bh),h		;17f7
	inc hl			;17fa
	ld a,l			;17fb
	or h			;17fc
	jr nz,l17ceh		;17fd
l17ffh:
	ld l,(ix-009h)		;17ff
	ld h,(ix-008h)		;1802
	jp cret			;1805
l1808h:
	ld (ix-002h),005h	;1808
	jr l1852h		;180c
l180eh:
	call __sigchk		;180e
	ld l,(ix+008h)		;1811
	ld h,(ix+009h)		;1814
	ld a,(hl)		;1817
	inc hl			;1818
	ld (ix+008h),l		;1819
	ld (ix+009h),h		;181c
	ld l,a			;181f
	rla			;1820
	sbc a,a			;1821
	ld h,a			;1822
	ld (ix-005h),l		;1823
	ld (ix-004h),h		;1826
	ld de,0000ah		;1829
	or a			;182c
	sbc hl,de		;182d
	jr nz,l1840h		;182f
	ld hl,0000dh		;1831
	push hl			;1834
	ld l,(ix-002h)		;1835
	ld h,000h		;1838
	push hl			;183a
	call _bdos		;183b
	pop bc			;183e
	pop bc			;183f
l1840h:
	ld l,(ix-005h)		;1840
	ld h,(ix-004h)		;1843
	push hl			;1846
	ld l,(ix-002h)		;1847
	ld h,000h		;184a
	push hl			;184c
	call _bdos		;184d
	pop bc			;1850
	pop bc			;1851
l1852h:
	ld l,(ix+00ah)		;1852
	ld h,(ix+00bh)		;1855
	dec hl			;1858
	ld (ix+00ah),l		;1859
	ld (ix+00bh),h		;185c
	inc hl			;185f
	ld a,l			;1860
	or h			;1861
	jr nz,l180eh		;1862
	jr l17ffh		;1864
l1866h:
	call _getuid		;1866
	ld (ix-003h),l		;1869
	jp l1992h		;186c
l186fh:
	call __sigchk		;186f
	ld l,(iy+029h)		;1872
	ld h,000h		;1875
	push hl			;1877
	call _setuid		;1878
	pop bc			;187b
	ld de,00080h		;187c
	ld hl,00000h		;187f
	push hl			;1882
	push de			;1883
	ld e,(iy+025h)		;1884
	ld d,(iy+026h)		;1887
	ld l,(iy+027h)		;188a
	ld h,(iy+028h)		;188d
	call aldiv		;1890
	ld (ix-007h),e		;1893
	ld (ix-006h),d		;1896
	ld a,(iy+025h)		;1899
	and 07fh		;189c
	ld (ix-002h),a		;189e
	ld l,a			;18a1
	ld e,l			;18a2
	ld a,080h		;18a3
	sub e			;18a5
	ld (ix-001h),a		;18a6
	ld e,a			;18a9
	ld d,000h		;18aa
	ld l,(ix+00ah)		;18ac
	ld h,(ix+00bh)		;18af
	or a			;18b2
	sbc hl,de		;18b3
	jr nc,l18bdh		;18b5
	ld a,(ix+00ah)		;18b7
	ld (ix-001h),a		;18ba
l18bdh:
	ld l,(ix-007h)		;18bd
	ld h,(ix-006h)		;18c0
	ld (iy+021h),l		;18c3
	ld (iy+022h),h		;18c6
	ld (iy+023h),000h	;18c9
	ld a,(ix-001h)		;18cd
	cp 080h			;18d0
	jr nz,l18e6h		;18d2
	ld l,(ix+008h)		;18d4
	ld h,(ix+009h)		;18d7
	push hl			;18da
	ld hl,0001ah		;18db
	push hl			;18de
	call _bdos		;18df
	pop bc			;18e2
	pop bc			;18e3
	jr l1944h		;18e4
l18e6h:
	push ix			;18e6
	pop de			;18e8
	ld hl,0ff77h		;18e9
	add hl,de		;18ec
	push hl			;18ed
	ld hl,0001ah		;18ee
	push hl			;18f1
	call _bdos		;18f2
	pop bc			;18f5
	push ix			;18f6
	pop de			;18f8
	ld hl,0ff77h		;18f9
	add hl,de		;18fc
	ld (hl),01ah		;18fd
	ld hl,0007fh		;18ff
	ex (sp),hl		;1902
	push ix			;1903
	pop de			;1905
	ld hl,0ff78h		;1906
	add hl,de		;1909
	push hl			;190a
	push ix			;190b
	pop de			;190d
	ld hl,0ff77h		;190e
	add hl,de		;1911
	push hl			;1912
	call _bmove		;1913
	pop bc			;1916
	pop bc			;1917
	pop bc			;1918
	push iy			;1919
	ld hl,00021h		;191b
	push hl			;191e
	call _bdos		;191f
	pop bc			;1922
	ld l,(ix-001h)		;1923
	ld h,000h		;1926
	ex (sp),hl		;1928
	push ix			;1929
	pop de			;192b
	ld l,(ix-002h)		;192c
	ld h,000h		;192f
	add hl,de		;1931
	ld de,0ff77h		;1932
	add hl,de		;1935
	push hl			;1936
	ld l,(ix+008h)		;1937
	ld h,(ix+009h)		;193a
	push hl			;193d
	call _bmove		;193e
	pop bc			;1941
	pop bc			;1942
	pop bc			;1943
l1944h:
	push iy			;1944
	ld hl,00022h		;1946
	push hl			;1949
	call _bdos		;194a
	pop bc			;194d
	pop bc			;194e
	ld a,l			;194f
	or a			;1950
	jr nz,l199bh		;1951
	ld e,(ix-001h)		;1953
	ld d,000h		;1956
	ld l,(ix+008h)		;1958
	ld h,(ix+009h)		;195b
	add hl,de		;195e
	ld (ix+008h),l		;195f
	ld (ix+009h),h		;1962
	ld hl,00000h		;1965
	ld d,l			;1968
	push hl			;1969
	push de			;196a
	push iy			;196b
	pop de			;196d
	ld hl,00025h		;196e
	add hl,de		;1971
	call asaladd		;1972
	ld e,(ix-001h)		;1975
	ld d,000h		;1978
	ld l,(ix+00ah)		;197a
	ld h,(ix+00bh)		;197d
	or a			;1980
	sbc hl,de		;1981
	ld (ix+00ah),l		;1983
	ld (ix+00bh),h		;1986
	ld l,(ix-003h)		;1989
	ld h,d			;198c
	push hl			;198d
	call _setuid		;198e
	pop bc			;1991
l1992h:
	ld a,(ix+00ah)		;1992
	or (ix+00bh)		;1995
	jp nz,l186fh		;1998
l199bh:
	ld l,(ix-003h)		;199b
	ld h,000h		;199e
	push hl			;19a0
	call _setuid		;19a1
	pop bc			;19a4
	ld e,(ix+00ah)		;19a5
	ld d,(ix+00bh)		;19a8
	ld l,(ix-009h)		;19ab
	ld h,(ix-008h)		;19ae
	or a			;19b1
	sbc hl,de		;19b2
	jp cret			;19b4
;==========================================================================
; 40	_fsize
;==========================================================================
__fsize:
	call csv		;19b7
	push bc			;19ba
	push bc			;19bb
	ld a,(ix+006h)		;19bc
	cp 008h			;19bf
	jr c,l19cbh		;19c1
	ld de,0ffffh		;19c3
	ld l,e			;19c6
	ld h,d			;19c7
	jp cret			;19c8
l19cbh:
	ld de,0002ah		;19cb
	ld l,(ix+006h)		;19ce
	ld h,000h		;19d1
	call amul		;19d3
	ld de,__fcb		;19d6
	add hl,de		;19d9
	push hl			;19da
	pop iy			;19db
	push hl			;19dd
	ld hl,00023h		;19de
	push hl			;19e1
	call _bdos		;19e2
	pop bc			;19e5
	pop bc			;19e6
	ld b,007h		;19e7
	ld e,(iy+021h)		;19e9
	ld d,(iy+022h)		;19ec
	ld hl,00000h		;19ef
	call allsh		;19f2
	ld (ix-004h),e		;19f5
	ld (ix-003h),d		;19f8
	ld (ix-002h),l		;19fb
	ld (ix-001h),h		;19fe
	push hl			;1a01
	push de			;1a02
	ld e,(iy+025h)		;1a03
	ld d,(iy+026h)		;1a06
	ld l,(iy+027h)		;1a09
	ld h,(iy+028h)		;1a0c
	call lrelop		;1a0f
	jp p,l1a24h		;1a12
	ld e,(ix-004h)		;1a15
	ld d,(ix-003h)		;1a18
	ld l,(ix-002h)		;1a1b
	ld h,(ix-001h)		;1a1e
	jp cret			;1a21
l1a24h:
	ld e,(iy+025h)		;1a24
	ld d,(iy+026h)		;1a27
	ld l,(iy+027h)		;1a2a
	ld h,(iy+028h)		;1a2d
	jp cret			;1a30
;==========================================================================
; 41	lseek
;==========================================================================
_lseek:
	call csv		;1a33
	ld a,(ix+006h)		;1a36
	cp 008h			;1a39
	jr c,l1a45h		;1a3b
	ld de,0ffffh		;1a3d
	ld l,e			;1a40
	ld h,d			;1a41
	jp cret			;1a42
l1a45h:
	ld de,0002ah		;1a45
	ld l,(ix+006h)		;1a48
	ld h,000h		;1a4b
	call amul		;1a4d
	ld de,__fcb		;1a50
	add hl,de		;1a53
	push hl			;1a54
	pop iy			;1a55
	ld a,(ix+00ch)		;1a57
	cp 001h			;1a5a
	jr z,l1a89h		;1a5c
	cp 002h			;1a5e
	ld e,(ix+008h)		;1a60
	ld d,(ix+009h)		;1a63
	ld l,(ix+00ah)		;1a66
	ld h,(ix+00bh)		;1a69
	jr z,l1aa3h		;1a6c
	ld (iy+025h),e		;1a6e
	ld (iy+026h),d		;1a71
	ld (iy+027h),l		;1a74
	ld (iy+028h),h		;1a77
l1a7ah:
	ld e,(iy+025h)		;1a7a
	ld d,(iy+026h)		;1a7d
	ld l,(iy+027h)		;1a80
	ld h,(iy+028h)		;1a83
	jp cret			;1a86
l1a89h:
	ld e,(ix+008h)		;1a89
	ld d,(ix+009h)		;1a8c
	ld l,(ix+00ah)		;1a8f
	ld h,(ix+00bh)		;1a92
	push hl			;1a95
	push de			;1a96
	push iy			;1a97
	pop de			;1a99
	ld hl,00025h		;1a9a
	add hl,de		;1a9d
	call asaladd		;1a9e
	jr l1a7ah		;1aa1
l1aa3h:
	push hl			;1aa3
	push de			;1aa4
	ld l,(ix+006h)		;1aa5
	ld h,000h		;1aa8
	push hl			;1aaa
	call __fsize		;1aab
	pop bc			;1aae
	call aladd		;1aaf
	ld (iy+025h),e		;1ab2
	ld (iy+026h),d		;1ab5
	ld (iy+027h),l		;1ab8
	ld (iy+028h),h		;1abb
	jr l1a7ah		;1abe
;==========================================================================
; 42	creat
;==========================================================================
creat:
	call csv		;1ac0
	dec sp			;1ac3
	call _getfcb		;1ac4
	push hl			;1ac7
	pop iy			;1ac8
	ld a,l			;1aca
	or h			;1acb
	jr nz,l1ad4h		;1acc
l1aceh:
	ld hl,0ffffh		;1ace
	jp cret			;1ad1
l1ad4h:
	call _getuid		;1ad4
	ld (ix-001h),l		;1ad7
	ld l,(ix+006h)		;1ada
	ld h,(ix+007h)		;1add
	push hl			;1ae0
	push iy			;1ae1
	call _setfcb		;1ae3
	pop bc			;1ae6
	pop bc			;1ae7
	ld a,l			;1ae8
	or h			;1ae9
	jr nz,l1b28h		;1aea
	ld l,(ix+006h)		;1aec
	ld h,(ix+007h)		;1aef
	push hl			;1af2
	call _unlink		;1af3
	ld l,(iy+029h)		;1af6
	ld h,000h		;1af9
	ex (sp),hl		;1afb
	call _setuid		;1afc
	pop bc			;1aff
	push iy			;1b00
	ld hl,00016h		;1b02
	push hl			;1b05
	call _bdos		;1b06
	pop bc			;1b09
	pop bc			;1b0a
	ld a,l			;1b0b
	cp 0ffh			;1b0c
	ld l,(ix-001h)		;1b0e
	ld h,000h		;1b11
	push hl			;1b13
	jr nz,l1b20h		;1b14
	call _setuid		;1b16
	pop bc			;1b19
	ld (iy+024h),000h	;1b1a
	jr l1aceh		;1b1e
l1b20h:
	call _setuid		;1b20
	pop bc			;1b23
	ld (iy+024h),002h	;1b24
l1b28h:
	ld (iy+010h),000h	;1b28
	ld hl,0000fh		;1b2c
	push hl			;1b2f
	push iy			;1b30
	pop de			;1b32
	ld hl,00011h		;1b33
	add hl,de		;1b36
	push hl			;1b37
	push iy			;1b38
	pop de			;1b3a
	ld hl,00010h		;1b3b
	add hl,de		;1b3e
	push hl			;1b3f
	call _bmove		;1b40
	pop bc			;1b43
	pop bc			;1b44
	pop bc			;1b45
	ld de,__fcb		;1b46
	push iy			;1b49
	pop hl			;1b4b
	or a			;1b4c
	sbc hl,de		;1b4d
	ld de,0002ah		;1b4f
	call adiv		;1b52
	jp cret			;1b55
;==========================================================================
; 43	_cpm_cle
;==========================================================================
__cpm_cle:
	call csv		;1b58
	dec sp			;1b5b
	ld (ix-001h),000h	;1b5c
l1b60h:
	ld l,(ix-001h)		;1b60
	ld h,000h		;1b63
	push hl			;1b65
	call _close		;1b66
	pop bc			;1b69
	inc (ix-001h)		;1b6a
	ld a,(ix-001h)		;1b6d
	cp 008h			;1b70
	jr c,l1b60h		;1b72
	jp cret			;1b74
;==========================================================================
; 44	getfcb
;==========================================================================
_getfcb:
	call csv		;1b77
	ld iy,__fcb		;1b7a
	jr l1ba5h		;1b7e
l1b80h:
	ld a,(iy+024h)		;1b80
	or a			;1b83
	jr nz,l1ba0h		;1b84
	ld (iy+024h),001h	;1b86
	ld (iy+025h),000h	;1b8a
	ld (iy+026h),000h	;1b8e
	ld (iy+027h),000h	;1b92
	ld (iy+028h),000h	;1b96
	push iy			;1b9a
	pop hl			;1b9c
	jp cret			;1b9d
l1ba0h:
	ld de,0002ah		;1ba0
	add iy,de		;1ba3
l1ba5h:
	ld de,l28e2h		;1ba5
	push iy			;1ba8
	pop hl			;1baa
	or a			;1bab
	sbc hl,de		;1bac
	jr c,l1b80h		;1bae
	ld hl,00000h		;1bb0
	jp cret			;1bb3
;==========================================================================
; 45	close
;==========================================================================
_close:
	call csv		;1bb6
	dec sp			;1bb9
	ld a,(ix+006h)		;1bba
	cp 008h			;1bbd
	jp nc,cret		;1bbf
	ld de,0002ah		;1bc2
	ld l,a			;1bc5
	ld h,000h		;1bc6
	call amul		;1bc8
	ld de,__fcb		;1bcb
	add hl,de		;1bce
	push hl			;1bcf
	pop iy			;1bd0
	ld a,(iy+024h)		;1bd2
	cp 002h			;1bd5
	jr z,l1bf0h		;1bd7
	cp 003h			;1bd9
	jr z,l1bf0h		;1bdb
	ld hl,0000ch		;1bdd
	push hl			;1be0
	call _bdoshl		;1be1
	pop bc			;1be4
	bit 0,h			;1be5
	jr z,l1c13h		;1be7
	ld a,(iy+024h)		;1be9
	cp 001h			;1bec
	jr nz,l1c13h		;1bee
l1bf0h:
	call _getuid		;1bf0
	ld (ix-001h),l		;1bf3
	ld l,(iy+029h)		;1bf6
	ld h,000h		;1bf9
	push hl			;1bfb
	call _setuid		;1bfc
	pop bc			;1bff
	push iy			;1c00
	ld hl,00010h		;1c02
	push hl			;1c05
	call _bdos		;1c06
	pop bc			;1c09
	ld l,(ix-001h)		;1c0a
	ld h,000h		;1c0d
	ex (sp),hl		;1c0f
	call _setuid		;1c10
l1c13h:
	ld (iy+024h),000h	;1c13
	jp cret			;1c17
;==========================================================================
; 46	unlink
;==========================================================================
_unlink:
	call csv		;1c1a
	ld hl,0ffd3h		;1c1d
	add hl,sp		;1c20
	ld sp,hl		;1c21
	ld l,(ix+006h)		;1c22
	ld h,(ix+007h)		;1c25
	push hl			;1c28
	push ix			;1c29
	pop de			;1c2b
	ld hl,0ffd6h		;1c2c
	add hl,de		;1c2f
	push hl			;1c30
	call _setfcb		;1c31
	pop bc			;1c34
	pop bc			;1c35
	ld a,l			;1c36
	or h			;1c37
	jr z,l1c40h		;1c38
	ld hl,00000h		;1c3a
	jp cret			;1c3d
l1c40h:
	call _getuid		;1c40
	ld (ix-02bh),l		;1c43
	push ix			;1c46
	pop de			;1c48
	ld hl,0ffffh		;1c49
	add hl,de		;1c4c
	ld l,(hl)		;1c4d
	ld h,000h		;1c4e
	push hl			;1c50
	call _setuid		;1c51
	push ix			;1c54
	pop de			;1c56
	ld hl,0ffd6h		;1c57
	add hl,de		;1c5a
	ex (sp),hl		;1c5b
	ld hl,00013h		;1c5c
	push hl			;1c5f
	call _bdos		;1c60
	pop bc			;1c63
	ld a,l			;1c64
	rla			;1c65
	sbc a,a			;1c66
	ld h,a			;1c67
	ld (ix-02dh),l		;1c68
	ld (ix-02ch),h		;1c6b
	ld l,(ix-02bh)		;1c6e
	ld h,000h		;1c71
	ex (sp),hl		;1c73
	call _setuid		;1c74
	pop bc			;1c77
	ld l,(ix-02dh)		;1c78
	ld h,(ix-02ch)		;1c7b
	jp cret			;1c7e
;==========================================================================
; 47	setfcb
;==========================================================================
_setfcb:
	call csv		;1c81
	push bc			;1c84
	ld c,(ix+008h)		;1c85
	ld b,(ix+009h)		;1c88
	push bc			;1c8b
	pop iy			;1c8c
	jr l1c92h		;1c8e
l1c90h:
	inc iy			;1c90
l1c92h:
	ld a,(iy+000h)		;1c92
	ld l,a			;1c95
	rla			;1c96
	sbc a,a			;1c97
	ld h,a			;1c98
	push hl			;1c99
	call _isspace		;1c9a
	pop bc			;1c9d
	ld a,l			;1c9e
	or h			;1c9f
	jr nz,l1c90h		;1ca0
	ld (ix-001h),000h	;1ca2
	jr l1cdeh		;1ca6
l1ca8h:
	ld (ix-002h),000h	;1ca8
l1cach:
	push iy			;1cac
	pop de			;1cae
	ld l,(ix-002h)		;1caf
	ld h,000h		;1cb2
	add hl,de		;1cb4
	ld a,(hl)		;1cb5
	ld l,a			;1cb6
	rla			;1cb7
	sbc a,a			;1cb8
	ld h,a			;1cb9
	push hl			;1cba
	call toupper		;1cbb
	pop bc			;1cbe
	push hl			;1cbf
	ld e,(ix-002h)		;1cc0
	ld d,000h		;1cc3
	ld l,(ix-001h)		;1cc5
	ld h,d			;1cc8
	add hl,hl		;1cc9
	add hl,hl		;1cca
	add hl,de		;1ccb
	ld de,l28e2h		;1ccc
	add hl,de		;1ccf
	ld a,(hl)		;1cd0
	ld l,a			;1cd1
	rla			;1cd2
	sbc a,a			;1cd3
	ld h,a			;1cd4
	pop de			;1cd5
	or a			;1cd6
	sbc hl,de		;1cd7
	jr z,l1cf9h		;1cd9
	inc (ix-001h)		;1cdb
l1cdeh:
	ld a,(ix-001h)		;1cde
	cp 004h			;1ce1
	jr c,l1ca8h		;1ce3
	push iy			;1ce5
	ld l,(ix+006h)		;1ce7
	ld h,(ix+007h)		;1cea
	push hl			;1ced
	call _fc_parse		;1cee
	pop bc			;1cf1
	pop bc			;1cf2
	ld hl,00000h		;1cf3
	jp cret			;1cf6
l1cf9h:
	inc (ix-002h)		;1cf9
	ld a,(ix-002h)		;1cfc
	cp 004h			;1cff
	jr nz,l1cach		;1d01
	ld a,(ix-001h)		;1d03
	add a,004h		;1d06
	ld e,(ix+006h)		;1d08
	ld d,(ix+007h)		;1d0b
	ld hl,00024h		;1d0e
	add hl,de		;1d11
	ld (hl),a		;1d12
	ld hl,00001h		;1d13
	jp cret			;1d16
;==========================================================================
; 48	fc_parse
;==========================================================================
_fc_parse:
	call csv		;1d19
	push bc			;1d1c
	dec sp			;1d1d
	ld c,(ix+006h)		;1d1e
	ld b,(ix+007h)		;1d21
	push bc			;1d24
	pop iy			;1d25
	ld (iy+000h),000h	;1d27
	call _getuid		;1d2b
	ld (iy+029h),l		;1d2e
	ld l,(ix+008h)		;1d31
	ld h,(ix+009h)		;1d34
	ld (ix-002h),l		;1d37
	ld (ix-001h),h		;1d3a
	jr l1d4ch		;1d3d
l1d3fh:
	ld l,(ix-002h)		;1d3f
	ld h,(ix-001h)		;1d42
	inc hl			;1d45
	ld (ix-002h),l		;1d46
	ld (ix-001h),h		;1d49
l1d4ch:
	ld l,(ix-002h)		;1d4c
	ld h,(ix-001h)		;1d4f
	ld a,(hl)		;1d52
	ld l,a			;1d53
	rla			;1d54
	sbc a,a			;1d55
	ld h,a			;1d56
	push hl			;1d57
	call _isdigit		;1d58
	pop bc			;1d5b
	ld a,l			;1d5c
	or h			;1d5d
	jr nz,l1d3fh		;1d5e
	ld e,(ix-002h)		;1d60
	ld d,(ix-001h)		;1d63
	ld l,(ix+008h)		;1d66
	ld h,(ix+009h)		;1d69
	or a			;1d6c
	sbc hl,de		;1d6d
	jr z,l1d93h		;1d6f
	ld l,e			;1d71
	ld h,d			;1d72
	ld a,(hl)		;1d73
	cp 03ah			;1d74
	ld l,(ix+008h)		;1d76
	ld h,(ix+009h)		;1d79
	jr nz,l1d99h		;1d7c
	push hl			;1d7e
	call _atoi		;1d7f
	pop bc			;1d82
	ld (iy+029h),l		;1d83
	ld l,(ix-002h)		;1d86
	ld h,(ix-001h)		;1d89
	inc hl			;1d8c
	ld (ix+008h),l		;1d8d
	ld (ix+009h),h		;1d90
l1d93h:
	ld l,(ix+008h)		;1d93
	ld h,(ix+009h)		;1d96
l1d99h:
	ld a,(hl)		;1d99
	or a			;1d9a
	jr z,l1dc8h		;1d9b
	ld l,(ix+008h)		;1d9d
	ld h,(ix+009h)		;1da0
	inc hl			;1da3
	ld a,(hl)		;1da4
	cp 03ah			;1da5
	jr nz,l1dc8h		;1da7
	dec hl			;1da9
	ld a,(hl)		;1daa
	ld l,a			;1dab
	rla			;1dac
	sbc a,a			;1dad
	ld h,a			;1dae
	push hl			;1daf
	call toupper		;1db0
	pop bc			;1db3
	ld a,l			;1db4
	add a,0c0h		;1db5
	ld (iy+000h),a		;1db7
	ld l,(ix+008h)		;1dba
	ld h,(ix+009h)		;1dbd
	inc hl			;1dc0
	inc hl			;1dc1
	ld (ix+008h),l		;1dc2
	ld (ix+009h),h		;1dc5
l1dc8h:
	push iy			;1dc8
	pop hl			;1dca
	inc hl			;1dcb
	ld (ix-002h),l		;1dcc
	ld (ix-001h),h		;1dcf
	jr l1dfbh		;1dd2
l1dd4h:
	ld l,(ix+008h)		;1dd4
	ld h,(ix+009h)		;1dd7
	ld a,(hl)		;1dda
	inc hl			;1ddb
	ld (ix+008h),l		;1ddc
	ld (ix+009h),h		;1ddf
	ld l,a			;1de2
	rla			;1de3
	sbc a,a			;1de4
	ld h,a			;1de5
	push hl			;1de6
	call toupper		;1de7
	pop bc			;1dea
	ld a,l			;1deb
	ld l,(ix-002h)		;1dec
	ld h,(ix-001h)		;1def
	inc hl			;1df2
	ld (ix-002h),l		;1df3
	ld (ix-001h),h		;1df6
	dec hl			;1df9
	ld (hl),a		;1dfa
l1dfbh:
	ld l,(ix+008h)		;1dfb
	ld h,(ix+009h)		;1dfe
	ld a,(hl)		;1e01
	cp 02eh			;1e02
	ld a,(hl)		;1e04
	jr z,l1e33h		;1e05
	cp 02ah			;1e07
	ld a,(hl)		;1e09
	jr z,l1e33h		;1e0a
	ld e,a			;1e0c
	rla			;1e0d
	sbc a,a			;1e0e
	ld d,a			;1e0f
	ld hl,00020h		;1e10
	or a			;1e13
	sbc hl,de		;1e14
	jp p,l1e2ch		;1e16
	push iy			;1e19
	pop de			;1e1b
	ld hl,00009h		;1e1c
	add hl,de		;1e1f
	ex de,hl		;1e20
	ld l,(ix-002h)		;1e21
	ld h,(ix-001h)		;1e24
	or a			;1e27
	sbc hl,de		;1e28
	jr c,l1dd4h		;1e2a
l1e2ch:
	ld l,(ix+008h)		;1e2c
	ld h,(ix+009h)		;1e2f
	ld a,(hl)		;1e32
l1e33h:
	cp 02ah			;1e33
	jr nz,l1e3dh		;1e35
	ld (ix-003h),03fh	;1e37
	jr l1e55h		;1e3b
l1e3dh:
	ld (ix-003h),020h	;1e3d
	jr l1e55h		;1e41
l1e43h:
	ld a,(ix-003h)		;1e43
	ld l,(ix-002h)		;1e46
	ld h,(ix-001h)		;1e49
	inc hl			;1e4c
	ld (ix-002h),l		;1e4d
	ld (ix-001h),h		;1e50
	dec hl			;1e53
	ld (hl),a		;1e54
l1e55h:
	push iy			;1e55
	pop de			;1e57
	ld hl,00009h		;1e58
	add hl,de		;1e5b
	ex de,hl		;1e5c
	ld l,(ix-002h)		;1e5d
	ld h,(ix-001h)		;1e60
	or a			;1e63
	sbc hl,de		;1e64
	jr c,l1e43h		;1e66
l1e68h:
	ld l,(ix+008h)		;1e68
	ld h,(ix+009h)		;1e6b
	ld a,(hl)		;1e6e
	or a			;1e6f
	ld a,(hl)		;1e70
	jr z,l1eaeh		;1e71
	inc hl			;1e73
	ld (ix+008h),l		;1e74
	ld (ix+009h),h		;1e77
	cp 02eh			;1e7a
	jr nz,l1e68h		;1e7c
	jr l1ea7h		;1e7e
l1e80h:
	ld l,(ix+008h)		;1e80
	ld h,(ix+009h)		;1e83
	ld a,(hl)		;1e86
	inc hl			;1e87
	ld (ix+008h),l		;1e88
	ld (ix+009h),h		;1e8b
	ld l,a			;1e8e
	rla			;1e8f
	sbc a,a			;1e90
	ld h,a			;1e91
	push hl			;1e92
	call toupper		;1e93
	pop bc			;1e96
	ld a,l			;1e97
	ld l,(ix-002h)		;1e98
	ld h,(ix-001h)		;1e9b
	inc hl			;1e9e
	ld (ix-002h),l		;1e9f
	ld (ix-001h),h		;1ea2
	dec hl			;1ea5
	ld (hl),a		;1ea6
l1ea7h:
	ld l,(ix+008h)		;1ea7
	ld h,(ix+009h)		;1eaa
	ld a,(hl)		;1ead
l1eaeh:
	ld e,a			;1eae
	rla			;1eaf
	sbc a,a			;1eb0
	ld d,a			;1eb1
	ld hl,00020h		;1eb2
	or a			;1eb5
	sbc hl,de		;1eb6
	ld l,(ix+008h)		;1eb8
	ld h,(ix+009h)		;1ebb
	ld a,(hl)		;1ebe
	jp p,l1ee0h		;1ebf
	cp 02ah			;1ec2
	jr z,l1ed9h		;1ec4
	push iy			;1ec6
	pop de			;1ec8
	ld hl,0000ch		;1ec9
	add hl,de		;1ecc
	ex de,hl		;1ecd
	ld l,(ix-002h)		;1ece
	ld h,(ix-001h)		;1ed1
	or a			;1ed4
	sbc hl,de		;1ed5
	jr c,l1e80h		;1ed7
l1ed9h:
	ld l,(ix+008h)		;1ed9
	ld h,(ix+009h)		;1edc
	ld a,(hl)		;1edf
l1ee0h:
	cp 02ah			;1ee0
	jr nz,l1eeah		;1ee2
	ld (ix-003h),03fh	;1ee4
	jr l1f02h		;1ee8
l1eeah:
	ld (ix-003h),020h	;1eea
	jr l1f02h		;1eee
l1ef0h:
	ld a,(ix-003h)		;1ef0
	ld l,(ix-002h)		;1ef3
	ld h,(ix-001h)		;1ef6
	inc hl			;1ef9
	ld (ix-002h),l		;1efa
	ld (ix-001h),h		;1efd
	dec hl			;1f00
	ld (hl),a		;1f01
l1f02h:
	push iy			;1f02
	pop de			;1f04
	ld hl,0000ch		;1f05
	add hl,de		;1f08
	ex de,hl		;1f09
	ld l,(ix-002h)		;1f0a
	ld h,(ix-001h)		;1f0d
	or a			;1f10
	sbc hl,de		;1f11
	jr c,l1ef0h		;1f13
	ld a,000h		;1f15
	ld (iy+020h),a		;1f17
	ld (iy+00ch),a		;1f1a
	jp cret			;1f1d
	call csv		;1f20
	push bc			;1f23
	ld a,(ix+006h)		;1f24
	cp 001h			;1f27
	jr z,l1f31h		;1f29
	ld hl,0ffffh		;1f2b
	jp cret			;1f2e
l1f31h:
	ld hl,(02d13h)		;1f31
	ld (ix-002h),l		;1f34
	ld (ix-001h),h		;1f37
	ld l,(ix+008h)		;1f3a
	ld h,(ix+009h)		;1f3d
	ld (02d13h),hl		;1f40
	ld l,(ix-002h)		;1f43
	ld h,(ix-001h)		;1f46
	jp cret			;1f49
;==========================================================================
; 49	_sigchk
;==========================================================================
__sigchk:
	call csv		;1f4c
	dec sp			;1f4f
	ld hl,0000bh		;1f50
	push hl			;1f53
	call _bdos		;1f54
	pop bc			;1f57
	ld a,l			;1f58
	or a			;1f59
	jp z,cret		;1f5a
	ld hl,00001h		;1f5d
	push hl			;1f60
	call _bdos		;1f61
	pop bc			;1f64
	ld e,l			;1f65
	ld (ix-001h),e		;1f66
	ld a,e			;1f69
	cp 003h			;1f6a
	jp nz,cret		;1f6c
	ld de,00001h		;1f6f
	ld hl,(02d13h)		;1f72
	or a			;1f75
	sbc hl,de		;1f76
	jp z,cret		;1f78
	ld hl,(02d13h)		;1f7b
	ld a,l			;1f7e
	or h			;1f7f
	jr nz,l1f8ah		;1f80
	ld hl,0ffffh		;1f82
	push hl			;1f85
	call __exit		;1f86
	pop bc			;1f89
l1f8ah:
	ld hl,(02d13h)		;1f8a
	call indir		;1f8d
	jp cret			;1f90
;==========================================================================
; 50	getuid
;==========================================================================
_getuid:
	call csv		;1f93
	ld c,020h		;1f96
	ld e,0ffh		;1f98
	push ix			;1f9a
	call 00005h		;1f9c
	pop ix			;1f9f
	ld l,a			;1fa1
	ld h,000h		;1fa2
	jp cret			;1fa4
;==========================================================================
; 51	setuid
;==========================================================================
_setuid:
	call csv		;1fa7
	ld e,(ix+006h)		;1faa
	ld c,020h		;1fad
	push ix			;1faf
	call 00005h		;1fb1
	pop ix			;1fb4
	jp cret			;1fb6
;==========================================================================
; 52	bdos
;==========================================================================
_bdos:
	call csv		;1fb9
	ld e,(ix+008h)		;1fbc
	ld d,(ix+009h)		;1fbf
	ld c,(ix+006h)		;1fc2
	push ix			;1fc5
	call 00005h		;1fc7
	pop ix			;1fca
	ld l,a			;1fcc
	rla			;1fcd
	sbc a,a			;1fce
	ld h,a			;1fcf
	jp cret			;1fd0
;==========================================================================
; 53	bdoshl
;==========================================================================
_bdoshl:
	call csv		;1fd3
	ld e,(ix+008h)		;1fd6
	ld d,(ix+009h)		;1fd9
	ld c,(ix+006h)		;1fdc
	push ix			;1fdf
	call 00005h		;1fe1
	pop ix			;1fe4
	jp cret			;1fe6
;==========================================================================
; 54	_exit
;==========================================================================
__exit:
	call __cpm_cle		;1fe9
	pop hl			;1fec
	pop hl			;1fed
	ld (00080h),hl		;1fee	;store exit status
	jp 00000h		;1ff1	;Warm boot CP/M
;==========================================================================
; 55	isupper
;==========================================================================
_isupper:
	pop de			;1ff4
	pop hl			;1ff5
	push hl			;1ff6
	push de			;1ff7
	ld a,h			;1ff8
	or a			;1ff9
	jr nz,l2009h		;1ffa
	ld a,l			;1ffc
	cp 041h		;'A'	;1ffd
	jr c,l2009h		;1fff
	cp 05bh		;' '	;2001
	jr nc,l2009h		;2003
	ld hl,00001h		;2005
	ret			;2008
l2009h:
	ld hl,00000h		;2009
	ret			;200c
;==========================================================================
; 56	isspace
;==========================================================================
_isspace:
	pop de			;200d
	pop hl			;200e
	push hl			;200f
	push de			;2010
	ld a,h			;2011
	or a			;2012
	jr nz,l2026h		;2013
	ld a,l			;2015
	cp 020h			;2016
	jr z,l2022h		;2018
	cp 00ch			;201a
	jr z,l2022h		;201c
	cp 009h			;201e
	jr nz,l2026h		;2020
l2022h:
	ld hl,00001h		;2022
	ret			;2025
l2026h:
	ld hl,00000h		;2026
	ret			;2029
;==========================================================================
; 57	_strlen
;==========================================================================
_strlen:
	pop hl			;202a
	pop de			;202b
	push de			;202c
	push hl			;202d
	ld hl,00000h		;202e
l2031h:
	ld a,(de)		;2031
	or a			;2032
	ret z			;2033
	inc hl			;2034
	inc de			;2035
	jr l2031h		;2036
;==========================================================================
; 58	toupper
;==========================================================================
toupper:
	pop de			;2038
	pop hl			;2039
	push hl			;203a
	push de			;203b
	ld a,h			;203c
	or a			;203d
	ret nz			;203e
	ld a,l			;203f
	cp 061h			;2040
	ret c			;2042
	cp 07bh			;2043
	ret nc			;2045
	sub 020h		;2046
	ld l,a			;2048
	ret			;2049
;==========================================================================
; 59	digit
;==========================================================================
digit:
	sub 030h		;204a
	ret c			;204c
	cp 00ah			;204d
	ccf			;204f
	ret			;2050
;==========================================================================
; 60	atoi
;==========================================================================
_atoi:
	pop bc			;2051
	pop de			;2052
	push de			;2053
	push bc			;2054
	ld hl,00000h		;2055
l2058h:
	ld a,(de)		;2058
	inc de			;2059
	cp 020h			;205a
	jr z,l2058h		;205c
	cp 009h			;205e
	jr z,l2058h		;2060
	dec de			;2062
	cp 02dh			;2063
	jr z,l206ch		;2065
	cp 02bh			;2067
	jr nz,l206dh		;2069
	or a			;206b
l206ch:
	inc de			;206c
l206dh:
	ex af,af'		;206d
l206eh:
	ld a,(de)		;206e
	inc de			;206f
	call digit		;2070
	jr c,l2081h		;2073
	add hl,hl		;2075
	ld c,l			;2076
	ld b,h			;2077
	add hl,hl		;2078
	add hl,hl		;2079
	add hl,bc		;207a
	ld c,a			;207b
	ld b,000h		;207c
	add hl,bc		;207e
	jr l206eh		;207f
l2081h:
	ex af,af'		;2081
	ret nz			;2082
	ex de,hl		;2083
	ld hl,00000h		;2084
	sbc hl,de		;2087
	ret			;2089
;==========================================================================
; 61	brk
;==========================================================================
_brk:
	pop hl			;208a
	pop de			;208b
	ld (memtop),de		;208c
	push de			;2090
	jp (hl)			;2091
;==========================================================================
; 61	sbrk
;==========================================================================
_sbrk:
	pop bc			;2092
	pop de			;2093
	push de			;2094
	push bc			;2095
	ld hl,(memtop)		;2096 0x2d15
	ld a,l			;2099
	or h			;209a
	jr nz,l20a3h		;209b
	ld hl,02d17h		;209d
	ld (memtop),hl		;20a0
l20a3h:
	add hl,de		;20a3
	ld bc,0x400		;20a4
	add hl,bc		;20a7
	sbc hl,sp		;20a8
	jr c,l20b0h		;20aa
	ld hl,0ffffh		;20ac
	ret			;20af
l20b0h:
	ld hl,(memtop)		;20b0
	push hl			;20b3
	add hl,de		;20b4
	ld (memtop),hl		;20b5
	pop hl			;20b8
	ret			;20b9
	ld hl,(memtop)		;20ba
	ld bc,00080h		;20bd
	add hl,bc		;20c0
	sbc hl,sp		;20c1
	ld hl,00001h		;20c3
	ret c			;20c6
	dec hl			;20c7
	ret			;20c8
;==========================================================================
; 62	shll
;==========================================================================
shll:
	ld a,b			;20c9
	or a			;20ca
	ret z			;20cb
	cp 010h			;20cc
	jr c,l20d2h		;20ce
	ld b,010h		;20d0
l20d2h:
	add hl,hl		;20d2
	djnz l20d2h		;20d3
	ret			;20d5
;==========================================================================
; 63	aslr
;==========================================================================
aslr:
	ld e,(hl)		;20d6
	inc hl			;20d7
	ld d,(hl)		;20d8
	push hl			;20d9
	ex de,hl		;20da
	call shlr		;20db
	ex de,hl		;20de
	pop hl			;20df
	ld (hl),d		;20e0
	dec hl			;20e1
	ld (hl),e		;20e2
	ex de,hl		;20e3
	ret			;20e4
;==========================================================================
; 64	allsh
;==========================================================================
allsh:
	ld a,b			;20e5
	or a			;20e6
	ret z			;20e7
	cp 021h		;'!'	;20e8
	jr c,l20eeh		;20ea
	ld b,020h		;20ec
l20eeh:
	ex de,hl		;20ee
	add hl,hl		;20ef
	ex de,hl		;20f0
	adc hl,hl		;20f1
	djnz l20eeh		;20f3
	ret			;20f5
;==========================================================================
; 65	movmem bmove
;==========================================================================
_bmove:
	pop hl			;20f6
	exx			;20f7
	pop hl			;20f8
	pop de			;20f9
	pop bc			;20fa
	ld a,b			;20fb
	or c			;20fc
	jr z,l2101h		;20fd
	ldir			;20ff
l2101h:
	push bc			;2101
	push de			;2102
	push hl			;2103
	exx			;2104
	jp (hl)			;2105
;==========================================================================
; 66	lrelop
;==========================================================================
lrelop:
	exx			;2106
	pop hl			;2107
	exx			;2108
	pop bc			;2109
	ex de,hl		;210a
	ex (sp),hl		;210b
	ex de,hl		;210c
	or a			;210d
	sbc hl,de		;210e
	pop hl			;2110
	jr nz,l211ch		;2111
	sbc hl,bc		;2113
	jr z,l211ch		;2115
	ld a,002h		;2117
	rra			;2119
	or a			;211a
	rlca			;211b
l211ch:
	exx			;211c
	jp (hl)			;211d
;==========================================================================
; 67	asaladd
;==========================================================================
asaladd:
	call iregset		;211e
	call aladd		;2121
	jp iregstore		;2124
;==========================================================================
; 68	aladd
;==========================================================================
aladd:
	exx			;2127
	pop hl			;2128
	exx			;2129
	pop bc			;212a
	ex de,hl		;212b
	add hl,bc		;212c
	ex de,hl		;212d
	pop bc			;212e
	adc hl,bc		;212f
	exx			;2131
	push hl			;2132
	exx			;2133
	ret			;2134
;==========================================================================
; 69	alsub
;==========================================================================
alsub:
	exx			;2135
	pop hl			;2136
	exx			;2137
	pop bc			;2138
	ex de,hl		;2139
	or a			;213a
	sbc hl,bc		;213b
	ex de,hl		;213d
	pop bc			;213e
	sbc hl,bc		;213f
	exx			;2141
	push hl			;2142
	exx			;2143
	ret			;2144
;==========================================================================
; 70	iregset
;==========================================================================
iregset:
	ld e,(hl)		;2145
	inc hl			;2146
	ld d,(hl)		;2147
	inc hl			;2148
	ld c,(hl)		;2149
	inc hl			;214a
	ld b,(hl)		;214b
	ex (sp),hl		;214c
	push bc			;214d
	ex (sp),hl		;214e
	pop bc			;214f
	exx			;2150
	pop hl			;2151
	pop bc			;2152
	pop de			;2153
	ex (sp),hl		;2154
	push bc			;2155
	ex (sp),hl		;2156
	pop bc			;2157
	ex (sp),hl		;2158
	push hl			;2159
	push bc			;215a
	push de			;215b
	exx			;215c
	push bc			;215d
	ret			;215e
;==========================================================================
; 70	iregstore
;==========================================================================
iregstore:
	ex (sp),hl		;215f
	pop bc			;2160
	ld (hl),b		;2161
	dec hl			;2162
	ld (hl),c		;2163
	dec hl			;2164
	ld (hl),d		;2165
	dec hl			;2166
	ld (hl),e		;2167
	push bc			;2168
	pop hl			;2169
	ret			;216a
;==========================================================================
; 71	amul
;==========================================================================
amul:
	ld a,e			;216b
	ld c,d			;216c
	ex de,hl		;216d
	ld hl,00000h		;216e
	ld b,008h		;2171
	call mult8b		;2173
	ex de,hl		;2176
	jr l217ah		;2177
l2179h:
	add hl,hl		;2179
l217ah:
	djnz l2179h		;217a
	ex de,hl		;217c
	ld a,c			;217d
;==========================================================================
; 72	mult8b
;==========================================================================
mult8b:
	srl a			;217e
	jr nc,l2183h		;2180
	add hl,de		;2182
l2183h:
	ex de,hl		;2183
	add hl,hl		;2184
	ex de,hl		;2185
	ret z			;2186
	djnz mult8b		;2187
	ret			;2189
;==========================================================================
; 73	shlr
;==========================================================================
shlr:
	ld a,b			;218a
	or a			;218b
	ret z			;218c
	cp 010h			;218d
	jr c,l2193h		;218f
	ld b,010h		;2191
l2193h:
	srl h			;2193
	rr l			;2195
	djnz l2193h		;2197
	ret			;2199
;==========================================================================
; 74	_pnum
;==========================================================================
__pnum:
	call csv		;219a
	ld hl,0ffe1h		;219d
	add hl,sp		;21a0
	ld sp,hl		;21a1
	ld a,(ix+00ah)		;21a2
	ld e,a			;21a5
	rla			;21a6
	sbc a,a			;21a7
	ld d,a			;21a8
	ld hl,0001eh		;21a9
	or a			;21ac
	sbc hl,de		;21ad
	jp p,l21b6h		;21af
	ld (ix+00ah),01eh	;21b2
l21b6h:
	ld a,(ix+00eh)		;21b6
	or a			;21b9
	jr z,l21ech		;21ba
	bit 7,(ix+009h)		;21bc
	jr z,l21ech		;21c0
	ld e,(ix+006h)		;21c2
	ld d,(ix+007h)		;21c5
	ld l,(ix+008h)		;21c8
	ld h,(ix+009h)		;21cb
	push hl			;21ce
	push de			;21cf
	ld hl,00000h		;21d0
	pop bc			;21d3
	or a			;21d4
	sbc hl,bc		;21d5
	pop bc			;21d7
	ex de,hl		;21d8
	ld hl,00000h		;21d9
	sbc hl,bc		;21dc
	ld (ix+006h),e		;21de
	ld (ix+007h),d		;21e1
	ld (ix+008h),l		;21e4
	ld (ix+009h),h		;21e7
	jr l21f0h		;21ea
l21ech:
	ld (ix+00eh),000h	;21ec
l21f0h:
	ld a,(ix+00ah)		;21f0
	or a			;21f3
	jr nz,l2207h		;21f4
	ld a,(ix+006h)		;21f6
	or (ix+007h)		;21f9
	or (ix+008h)		;21fc
	or (ix+009h)		;21ff
	jr nz,l2207h		;2202
	inc (ix+00ah)		;2204
l2207h:
	push ix			;2207
	pop de			;2209
	ld hl,0ffffh		;220a
	add hl,de		;220d
	push hl			;220e
	pop iy			;220f
	jr l2251h		;2211
l2213h:
	ld a,(ix+010h)		;2213
	ld hl,00000h		;2216
	ld d,l			;2219
	ld e,a			;221a
	push hl			;221b
	push de			;221c
	ld e,(ix+006h)		;221d
	ld d,(ix+007h)		;2220
	ld l,(ix+008h)		;2223
	ld h,(ix+009h)		;2226
	call llmod		;2229
	ex de,hl		;222c
	ld de,l28f2h		;222d
	add hl,de		;2230
	ld a,(hl)		;2231
	ld de,0ffffh		;2232
	add iy,de		;2235
	ld (iy+000h),a		;2237
	ld a,(ix+010h)		;223a
	ld hl,00000h		;223d
	ld d,l			;2240
	ld e,a			;2241
	push hl			;2242
	push de			;2243
	push ix			;2244
	pop de			;2246
	ld hl,00006h		;2247
	add hl,de		;224a
	call aslldiv		;224b
	dec (ix+00ah)		;224e
l2251h:
	ld a,(ix+006h)		;2251
	or (ix+007h)		;2254
	or (ix+008h)		;2257
	or (ix+009h)		;225a
	jr nz,l2213h		;225d
	ld a,(ix+00ah)		;225f
	ld e,a			;2262
	rla			;2263
	sbc a,a			;2264
	ld d,a			;2265
	ld hl,00000h		;2266
	or a			;2269
	sbc hl,de		;226a
	jp m,l2213h		;226c
	ld a,(ix+00eh)		;226f
	push iy			;2272
	pop hl			;2274
	sub l			;2275
	push ix			;2276
	pop hl			;2278
	add a,l			;2279
	add a,0ffh		;227a
	ld (ix+00ah),a		;227c
	ld (ix-001h),a		;227f
	ld e,(ix+00ch)		;2282
	ld d,000h		;2285
	ld l,(ix-001h)		;2287
	ld h,d			;228a
	or a			;228b
	sbc hl,de		;228c
	jr nc,l22a3h		;228e
	ld (ix-001h),e		;2290
	jr l22a3h		;2293
l2295h:
	ld hl,00020h		;2295
	push hl			;2298
	ld l,(ix+012h)		;2299
	ld h,(ix+013h)		;229c
	call indir		;229f
	pop bc			;22a2
l22a3h:
	ld e,(ix+00ch)		;22a3
	dec (ix+00ch)		;22a6
	ld a,(ix+00ah)		;22a9
	cp e			;22ac
	jp m,l2295h		;22ad
	ld a,(ix+00eh)		;22b0
	or a			;22b3
	jr z,l22ddh		;22b4
	ld hl,0002dh		;22b6
	push hl			;22b9
	ld l,(ix+012h)		;22ba
	ld h,(ix+013h)		;22bd
	call indir		;22c0
	pop bc			;22c3
	dec (ix+00ah)		;22c4
	jr l22ddh		;22c7
l22c9h:
	ld a,(iy+000h)		;22c9
	inc iy			;22cc
	ld l,a			;22ce
	rla			;22cf
	sbc a,a			;22d0
	ld h,a			;22d1
	push hl			;22d2
	ld l,(ix+012h)		;22d3
	ld h,(ix+013h)		;22d6
	call indir		;22d9
	pop bc			;22dc
l22ddh:
	ld a,(ix+00ah)		;22dd
	dec (ix+00ah)		;22e0
	or a			;22e3
	jr nz,l22c9h		;22e4
	ld l,(ix-001h)		;22e6
	ld h,000h		;22e9
	jp cret			;22eb
;==========================================================================
; 75	lregset
;==========================================================================
lregset:
	pop bc			;22ee
	exx			;22ef
	pop bc			;22f0
	pop de			;22f1
	exx			;22f2
	ex de,hl		;22f3
	ex (sp),hl		;22f4
	ex de,hl		;22f5
	exx			;22f6
	push bc			;22f7
	pop hl			;22f8
	ex (sp),hl		;22f9
	exx			;22fa
	push bc			;22fb
	ret			;22fc
;==========================================================================
; 76	iregset
;==========================================================================
iregset:
	pop de			;22fd
	call lregset		;22fe
	push hl			;2301
	ex (sp),iy		;2302
	ld h,(iy+003h)		;2304
	ld l,(iy+002h)		;2307
	exx			;230a
	push hl			;230b
	ld h,(iy+001h)		;230c
	ld l,(iy+000h)		;230f
	exx			;2312
	ret			;2313
;==========================================================================
; 77	sgndiv
;==========================================================================
sgndiv:
	call negif		;2314
	exx			;2317
	ex de,hl		;2318
	exx			;2319
	ex de,hl		;231a
	call negif		;231b
	ex de,hl		;231e
	exx			;231f
	ex de,hl		;2320
	exx			;2321
	jp divide		;2322
asaldiv:
	call iregset		;2325
	call dosdiv		;2328
store:
	ld (iy+000h),e		;232b
	ld (iy+001h),d		;232e
	ld (iy+002h),l		;2331
	ld (iy+003h),h		;2334
	pop iy			;2337
	ret			;2339
;==========================================================================
; 78	aldiv
;==========================================================================
aldiv:
	call lregset		;233a
;==========================================================================
; 79	dosdiv
;==========================================================================
dosdiv:
	ld a,h			;233d
	xor d			;233e
	ex af,af'		;233f
	call sgndiv		;2340
	ex af,af'		;2343
	push bc			;2344
	exx			;2345
	pop hl			;2346
	ld e,c			;2347
	ld d,b			;2348
	jp m,negat		;2349
	ret			;234c
lldiv:
	call lregset		;234d
;==========================================================================
; 80	doudiv
;==========================================================================
doudiv:
	call divide		;2350
	push bc			;2353
	exx			;2354
	pop hl			;2355
	ld e,c			;2356
	ld d,b			;2357
	ret			;2358
;==========================================================================
; 81	aslldiv
;==========================================================================
aslldiv:
	call iregset		;2359
	call doudiv		;235c
	jr store		;235f
almod:
	call lregset		;2361
;==========================================================================
; 82	dosrem
;==========================================================================
dosrem:
	ld a,h			;2364
	ex af,af'		;2365
	call sgndiv		;2366
	push hl			;2369
	exx			;236a
	pop de			;236b
	ex de,hl		;236c
	ex af,af'		;236d
	or a			;236e
	jp m,negat		;236f
	ret			;2372

	call iregset		;2373
	call dosrem		;2376
	jr store		;2379
;==========================================================================
; 83	llmod
;==========================================================================
llmod:
	call lregset		;237b
;==========================================================================
; 84	dourem
;==========================================================================
dourem:
	call divide		;237e
	push hl			;2381
	exx			;2382
	pop de			;2383
	ex de,hl		;2384
	ret			;2385
asllmod:
	call iregset		;2386
	call dourem		;2389
	jr store		;238c
negat:
	push hl			;238e
	ld hl,00000h		;238f
	or a			;2392
	sbc hl,de		;2393
	ex de,hl		;2395
	pop bc			;2396
	ld hl,00000h		;2397
	sbc hl,bc		;239a
	ret			;239c
;==========================================================================
; 85	negif
;==========================================================================
negif:
	bit 7,h			;239d
	ret z			;239f
	exx			;23a0
	ld c,l			;23a1
	ld b,h			;23a2
	ld hl,00000h		;23a3
	or a			;23a6
	sbc hl,bc		;23a7
	exx			;23a9
	ld c,l			;23aa
	ld b,h			;23ab
	ld hl,00000h		;23ac
	sbc hl,bc		;23af
	ret			;23b1
;==========================================================================
;	divide
;==========================================================================
divide:
	ld bc,00000h		;23b2
	ld a,e			;23b5
	or d			;23b6
	exx			;23b7
	ld bc,00000h		;23b8
	or e			;23bb
	or d			;23bc
	exx			;23bd
	ret z			;23be
	ld a,001h		;23bf
	jr l23dch		;23c1
l23c3h:
	push hl			;23c3
	exx			;23c4
	push hl			;23c5
	or a			;23c6
	sbc hl,de		;23c7
	exx			;23c9
	sbc hl,de		;23ca
	exx			;23cc
	pop hl			;23cd
	exx			;23ce
	pop hl			;23cf
	jr c,l23e0h		;23d0
	exx			;23d2
	inc a			;23d3
	ex de,hl		;23d4
	add hl,hl		;23d5
	ex de,hl		;23d6
	exx			;23d7
	ex de,hl		;23d8
	adc hl,hl		;23d9
	ex de,hl		;23db
l23dch:
	bit 7,d			;23dc
	jr z,l23c3h		;23de
l23e0h:
	push hl			;23e0
	exx			;23e1
	push hl			;23e2
	or a			;23e3
	sbc hl,de		;23e4
	exx			;23e6
	sbc hl,de		;23e7
	exx			;23e9
	jr nc,l23f2h		;23ea
	pop hl			;23ec
	exx			;23ed
	pop hl			;23ee
	exx			;23ef
	jr l23f6h		;23f0
l23f2h:
	inc sp			;23f2
	inc sp			;23f3
	inc sp			;23f4
	inc sp			;23f5
l23f6h:
	ccf			;23f6
	rl c			;23f7
	rl b			;23f9
	exx			;23fb
	rl c			;23fc
	rl b			;23fe
	srl d			;2400
	rr e			;2402
	exx			;2404
	rr d			;2405
	rr e			;2407
	exx			;2409
	dec a			;240a
	jr nz,l23e0h		;240b
	ret			;240d
	call sub_241dh		;240e
	ex de,hl		;2411
	ret			;2412
	call adiv		;2413
	ex de,hl		;2416
	ret			;2417
;==========================================================================
; 86	adiv
;==========================================================================
adiv:
	xor a			;2418
	ex af,af'		;2419
	ex de,hl		;241a
	jr l2428h		;241b
;--------------------------------------------------------------------------
; 87	
;--------------------------------------------------------------------------
sub_241dh:
	ld a,h			;241d
	xor d			;241e
	ld a,h			;241f
	ex af,af'		;2420
	call sub_246ah		;2421
	ex de,hl		;2424
	call sub_246ah		;2425
l2428h:
	ld b,001h		;2428
	ld a,h			;242a
	or l			;242b
	ret z			;242c
l242dh:
	push hl			;242d
	add hl,hl		;242e
	jr c,l243fh		;242f
	ld a,d			;2431
	cp h			;2432
	jr c,l243fh		;2433
	jr nz,l243bh		;2435
	ld a,e			;2437
	cp l			;2438
	jr c,l243fh		;2439
l243bh:
	pop af			;243b
	inc b			;243c
	jr l242dh		;243d
l243fh:
	pop hl			;243f
	ex de,hl		;2440
	push hl			;2441
	ld hl,00000h		;2442
	ex (sp),hl		;2445
l2446h:
	ld a,h			;2446
	cp d			;2447
	jr c,l2452h		;2448
	jr nz,l2450h		;244a
	ld a,l			;244c
	cp e			;244d
	jr c,l2452h		;244e
l2450h:
	sbc hl,de		;2450
l2452h:
	ex (sp),hl		;2452
	ccf			;2453
	adc hl,hl		;2454
	srl d			;2456
	rr e			;2458
	ex (sp),hl		;245a
	djnz l2446h		;245b
	pop de			;245d
	ex de,hl		;245e
	ex af,af'		;245f
	call m,sub_246dh	;2460
	ex de,hl		;2463
	or a			;2464
	call m,sub_246dh	;2465
	ex de,hl		;2468
	ret			;2469
;--------------------------------------------------------------------------
; 88	
;--------------------------------------------------------------------------
sub_246ah:
	bit 7,h			;246a
	ret z			;246c
;--------------------------------------------------------------------------
; 89	
;--------------------------------------------------------------------------
sub_246dh:
	ld b,h			;246d
	ld c,l			;246e
	ld hl,00000h		;246f
	or a			;2472
	sbc hl,bc		;2473
	ret			;2475
;==========================================================================
; 90	csv	
;==========================================================================
csv:
	pop hl			;2476
	push iy			;2477
	push ix			;2479
	ld ix,00000h		;247b
	add ix,sp		;247f
	jp (hl)			;2481
;==========================================================================
; 91	cret	
;==========================================================================
cret:
	ld sp,ix		;2482
	pop ix			;2484
	pop iy			;2486
	ret			;2488
;==========================================================================
; 92	indir
;==========================================================================
indir:
	jp (hl)			;2489
;==========================================================================
; 93	_isdigit	
;==========================================================================
_isdigit:
	pop de			;248a
	pop hl			;248b
	push hl			;248c
	push de			;248d
	ld a,h			;248e
	or a			;248f
	jr nz,l249fh		;2490
	ld a,l			;2492
	cp 030h			;2493
	jr c,l249fh		;2495
	cp 03ah			;2497
	jr nc,l249fh		;2499
	ld hl,00001h		;249b
	ret			;249e
l249fh:
	ld hl,00000h		;249f
	ret			;24a2
;
;==========================================================================
; 	

data:

; BLOCK 'data_24a3' (start 0x24a3 end 0x297f)
data_24a3_start:
	defb 000h		;24a3
l24a4h:
	defb 000h		;24a4
	defb 001h		;24a5
	defb 002h		;24a6
	defb 003h		;24a7
l24a8h:
	defb 000h		;24a8
l24a9h:
	defb 001h		;24a9

; BLOCK 'data_24aa' (start 0x24aa end 0x24f2)
struct_24aa:
	defw 00000h		;24aa
	defw 00000h		;24ac

	defw data_24aa_end	;24ae
	defw cod_TEXT		;24b0

	defw msg_PSECT		;24b2
	defw cod_PSECT		;24b4

	defw msg_RELOC		;24b6
	defw cod_RELOC		;24b8

	defw msg_SYM		;24ba
	defw cod_SYM		;24bc

	defw msg_START		;24be
	defw cod_START		;24c0

	defw msg_END		;24c2
	defw cod_END		;24c4

	defw msg_IDENT		;24c6
	defw cod_IDENT		;24c8

	defw msg_XPSECT		;24ca
	defw cod_XPSECT		;24cc
l24ceh:
	defw msg_GLOBAL		;24ce
	defw msg_PURE		;24d0
	defw msg_OVRLD		;24d2
	defw msg_ABS		;24d4
l24d6h:
	defw msg_RABS		;24d6
	defw msg_RPSECT		;24d8
	defw msg_RNAME		;24da
	defw msg_Unknown1	;24dc
	defw msg_Unknown2	;24de
	defw msg_RRPSECT	;24e0
	defw msg_RRNAME		;24e2
l24e4h:
	defw l2565h		;24e4
	defw msg_STACK		;24e6
	defw msg_COMM		;24e8
	defw msg_REG		;24ea
	defw msg_LINENO		;24ec
	defw msg_FILNAM		;24ee
	defw msg_EXTERN		;24f0
data_24aa_end:
msg_TEXT:
	defb 054h		;24f2
	defb 045h		;24f3
	defb 058h		;24f4
	defb 054h		;24f5
	defb 000h		;24f6
msg_PSECT:
	defb 050h		;24f7
	defb 053h		;24f8
	defb 045h		;24f9
	defb 043h		;24fa
	defb 054h		;24fb
	defb 000h		;24fc
msg_RELOC:
	defb 052h		;24fd
	defb 045h		;24fe
	defb 04ch		;24ff
	defb 04fh		;2500
	defb 043h		;2501
	defb 000h		;2502
msg_SYM:
	defb 053h		;2503
	defb 059h		;2504
	defb 04dh		;2505
	defb 000h		;2506
msg_START:
	defb 053h		;2507
	defb 054h		;2508
	defb 041h		;2509
	defb 052h		;250a
	defb 054h		;250b
	defb 000h		;250c
msg_END:
	defb 045h		;250d
	defb 04eh		;250e
	defb 044h		;250f
	defb 000h		;2510
msg_IDENT:
	defb 049h		;2511
	defb 044h		;2512
	defb 045h		;2513
	defb 04eh		;2514
	defb 054h		;2515
	defb 000h		;2516
msg_XPSECT:
	defb 058h		;2517
	defb 050h		;2518
	defb 053h		;2519
	defb 045h		;251a
	defb 043h		;251b
	defb 054h		;251c
	defb 000h		;251d
msg_GLOBAL:
	defb 047h		;251e
	defb 04ch		;251f
	defb 04fh		;2520
	defb 042h		;2521
	defb 041h		;2522
	defb 04ch		;2523
	defb 000h		;2524
msg_PURE:
	defb 050h		;2525
	defb 055h		;2526
	defb 052h		;2527
	defb 045h		;2528
	defb 000h		;2529
msg_OVRLD:
	defb 04fh		;252a
	defb 056h		;252b
	defb 052h		;252c
	defb 04ch		;252d
	defb 044h		;252e
	defb 000h		;252f
msg_ABS:
	defb 041h		;2530
	defb 042h		;2531
	defb 053h		;2532
	defb 000h		;2533
msg_RABS:
	defb 052h		;2534
	defb 041h		;2535
	defb 042h		;2536
	defb 053h		;2537
	defb 000h		;2538
msg_RPSECT:
	defb 052h		;2539
	defb 050h		;253a
	defb 053h		;253b
	defb 045h		;253c
	defb 043h		;253d
	defb 054h		;253e
	defb 000h		;253f
msg_RNAME:
	defb 052h		;2540
	defb 04eh		;2541
	defb 041h		;2542
	defb 04dh		;2543
	defb 045h		;2544
	defb 000h		;2545
msg_Unknown1:
	defb 055h		;2546
	defb 06eh		;2547
	defb 06bh		;2548
	defb 06eh		;2549
	defb 06fh		;254a
	defb 077h		;254b
	defb 06eh		;254c
	defb 000h		;254d
msg_Unknown2:
	defb 055h		;254e
	defb 06eh		;254f
	defb 06bh		;2550
	defb 06eh		;2551
	defb 06fh		;2552
	defb 077h		;2553
	defb 06eh		;2554
	defb 000h		;2555
msg_RRPSECT:
	defb 052h		;2556
	defb 052h		;2557
	defb 050h		;2558
	defb 053h		;2559
	defb 045h		;255a
	defb 043h		;255b
	defb 054h		;255c
	defb 000h		;255d
msg_RRNAME:
	defb 052h		;255e
	defb 052h		;255f
	defb 04eh		;2560
	defb 041h		;2561
	defb 04dh		;2562
	defb 045h		;2563
	defb 000h		;2564
l2565h:
	defb 000h		;2565
msg_STACK:
	defb 053h		;2566
	defb 054h		;2567
	defb 041h		;2568
	defb 043h		;2569
	defb 04bh		;256a
	defb 000h		;256b
msg_COMM:
	defb 043h		;256c
	defb 04fh		;256d
	defb 04dh		;256e
	defb 04dh		;256f
	defb 000h		;2570
msg_REG:
	defb 052h		;2571
	defb 045h		;2572
	defb 047h		;2573
	defb 000h		;2574
msg_LINENO:
	defb 04ch		;2575
	defb 049h		;2576
	defb 04eh		;2577
	defb 045h		;2578
	defb 04eh		;2579
	defb 04fh		;257a
	defb 000h		;257b
msg_FILNAM:
	defb 046h		;257c
	defb 049h		;257d
	defb 04ch		;257e
	defb 04eh		;257f
	defb 041h		;2580
	defb 04dh		;2581
	defb 000h		;2582
msg_EXTERN:
	defb 045h		;2583
	defb 058h		;2584
	defb 054h		;2585
	defb 045h		;2586
	defb 052h		;2587
	defb 04eh		;2588
	defb 000h		;2589
msg_l_obj:
	defb 06ch		;258a
	defb 02eh		;258b
	defb 06fh		;258c
	defb 062h		;258d
	defb 06ah		;258e
	defb 000h		;258f
msg_rb:
	defb 072h		;2590
	defb 062h		;2591
	defb 000h		;2592
msg_cannot_open:
	defb 063h		;2593
	defb 061h		;2594
	defb 06eh		;2595
	defb 06eh		;2596
	defb 06fh		;2597
	defb 074h		;2598
	defb 020h		;2599
	defb 06fh		;259a
	defb 070h		;259b
	defb 065h		;259c
	defb 06eh		;259d
	defb 000h		;259e
l259fh:
	defb 025h		;259f "%s\n"
	defb 073h		;25a0
	defb 00ah		;25a1
	defb 000h		;25a2
l25a3h:
	defb 009h		;25a3 "\t%d\t%s\n"
	defb 025h		;25a4
	defb 064h		;25a5
	defb 009h		;25a6
	defb 025h		;25a7
	defb 073h		;25a8
	defb 00ah		;25a9
	defb 000h		;25aa
msg_u_r_type:
	defb 075h		;25ab	"unknown record type: %d"
	defb 06eh		;25ac
	defb 06bh		;25ad
	defb 06eh		;25ae
	defb 06fh		;25af
	defb 077h		;25b0
	defb 06eh		;25b1
	defb 020h		;25b2
	defb 072h		;25b3
	defb 065h		;25b4
	defb 063h		;25b5
	defb 06fh		;25b6
	defb 072h		;25b7
	defb 064h		;25b8
	defb 020h		;25b9
	defb 074h		;25ba
	defb 079h		;25bb
	defb 070h		;25bc
	defb 065h		;25bd
	defb 03ah		;25be
	defb 020h		;25bf
	defb 025h		;25c0
	defb 064h		;25c1
	defb 000h		;25c2

msg_r_t_l:
	defb 025h		;25c3
	defb 073h		;25c4
	defb 020h		;25c5
	defb 072h		;25c6
	defb 065h		;25c7
	defb 063h		;25c8
	defb 06fh		;25c9
	defb 072h		;25ca
	defb 064h		;25cb
	defb 020h		;25cc
	defb 074h		;25cd
	defb 06fh		;25ce
	defb 06fh		;25cf
	defb 020h		;25d0
	defb 06ch		;25d1
	defb 06fh		;25d2
	defb 06eh		;25d3
	defb 067h		;25d4
	defb 03ah		;25d5
	defb 020h		;25d6
	defb 025h		;25d7
	defb 064h		;25d8
	defb 000h		;25d9
msg_i_r:
	defb 069h		;25da
	defb 06eh		;25db
	defb 063h		;25dc
	defb 06fh		;25dd
	defb 06dh		;25de
	defb 070h		;25df
	defb 06ch		;25e0
	defb 065h		;25e1
	defb 074h		;25e2
	defb 065h		;25e3
	defb 020h		;25e4
	defb 072h		;25e5
	defb 065h		;25e6
	defb 063h		;25e7
	defb 06fh		;25e8
	defb 072h		;25e9
	defb 064h		;25ea
	defb 03ah		;25eb
	defb 020h		;25ec
	defb 074h		;25ed
	defb 079h		;25ee
	defb 070h		;25ef
	defb 065h		;25f0
	defb 020h		;25f1
	defb 03dh		;25f2
	defb 020h		;25f3
	defb 025h		;25f4
	defb 064h		;25f5
	defb 02ch		;25f6
	defb 020h		;25f7
	defb 06ch		;25f8
	defb 065h		;25f9
	defb 06eh		;25fa
	defb 067h		;25fb
	defb 074h		;25fc
	defb 068h		;25fd
	defb 020h		;25fe
	defb 03dh		;25ff
	defb 020h		;2600
	defb 025h		;2601
	defb 064h		;2602
	defb 000h		;2603
msg_t_r_l_s:
	defb 074h		;2604
	defb 065h		;2605
	defb 078h		;2606
	defb 074h		;2607
	defb 020h		;2608
	defb 072h		;2609
	defb 065h		;260a
	defb 063h		;260b
	defb 06fh		;260c
	defb 072h		;260d
	defb 064h		;260e
	defb 020h		;260f
	defb 068h		;2610
	defb 061h		;2611
	defb 073h		;2612
	defb 020h		;2613
	defb 06ch		;2614
	defb 065h		;2615
	defb 06eh		;2616
	defb 067h		;2617
	defb 074h		;2618
	defb 068h		;2619
	defb 020h		;261a
	defb 074h		;261b
	defb 06fh		;261c
	defb 06fh		;261d
	defb 020h		;261e
	defb 073h		;261f
	defb 06dh		;2620
	defb 061h		;2621
	defb 06ch		;2622
	defb 06ch		;2623
	defb 03ah		;2624
	defb 020h		;2625
	defb 025h		;2626
	defb 064h		;2627
	defb 000h		;2628
l2629h:
	defb 009h		;2629
	defb 009h		;262a
	defb 025h		;262b
	defb 073h		;262c
	defb 009h		;262d
	defb 025h		;262e
	defb 044h		;262f
	defb 009h		;2630
	defb 025h		;2631
	defb 064h		;2632
	defb 00ah		;2633
	defb 000h		;2634
l2635h:
	defb 009h		;2635
	defb 009h		;2636
	defb 000h		;2637
l2638h:
	defb 025h		;2638
	defb 030h		;2639
	defb 032h		;263a
	defb 078h		;263b
	defb 020h		;263c
	defb 000h		;263d
l263eh:
	defb 009h		;263e
	defb 009h		;263f
	defb 025h		;2640
	defb 073h		;2641
	defb 000h		;2642
msg_abs_0:
	defb 028h		;2643
	defb 061h		;2644
	defb 062h		;2645
	defb 073h		;2646
	defb 029h		;2647
	defb 000h		;2648
msg_u_p_f:
	defb 075h		;2649
	defb 06eh		;264a
	defb 06bh		;264b
	defb 06eh		;264c
	defb 06fh		;264d
	defb 077h		;264e
	defb 06eh		;264f
	defb 020h		;2650
	defb 070h		;2651
	defb 073h		;2652
	defb 065h		;2653
	defb 063h		;2654
	defb 074h		;2655
	defb 020h		;2656
	defb 066h		;2657
	defb 06ch		;2658
	defb 061h		;2659
	defb 067h		;265a
	defb 03ah		;265b
	defb 020h		;265c
	defb 030h		;265d
	defb 058h		;265e
	defb 025h		;265f
	defb 078h		;2660
	defb 000h		;2661
l2662h:
	defb 009h		;2662
	defb 025h		;2663
	defb 073h		;2664
	defb 000h		;2665
msg_unkn_reln_typ:
	defb 075h		;2666
	defb 06eh		;2667
	defb 06bh		;2668
	defb 06eh		;2669
	defb 06fh		;266a
	defb 077h		;266b
	defb 06eh		;266c
	defb 020h		;266d
	defb 072h		;266e
	defb 065h		;266f
	defb 06ch		;2670
	defb 06fh		;2671
	defb 063h		;2672
	defb 061h		;2673
	defb 074h		;2674
	defb 069h		;2675
	defb 06fh		;2676
	defb 06eh		;2677
	defb 020h		;2678
	defb 074h		;2679
	defb 079h		;267a
	defb 070h		;267b
	defb 065h		;267c
	defb 03ah		;267d
	defb 020h		;267e
	defb 030h		;267f
	defb 058h		;2680
	defb 025h		;2681
	defb 078h		;2682
	defb 030h		;2683
	defb 000h		;2684
l2685h:
	defb 009h		;2685
	defb 009h		;2686
	defb 025h		;2687
	defb 064h		;2688
	defb 009h		;2689
	defb 025h		;268a
	defb 073h		;268b
	defb 009h		;268c
	defb 025h		;268d
	defb 073h		;268e
	defb 009h		;268f
	defb 025h		;2690
	defb 064h		;2691
	defb 00ah		;2692
	defb 000h		;2693
l2694h:
	defb 009h		;2694
	defb 009h		;2695
	defb 025h		;2696
	defb 073h		;2697
	defb 009h		;2698
	defb 025h		;2699
	defb 073h		;269a
	defb 009h		;269b
	defb 025h		;269c
	defb 044h		;269d
	defb 000h		;269e
l269fh:
	defb 000h		;269f
msg_abs_1:
	defb 028h		;26a0
	defb 061h		;26a1
	defb 062h		;26a2
	defb 073h		;26a3
	defb 029h		;26a4
	defb 000h		;26a5
l26a6h:
	defb 009h		;26a6
	defb 047h		;26a7
	defb 04ch		;26a8
	defb 04fh		;26a9
	defb 042h		;26aa
	defb 041h		;26ab
	defb 04ch		;26ac
	defb 000h		;26ad
msg_u_s_t:
	defb 075h		;26ae
	defb 06eh		;26af
	defb 06bh		;26b0
	defb 06eh		;26b1
	defb 06fh		;26b2
	defb 077h		;26b3
	defb 06eh		;26b4
	defb 020h		;26b5
	defb 073h		;26b6
	defb 079h		;26b7
	defb 06dh		;26b8
	defb 062h		;26b9
	defb 06fh		;26ba
	defb 06ch		;26bb
	defb 020h		;26bc
	defb 074h		;26bd
	defb 079h		;26be
	defb 070h		;26bf
	defb 065h		;26c0
	defb 020h		;26c1
	defb 025h		;26c2
	defb 064h		;26c3
	defb 000h		;26c4
l26c5h:
	defb 009h		;26c5
	defb 025h		;26c6
	defb 073h		;26c7
	defb 00ah		;26c8
	defb 000h		;26c9
l26cah:
	defb 009h		;26ca
	defb 009h		;26cb
	defb 025h		;26cc
	defb 073h		;26cd
	defb 009h		;26ce
	defb 025h		;26cf
	defb 06ch		;26d0
	defb 075h		;26d1
	defb 00ah		;26d2
	defb 000h		;26d3
msg_abs_2:
	defb 028h		;26d4
	defb 061h		;26d5
	defb 062h		;26d6
	defb 073h		;26d7
	defb 029h		;26d8
	defb 000h		;26d9
msg_Machine:
	defb 009h		;26da
	defb 009h		;26db
	defb 04dh		;26dc
	defb 061h		;26dd
	defb 063h		;26de
	defb 068h		;26df
	defb 069h		;26e0
	defb 06eh		;26e1
	defb 065h		;26e2
	defb 009h		;26e3
	defb 009h		;26e4
	defb 03dh		;26e5
	defb 020h		;26e6
	defb 025h		;26e7
	defb 073h		;26e8
	defb 00ah		;26e9
	defb 000h		;26ea
msg_32_bit_order:
	defb 009h		;26eb
	defb 009h		;26ec
	defb 033h		;26ed
	defb 032h		;26ee
	defb 020h		;26ef
	defb 062h		;26f0
	defb 069h		;26f1
	defb 074h		;26f2
	defb 020h		;26f3
	defb 06fh		;26f4
	defb 072h		;26f5
	defb 064h		;26f6
	defb 065h		;26f7
	defb 072h		;26f8
	defb 009h		;26f9
	defb 03dh		;26fa
	defb 020h		;26fb
	defb 025h		;26fc
	defb 064h		;26fd
	defb 020h		;26fe
	defb 025h		;26ff
	defb 064h		;2700
	defb 020h		;2701
	defb 025h		;2702
	defb 064h		;2703
	defb 020h		;2704
	defb 025h		;2705
	defb 064h		;2706
	defb 00ah		;2707
	defb 000h		;2708
msg_16_bit_order:
	defb 009h		;2709
	defb 009h		;270a
	defb 031h		;270b
	defb 036h		;270c
	defb 020h		;270d
	defb 062h		;270e
	defb 069h		;270f
	defb 074h		;2710
	defb 020h		;2711
	defb 06fh		;2712
	defb 072h		;2713
	defb 064h		;2714
	defb 065h		;2715
	defb 072h		;2716
	defb 009h		;2717
	defb 03dh		;2718
	defb 020h		;2719
	defb 025h		;271a
	defb 064h		;271b
	defb 020h		;271c
	defb 025h		;271d
	defb 064h		;271e
	defb 00ah		;271f
	defb 000h		;2720
l2721h:
	defb 009h		;2721
	defb 009h		;2722
	defb 025h		;2723
	defb 073h		;2724
	defb 000h		;2725
msg_abs_3:
	defb 028h		;2726
	defb 061h		;2727
	defb 062h		;2728
	defb 073h		;2729
	defb 029h		;272a
	defb 000h		;272b
msg_size_:
	defb 009h		;272c
	defb 073h		;272d
	defb 069h		;272e
	defb 07ah		;272f
	defb 065h		;2730
	defb 03dh		;2731
	defb 025h		;2732
	defb 06ch		;2733
	defb 075h		;2734
	defb 000h		;2735
msg_reloc_:
	defb 009h		;2736
	defb 072h		;2737
	defb 065h		;2738
	defb 06ch		;2739
	defb 06fh		;273a
	defb 063h		;273b
	defb 03dh		;273c
	defb 025h		;273d
	defb 075h		;273e
	defb 000h		;273f
l2740h:
	defb 025h		;2740
	defb 073h		;2741
	defb 03ah		;2742
	defb 020h		;2743
	defb 000h		;2744
l2745h:
	defb 025h		;2745
	defb 064h		;2746
	defb 03ah		;2747
	defb 020h		;2748
	defb 000h		;2749
msg_null:
	defb 028h		;274a
	defb 06eh		;274b
	defb 075h		;274c
	defb 06ch		;274d
	defb 06ch		;274e
	defb 029h		;274f
	defb 000h		;2750
l2751h:
	defb 00fh		;2751
	defb 02bh		;2752
	defb 000h		;2753
	defb 000h		;2754
	defb 00fh		;2755
	defb 02bh		;2756
	defb 009h		;2757
	defb 000h		;2758
l2759h:
	defb 000h		;2759
	defb 000h		;275a
	defb 000h		;275b
	defb 000h		;275c
	defb 000h		;275d
	defb 000h		;275e
	defb 006h		;275f
	defb 001h		;2760
l2761h:
	defb 000h		;2761
	defb 000h		;2762
	defb 000h		;2763
	defb 000h		;2764
	defb 000h		;2765
	defb 000h		;2766
	defb 006h		;2767
	defb 002h		;2768
	defb 000h		;2769
	defb 000h		;276a
	defb 000h		;276b
	defb 000h		;276c
	defb 000h		;276d
	defb 000h		;276e
	defb 000h		;276f
	defb 000h		;2770
	defb 000h		;2771
	defb 000h		;2772
	defb 000h		;2773
	defb 000h		;2774
	defb 000h		;2775
	defb 000h		;2776
	defb 000h		;2777
	defb 000h		;2778
	defb 000h		;2779
	defb 000h		;277a
	defb 000h		;277b
	defb 000h		;277c
	defb 000h		;277d
	defb 000h		;277e
	defb 000h		;277f
	defb 000h		;2780
	defb 000h		;2781
	defb 000h		;2782
	defb 000h		;2783
	defb 000h		;2784
	defb 000h		;2785
	defb 000h		;2786
	defb 000h		;2787
	defb 000h		;2788
	defb 000h		;2789
	defb 000h		;278a
	defb 000h		;278b
	defb 000h		;278c
	defb 000h		;278d
	defb 000h		;278e
	defb 000h		;278f
	defb 000h		;2790
nularg:
	defb 000h		;2791
__fcb:
	defb 000h		;2792
	defb 020h		;2793
	defb 020h		;2794
	defb 020h		;2795
	defb 020h		;2796
	defb 020h		;2797
	defb 020h		;2798
	defb 020h		;2799
	defb 020h		;279a
	defb 020h		;279b
	defb 020h		;279c
	defb 020h		;279d
	defb 000h		;279e
	defb 000h		;279f
	defb 000h		;27a0
	defb 000h		;27a1
	defb 000h		;27a2
	defb 000h		;27a3
	defb 000h		;27a4
	defb 000h		;27a5
	defb 000h		;27a6
	defb 000h		;27a7
	defb 000h		;27a8
	defb 000h		;27a9
	defb 000h		;27aa
	defb 000h		;27ab
	defb 000h		;27ac
	defb 000h		;27ad
	defb 000h		;27ae
	defb 000h		;27af
	defb 000h		;27b0
	defb 000h		;27b1
	defb 000h		;27b2
	defb 000h		;27b3
	defb 000h		;27b4
	defb 000h		;27b5
	defb 004h		;27b6
	defb 000h		;27b7
	defb 000h		;27b8
	defb 000h		;27b9
	defb 000h		;27ba
	defb 000h		;27bb
	defb 000h		;27bc
	defb 020h		;27bd
	defb 020h		;27be
	defb 020h		;27bf
	defb 020h		;27c0
	defb 020h		;27c1
	defb 020h		;27c2
	defb 020h		;27c3
	defb 020h		;27c4
	defb 020h		;27c5
	defb 020h		;27c6
	defb 020h		;27c7
	defb 000h		;27c8
	defb 000h		;27c9
	defb 000h		;27ca
	defb 000h		;27cb
	defb 000h		;27cc
	defb 000h		;27cd
	defb 000h		;27ce
	defb 000h		;27cf
	defb 000h		;27d0
	defb 000h		;27d1
	defb 000h		;27d2
	defb 000h		;27d3
	defb 000h		;27d4
	defb 000h		;27d5
	defb 000h		;27d6
	defb 000h		;27d7
	defb 000h		;27d8
	defb 000h		;27d9
	defb 000h		;27da
	defb 000h		;27db
	defb 000h		;27dc
	defb 000h		;27dd
	defb 000h		;27de
	defb 000h		;27df
	defb 004h		;27e0
	defb 000h		;27e1
	defb 000h		;27e2
	defb 000h		;27e3
	defb 000h		;27e4
	defb 000h		;27e5
	defb 000h		;27e6
	defb 020h		;27e7
	defb 020h		;27e8
	defb 020h		;27e9
	defb 020h		;27ea
	defb 020h		;27eb
	defb 020h		;27ec
	defb 020h		;27ed
	defb 020h		;27ee
	defb 020h		;27ef
	defb 020h		;27f0
	defb 020h		;27f1
	defb 000h		;27f2
	defb 000h		;27f3
	defb 000h		;27f4
	defb 000h		;27f5
	defb 000h		;27f6
	defb 000h		;27f7
	defb 000h		;27f8
	defb 000h		;27f9
	defb 000h		;27fa
	defb 000h		;27fb
	defb 000h		;27fc
	defb 000h		;27fd
	defb 000h		;27fe
	defb 000h		;27ff
	defb 000h		;2800
	defb 000h		;2801
	defb 000h		;2802
	defb 000h		;2803
	defb 000h		;2804
	defb 000h		;2805
	defb 000h		;2806
	defb 000h		;2807
	defb 000h		;2808
	defb 000h		;2809
	defb 004h		;280a
	defb 000h		;280b
	defb 000h		;280c
	defb 000h		;280d
	defb 000h		;280e
	defb 000h		;280f
	defb 000h		;2810
	defb 000h		;2811
	defb 000h		;2812
	defb 000h		;2813
	defb 000h		;2814
	defb 000h		;2815
	defb 000h		;2816
	defb 000h		;2817
	defb 000h		;2818
	defb 000h		;2819
	defb 000h		;281a
	defb 000h		;281b
	defb 000h		;281c
	defb 000h		;281d
	defb 000h		;281e
	defb 000h		;281f
	defb 000h		;2820
	defb 000h		;2821
	defb 000h		;2822
	defb 000h		;2823
	defb 000h		;2824
	defb 000h		;2825
	defb 000h		;2826
	defb 000h		;2827
	defb 000h		;2828
	defb 000h		;2829
	defb 000h		;282a
	defb 000h		;282b
	defb 000h		;282c
	defb 000h		;282d
	defb 000h		;282e
	defb 000h		;282f
	defb 000h		;2830
	defb 000h		;2831
	defb 000h		;2832
	defb 000h		;2833
	defb 000h		;2834
	defb 000h		;2835
	defb 000h		;2836
	defb 000h		;2837
	defb 000h		;2838
	defb 000h		;2839
	defb 000h		;283a
	defb 000h		;283b
	defb 000h		;283c
	defb 000h		;283d
	defb 000h		;283e
	defb 000h		;283f
	defb 000h		;2840
	defb 000h		;2841
	defb 000h		;2842
	defb 000h		;2843
	defb 000h		;2844
	defb 000h		;2845
	defb 000h		;2846
	defb 000h		;2847
	defb 000h		;2848
	defb 000h		;2849
	defb 000h		;284a
	defb 000h		;284b
	defb 000h		;284c
	defb 000h		;284d
	defb 000h		;284e
	defb 000h		;284f
	defb 000h		;2850
	defb 000h		;2851
	defb 000h		;2852
	defb 000h		;2853
	defb 000h		;2854
	defb 000h		;2855
	defb 000h		;2856
	defb 000h		;2857
	defb 000h		;2858
	defb 000h		;2859
	defb 000h		;285a
	defb 000h		;285b
	defb 000h		;285c
	defb 000h		;285d
	defb 000h		;285e
	defb 000h		;285f
	defb 000h		;2860
	defb 000h		;2861
	defb 000h		;2862
	defb 000h		;2863
	defb 000h		;2864
	defb 000h		;2865
	defb 000h		;2866
	defb 000h		;2867
	defb 000h		;2868
	defb 000h		;2869
	defb 000h		;286a
	defb 000h		;286b
	defb 000h		;286c
	defb 000h		;286d
	defb 000h		;286e
	defb 000h		;286f
	defb 000h		;2870
	defb 000h		;2871
	defb 000h		;2872
	defb 000h		;2873
	defb 000h		;2874
	defb 000h		;2875
	defb 000h		;2876
	defb 000h		;2877
	defb 000h		;2878
	defb 000h		;2879
	defb 000h		;287a
	defb 000h		;287b
	defb 000h		;287c
	defb 000h		;287d
	defb 000h		;287e
	defb 000h		;287f
	defb 000h		;2880
	defb 000h		;2881
	defb 000h		;2882
	defb 000h		;2883
	defb 000h		;2884
	defb 000h		;2885
	defb 000h		;2886
	defb 000h		;2887
	defb 000h		;2888
	defb 000h		;2889
	defb 000h		;288a
	defb 000h		;288b
	defb 000h		;288c
	defb 000h		;288d
	defb 000h		;288e
	defb 000h		;288f
	defb 000h		;2890
	defb 000h		;2891
	defb 000h		;2892
	defb 000h		;2893
	defb 000h		;2894
	defb 000h		;2895
	defb 000h		;2896
	defb 000h		;2897
	defb 000h		;2898
	defb 000h		;2899
	defb 000h		;289a
	defb 000h		;289b
	defb 000h		;289c
	defb 000h		;289d
	defb 000h		;289e
	defb 000h		;289f
	defb 000h		;28a0
	defb 000h		;28a1
	defb 000h		;28a2
	defb 000h		;28a3
	defb 000h		;28a4
	defb 000h		;28a5
	defb 000h		;28a6
	defb 000h		;28a7
	defb 000h		;28a8
	defb 000h		;28a9
	defb 000h		;28aa
	defb 000h		;28ab
	defb 000h		;28ac
	defb 000h		;28ad
	defb 000h		;28ae
	defb 000h		;28af
	defb 000h		;28b0
	defb 000h		;28b1
	defb 000h		;28b2
	defb 000h		;28b3
	defb 000h		;28b4
	defb 000h		;28b5
	defb 000h		;28b6
	defb 000h		;28b7
	defb 000h		;28b8
	defb 000h		;28b9
	defb 000h		;28ba
	defb 000h		;28bb
	defb 000h		;28bc
	defb 000h		;28bd
	defb 000h		;28be
	defb 000h		;28bf
	defb 000h		;28c0
	defb 000h		;28c1
	defb 000h		;28c2
	defb 000h		;28c3
	defb 000h		;28c4
	defb 000h		;28c5
	defb 000h		;28c6
	defb 000h		;28c7
	defb 000h		;28c8
	defb 000h		;28c9
	defb 000h		;28ca
	defb 000h		;28cb
	defb 000h		;28cc
	defb 000h		;28cd
	defb 000h		;28ce
	defb 000h		;28cf
	defb 000h		;28d0
	defb 000h		;28d1
	defb 000h		;28d2
	defb 000h		;28d3
	defb 000h		;28d4
	defb 000h		;28d5
	defb 000h		;28d6
	defb 000h		;28d7
	defb 000h		;28d8
	defb 000h		;28d9
	defb 000h		;28da
	defb 000h		;28db
	defb 000h		;28dc
	defb 000h		;28dd
	defb 000h		;28de
	defb 000h		;28df
	defb 000h		;28e0
	defb 000h		;28e1
l28e2h:
	defb 043h		;28e2
	defb 04fh		;28e3
	defb 04eh		;28e4
	defb 03ah		;28e5
	defb 052h		;28e6
	defb 044h		;28e7
	defb 052h		;28e8
	defb 03ah		;28e9
	defb 050h		;28ea
	defb 055h		;28eb
	defb 04eh		;28ec
	defb 03ah		;28ed
	defb 04ch		;28ee
	defb 053h		;28ef
	defb 054h		;28f0
	defb 03ah		;28f1
l28f2h:
	defb 030h		;28f2
	defb 031h		;28f3
	defb 032h		;28f4
	defb 033h		;28f5
	defb 034h		;28f6
	defb 035h		;28f7
	defb 036h		;28f8
	defb 037h		;28f9
	defb 038h		;28fa
	defb 039h		;28fb
	defb 041h		;28fc
	defb 042h		;28fd
	defb 043h		;28fe
	defb 044h		;28ff
	defb 045h		;2900
	defb 046h		;2901
	defb 000h		;2902
__Hdata:
	defb 01ah		;2903
	defb 01ah		;2904
l2905h:
	defb 01ah		;2905
	defb 01ah		;2906
l2907h:
	defb 01ah		;2907
l2908h:
	defb 01ah		;2908
	defb 01ah		;2909
l290ah:
	defb 01ah		;290a   0
l290bh:
	defb 01ah		;290b   1
l290ch:
	defb 01ah		;290c   2
l290dh:
	defb 01ah		;290d   3
l290eh:
	defb 01ah		;290e   4
l290fh:
	defb 01ah		;290f   5
l2910h:
	defb 01ah		;2910   6
	defb 01ah		;2911   7
	defb 01ah		;2912   8
	defb 01ah		;2913   9
	defb 01ah		;2914  10
	defb 01ah		;2915  11
l2916h:
	defb 01ah		;2916  12   1
	defb 01ah		;2917  13   2
	defb 01ah		;2918  14   3
	defb 01ah		;2919  15   4
	defb 01ah		;291a  16   5
	defb 01ah		;291b  17   6
	defb 01ah		;291c  18   7
	defb 01ah		;291d  19   8
	defb 01ah		;291e  20   9
	defb 01ah		;291f  21  10
	defb 01ah		;2920  22  11
	defb 01ah		;2921  23  12
	defb 01ah		;2922  24  13
	defb 01ah		;2923  25  14
	defb 01ah		;2924  26  15
	defb 01ah		;2925  27  16
	defb 01ah		;2926  28  17
	defb 01ah		;2927  29  18
	defb 01ah		;2928  30  19
	defb 01ah		;2929  31  20
	defb 01ah		;292a  32  21
	defb 01ah		;292b  33  22
	defb 01ah		;292c  34  23
	defb 01ah		;292d  35  24
	defb 01ah		;292e  36  25
	defb 01ah		;292f  37  26
	defb 01ah		;2930  38  27
	defb 01ah		;2931  39  28
	defb 01ah		;2932  40  29
	defb 01ah		;2933  41  30
	defb 01ah		;2934  42  31
	defb 01ah		;2935  43  32
	defb 01ah		;2936  44  33
	defb 01ah		;2937  45  34
	defb 01ah		;2938  46  35
	defb 01ah		;2939  47  36
	defb 01ah		;293a  48  37
	defb 01ah		;293b  49  38
	defb 01ah		;293c  50  39
	defb 01ah		;293d  51  40
	defb 01ah		;293e  52  41
	defb 01ah		;293f  53  42
	defb 01ah		;2940  54  43
	defb 01ah		;2941  55  44
	defb 01ah		;2942  56  45
	defb 01ah		;2943  57  46
	defb 01ah		;2944  58  47
	defb 01ah		;2945  59  48
	defb 01ah		;2946  60  49
	defb 01ah		;2947  61  50
	defb 01ah		;2948  62  51
	defb 01ah		;2949  63  52
	defb 01ah		;294a  64  53
	defb 01ah		;294b  65  54
	defb 01ah		;294c  66  55
	defb 01ah		;294d  67  56
	defb 01ah		;294e  68  57
	defb 01ah		;294f  69  58
	defb 01ah		;2950  70  59
	defb 01ah		;2951  71  60
	defb 01ah		;2952  72  61
	defb 01ah		;2953  73  62
	defb 01ah		;2954  74  63
	defb 01ah		;2955  75  64
	defb 01ah		;2956  76  65
	defb 01ah		;2957  77  66
	defb 01ah		;2958  78  67
	defb 01ah		;2959  79  68
	defb 01ah		;295a  80  69
	defb 01ah		;295b  81  70
	defb 01ah		;295c  82  71
	defb 01ah		;295d  83  72
	defb 01ah		;295e  84  73
	defb 01ah		;295f  85  74
	defb 01ah		;2960  86  75
	defb 01ah		;2961  87  76
	defb 01ah		;2962  88  77
	defb 01ah		;2963  89  78
	defb 01ah		;2964  90  79
	defb 01ah		;2965  91  80
	defb 01ah		;2966  92  81
	defb 01ah		;2967  93  82
	defb 01ah		;2968  94  83
	defb 01ah		;2969  95  84
	defb 01ah		;296a  96  85
	defb 01ah		;296b  97  86
	defb 01ah		;296c  98  87
	defb 01ah		;296d  99  88
	defb 01ah		;296e 100  89
	defb 01ah		;296f 101  90
	defb 01ah		;2970 102  91
	defb 01ah		;2971 103  92
	defb 01ah		;2972 104  93
	defb 01ah		;2973 105  94
	defb 01ah		;2974 106  95
	defb 01ah		;2975 107  96
	defb 01ah		;2976 108  97
	defb 01ah		;2977 109  98
	defb 01ah		;2978 110  99
	defb 01ah		;2979 112 100
	defb 01ah		;297a 113
	defb 01ah		;297b 114
	defb 01ah		;297c 115
	defb 01ah		;297d 116
	defb 01ah		;297e 117
data_24a3_end:
	ld a,(de)		;297f
