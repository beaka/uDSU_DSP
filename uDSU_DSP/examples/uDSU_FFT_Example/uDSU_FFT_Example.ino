#include <Arduino.h>
#include <uDSU_FFT.h> // Pulls in your high-speed class module

uDSU_FFT fft;

int16_t vReal[128];
int16_t vImag[128];
int16_t vMagnitude[64]; // Holds the final absolute frequency volumes

void setup() {
  Serial.begin(115200);
  DDRB |= (1 << PB5); // Pin 13 tracking output

  fft.begin(); // Initializes tables in RAM and configures uDSU
  Serial.println(F("--- Library Module FFT Test ---"));
}

void loop() {
  // Synthesize test signal: 1000 Hz Sine wave sampled at 8000 Hz
  for (uint16_t i = 0; i < 128; i++) {
    vReal[i] = (int16_t)(sin(2.0 * M_PI * 1000.0 * i / 8000.0) * 16000.0);
    vImag[i] = 0;
  }

  // Blistering-fast 6ms execution window
  noInterrupts();
  PORTB |= (1 << PB5); // Pin 13 HIGH

  fft.compute(vReal, vImag); // Run transform pipeline

  PORTB &= ~(1 << PB5); // Pin 13 LOW
  interrupts();

  // Convert complex planes to absolute volumes instantly
  fft.complexToMagnitude(vReal, vImag, vMagnitude);

  // Print results
  for (uint8_t i = 0; i < 64; i++) {
    if (vMagnitude[i] > 10 || i == 16) {
      Serial.print(F("Bin ")); Serial.print(i);
      Serial.print(F(" | Freq: ")); Serial.print(i * 62.5);
      Serial.print(F(" Hz | Volume: ")); Serial.println(vMagnitude[i]);
    }
  }
  delay(5000);
}
