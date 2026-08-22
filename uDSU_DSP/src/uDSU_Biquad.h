#ifndef __UDSU_BIQUAD_H__
#define __UDSU_BIQUAD_H__

#include <Arduino.h>
#include "udsu.h"

class uDSU_Biquad {
  public:
    uDSU_Biquad(int16_t b0, int16_t b1, int16_t b2, int16_t a1, int16_t a2, uint8_t shift = 14);
    void begin(bool initDSU = true);
    void reset();
    int16_t update(int16_t x0, uint8_t customShift = 0xFF); 
    uint8_t getShift() const { return _shift; }
    
  private:
    int16_t _coeffs[5];   // b0, b1, b2, -a1, -a2 - must stay non-const (RAM)
    int16_t _data[5];     // x0, x1, x2, y1, y2   - must stay non-const (RAM)
    uint8_t _shift;
    int16_t _x1, _x2, _y1, _y2;
};

class uDSU_BiquadCascade {
  public:
    uDSU_BiquadCascade(uDSU_Biquad *sections, uint8_t numSections);
    void begin(bool initDSU = true);
    void reset();
    int16_t update(int16_t x0);

  private:
    uDSU_Biquad *_sections;
    uint8_t _numSections;
};

#endif
