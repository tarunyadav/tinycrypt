; Listing generated by Microsoft (R) Optimizing Compiler Version 19.10.25019.0 

	TITLE	C:\hub\tinycrypt\stream\chacha\cc20.c
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	_cc20_setkey
PUBLIC	_cc20_encrypt
PUBLIC	_F
PUBLIC	_cc20_stream
; Function compile flags: /Ogspy
; File c:\hub\tinycrypt\stream\chacha\cc20.c
;	COMDAT _cc20_stream
_TEXT	SEGMENT
_c$ = 8							; size = 4
_x$ = 12						; size = 4
_cc20_stream PROC					; COMDAT

; 84   : {

	push	ebx

; 85   :     int i;
; 86   : 
; 87   :     // copy state to x
; 88   :     memcpy(x->b, c->s.b, 64);

	mov	ebx, DWORD PTR _x$[esp]
	push	ebp
	mov	ebp, DWORD PTR _c$[esp+4]
	push	esi
	push	edi
	push	16					; 00000010H
	pop	ecx
	mov	esi, ebp
	mov	edi, ebx
	rep movsd
	push	10					; 0000000aH
	pop	esi
$LL4@cc20_strea:

; 89   :     // apply 20 rounds
; 90   :     for (i=0; i<20; i+=2) {
; 91   :       F(x->w);

	push	ebx
	call	_F
	pop	ecx
	sub	esi, 1
	jne	SHORT $LL4@cc20_strea

; 92   :     }
; 93   :     // add state to x
; 94   :     for (i=0; i<16; i++) {

	mov	ecx, ebp
	push	16					; 00000010H
	sub	ecx, ebx
	pop	edx
$LL13@cc20_strea:

; 95   :       x->w[i] += c->s.w[i];

	mov	eax, DWORD PTR [ecx+ebx]
	add	DWORD PTR [ebx], eax
	lea	ebx, DWORD PTR [ebx+4]
	sub	edx, 1
	jne	SHORT $LL13@cc20_strea

; 96   :     }
; 97   :     // update block counter
; 98   :     c->s.w[12]++;

	inc	DWORD PTR [ebp+48]
	pop	edi
	pop	esi
	pop	ebp
	pop	ebx

; 99   :     // stopping at 2^70 bytes per nonce is user's responsibility
; 100  : }

	ret	0
_cc20_stream ENDP
_TEXT	ENDS
; Function compile flags: /Ogspy
; File c:\hub\tinycrypt\stream\chacha\cc20.c
;	COMDAT _F
_TEXT	SEGMENT
_r$1$ = -24						; size = 4
_i$1$ = -20						; size = 4
_idx16$ = -16						; size = 16
_s$ = 8							; size = 4
_F	PROC						; COMDAT

