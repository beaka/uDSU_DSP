// ============================================================================
//  Final Patched lgt8xp uDSU Assembly Library (Local Bypassing Version)
// ============================================================================

#include <avr/io.h>

// DSCS - Control Status Register see "Register Definitions" section
// DSIR - Arithmetic Instruction Register
// DSSD - DA Saturation Operation Register
// DSDX - Operand Register DSDX
// DSDY - Operand Register DSDY
// DSAL - Least Significant 16 bits of DA
// DSAH - Most Significant 16 bits of DA

// address for IN/OUT - FAST IO mapping
#define	DSCS	0x00 
#define	DSIR	0x01 
#define	DSSD	0x02 
#define	DSDX	0x10 
#define	DSDY	0x11 
#define	DSAL	0x38
#define	DSAH	0x39

// address for LD/ST - normal LD/ST mampping
#define	LS_DSCS	0x20
#define	LS_DSIR	0x21
#define	LS_DSSD	0x22
#define	LS_DSDX	0x30
#define	LS_DSDY	0x31
#define	LS_DSAL	0x58
#define	LS_DSAH	0x59


#define	XADD	0x05	
#define	XADS	0x25	
#define	XSUB	0x01	
#define	XSBS	0x21	
#define	MVY		0x1d	
#define	MVNY	0x19	
#define	MVNYS	0x39	
#define	ADAY	0x17	
#define	ADAYS	0x37	
#define	SBAY	0x13	
#define	SBAYS	0x33	

#define	XMULUU	0x44	
#define	XMULUS	0x54	
#define	XMULSU	0x64	
#define	XMULSS	0x74	
						
#define	XMNLUU	0x40	
#define	XMNLUS	0x50	
#define	XMNLSU	0x60	
#define	XMNLSS	0x70	
						
#define	FXMULUU	0x4c	
#define	FXMULUS	0x5c	
#define	FXMULSU	0x6c	
#define	FXMULSS	0x7c	
						
#define	FXMNLUU	0x48	
#define	FXMNLUS	0x58	
#define	FXMNLSU	0x68	
#define	FXMNLSS	0x78	
#define	XMACUU	0x46	
#define	XMACUS	0x56	
#define	XMACSU	0x66	
#define	XMACSS	0x76	

#define	SMACUU	0x47	
#define	SMACUS	0x57	
#define	SMACSU	0x67	
#define	SMACSS	0x77	
						
#define	FXMACUU	0x4e	
#define	FXMACUS	0x5e	
#define	FXMACSU	0x6e	
#define	FXMACSS	0x7e	
						
#define	FSMACUU	0x4f	
#define	FSMACUS	0x5f	
#define	FSMACSU	0x6f	
#define	FSMACSS	0x7f	
						
#define	XMSCUU	0x42	
#define	XMSCUS	0x52	
#define	XMSCSU	0x62	
#define	XMSCSS	0x72	
						
#define	SMSCUU	0x43	
#define	SMSCUS	0x53	
#define	SMSCSU	0x63	
#define	SMSCSS	0x73	
						
#define	FMSCUU	0x4a	
#define	FMSCUS	0x5a	
#define	FMSCSU	0x6a	
#define	FMSCSS	0x7a	

#define	FSMSCUU	0x4b	
#define	FSMSCUS	0x5b	
#define	FSMSCSU	0x6b	
#define	FSMSCSS	0x7b	

#define CLRA	0x80	
#define NEGA	0x84	
#define NEGAS	0x85	
#define USQX	0x88	
#define SSQX	0x89	
#define USQY	0x8a	
#define SSQY	0x8b	
#define ABSA	0xa0	
#define XDIVA	0xb0	
#define XDIVR	0xb1	

#define ASLA	0xc0	
#define ASRA	0xd0	
#define ASRAS	0xf0	

