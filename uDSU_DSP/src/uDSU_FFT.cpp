#include "uDSU_FFT.h"
#include <math.h>

uDSU_FFT::uDSU_FFT() {
    // Constructor
}

uDSU_FFT::~uDSU_FFT() {
    // Destructor
}

void uDSU_FFT::begin() {
    dsu_init(DSU_MM_FAST); // Lock hardware coprocessor to FAST I/O mode

    // 1. Populate the 0-90 degree Sine Table directly into safe RAM channels
    for (uint8_t i = 0; i <= 32; i++) {
        _twiddleQuarter[i] = (int16_t)(sin((i * M_PI) / 64.0) * 32767.0);
    }

    // 2. Generate the 128-point Bit-Reversal Table cleanly at runtime inside RAM
    for (uint16_t i = 0; i < 128; i++) {
        uint8_t reversed = 0;
        uint8_t temp = i;
        for (uint8_t bit = 0; bit < 7; bit++) { // 128 points = 2^7
            reversed <<= 1;
            reversed |= (temp & 1);
            temp >>= 1;
        }
        _bitReverseRAM[i] = reversed;
    }
}

void uDSU_FFT::lookupTwiddle(uint8_t index, int16_t &sinOut, int16_t &cosOut) {
    index &= 0x7F; // Keep index wrapped to a 128-point circle

    // --- Calculate SINE ---
    uint8_t sIdx = index & 0x1F;   
    bool sinNeg  = (index >= 64);   
    bool sinFlip = (index & 0x20);  

    int16_t rawSin = sinFlip ? _twiddleQuarter[32 - sIdx] : _twiddleQuarter[sIdx];
    sinOut = sinNeg ? -rawSin : rawSin;

    // --- Calculate COSINE ---
    uint8_t cIndex = (index + 32) & 0x7F;
    uint8_t cIdx   = cIndex & 0x1F;
    bool cosNeg    = (cIndex >= 64);
    bool cosFlip   = (cIndex & 0x20);

    int16_t rawCos = cosFlip ? _twiddleQuarter[32 - cIdx] : _twiddleQuarter[cIdx];
    cosOut = cosNeg ? -rawCos : rawCos;
}

void uDSU_FFT::shuffleData(int16_t *vReal, int16_t *vImag) {
    for (uint16_t i = 0; i < 128; i++) {
        uint8_t j = _bitReverseRAM[i];
        if (i < j) {
            int16_t tempR = vReal[i]; vReal[i] = vReal[j]; vReal[j] = tempR;
            int16_t tempI = vImag[i]; vImag[i] = vImag[j]; vImag[j] = tempI;
        }
    }
}

void uDSU_FFT::compute(int16_t *vReal, int16_t *vImag) {
    shuffleData(vReal, vImag); 

    uint8_t bSize = 1; 
    
    for (uint8_t stage = 0; stage < 7; stage++) {
        uint8_t nextSize = bSize << 1; 
        uint8_t tStep = 128 / nextSize; 

        for (uint16_t baseIdx = 0; baseIdx < 128; baseIdx += nextSize) {
            for (uint8_t i = 0; i < bSize; i++) {
                uint8_t p = baseIdx + i;
                uint8_t q = p + bSize;

                int16_t wr, wi;
                lookupTwiddle(i * tStep, wi, wr); 

                // Secure original samples in core working CPU registers
                int16_t rP = vReal[p]; int16_t iP = vImag[p];
                int16_t rQ = vReal[q]; int16_t iQ = vImag[q];

                // ----------------------------------------------------------------
                // VERIFIED SIGNED MULTIPLIER COPROCESSOR MATH
                // ----------------------------------------------------------------
                // Runs intermediate multiplications directly through your library assembly
                int32_t p1 = (int32_t)dsu_xmulss(rQ, wr); //
                int32_t p2 = (int32_t)dsu_xmulss(iQ, wi); //
                int32_t p3 = (int32_t)dsu_xmulss(rQ, wi); //
                int32_t p4 = (int32_t)dsu_xmulss(iQ, wr); //

                // Combine terms matching standard complex vector orientations
                int32_t tRealLong = p1 + p2;
                int32_t tImagLong = p4 - p3;

                // Scale back from Q15 down to 16-bit boundaries
                int16_t tReal = (int16_t)(tRealLong >> 15);
                int16_t tImag = (int16_t)(tImagLong >> 15);

                // In-place Radix-2 butterfly scaling updates to safely prevent overflows
                vReal[p] = (rP + tReal) >> 1;
                vReal[q] = (rP - tReal) >> 1;
                vImag[p] = (iP + tImag) >> 1;
                vImag[q] = (iP - tImag) >> 1;
            }
        }
        bSize = nextSize; 
    }
}

void uDSU_FFT::complexToMagnitude(int16_t *vReal, int16_t *vImag, int16_t *vOutput) {
    for (uint8_t i = 0; i < 64; i++) {
        int16_t absR = abs(vReal[i]);
        int16_t absI = abs(vImag[i]);
        
        int16_t maxVal = (absR > absI) ? absR : absI;
        int16_t minVal = (absR > absI) ? absI : absR;
        
        // Alpha-Max Beta-Min vector approximation: max + (0.25 * min)
        vOutput[i] = maxVal + (minVal >> 2); 
    }
}
