/*
 * uDSU_DSP - Biquad_LowPass example
 *
 * Single 2nd-order Butterworth low-pass biquad section, designed for
 * fs = 8000 Hz, fc = 500 Hz, Q = 0.7071 (RBJ Audio EQ Cookbook
 * formulas, coefficients in Q14 fixed point, a0 normalized to 1).
 *
 * Each sample runs as one chain of hardware multiply-accumulate /
 * multiply-subtract operations on the LGT8F328P uDSU
 * (dsu_xmulss / dsu_smacss1 / dsu_smscss1 / dsu_ashr3) instead of
 * five separate software multiplies plus a software shift.
 *
 * Board: LGT8F328P (e.g. "Larduino"/lgt8fx core)
 */
#include <Arduino.h>
#include "udsu.h"
#include "uDSU_Biquad.h"

// b0, b1, b2, a1, a2 in Q14 fixed point (shift = 14), a0 = 1.
uDSU_Biquad lowpass(491, 982, 491, -23826, 9405, 14);

const float SAMPLE_RATE = 8000.0;
uint32_t sampleIndex = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial) {}

  lowpass.begin();  // calls dsu_init() and clears x1,x2,y1,y2

  Serial.println("uDSU_DSP Biquad_LowPass example");
  Serial.println("sample, input, filtered");
}

void loop() {
  float t = sampleIndex / SAMPLE_RATE;

  // "Signal" = 100 Hz tone (should pass) + 2500 Hz tone (should be
  // attenuated by the 500 Hz low-pass), scaled to +-8000 counts.
  float signal = 6000.0 * sin(2 * PI * 100.0 * t) +
                 2000.0 * sin(2 * PI * 2500.0 * t);
  int16_t input = (int16_t)signal;

  int16_t output = lowpass.update(input);

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
