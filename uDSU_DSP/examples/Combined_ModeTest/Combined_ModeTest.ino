/*
 * uDSU_DSP - Combined_ModeTest
 *
 * Purpose: verify that uDSU_Biquad still produces correct results
 * when the uDSU is initialized with DSU_MM_FAST (the mode uDSU_FIR
 * needs for dsu_fmacss to work), instead of the DSU_MM_NORMAL mode
 * used by the standalone Biquad_LowPass example.
 *
 * Runs the *exact same* 100Hz+2500Hz test signal as the standalone
 * Biquad_LowPass example, through a biquad with identical
 * coefficients, but with the DSU left in FAST mode (because a
 * uDSU_FIR instance is also running in this sketch).
 *
 * How to check the result: compare the "biquad_fast" column below
 * against the "filtered" column you already captured from
 * Biquad_LowPass (run under DSU_MM_NORMAL). If they match sample for
 * sample, uDSU_FIR and uDSU_Biquad can safely coexist in one sketch,
 * initialized once with DSU_MM_FAST.
 *
 * Board: LGT8F328P (e.g. "Larduino"/lgt8fx core)
 */
#include <Arduino.h>
#include "udsu.h"
#include "uDSU_FIR.h"
#include "uDSU_Biquad.h"

// Same 16 FIR taps as the FIR_LowPass example. NOT const -- see the
// note in that example about avr-gcc placing const arrays in flash.
int16_t firCoeffs[16] = {
  -114, -159, -139, 291, 1450, 3284, 5246, 6524,
  6524, 5246, 3284, 1450, 291, -139, -159, -114
};
uDSU_FIR fir(firCoeffs, 16);

// Same coefficients as the Biquad_LowPass example (Q14, shift=14).
uDSU_Biquad biquad(491, 982, 491, -23826, 9405, 14);

const float SAMPLE_RATE = 8000.0;
uint32_t sampleIndex = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial) {}

  // Initialize the uDSU ONCE, in FAST mode (required by uDSU_FIR).
  // Both filter objects are told not to re-initialize it themselves.
  dsu_init(DSU_MM_FAST);
  fir.begin(false);
  biquad.begin(false);

  Serial.println("uDSU_DSP Combined_ModeTest (single DSU_MM_FAST init)");
  Serial.println("sample, input_fir, fir_out, input_bq, biquad_fast");
}

void loop() {
  float t = sampleIndex / SAMPLE_RATE;

  // FIR signal: same as FIR_LowPass example (100Hz + 3000Hz).
  float sigFir = 6000.0 * sin(2 * PI * 100.0 * t) +
                 2000.0 * sin(2 * PI * 3000.0 * t);
  int16_t inFir = (int16_t)sigFir;
  int16_t outFir = (int16_t)(fir.update(inFir) >> 15);

  // Biquad signal: same as Biquad_LowPass example (100Hz + 2500Hz).
  float sigBq = 6000.0 * sin(2 * PI * 100.0 * t) +
                2000.0 * sin(2 * PI * 2500.0 * t);
  int16_t inBq = (int16_t)sigBq;
  int16_t outBq = biquad.update(inBq);

  Serial.print(sampleIndex);
  Serial.print(", ");
  Serial.print(inFir);
  Serial.print(", ");
  Serial.print(outFir);
  Serial.print(", ");
  Serial.print(inBq);
  Serial.print(", ");
  Serial.println(outBq);

  sampleIndex++;
  if (sampleIndex >= 200) {
    while (1) {}  // done - halt so the Serial Plotter/Monitor settles
  }

  delayMicroseconds((uint32_t)(1000000.0 / SAMPLE_RATE));
}
