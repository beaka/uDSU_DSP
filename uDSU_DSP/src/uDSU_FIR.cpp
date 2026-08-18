#include "uDSU_FIR.h"

uDSU_FIR::uDSU_FIR(const int16_t *coeffs, uint8_t numTaps)
  : _coeffs(coeffs), _history(nullptr), _numTaps(numTaps) {
  _history = (int16_t *)calloc(numTaps, sizeof(int16_t));
}

uDSU_FIR::~uDSU_FIR() {
  if (_history) free(_history);
}

void uDSU_FIR::begin(bool initDSU) {
  if (initDSU) {
    // dsu_fmacss()'s inner loop feeds DX/DY via r0/r1 (see udsu.S) --
    // it never issues an explicit "out DSDX,../out DSDY,.." like the
    // scalar ops do. That r0/r1 <-> DX/DY aliasing appears to only be
    // active in FAST mode; under NORMAL mode the multiply-accumulate
    // loop silently runs against stale/zero operands, so every
    // update() comes back as 0 regardless of input. Use FAST mode
    // here specifically because this class relies on dsu_fmacss().
    dsu_init(DSU_MM_FAST);
  }
  reset();
}

void uDSU_FIR::reset() {
  for (uint8_t i = 0; i < _numTaps; i++) {
    _history[i] = 0;
  }
}

int32_t uDSU_FIR::update(int16_t input) {
  // Shift the delay line: history[0] is always the newest sample,
  // matching the tap order coeffs[0..N-1] is written in (h[0] pairs
  // with the newest sample). Simple and predictable; for very long
  // filters a circular buffer would avoid this O(N) shift.
  for (uint8_t i = _numTaps - 1; i > 0; i--) {
    _history[i] = _history[i - 1];
  }
  _history[0] = input;

  // Hardware dot-product: da = sum(coeffs[i] * history[i]).
  // Addresses are OR'd with 0x2000 to select the uDSU's 16-bit SRAM
  // access mirror, exactly as in the reference test_udsu.ino sketch.
  dsu_clr();
  int32_t acc = dsu_fmacss(
      ((uint16_t)(uintptr_t)_coeffs) | 0x2000,
      ((uint16_t)(uintptr_t)_history) | 0x2000,
      _numTaps);

  return acc;
}