.global dsu_da
.global dsu_init
.global local_dsu_reset
.global local_xmnluu
.global local_xmnlss
.global local_fxmnluu
.global local_fxmnlss
.global local_xmacsu0
.global local_xmacus0
.global local_xmacss0
.global local_smacuu0
.global local_xmscuu0
.global dsu_xmscuu0
.global local_xmscuu1
.global local_xmscss0
.global local_xmscss1
.global local_dsu_ashr0
.global local_dsu_ashr2
.global local_dsu_div0
.global dsu_xadd
.global  dsu_xads
.global    dsu_xsub
 .global    dsu_xsbs
 .global    dsu_aday
 .global  dsu_adays
 .global    dsu_sbay
 .global   dsu_sbays
 .global   dsu_xmuluu
 .global   dsu_xmulsu
 .global   dsu_xmulus
 .global  dsu_xmulss
 .global   dsu_fxmuluu
 .global   dsu_fxmulsu
 .global dsu_fxmulus
 .global dsu_fxmulss
 .global dsu_xmnlsu
 .global dsu_xmnlus
 .global dsu_fxmnlsu
 .global dsu_fxmnlus
 .global dsu_xmacuu0
 .global dsu_xmacuu1
 .global dsu_xmacsu1
 .global dsu_xmacus1
 .global dsu_xmacss1
 .global dsu_smacuu1
 .global dsu_smacsu0
 .global dsu_smacsu1
 .global dsu_smacus0
 .global dsu_smacus1
 .global dsu_smacss0
 .global dsu_smacss1
 .global dsu_xmscsu0
 .global dsu_xmscsu1
 .global dsu_xmscus0
 .global dsu_xmscus1
 .global dsu_smscuu0
 .global dsu_smscuu1
 .global dsu_smscsu0
 .global dsu_smscsu1
 .global dsu_smscus0
 .global dsu_smscus1
 .global dsu_smscss0
 .global dsu_smscss1
 .global dsu_usqx0
 .global dsu_usqx1
 .global dsu_ssqx0
 .global dsu_ssqx1
 .global dsu_usqy0
 .global dsu_usqy1
 .global dsu_ssqy0
 .global dsu_ssqy1
 .global dsu_uneg0
 .global dsu_uneg1
 .global dsu_uneg2
 .global dsu_uneg3
 .global dsu_sneg0
 .global dsu_sneg1
 .global dsu_sneg2
 .global dsu_sneg3
 .global dsu_abs0
 .global dsu_abs1
 .global dsu_abs2
 .global dsu_abs3
 .global dsu_ashl1
 .global dsu_ashl0
 .global dsu_ashl1
 .global dsu_ashl1
 .global dsu_ashl1
 .global dsu_ashr1
 .global dsu_ashr3
 .global dsu_ashr3
 .global dsu_div1
 .global dsu_div1
 .global dsu_fmacss
 .global dsu_xadd
 .global dsu_xads
 .global dsu_xsub
 .global dsu_xsbs
 .global dsu_aday
 .global dsu_adays
 .global dsu_sbay
 .global dsu_sbays
 .global dsu_xmuluu
 .global dsu_xmulsu
 .global dsu_xmulus
 .global dsu_xmulss
 .global dsu_fxmuluu
 .global dsu_fxmulsu
 .global dsu_fxmulus
 .global dsu_fxmulss
 .global dsu_xmnlsu
 .global dsu_xmnlus
 .global dsu_fxmnlsu
 .global dsu_fxmnlus
 .global dsu_xmacuu0
 .global dsu_xmacuu1
 .global dsu_xmacsu1
 .global dsu_xmacus1
 .global dsu_xmacss1
 .global dsu_smacuu1
 .global dsu_smacsu0
 .global dsu_smacsu1
 .global dsu_smacus0
 .global dsu_smacus1
 .global dsu_smacss0
 .global dsu_smacss1
 .global dsu_xmscsu0
 .global dsu_xmscsu1
 .global dsu_xmscus0
 .global dsu_xmscus1
 .global dsu_smscuu0
 .global dsu_smscuu1
 .global dsu_smscsu0
 .global dsu_smscsu1
 .global dsu_smscus0
 .global dsu_smscus1
 .global dsu_smscss0
 .global dsu_smscss1
 .global dsu_usqx1
 .global dsu_ssqx1
 .global dsu_usqy1
 .global dsu_ssqy1
 .global dsu_uneg2
 .global dsu_uneg3
 .global dsu_sneg2
 .global dsu_sneg3
 .global dsu_abs2
 .global dsu_abs3
 .global dsu_ashl0
 .global dsu_ashl1
 .global dsu_ashr1
 .global dsu_ashr3
 .global dsu_div1
 .global dsu_fmacss

dsu_init:
	ldi r20, 0x80
	or r20, r24
	out DSCS, r20
	ret