; 53   : {

	sub	esp, 24					; 00000018H
	push	ebx
	push	ebp

; 54   :     int         i;
; 55   :     uint32_t    a, b, c, d, r, t, idx;
; 56   :     
; 57   :     uint16_t idx16[8]=
; 58   :     { 0xC840, 0xD951, 0xEA62, 0xFB73,    // column index
; 59   :       0xFA50, 0xCB61, 0xD872, 0xE943 };  // diagnonal index
; 60   :     
; 61   :     for (i=0; i<8; i++) {

	xor	edx, edx
	mov	DWORD PTR _idx16$[esp+32], -648951744	; d951c840H
	push	esi
	mov	DWORD PTR _idx16$[esp+40], -76289438	; fb73ea62H
	mov	DWORD PTR _idx16$[esp+44], -882771376	; cb61fa50H
	mov	DWORD PTR _idx16$[esp+48], -381429646	; e943d872H
	mov	DWORD PTR _i$1$[esp+36], edx
	push	edi
$LL4@F:

; 62   :       idx = idx16[i];

	movzx	esi, WORD PTR _idx16$[esp+edx*2+40]

; 63   :         
; 64   :       a = (idx         & 0xF);
; 65   :       b = ((idx >>  4) & 0xF);
; 66   :       c = ((idx >>  8) & 0xF);
; 67   :       d = ((idx >> 12) & 0xF);
; 68   :   
; 69   :       r = 0x07080C10;

	mov	ecx, 117967888				; 07080c10H
	mov	edx, DWORD PTR _s$[esp+36]
	mov	edi, esi
	mov	ebx, esi
	shr	edi, 4
	mov	ebp, esi
	shr	ebx, 8
	and	ebp, 15					; 0000000fH
	mov	DWORD PTR _r$1$[esp+40], ecx
	and	edi, 15					; 0000000fH
	and	ebx, 15					; 0000000fH
	shr	esi, 12					; 0000000cH
$LL7@F:

; 70   :       
; 71   :       /* The quarter-round */
; 72   :       do {
; 73   :         s[a] = s[a] + s[b]; 

	mov	eax, DWORD PTR [edx+edi*4]
	add	DWORD PTR [edx+ebp*4], eax

; 74   :         s[d] = ROTL32(s[d] ^ s[a], r & 0xFF);

	mov	eax, DWORD PTR [edx+esi*4]
	xor	eax, DWORD PTR [edx+ebp*4]
	movzx	ecx, cl
	rol	eax, cl

; 75   :         XCHG(c, a);
; 76   :         XCHG(d, b);
; 77   :         r >>= 8;

	mov	ecx, DWORD PTR _r$1$[esp+40]
	mov	DWORD PTR [edx+esi*4], eax
	mov	eax, ebx
	mov	ebx, ebp
	shr	ecx, 8
	mov	DWORD PTR _r$1$[esp+40], ecx
	mov	ebp, eax
	mov	eax, esi
	mov	esi, edi
	mov	edi, eax

; 78   :       } while (r != 0);

	test	ecx, ecx
	jne	SHORT $LL7@F

; 54   :     int         i;
; 55   :     uint32_t    a, b, c, d, r, t, idx;
; 56   :     
; 57   :     uint16_t idx16[8]=
; 58   :     { 0xC840, 0xD951, 0xEA62, 0xFB73,    // column index
; 59   :       0xFA50, 0xCB61, 0xD872, 0xE943 };  // diagnonal index
; 60   :     
; 61   :     for (i=0; i<8; i++) {

	mov	edx, DWORD PTR _i$1$[esp+40]
	inc	edx
	mov	DWORD PTR _i$1$[esp+40], edx
	cmp	edx, 8
	jl	SHORT $LL4@F
	pop	edi
	pop	esi
	pop	ebp
	pop	ebx

; 79   :     }    
; 80   : }

	add	esp, 24					; 00000018H
	ret	0
_F	ENDP
_TEXT	ENDS
; Function compile flags: /Ogspy
; File c:\hub\tinycrypt\stream\chacha\cc20.c
;	COMDAT _cc20_encrypt
_TEXT	SEGMENT
_stream$ = -64						; size = 64
_len$ = 8						; size = 4
_in$ = 12						; size = 4
_ctx$ = 16						; size = 4
_cc20_encrypt PROC					; COMDAT

; 104  : {

	sub	esp, 64					; 00000040H
	push	esi

; 105  :     uint32_t i, r;
; 106  :     cc20_blk stream;
; 107  :     uint8_t  *p=(uint8_t*)in;
; 108  :     
; 109  :     while (len) {      

	mov	esi, DWORD PTR _len$[esp+64]
	push	edi
	mov	edi, DWORD PTR _in$[esp+68]
	test	esi, esi
	je	SHORT $LN3@cc20_encry
	push	ebx
	push	ebp
	push	64					; 00000040H
	pop	ebx
$LL2@cc20_encry:

; 110  :       cc20_stream(ctx, &stream);

	lea	eax, DWORD PTR _stream$[esp+80]
	push	eax
	push	DWORD PTR _ctx$[esp+80]
	call	_cc20_stream
	pop	ecx
	pop	ecx

; 111  :       
; 112  :       r=(len>64) ? 64 : len;

	cmp	esi, ebx
	mov	ecx, esi
	cmova	ecx, ebx

; 113  :       
; 114  :       // xor input with stream
; 115  :       for (i=0; i<r; i++) {

	test	ecx, ecx
	je	SHORT $LN5@cc20_encry
	lea	ebx, DWORD PTR _stream$[esp+80]
	mov	edx, edi
	sub	ebx, edi
	mov	ebp, ecx
$LL12@cc20_encry:

; 116  :         p[i] ^= stream.b[i];

	mov	al, BYTE PTR [ebx+edx]
	xor	BYTE PTR [edx], al
	inc	edx
	sub	ebp, 1
	jne	SHORT $LL12@cc20_encry
	push	64					; 00000040H
	pop	ebx
$LN5@cc20_encry:

; 117  :       }
; 118  :     
; 119  :       len -= r;
; 120  :       p += r;

	add	edi, ecx
	sub	esi, ecx
	jne	SHORT $LL2@cc20_encry
	pop	ebp
	pop	ebx
$LN3@cc20_encry:
	pop	edi
	pop	esi

; 121  :     }
; 122  : }

	add	esp, 64					; 00000040H
	ret	0
_cc20_encrypt ENDP
_TEXT	ENDS
; Function compile flags: /Ogspy
; File c:\hub\tinycrypt\stream\chacha\cc20.c
;	COMDAT _cc20_setkey
_TEXT	SEGMENT
_c$ = 8							; size = 4
_key$ = 12						; size = 4
_nonce$ = 16						; size = 4
_cc20_setkey PROC					; COMDAT

; 35   :     cc20_blk *iv=(cc20_blk*)nonce;
; 36   :     int      i;
; 37   :     
; 38   :     // "expand 32-byte k"
; 39   :     c->s.w[0] = 0x61707865;

	mov	eax, DWORD PTR _c$[esp-4]
	push	esi

; 40   :     c->s.w[1] = 0x3320646E;
; 41   :     c->s.w[2] = 0x79622D32;
; 42   :     c->s.w[3] = 0x6B206574;
; 43   : 
; 44   :     // copy 256-bit key
; 45   :     memcpy(&c->s.b[16], key, 32);

	mov	esi, DWORD PTR _key$[esp]
	push	edi
	push	8
	mov	DWORD PTR [eax], 1634760805		; 61707865H
	lea	edi, DWORD PTR [eax+16]
	mov	DWORD PTR [eax+4], 857760878		; 3320646eH
	mov	DWORD PTR [eax+8], 2036477234		; 79622d32H
	mov	DWORD PTR [eax+12], 1797285236		; 6b206574H
	pop	ecx
	rep movsd

; 46   :   
; 47   :     // set 32-bit block counter and 96-bit nonce/iv
; 48   :     c->s.w[12] = 1;
; 49   :     memcpy(&c->s.w[13], nonce, 12);

	mov	esi, DWORD PTR _nonce$[esp+4]
	lea	edi, DWORD PTR [eax+52]
	mov	DWORD PTR [eax+48], 1
	movsd
	movsd
	movsd
	pop	edi
	pop	esi

; 50   : }

	ret	0
_cc20_setkey ENDP
_TEXT	ENDS
END