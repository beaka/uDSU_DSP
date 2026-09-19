#include "uDSU_FIR.h"

uDSU_FIR::uDSU_FIR(const int16_t *coeffs, uint8_t numTaps)
  : _coeffs(coeffs), _history(nullptr), _numTaps(numTaps), _head(0) {
  // Allocate TWICE the space to allow continuous hardware streaming without wrapping loops
  _history = (int16_t *)calloc(numTaps * 2, sizeof(int16_t));
}

uDSU_FIR::~uDSU_FIR() {
  if (_history) free(_history);
}

void uDSU_FIR::begin(bool initDSU) {
  if (initDSU) {
    dsu_init(DSU_MM_FAST); // Required for dsu_fmacss() inside the ISR
  }
  reset();
}

void uDSU_FIR::reset() {
  _head = 0;
  for (uint16_t i = 0; i < ((uint16_t)_numTaps * 2); i++) {
    _history[i] = 0;
  }
}

// Fallback legacy method if called without the secondary I parameter
int32_t uDSU_FIR::update(int16_t input) {
  return update(input, nullptr);
}

// NEW METHOD IMPLEMENTATION: Swaps the RAM target address pointer safely
void uDSU_FIR::setCoefficients(const int16_t *newCoeffs) {
  _coeffs = newCoeffs;
}

// THE CORE HILBERT PIPELINE: Zero memory shifting, dynamic delay matching
int32_t uDSU_FIR::update(int16_t input, int16_t *i_out) {
  // 1. Step the circular pointer backwards (wrapping smoothly at numTaps)
  if (_head == 0) {
    _head = _numTaps - 1;
  } else {
    _head--;
  }

  // 2. Mirrored double-write: guarantees a linear history slice always exists
  _history[_head] = input;
  _history[_head + _numTaps] = input;

  // 3. DYNAMIC CENTER-TAP EXTRACTOR
  // Index 0 relative to _head is the newest sample. 
  // The delay-matched sample is sitting exactly ((_numTaps - 1) / 2) entries ahead.
  if (i_out != nullptr) {
    uint8_t centerTapOffset = (_numTaps - 1) >> 1;
    *i_out = _history[_head + centerTapOffset];
  }

  // 4. Stream the physical contiguous memory slice starting at _head into the DSC unit
  dsu_clr();
  int32_t acc = dsu_fmacss(
      ((uint16_t)(uintptr_t)_coeffs) | 0x2000,
      ((uint16_t)(uintptr_t)&_history[_head]) | 0x2000, 
      _numTaps);

  return acc;
}