local_dsu_reset:
    ldi r20, CLRA
    out DSIR, r20
    nop
    ret

local_xmnluu:
	clr r0
	out DSDX, r0
	out DSDY, r0
	nop
	out DSDX, r24
	out DSDY, r22
	ldi r20, XMULUU
	out DSIR, r20
	nop
	ldi r20, NEGA
	out DSIR, r20
	nop
	in	r22, DSAL
	in	r24, DSAH
	ret

local_xmnlss:
	clr r0
	out DSDX, r0
	out DSDY, r0
	nop
	out DSDX, r24
	out DSDY, r22
	ldi r20, XMULSS
	out DSIR, r20
	nop
	ldi r20, NEGAS
	out DSIR, r20
	nop
	in	r22, DSAL
	in	r24, DSAH
	ret

local_fxmnluu:
    out DSDX, r24
    out DSDY, r22
    ldi r20, FXMULUU
    out DSIR, r20
    nop
    ldi r20, NEGA
    out DSIR, r20
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_fxmnlss:
    out DSDX, r24
    out DSDY, r22
    ldi r20, FXMULSS
    out DSIR, r20
    nop
    ldi r20, NEGAS
    out DSIR, r20
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_xmacsu0:
	out DSDX, r24
	out DSDY, r22
	ldi r20, XMACSU
	out DSIR, r20
	nop
	nop
	in	r22, DSAL
	in	r24, DSAH
	ret

local_xmacus0:
	out DSDX, r24
	out DSDY, r22
	ldi r20, XMACUS
	out DSIR, r20
	nop
	nop
	in	r22, DSAL
	in	r24, DSAH
	ret

local_xmacss0:
	out DSDX, r24
	out DSDY, r22
	ldi r20, XMACSS
	out DSIR, r20
	nop
	nop
	in	r22, DSAL
	in	r24, DSAH
	ret

local_smacuu0:
	out DSDX, r24
	out DSDY, r22
	ldi r20, SMACUU
	out DSIR, r20
	nop
	nop
	in	r22, DSAL
	in	r24, DSAH
	ret

local_xmscuu0:
    clr r0
    out DSDX, r0
    out DSDY, r0
    nop
    out DSDX, r24
    out DSDY, r22
    ldi r20, XMULUU
    out DSIR, r20
    nop
    //ldi r20, SBAY
    out DSIR, r20
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_xmscuu1:
    clr r0
    out DSDX, r0
    out DSDY, r0
    nop
    out DSAL, r22       
    out DSAH, r24
    out DSDX, r20       
    out DSDY, r18
    ldi r20, XMULUU
    out DSIR, r20
    nop
    //ldi r20, SBAY
    out DSIR, r20
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_xmscss0:
    clr r0
    out DSDX, r0
    out DSDY, r0
    nop
    out DSDX, r24
    out DSDY, r22
    ldi r20, XMULSS
    out DSIR, r20
    nop
    ldi r20, NEGAS
    out DSIR, r20
    nop
    ;ldi r20, ADAYS
    out DSIR, r20
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_xmscss1:
    clr r0
    out DSDX, r0
    out DSDY, r0
    nop
    out DSAL, r22       
    out DSAH, r24
    out DSDX, r20       
    out DSDY, r18
    ldi r20, XMULSS
    out DSIR, r20
    nop
    ldi r20, NEGAS
    out DSIR, r20
    nop
    ;ldi r20, ADAYS
    out DSIR, r20
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_dsu_div0:
    ldi r20, XDIVA
    out DSIR, r20
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_dsu_ashr0:
    ldi r25, ASRA
    or  r24, r25
    out DSIR, r24
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret

local_dsu_ashr2:
    ldi r25, ASRAS
    or  r24, r25
    out DSIR, r24
    nop
    in  r22, DSAL
    in  r24, DSAH
    ret
    

    ; unsigned long dsu_da(void)
; return DA
dsu_da:
	in r22, DSAL
	in r24, DSAH	; return da
	ret

; unsigned long dsu_dx(void)
; return DX
dsu_dx:
	in r24, DSDX	; return dx
	ret

; unsigned long dsu_dy(void)
; return DY
dsu_dy:
	in r24, DSDY	; return dy
	ret

