#ifndef __UDSU_FIR_H__
#define __UDSU_FIR_H__

#include <Arduino.h>
#include "udsu.h"

class uDSU_FIR {
  public:
    uDSU_FIR(const int16_t *coeffs, uint8_t numTaps);
    ~uDSU_FIR();

    void begin(bool initDSU = true);
    void reset();

    // Legacy standard single-output FIR update
    int32_t update(int16_t input);

    // NEW OVERLOAD: Calculates Q value as return, populates delay-matched I sample
    int32_t update(int16_t input, int16_t *i_out);

    // NEW METHOD: Safely swaps the coefficient pointer on the fly
    void setCoefficients(const int16_t *newCoeffs);

    uint8_t numTaps() const { return _numTaps; }

  private:
    const int16_t *_coeffs; // Pointer to active coefficients in RAM
    int16_t *_history;       // Pointer to double-sized mirrored history buffer
    uint8_t _numTaps;
    uint8_t _head;           // Circular buffer window tracker
};

#endif
