#ifndef UDSU_FFT_H
#define UDSU_FFT_H

#include <Arduino.h>
#include "udsu.h" // Links to your existing hardware library headers

class uDSU_FFT {
public:
    uDSU_FFT();
    ~uDSU_FFT();

    // Initializes the uDSU hardware and populates the RAM tables
    void begin();

    // Executes the high-speed 128-point Radix-2 hardware-accelerated transform
    void compute(int16_t *vReal, int16_t *vImag);

    // High-speed Alpha-Max Beta-Min complex magnitude approximation vector
    void complexToMagnitude(int16_t *vReal, int16_t *vImag, int16_t *vOutput);

private:
    // Protected RAM arrays to prevent memory corruption space overlaps
    int16_t _twiddleQuarter[33]; 
    uint8_t _bitReverseRAM[128];

    // Internal processing helper methods
    void lookupTwiddle(uint8_t index, int16_t &sinOut, int16_t &cosOut);
    void shuffleData(int16_t *vReal, int16_t *vImag);
};

#endif // UDSU_FFT_H
