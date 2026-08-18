#include "uDSU_Biquad.h"

uDSU_Biquad::uDSU_Biquad(int16_t b0, int16_t b1, int16_t b2,
                         int16_t a1, int16_t a2, uint8_t shift)
  : _b0(b0), _b1(b1), _b2(b2), _a1(a1), _a2(a2), _shift(shift),
    _x1(0), _x2(0), _y1(0), _y2(0) {}

void uDSU_Biquad::begin(bool initDSU) {
  if (initDSU) {
    dsu_init(DSU_MM_NORMAL);
  }
  reset();
}

void uDSU_Biquad::reset() {
  _x1 = _x2 = 0;
  _y1 = _y2 = 0;
}

int16_t uDSU_Biquad::update(int16_t x0) {
  // acc = b0*x0
  int32_t acc = (int32_t)dsu_xmulss(_b0, x0);
  // acc += b1*x1 ; acc += b2*x2
  acc = dsu_smacss1(acc, _b1, _x1);
  acc = dsu_smacss1(acc, _b2, _x2);
  // acc -= a1*y1 ; acc -= a2*y2
  acc = dsu_smscss1(acc, _a1, _y1);
  acc = dsu_smscss1(acc, _a2, _y2);

  // Rescale from Q(shift) back to the input's units.
  int16_t y0 = (int16_t)dsu_ashr3(acc, _shift);

  _x2 = _x1;
  _x1 = x0;
  _y2 = _y1;
  _y1 = y0;

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
  for (uint8_t i = 0; i < _numSections; i++) {
    y = _sections[i].update(y);
  }
  return y;
}
