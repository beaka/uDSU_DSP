#include "uDSU_Biquad.h"

uDSU_Biquad::uDSU_Biquad(int16_t b0, int16_t b1, int16_t b2,
                         int16_t a1, int16_t a2, uint8_t shift)
  : _b0(b0), _b1(b1), _b2(b2), _a1(a1), _a2(a2), _shift(shift),
    _x1(0), _x2(0), _y1(0), _y2(0) {}

void uDSU_Biquad::begin(bool initDSU) {
  if (initDSU) {
    dsu_init(DSU_MM_FAST);
  }
  reset();
}

void uDSU_Biquad::reset() {
  _x1 = _x2 = 0;
  _y1 = _y2 = 0;
}

int16_t uDSU_Biquad::update(int16_t x0, uint8_t customShift) {
  // 1. Maintain hardware multiplier for feed-forward paths
  int32_t term_b0 = (int32_t)dsu_xmulss(_b0, x0);
  int32_t term_b1 = (int32_t)dsu_xmulss(_b1, _x1);
  int32_t term_b2 = (int32_t)dsu_xmulss(_b2, _x2);

  // 2. Maintain hardware multiplier for feedback paths
  int32_t term_a1 = (int32_t)dsu_xmulss(_a1, _y1);
  int32_t term_a2 = (int32_t)dsu_xmulss(_a2, _y2);

  // 3. Process accumulator tracking in pure C++ software.
  // This bypasses the buggy dsu_smscss1 hardware accumulation logic.
  // Standard biquad form: y0 = b0*x0 + b1*x1 + b2*x2 - a1*y1 - a2*y2
  int32_t acc = term_b0 + term_b1 + term_b2 - term_a1 - term_a2;

  // 4. Handle default/custom bit shifting safely
  uint8_t shiftAmount = (customShift == 0xFF) ? _shift : customShift;
  int16_t y0 = (int16_t)(acc >> shiftAmount);

  // 5. Update history registers
  _x2 = _x1;  _x1 = x0;
  _y2 = _y1;  _y1 = y0;

  return y0;
}

//=====================================================================
// uDSU_BiquadCascade
//=====================================================================
uDSU_BiquadCascade::uDSU_BiquadCascade(uDSU_Biquad *sections, uint8_t numSections)
  : _sections(sections), _numSections(numSections) {}

void uDSU_BiquadCascade::begin(bool initDSU) {
  if (initDSU) {
    dsu_init(DSU_MM_NORMAL);
  }
  reset();
}

void uDSU_BiquadCascade::reset() {
  for (uint8_t i = 0; i < _numSections; i++) {
    _sections[i].reset();
  }
}

int16_t uDSU_BiquadCascade::update(int16_t x0) {
  int16_t y = x0;
  
  // Pass through all intermediate sections
  for (uint8_t i = 0; i < _numSections - 1; i++) {
    // Shift by (_shift - 1). For Q14, this shifts by 13.
    // The signal travels to the next stage with high resolution (Q1).
    y = _sections[i].update(y, _sections[i].getShift() - 1); 
  }
  
  // The final section shifts by the remaining amount to bring it back to a normal Q0 integer.
  // Since the incoming signal is Q1, the final stage needs to clear its own Q14 scale PLUS the extra Q1.
  y = _sections[_numSections - 1].update(y, _sections[_numSections - 1].getShift() + 1);
  
  return y;
}
