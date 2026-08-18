//=====================================================================
//  uDSU_FIR - hardware-accelerated FIR filter for the LGT8F328P uDSU
//
//  Uses dsu_fmacss() (see udsu.S / udsu.h) which runs the whole
//  tap-by-tap multiply-accumulate loop *inside* the uDSU hardware:
//      da = sum( coeffs[i] * history[i] )   for i = 0 .. numTaps-1
//
//  Both arrays must live in normal SRAM; the class takes care of
//  OR-ing their addresses with 0x2000 to select the uDSU's 16-bit
//  access mirror, exactly as shown in the reference test_udsu.ino.
//=====================================================================
#ifndef __UDSU_FIR_H__
#define __UDSU_FIR_H__

#include <Arduino.h>
#include "udsu.h"

class uDSU_FIR {
  public:
    // coeffs  : pointer to numTaps signed 16-bit coefficients, MUST
    //           live in real SRAM (not flash). dsu_fmacss() takes the
    //           raw address and OR's it with 0x2000 to reach the
    //           uDSU's 16-bit access mirror -- a flash address there
    //           just reads garbage. Concretely: do NOT declare your
    //           coefficient array `const` at file scope, since
    //           avr-gcc is free to place a plain `const` array into
    //           flash instead of RAM. A plain (non-const) global or
    //           a RAM-allocated array is safe.
    //           Recommended format: Q15 fixed point (i.e. a coefficient
    //           of 1.0 is stored as 32767), so the raw update() sum
    //           can be rescaled back to the input range with >>15.
    // numTaps : number of filter taps (1-255). Keep it modest (<=32)
    //           since update() shifts the whole history buffer.
    uDSU_FIR(const int16_t *coeffs, uint8_t numTaps);
    ~uDSU_FIR();

    // Call once from setup(). Set initDSU=false if you already called
    // dsu_init() yourself (e.g. because you're sharing the uDSU with
    // other code). NOTE: this class needs DSU_MM_FAST specifically
    // (dsu_fmacss's loop relies on it) -- if you also use
    // uDSU_Biquad in the same sketch, initialize whichever one runs
    // last with initDSU=false, or call dsu_init(DSU_MM_FAST) yourself
    // right before every uDSU_FIR::update() call.
    void begin(bool initDSU = true);

    // Clears the internal sample history (does not touch coefficients).
    void reset();

    // Pushes one new input sample through the filter and returns the
    // raw 32-bit accumulator sum(coeff[i] * history[i]). If coeffs are
    // Q15 fixed point, shift the result right by 15 to rescale it back
    // to the input's units, e.g.: int16_t y = fir.update(x) >> 15;
    int32_t update(int16_t input);

    uint8_t numTaps() const { return _numTaps; }

  private:
    const int16_t *_coeffs;
    int16_t *_history;
    uint8_t _numTaps;
};

#endif
