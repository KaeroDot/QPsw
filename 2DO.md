# scripts
- simplify CCC - either do not use or speed up processing
- interpolate calibrated errors
- fit into QWTB
- think out all corrections: are impedance corrections needed when PJVS calibration is used?
- fit into TWM

# libraries
- fix issues in infostrings
- fix issues in qwbt (mostly details)
- convert all TWM depending libraries from compiled to source distribution:
        - golpi
        - infostrings
        - vilib

# drivers
- PJVS drivers abstraction layer
- add multiplexer to TWM

# gui
- think out GUI design
- make main part with settings
- manual control of multiplexer?


# plan:
two methods:
1, switching with regular timing, power calculation more complex, requires recalculation of phases
to estimate phase of both U/I channels in one time. Enables PQ measurements.
2, switching with irregular timing, e.g. calibration of 1st ADC, of 2nd ADC, than simple power
measurement as in TWM, only the error of digitizer is updated. simpler to implement all corrections.