; void dsu_init(uint8_t dsu_mm)
; initial dsu
; enable dsu module
;  dsu_mm : dsu memory mode
;		1 = normal i/o
;		0 = fast i/o

;dsu_init:
;	ldi r20, 0x80		; 1c
;	or r20, r24			; 1c
;	out DSCS, r20		; 1c
;	ret					; 2c

; unsigned int xadd(unsigned int dx, unsigned int dy)
; return (dx + dy)
dsu_xadd:
	out DSDX, r24		; 1c, set dx
	out DSDY, r22		; 1c, set dy
	ldi r20, XADD		; 1c, load opcode
	out DSIR, r20		; 1c, do xadd
	in r24, DSAL			; 1c, {r25, r24} = DA (low half is okay)
	ret					; 2c

; int xads(int dx, int dy)
; return (dx + dy)
dsu_xads:
	out DSDX, r24
	out DSDY, r22
	ldi r20, XADS
	out DSIR, r20		; do xads
	in	r24, DSAL
	ret

; unsigned int xsub(unsigned int dx, unsigned int dy)
; return (dx - dy)
dsu_xsub:
	out DSDX, r24
	out DSDY, r22
	ldi r20, XSUB
	out DSIR, r20	; do xads
	in	r24, DSAL
	ret

; int xsbs(int dx, int dy)
; return (dx - dy)
dsu_xsbs:
	out DSDX, r24
	out DSDY, r22
	ldi r20, XSBS
	out DSIR, r20	; do xads
	in	r24, DSAL
	ret

; void mvy(void)
; foo: da = dy
dsu_mvy:
	ldi r20, MVY
	out DSIR, r20	; do mvy
	ret

; void mvny(void)
; foo: da = -dy
dsu_mvny:
	ldi r20, MVNY
	out DSIR, r20	; do mvy
	ret

; void mvnys(void)
; foo: da = -dy
dsu_mvnys:
	ldi r20, MVNYS
	out DSIR, r20	; do mvy
	ret

; unsigned long aday(unsigned long da, int dy)
; return (da + dy)
dsu_aday:
	out DSAH, r24
	out DSAL, r22	; set da
	out DSDY, r20	; set dy
	ldi r20, ADAY
	out DSIR, r20	; do xads
	in	r22, DSAL
	in	r24, DSAH	; return da
	ret

; long adays(long da, int dy)
; return (da + dy)
dsu_adays:
	out DSAH, r24
	out DSAL, r22	; set da
	out DSDY, r20	; set dy
	ldi r20, ADAYS
	out DSIR, r20	; do xads
	in	r22, DSAL
	in	r24, DSAH	; return da
	ret

; unsigned long sbay(unsigned long da, int dy)
; return (da - dy)
dsu_sbay:
	out DSAH, r24
	out DSAL, r22	; set da
	out DSDY, r20	; set dy
	ldi r20, SBAY
	out DSIR, r20	; do xads
	in	r22, DSAL
	in	r24, DSAH	; return da
	ret

; long sbays(long da, int dy)
; return (da - dy)
dsu_sbays:
	out DSAH, r24
	out DSAL, r22	; set da
	out DSDY, r20	; set dy
	ldi r20, SBAYS
	out DSIR, r20	; do xads
	in	r22, DSAL
	in	r24, DSAH	; return da
	ret

; unsigned long dsu_xmuluu(unsigned int dx, unsigned int dy)
; return (dx * dy)
dsu_xmuluu:
	out DSDX, r24	; +1, set dx
	out DSDY, r22	; +1, set dy
	ldi r20, XMULUU	; +1, load opcode
	out DSIR, r20	; +1, do multiply
	in	r22, DSAL	; +1, {r25, r24} = DAL
	in	r24, DSAH	; +1, {r23, r22} = DAH
	ret				; +2

