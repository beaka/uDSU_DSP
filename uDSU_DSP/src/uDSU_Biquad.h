//=====================================================================
//  uDSU_Biquad - hardware-accelerated biquad (2nd order IIR) filter
//                for the LGT8F328P uDSU
//
//  Direct Form I difference equation:
//      y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2]
//                     - a1*y[n-1] - a2*y[n-2]
//
//  Coefficients are signed 16-bit fixed point, scaled by 2^shift
//  (i.e. Q(shift) format, e.g. shift=14 -> 1.0 stored as 16384).
//  Any RBJ "Audio EQ Cookbook" biquad design (lowpass, highpass,
//  bandpass, notch, peaking EQ, shelf...) normalized so a0 = 1 can be
//  quantized into this form.
//
//  Each stage runs as one chain of hardware multiply-accumulate /
//  multiply-subtract ops on the uDSU (dsu_xmulss / dsu_smacss1 /
//  dsu_smscss1), followed by one hardware arithmetic shift
//  (dsu_ashr3) to rescale back to the input's units.
//=====================================================================
#ifndef __UDSU_BIQUAD_H__
#define __UDSU_BIQUAD_H__

#include <Arduino.h>
#include "udsu.h"

class uDSU_Biquad {
  public:
    // b0,b1,b2,a1,a2 : Q(shift) fixed-point coefficients (a0 assumed 1).
    // shift          : fixed-point scale factor, e.g. 14 for Q14.
    uDSU_Biquad(int16_t b0, int16_t b1, int16_t b2,
                int16_t a1, int16_t a2, uint8_t shift = 14);

    // Call once from setup(). Set initDSU=false if you already called
    // dsu_init() yourself (e.g. because you're sharing the uDSU with
    // other filters/code).
    void begin(bool initDSU = true);

    // Clears the x[n-1], x[n-2], y[n-1], y[n-2] history.
    void reset();

    // Runs one sample through the section, returns y[n] rescaled back
    // to the input's units (i.e. already shifted right by `shift`).
    int16_t update(int16_t x0);

  private:
    int16_t _b0, _b1, _b2, _a1, _a2;
    uint8_t _shift;
    int16_t _x1, _x2;  // input history:  x[n-1], x[n-2]
    int16_t _y1, _y2;  // output history: y[n-1], y[n-2]
};

// Cascade of biquad sections, for filters steeper than 2nd order
// (e.g. a 4th order Butterworth = two cascaded biquads).
class uDSU_BiquadCascade {
  public:
    uDSU_BiquadCascade(uDSU_Biquad *sections, uint8_t numSections);

    void begin(bool initDSU = true);
    void reset();

    // Feeds x0 through every section in turn (section i's output
    // becomes section i+1's input) and returns the final output.
    int16_t update(int16_t x0);

  private:
    uDSU_Biquad *_sections;
    uint8_t _numSections;
};

#endif
