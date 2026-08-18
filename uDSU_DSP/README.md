# uDSU_DSP

FIR and biquad (IIR) filters for the LGT8F328P's built-in uDSU
(micro Digital Signal Unit) hardware multiply-accumulator, built on
top of the low-level `udsu.h` / `udsu.S` driver.

## Contents

- `src/udsu.h`, `src/udsu.S` - the original uDSU assembly driver
  (unchanged), exposing `dsu_*` functions for the hardware's
  add/subtract/multiply/multiply-accumulate/divide/shift ops.
- `src/uDSU_FIR.h/.cpp` - `uDSU_FIR` class. Runs the whole
  tap-by-tap convolution as **one hardware loop**
  (`dsu_fmacss`), the same primitive used by the `dsu_fmacss(...)`
  call at the end of `test_udsu.ino`.
- `src/uDSU_Biquad.h/.cpp` - `uDSU_Biquad` and `uDSU_BiquadCascade`
  classes. Each sample is one chain of hardware signed
  multiply-accumulate / multiply-subtract ops
  (`dsu_xmulss`, `dsu_smacss1`, `dsu_smscss1`) plus one hardware
  arithmetic shift (`dsu_ashr3`) to rescale the fixed-point result.
- `examples/FIR_LowPass` - 16-tap FIR low-pass, fs=8kHz, fc=800Hz.
- `examples/Biquad_LowPass` - 2nd-order Butterworth low-pass,
  fs=8kHz, fc=500Hz, Q=0.7071.

## Installation

Copy this whole `uDSU_DSP` folder into your Arduino `libraries/`
folder (or zip it and use *Sketch > Include Library > Add .ZIP
Library...*). Requires the LGT8F328P ("Larduino"/`lgt8fx`) board
package, since `udsu.S` uses LGT8F-specific SFRs and won't build for
a plain ATmega328P.

## Fixed-point format

Both filter types use signed 16-bit fixed-point coefficients:

- **FIR**: Q15 (coefficient `1.0` = `32767`). `update()` returns the
  raw 32-bit accumulator - shift it right by 15 to rescale back to
  your input's units.
- **Biquad**: Q(shift), shift defaults to 14 (coefficient `1.0` =
  `16384`). `update()` already rescales internally and returns a
  ready-to-use `int16_t`.

## Designing your own filters

The example coefficients were generated with NumPy:

```python
import numpy as np

# FIR: N-tap Hamming-windowed-sinc low-pass, unity DC gain
N, fs, fc = 16, 8000.0, 800.0
n = np.arange(N); m = n - (N - 1) / 2.0
h = np.sinc(2 * fc / fs * m) * np.hamming(N)
h /= np.sum(h)
fir_q15 = np.round(h * 32767).astype(np.int16)

# Biquad: RBJ Audio EQ Cookbook 2nd-order Butterworth low-pass
fc2, Q, fs = 500.0, 0.70710678, 8000.0
w0 = 2 * np.pi * fc2 / fs
alpha = np.sin(w0) / (2 * Q)
cosw0 = np.cos(w0)
b0 = (1 - cosw0) / 2; b1 = 1 - cosw0; b2 = (1 - cosw0) / 2
a0 = 1 + alpha; a1 = -2 * cosw0; a2 = 1 - alpha
SHIFT = 14
coeffs_q14 = [int(round(c / a0 * (1 << SHIFT))) for c in (b0, b1, b2, a1, a2)]
```

Swap in your own cutoff/Q/filter-type formulas (RBJ cookbook covers
highpass, bandpass, notch, peaking EQ, and shelves too) and re-run.
For steeper filters, design a higher-order Butterworth/Chebyshev
filter as a cascade of 2nd-order sections and feed them to
`uDSU_BiquadCascade`.

## Notes / limitations

- `uDSU_FIR::update()` shifts its history buffer every sample
  (O(numTaps)); fine for the modest tap counts these hardware DSP
  loops are meant for, but a circular buffer would be faster for
  very long filters.
- Coefficient and history arrays for `dsu_fmacss` must live in normal
  SRAM below `0x2000` (true for normal `calloc`/static arrays on
  this chip) - the library OR's their addresses with `0x2000` for you,
  exactly as shown in `test_udsu.ino`.
- Only one uDSU exists on-chip. If you mix `uDSU_FIR`/`uDSU_Biquad`
  with other direct `dsu_*` calls, only call `dsu_init()` once
  (pass `initDSU=false` to `begin()` on the others).