; long dsu_xmulsu(int dx, unsigned int dy)
; return (dx * dy)
dsu_xmulsu:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMULSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_xmulus(unsigned int dx, int dy)
; return (dx * dy)
dsu_xmulus:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMULUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_xmulss(int dx, int dy)
; return (dx * dy)
dsu_xmulss:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMULSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_xmnluu(unsigned int dx, unsigned int dy)
; return -(dx * dy)
dsu_xmnluu:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMNLUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_xmnlsu(int dx, unsigned int dy)
; return -(dx * dy)
dsu_xmnlsu:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMNLSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_xmnlus(unsigned int dx, int dy)
; return -(dx * dy)
dsu_xmnlus:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMNLUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_xmnlss(int dx, int dy)
; return -(dx * dy)
dsu_xmnlss:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMNLSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_fxmuluu(unsigned int dx, unsigned int dy)
; return (dx * dy) >> 1
dsu_fxmuluu:
	out DSDX, r24	; +1, set dx
	out DSDY, r22	; +1, set dy
	ldi r20, FXMULUU	; +1, load opcode
	out DSIR, r20	; +1, do multiply
	in	r22, DSAL	; +1, {r25, r24} = DAL
	in	r24, DSAH	; +1, {r23, r22} = DAH
	ret				; +2

; long dsu_fxmulsu(int dx, unsigned int dy)
; return (dx * dy) >> 1
dsu_fxmulsu:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMULSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fxmulus(unsigned int dx, int dy)
; return (dx * dy) >> 1
dsu_fxmulus:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMULUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fxmulss(int dx, int dy)
; return (dx * dy) >> 1
dsu_fxmulss:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMULSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fxmnluu(unsigned int dx, unsigned int dy)
; return (-(dx * dy)) >> 1
dsu_fxmnluu:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMNLUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fxmnlsu(int dx, unsigned int dy)
; return -(dx * dy) >> 1
dsu_fxmnlsu:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMNLSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fxmnlus(unsigned int dx, int dy)
; return -(dx * dy) >> 1
dsu_fxmnlus:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMNLUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fxmnlss(int dx, int dy)
; return -(dx * dy) >> 1
dsu_fxmnlss:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, FXMNLSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacuu0(unsigned int dx, unsigned int dy)
; return da + (dx * dy);
dsu_xmacuu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMACUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacuu1(unsigned long da, unsigned int dx, unsigned int dy)
; return da + (dx * dy);
dsu_xmacuu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMACUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacus0(unsigned int dx, int dy)
; return da + (dx * dy);
dsu_xmacus0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMACUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacus1(unsigned long da, unsigned int dx, int dy)
; return da + (dx * dy);
dsu_xmacus1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMACUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacsu0(int dx, unsigned int dy)
; return da + (dx * dy);
dsu_xmacsu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMACSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL 
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacsu1(unsigned long da, int dx, unsigned int dy)
; return da + (dx * dy);
dsu_xmacsu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMACSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacss0(int dx, int dy)
; return da + (dx * dy);
dsu_xmacss0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMACSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacss1(unsigned long da, int dx, int dy)
; return da + (dx * dy);
dsu_xmacss1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMACSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacuu0(unsigned int dx, unsigned int dy)
; return da + (dx * dy);
dsu_smacuu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMACUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacuu1(long da, unsigned int dx, unsigned int dy)
; return da + (dx * dy);
dsu_smacuu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMACUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacus0(unsigned int dx, int dy)
; return da + (dx * dy);
dsu_smacus0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMACUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacus1(long da, unsigned int dx, int dy)
; return da + (dx * dy);
dsu_smacus1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMACUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacsu0(int dx, unsigned int dy)
; return da + (dx * dy);
dsu_smacsu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMACSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

;long dsu_smacsu1(long da, int dx, unsigned int dy)
; return da + (dx * dy);
dsu_smacsu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMACSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacss0(int dx, int dy)
; return da + (dx * dy);
dsu_smacss0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMACSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacss1(long da, int dx, int dy)
; return da + (dx * dy);
dsu_smacss1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMACSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscuu0(unsigned int dx, unsigned int dy)
; return da - (dx * dy);
dsu_xmscuu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMSCUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscuu1(unsigned long da, unsigned int dx, unsigned int dy)
; return da - (dx * dy);
dsu_xmscuu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMSCUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscus0(unsigned int dx, int dy)
; return da - (dx * dy);
dsu_xmscus0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMSCUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscus1(unsigned long da, unsigned int dx, int dy)
; return da - (dx * dy);
dsu_xmscus1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMSCUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscsu0(int dx, unsigned int dy)
; return da - (dx * dy);
dsu_xmscsu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMSCSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscsu1(unsigned long da, int dx, unsigned int dy)
; return da - (dx * dy);
dsu_xmscsu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMSCSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmacss0(int dx, int dy)
; return da - (dx * dy);
dsu_xmscss0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, XMSCSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_xmscss1(unsigned long da, int dx, int dy)
; return da - (dx * dy);
dsu_xmscss1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, XMSCSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret
	
