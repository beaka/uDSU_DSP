/*
 * uDSU_DSP - FIR_LowPass example
 *
 * 16-tap FIR low-pass filter, designed for fs = 8000 Hz, fc = 800 Hz
 * (Hamming-windowed sinc, unity DC gain, coefficients in Q15 fixed
 * point). Every tap's multiply-accumulate is done in one hardware
 * loop by the LGT8F328P uDSU (dsu_fmacss), instead of 16 separate
 * software multiplies.
 *
 * Feeds a test signal (a "clean" tone mixed with a fast, noisy tone)
 * through the filter and prints input vs. filtered output so you can
 * see the noise removed.
 *
 * Board: LGT8F328P (e.g. "Larduino"/lgt8fx core)
 */
#include <Arduino.h>
#include "udsu.h"
#include "uDSU_FIR.h"

// 16 taps, Q15 fixed point, low-pass @ 800Hz for an 8kHz sample rate.
//
// NOTE: intentionally NOT declared `const`. Modern avr-gcc is free to
// place a plain `const` array like this into flash instead of RAM,
// which breaks dsu_fmacss() -- it expects a real SRAM address it can
// OR with 0x2000 to reach the uDSU's 16-bit access mirror. A flash
// address there just reads garbage/empty space, and you'll see the
// filtered output come out as 0 the whole time. Keeping this as a
// plain (non-const) global forces it into RAM.
int16_t firCoeffs[16] = {
  -114, -159, -139, 291, 1450, 3284, 5246, 6524,
  6524, 5246, 3284, 1450, 291, -139, -159, -114
};

uDSU_FIR fir(firCoeffs, 16);

const float SAMPLE_RATE = 8000.0;
uint32_t sampleIndex = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial) {}

  fir.begin();  // calls dsu_init() and clears the filter history

  Serial.println("uDSU_DSP FIR_LowPass example");
  Serial.println("sample, input, filtered");
}

void loop() {
  float t = sampleIndex / SAMPLE_RATE;

  // "Signal" = 100 Hz tone (should pass) + 3000 Hz tone (should be
  // attenuated by the 800 Hz low-pass), scaled to +-8000 counts.
  float signal = 6000.0 * sin(2 * PI * 100.0 * t) +
                 2000.0 * sin(2 * PI * 3000.0 * t);
  int16_t input = (int16_t)signal;

  // Q15 accumulator -> rescale back to the input's units.
  int16_t output = (int16_t)(fir.update(input) >> 15);

  Serial.print(sampleIndex);
  Serial.print(", ");
  Serial.print(input);
  Serial.print(", ");
  Serial.println(output);

  sampleIndex++;
  if (sampleIndex >= 200) {
    while (1) {}  // done - halt so the Serial Plotter/Monitor settles
  }

  delayMicroseconds((uint32_t)(1000000.0 / SAMPLE_RATE));
}
