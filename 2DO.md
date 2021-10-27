# scripts
- simplify CCC - either do not use or speed up processing
- interpolate calibrated errors
- fit into QWTB
- think out all corrections: are impedance corrections needed when PJVS calibration is used?
- fit into TWM

# libraries
- fix issues in qwbt (mostly details)
- convert all TWM depending libraries from compiled to source distribution:
        - golpi - done
        - infostrings - done
        - vilib - 2DO

# drivers
- PJVS drivers abstraction layer
- add multiplexer to TWM - done

# multiplexer hardware
- fix issue: new bootloader to avoid reseting after opening communictaion. Ricardo's
  reply: "adding a 4.7 uF Capacitor between RST and GND works for me, now when
  open/close/open the SERIAL port to communicate with the multiplexer does not
  reset the microcontroller. But, when you need to download a firmware, you
  have to reset the microcontroller by your own."

# QuPMXLabVIEWdriver
- Fix this issue: `*CLS` does not stops a running sequence. `*CLS` opens all
  relays and clear the status byte.  To stop running the sequence you have to
  use STOP command. To set the multiplexer to a know condition excute the
  following commands in order `STOP/*CLS`

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
