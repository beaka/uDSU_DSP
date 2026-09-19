WIP uDSC library for Arduino. Of course only applicable to the LGT8F328P.

Math functions implemented are in the header file and two examples are implemented so far, FIR filter and Biquad.

Added a FFT example, 128 bin completes in 6ms.

Added property FIR to change coefficients in existing instance, added a delay property for I/Q quadrature sync and converted to a circular buffer for speed.

47 tap FIR Hilbert in Q15 for I/Q with delayed I completes in 12us.
How to use the FIR:
#define FILTER_TAPS 47
int16_t hilbert_ssb[FILTER_TAPS] = {
  0, 0, 0, 0, 0, -1, 0, -9,
  0, -70, 0, -353, 0, -1223, 0, -3016,
  0, -5305, 0, -6426, 0, -4577, 0, 0,
  0, 4577, 0, 6426, 0, 5305, 0, 3016,
  0, 1223, 0, 353, 0, 70, 0, 9,
  0, 1, 0, 0, 0, 0, 0
};

uDSU_FIR hilbertFilter(hilbert_ssb, FILTER_TAPS);

Setup(){
   hilbertFilter.begin(true);  // Initializes DSU hardware mapping
   ... setup ADC etc
}

ISR(){
  current_I = (int16_t)ADC - 512;
  ...
  int16_t delayed_I = 0;
  int32_t q_raw = hilbertFilter.update(current_I, &delayed_I);
  int16_t shifted_I = (int16_t)(q_raw >> 15);
  demodulated_audio = shifted_I + current_Q; //Demodulated audio
}

change_coefficients(){
    cli();
    hilbertFilter.setCoefficients(hilbert_am);
    hilbertFilter.reset();
    sei();
}



For detailed info on the DSC functions this is the best translation of the databook I have found:https://github.com/Skogmus/Datasheet_translations
