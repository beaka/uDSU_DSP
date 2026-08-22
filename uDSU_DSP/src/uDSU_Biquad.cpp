#include "uDSU_Biquad.h"

uDSU_Biquad::uDSU_Biquad(int16_t b0, int16_t b1, int16_t b2, int16_t a1, int16_t a2, uint8_t shift)
    : _shift(shift), _x1(0), _x2(0), _y1(0), _y2(0) {
  _coeffs[0] = b0; _coeffs[1] = b1; _coeffs[2] = b2;
  _coeffs[3] = (int16_t)(-a1); _coeffs[4] = (int16_t)(-a2);
}

void uDSU_Biquad::reset() {
  _x1 = _x2 = 0;
  _y1 = _y2 = 0;
}

void uDSU_Biquad::begin(bool initDSU) {
  if (initDSU) dsu_init(DSU_MM_FAST);   // fmacss requires FAST, always
  reset();
}

int16_t uDSU_Biquad::update(int16_t x0, uint8_t customShift) {
  _data[0] = x0; _data[1] = _x1; _data[2] = _x2; _data[3] = _y1; _data[4] = _y2;

  dsu_clr();
  long acc = dsu_fmacss(((uint16_t)(uintptr_t)_coeffs) | 0x2000,
                         ((uint16_t)(uintptr_t)_data)   | 0x2000,
                         5);

  uint8_t shiftAmount = (customShift == 0xFF) ? _shift : customShift;
  int16_t y0 = (int16_t)dsu_ashr3(acc, shiftAmount);

  _x2 = _x1; _x1 = x0;
  _y2 = _y1; _y1 = y0;
  return y0;
}

// Cascade wrapper implementation
uDSU_BiquadCascade::uDSU_BiquadCascade(uDSU_Biquad *sections, uint8_t numSections)
    : _sections(sections), _numSections(numSections) {}

void uDSU_BiquadCascade::begin(bool initDSU) {
  if (initDSU) dsu_init(DSU_MM_FAST);
  reset();
}

void uDSU_BiquadCascade::reset() {
  for (uint8_t i = 0; i < _numSections; i++) {
    _sections[i].reset();
  }
}

int16_t uDSU_BiquadCascade::update(int16_t x0) {
  int16_t y = x0;
  for (uint8_t i = 0; i < _numSections - 1; i++) {
    y = _sections[i].update(y, _sections[i].getShift() - 1);
  }
  y = _sections[_numSections - 1].update(y, _sections[_numSections - 1].getShift() + 1);
  return y;
}
