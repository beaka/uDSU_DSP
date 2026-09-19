WIP uDSC library for Arduino. Of course only applicable to the LGT8F328P.

Math functions implemented are in the header file and two examples are implemented so far, FIR filter and Biquad.

Added a FFT example, 128 bin completes in 6ms.

Added property FIR to change coefficients in existing instance, added a delay property for I/Q quadrature sync and converted to a circular buffer for speed.

47 tap FIR Hilbert in Q15 for I/Q with delayed I completes in 12us.

For detailed info on the DSC functions this is the best translation of the databook I have found:https://github.com/Skogmus/Datasheet_translations
