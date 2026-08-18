
//=======================
//  lgt8xp uDSU library
//       Rev1.0.0
//=======================


#ifndef __UDSU__
#define __UDSU__

#include <avr/io.h>

#define DSU_MM_FAST		0x00
#define DSU_MM_NORMAL	0x40

extern "C" void dsu_init(unsigned char dsu_mm);

extern "C" unsigned int dsu_xadd(unsigned int dx, unsigned int dy);
extern "C" int signed   dsu_xads(int dx, int dy);
extern "C" unsigned int dsu_xsub(unsigned int dx, unsigned int dy);
extern "C" int dsu_xsbs(int dx, int dy);
extern "C" unsigned long dsu_aday(unsigned long da, unsigned int dy);
extern "C" long dsu_adays(long da, int dy);
extern "C" unsigned long dsu_sbay(unsigned long da, unsigned int dy);
extern "C" long dsu_sbays(long da, int dy);
extern "C" unsigned long dsu_xmuluu(unsigned int dx, unsigned int dy);
extern "C" long dsu_xmulsu(int dx, unsigned int dy);
extern "C" long dsu_xmulus(unsigned int dx, int dy);
extern "C" unsigned long dsu_xmulss(int dx, int dy);

extern "C" unsigned long dsu_xmacuu0(unsigned int dx, unsigned int dy);
extern "C" unsigned long dsu_xmacuu1(unsigned long da, unsigned int dx, unsigned int dy);
extern "C" unsigned long dsu_xmacus0(unsigned int dx, int dy);
extern "C" unsigned long dsu_xmacus1(unsigned long da, unsigned int dx, int dy);
extern "C" unsigned long dsu_xmacsu0(int dx, unsigned int dy);
extern "C" unsigned long dsu_xmacsu1(unsigned long da, int dx, unsigned int dy);
extern "C" unsigned long dsu_xmacss0(int dx, int dy);
extern "C" unsigned long dsu_xmacss1(unsigned long da, int dx, int dy);
extern "C" long dsu_smacuu0(unsigned int dx, unsigned int dy);
extern "C" long dsu_smacuu1(long da, unsigned int dx, unsigned int dy);
extern "C" long dsu_smacus0(unsigned int dx, int dy);
extern "C" long dsu_smacus1(long da, unsigned int dx, int dy);
extern "C" long dsu_smacsu0(int dx, unsigned int dy);
extern "C" long dsu_smacsu1(long da, int dx, unsigned int dy);
extern "C" long dsu_smacss0(int dx, int dy);
extern "C" long dsu_smacss1(long da, int dx, int dy);

extern "C" unsigned long dsu_xmscuu0(unsigned int dx, unsigned int dy);
extern "C" unsigned long dsu_xmscuu1(unsigned long da, unsigned int dx, unsigned int dy);
extern "C" unsigned long dsu_xmscus0(unsigned int dx, int dy);
extern "C" unsigned long dsu_xmscus1(unsigned long da, unsigned int dx, int dy);
extern "C" unsigned long dsu_xmscsu0(int dx, unsigned int dy);
extern "C" unsigned long dsu_xmscsu1(unsigned long da, int dx, unsigned int dy);
extern "C" unsigned long dsu_xmscss0(int dx, int dy);
extern "C" unsigned long dsu_xmscss1(unsigned long da, int dx, int dy);
extern "C" long dsu_smscuu0(unsigned int dx, unsigned int dy);
extern "C" long dsu_smscuu1(long da, unsigned int dx, unsigned int dy);
extern "C" long dsu_smscus0(unsigned int dx, int dy);
extern "C" long dsu_smscus1(long da, unsigned int dx, int dy);
extern "C" long dsu_smscsu0(int dx, unsigned int dy);
extern "C" long dsu_smscsu1(long da, int dx, unsigned int dy);
extern "C" long dsu_smscss0(int dx, int dy);
extern "C" long dsu_smscss1(long da, int dx, int dy);

extern "C" void dsu_usqx0(unsigned int dx);
extern "C" void dsu_ssqx0(int dx);
extern "C" void dsu_usqy0(unsigned int dy);
extern "C" void dsu_ssqy0(int dy);
extern "C" unsigned long dsu_usqx1(unsigned int dx);
extern "C" unsigned long dsu_ssqx1(int dx);
extern "C" unsigned long dsu_usqy1(unsigned int dy);
extern "C" unsigned long dsu_ssqy1(int dy);
extern "C" void dsu_uneg0(void);
extern "C" void dsu_uneg1(unsigned long da);
extern "C" long dsu_uneg2(void);
extern "C" long dsu_uneg3(unsigned long da);
extern "C" void dsu_sneg0(void);
extern "C" void dsu_sneg1(long da);
extern "C" long dsu_sneg2(void);
extern "C" long dsu_sneg3(long da);
extern "C" void dsu_abs0(void);
extern "C" void dsu_abs1(long da);
extern "C" unsigned long dsu_abs2(void);
extern "C" unsigned long dsu_abs3(long da);
extern "C" void dsu_clr(void);
extern "C" unsigned long dsu_div0(void);
extern "C" unsigned long dsu_div1(unsigned long da, unsigned int dy);

extern "C" unsigned long dsu_ashl0(unsigned char shn);
extern "C" unsigned long dsu_ashl1(unsigned long da, unsigned char shn);
extern "C" unsigned long dsu_ashr0(unsigned char shn);
extern "C" unsigned long dsu_ashr1(unsigned long da, unsigned char shn);
extern "C" long dsu_ashr2(unsigned char shn);
extern "C" long dsu_ashr3(long da, unsigned char shn);

extern "C" unsigned long dsu_da(void);
extern "C" unsigned int dsu_dx(void);
extern "C" unsigned int dsu_dy(void);

extern "C" long dsu_fmacss(unsigned int dx, unsigned int dy, unsigned char cnt);

#endif	