; long dsu_smscuu0(unsigned int dx, unsigned int dy)
; return da - (dx * dy);
dsu_smscuu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMSCUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smscuu1(unsigned long da, unsigned int dx, unsigned int dy)
; return da - (dx * dy);
dsu_smscuu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMSCUU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smscus0(unsigned int dx, int dy)
; return da - (dx * dy);
dsu_smscus0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMSCUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smscus1(unsigned long da, unsigned int dx, int dy)
; return da - (dx * dy);
dsu_smscus1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMSCUS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smscsu0(int dx, unsigned int dy)
; return da - (dx * dy);
dsu_smscsu0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMSCSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smscsu1(unsigned long da, int dx, unsigned int dy)
; return da - (dx * dy);
dsu_smscsu1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMSCSU	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smacss0(int dx, int dy)
; return da - (dx * dy);
dsu_smscss0:
	out DSDX, r24	; set dx
	out DSDY, r22	; set dy
	ldi r20, SMSCSS	; load opcode
	out DSIR, r20	; do multiply
	in	r22, DSAL	; {r25, r24} = DAL
	in	r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_smscss1(unsigned long da, int dx, int dy)
; return da - (dx * dy);
dsu_smscss1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDX, r20	; set dx
	out DSDY, r18	; set dy
	ldi r20, SMSCSS	; load opcode
	out DSIR, r20	; do multiply
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_usqx0(unsigend int dx)
; foo: dx^2;
dsu_usqx0:
	out DSDX, r24	; set dx
	ldi r20, USQX	; load opcode
	out DSIR, r20	; do square
	ret

; unsigned long dsu_usqx1(unsigend int dx)
; return: dx^2;
dsu_usqx1:
	out DSDX, r24	; set dx
	ldi r20, USQX	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_ssqx0(int dx)
; foo: dx^2;
dsu_ssqx0:
	out DSDX, r24	; set dx
	ldi r20, SSQX	; load opcode
	out DSIR, r20	; do square
	ret

; unsigned long dsu_ssqx1(int dx)
; return: dx^2;
dsu_ssqx1:
	out DSDX, r24	; set dx
	ldi r20, SSQX	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_usqy0(unsigend int dy)
; foo: dy^2;
dsu_usqy0:
	out DSDY, r24	; set dy
	ldi r20, USQY	; load opcode
	out DSIR, r20	; do square
	ret

; unsigned long dsu_usqy1(unsigend int dy)
; return: dy^2;
dsu_usqy1:
	out DSDY, r24	; set dy
	ldi r20, USQY	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_ssqy0(int dy)
; foo: dy^2;
dsu_ssqy0:
	out DSDY, r24	; set dy
	ldi r20, SSQY	; load opcode
	out DSIR, r20	; do square
	ret

; unsigned long dsu_ssqy1(int dy)
; return: dy^2;
dsu_ssqy1:
	out DSDY, r24	; set dy
	ldi r20, SSQY	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_clr(void)
; foo: da = 0;
dsu_clr:
	ldi r20, CLRA	; load opcode
	out DSIR, r20	; do square
	ret

; void dsu_abs0(void)
; foo: |da|;
dsu_abs0:
	ldi r20, ABSA	; load opcode
	out DSIR, r20	; do square
	ret

; void dsu_abs1(long da)
; foo: load da, then do |da|;
dsu_abs1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r20, ABSA	; load opcode
	out DSIR, r20	; do square
	ret

; unsigned long dsu_abs2(void)
; return: |da|;
dsu_abs2:
	ldi r20, ABSA	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_abs2(long da)
; foo: load da, then
; return: |da|;
dsu_abs3:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r20, ABSA	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_uneg0(void)
; foo: neg(da), da is unsigned;
dsu_uneg0:
	ldi r20, NEGA	; load opcode
	out DSIR, r20	; do square
	ret

; void dsu_uneg1(unsigned long da)
; foo: load da, then do neg(da)
dsu_uneg1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r20, NEGA	; load opcode
	out DSIR, r20	; do square
	ret

; long dsu_uneg2(void)
; return: neg(da), da is unsigned;
dsu_uneg2:
	ldi r20, NEGA	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_uneg3(unsigned long da)
; foo: load da, then
; return: neg(da);
dsu_uneg3:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r20, NEGA	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; void dsu_sneg0(void)
; foo: neg(da), da is signed;
dsu_sneg0:
	ldi r20, NEGAS	; load opcode
	out DSIR, r20	; do square
	ret

; void dsu_sneg1(long da)
; foo: load da, then do neg(da)
dsu_sneg1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r20, NEGAS	; load opcode
	out DSIR, r20	; do square
	ret

; long dsu_sneg2(void)
; return: neg(da), da is signed;
dsu_sneg2:
	ldi r20, NEGAS	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_sneg3(long da)
; foo: load da, then
; return: neg(da);
dsu_sneg3:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r20, NEGAS	; load opcode
	out DSIR, r20	; do square
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_div0(void)
; foo: da = da/dy
; return: da
dsu_div0:
	ldi r20, XDIVA	; load opcode
	out DSIR, r20	; do divider
chk_dc0:
	nop 
	nop
	nop
	in	r20, DSCS	; read csr
	andi r20, 0x20	; check divider complete flag
	brbc 1, chk_dc0	;
	nop
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_div1(unsigned long da, unsigned int dy)
; foo: da = da/dy, dy = da%dy
; return da
dsu_div1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	out DSDY, r20	; set dy
	ldi r20, XDIVR	; load opcode
	out DSIR, r20	; do divider
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_ashl0(unsigned char shn)
; foo: da = da << shn
; return da
dsu_ashl0:
	ldi r25, ASLA	; load opcode
	;andi r24, 0xf	;
	or r24, r25		; set shn
	out DSIR, r24	; do shift
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_ashl1(unsigned long da, unsigned char shn)
; foo: load da, then do da = da << shn
; return da
dsu_ashl1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r21, ASLA	; load opcode
	;andi r20, 0xf	;
	or r20, r21		; set shn
	out DSIR, r20	; do shift
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_ashr0(unsigned char shn)
; foo: da = da >> shn, da as unsigned data
; return da
dsu_ashr0:
	ldi r25, ASRA	; load opcode
	;andi r24, 0xf	;
	or r24, r25		; set shn
	out DSIR, r24	; do shift
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; unsigned long dsu_ashr1(unsigned long da, unsigned char shn)
; foo: load da, then do da = da >> shn
; return da
dsu_ashr1:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r21, ASRA	; load opcode
	;andi r20, 0xf	;
	or r20, r21		; set shn
	out DSIR, r20	; do shift
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_ashr2(unsigned char shn)
; foo: da = da >> shn, da as signed data
; return da
dsu_ashr2:
	ldi r25, ASRAS	; load opcode
	;andi r24, 0xf	;
	or r24, r25		; set shn
	out DSIR, r24	; do shift
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_ashr3(long da, unsigned char shn)
; foo: load da, then do da = da >> shn
; return da
dsu_ashr3:
	out DSAL, r22	; set DAL 
	out DSAH, r24	; set DAH
	ldi r21, ASRAS	; load opcode
	;andi r20, 0xf	;
	or r20, r21		; set shn
	out DSIR, r20	; do shift
	in  r22, DSAL	; {r25, r24} = DAL
	in  r24, DSAH	; {r23, r22} = DAH
	ret

; long dsu_fmacss2(unsigned int dx_addr, unsigned int dy_addr, unsigned char cnt)
; foo: loop of da = da + dx_addr[i] * dy_addr[i]
; return da
dsu_fmacss:
	push r28
	push r29
	movw r30, r24	; dx_addr load to Z
	movw r28, r22	; dy_addr load to Y
					; loop count is in r20
	ldi r21, XMACSS	; load opcode
fmacss2_loop:
	ldd r0, Z+2		; DX = *(dx_addr), then dx_addr += 2 (for 16bit address)
	ldd r1, Y+2		; DY = *(dy_addr), then dy_addr += 2 (for 16bit address)
	out DSIR, r21	; do da += dx * dy
	dec r20			; count down
	breq fmacss2_done	; if loop done
	rjmp fmacss2_loop
fmacss2_done:
	in	r22, DSAL	;
	in	r24, DSAH	; return DA
	pop r29
	pop r28
	ret
