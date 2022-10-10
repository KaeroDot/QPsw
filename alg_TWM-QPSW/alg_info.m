function alginfo = alg_info() %<<<1
% Part of QWTB. Info script for algorithm TWM-QPSW
%
% See also qwtb

    % info %<<<1
    alginfo.id = 'TWM-QPSW';
    alginfo.name = 'Power calculation algorithm for quantum power system, paired (voltage and current) systems.';
    alginfo.desc = 'Data reordering algorithm for Quantum Power System. After reordering the samples are sent to algorithm defined in |alt| quantity.';
    alginfo.citation = 'somethingXXX';
    alginfo.remarks = 'somethingXXX';
    alginfo.license = 'MIT';
    alginfo.providesGUF = 0;
    alginfo.providesMCM = 0;    

    % --- input quantities %<<<1
    pid = 1;

    % --- TWM flags %<<<2
    % note: presence of these parameters signalizes caller capabilities of the algoirthm
    % Algorithm does not support processing of multiple records at once.
    alginfo.inputs(pid).name = 'support_diff';
    alginfo.inputs(pid).desc = 'Algorithm supports differential input data';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'support_all_phases';
    alginfo.inputs(pid).desc = 'Algorithm supports inputs from all phases at once';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;

    % --- data processing %<<<2
    alginfo.inputs(pid).name = 'alg';
    alginfo.inputs(pid).desc = 'Algorithm to be used for calculation';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    % --- multiplexer settings %<<<2
    alginfo.inputs(pid).name = 'M';
    alginfo.inputs(pid).desc = 'Multiplexer configuration';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'S';
    alginfo.inputs(pid).desc = 'Multiplexer switches (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    % --- pjvs data %<<<2
    alginfo.inputs(pid).name = 'Uref';
    alginfo.inputs(pid).desc = 'PJVS reference values (V)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'fseg';
    alginfo.inputs(pid).desc = 'Frequency of PJVS segments (Hz)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Rs';
    alginfo.inputs(pid).desc = 'PJVS remove before PJVS step (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Re';
    alginfo.inputs(pid).desc = 'PJVS remove after PJVS step (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Ms';
    alginfo.inputs(pid).desc = 'PJVS remove before MX switch (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Me';
    alginfo.inputs(pid).desc = 'PJVS remove after MX switch (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;


    % --- standard TWM inputs %<<<2
    % sample data
    alginfo.inputs(pid).name = 'fs';
    alginfo.inputs(pid).desc = 'Sampling frequency';
    alginfo.inputs(pid).alternative = 1;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'Ts';
    alginfo.inputs(pid).desc = 'Sampling time';
    alginfo.inputs(pid).alternative = 1;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 't';
    alginfo.inputs(pid).desc = 'Time series';
    alginfo.inputs(pid).alternative = 1;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'y';
    alginfo.inputs(pid).desc = 'Sampled voltage';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'y_lo';
    alginfo.inputs(pid).desc = 'Sampled signal low-side';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'time_shift_lo';
    alginfo.inputs(pid).desc = 'Low-side channel timeshift';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % --- parameters:
    
    % ADC setup
    alginfo.inputs(pid).name = 'adc_bits';
    alginfo.inputs(pid).desc = 'ADC resolution';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
            
    alginfo.inputs(pid).name = 'adc_nrng';
    alginfo.inputs(pid).desc = 'ADC nominal range';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
            
    alginfo.inputs(pid).name = 'adc_lsb';
    alginfo.inputs(pid).desc = 'ADC LSB voltage';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
        
    % ADC jitter:
    alginfo.inputs(pid).name = 'adc_jitter';
    alginfo.inputs(pid).desc = 'ADC rms jitter';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
        
    % ADC apperture effect correction:
    % this set to non-zero value will enable auto correction of the aperture effect by algorithm
    alginfo.inputs(pid).name = 'adc_aper_corr';
    alginfo.inputs(pid).desc = 'ADC aperture effect correction switch';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    % apperture value must be passed if the 'adc_aper_corr' is non-zero:
    alginfo.inputs(pid).name = 'adc_aper';
    alginfo.inputs(pid).desc = 'ADC aperture value';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;     
    % ADC jitter [s]:
    alginfo.inputs(pid).name = 'adc_jitter';
    alginfo.inputs(pid).desc = 'ADC jitter value';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
        % ADC offset [V]:
    alginfo.inputs(pid).name = 'adc_offset';
    alginfo.inputs(pid).desc = 'ADC offset voltage';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
              
    
    % ADC gain calibration matrix (2D dependence, rows: freqs., columns: harmonic amplitudes)
    alginfo.inputs(pid).name = 'adc_gain_f';
    alginfo.inputs(pid).desc = 'ADC gain transfer: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
        
    alginfo.inputs(pid).name = 'adc_gain_a';
    alginfo.inputs(pid).desc = 'ADC gain transfer: voltage axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
        
    alginfo.inputs(pid).name = 'adc_gain';
    alginfo.inputs(pid).desc = 'ADC gain transfer: 2D data';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
     
    
    % ADC phase calibration matrix (2D dependence, rows: freqs., columns: harmonic amplitudes)
    alginfo.inputs(pid).name = 'adc_phi_f';
    alginfo.inputs(pid).desc = 'ADC phase transfer: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');    
    
    alginfo.inputs(pid).name = 'adc_phi_a';
    alginfo.inputs(pid).desc = 'ADC phase transfer: voltage axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    
    alginfo.inputs(pid).name = 'adc_phi';
    alginfo.inputs(pid).desc = 'ADC phase transfer: 2D data';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    
    % ADC SFDR (2D dependence, rows: fund. freqs., columns: fund. harmonic amplitudes)
    alginfo.inputs(pid).name = 'adc_sfdr_f';
    alginfo.inputs(pid).desc = 'ADC SFDR: fundamental frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
            
    alginfo.inputs(pid).name = 'adc_sfdr_a';
    alginfo.inputs(pid).desc = 'ADC SFDR: fundamental harmonic amplitude';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');    
    
    alginfo.inputs(pid).name = 'adc_sfdr';
    alginfo.inputs(pid).desc = 'ADC SFDR: 2D data';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    
    % ADC input admittance matrices (1D dependences, rows: freqs.)
    alginfo.inputs(pid).name = 'adc_Yin_f';
    alginfo.inputs(pid).desc = 'ADC input admittance: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    
    alginfo.inputs(pid).name = 'adc_Yin_Cp';
    alginfo.inputs(pid).desc = 'ADC input admittance: parallel capacitance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    
    alginfo.inputs(pid).name = 'adc_Yin_Gp';
    alginfo.inputs(pid).desc = 'ADC input admittance: parallel conductance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');
    
    
    
    % Transducer phase calibration matrix (2D dependence, rows: freqs., columns: input rms levels)
    alginfo.inputs(pid).name = 'tr_type';
    alginfo.inputs(pid).desc = 'Transducer type';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'tr_gain_f';
    alginfo.inputs(pid).desc = 'Transducer gain: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_gain_a';
    alginfo.inputs(pid).desc = 'Transducer gain: rms level axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_gain';
    alginfo.inputs(pid).desc = 'Transducer gain: 2D data';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % Transducer phase calibration matrix (2D dependence, rows: freqs., columns: input rms levels)
    alginfo.inputs(pid).name = 'tr_phi_f';
    alginfo.inputs(pid).desc = 'Transducer phase transfer: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_phi_a';
    alginfo.inputs(pid).desc = 'Transducer phase transfer: rms level axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_phi';
    alginfo.inputs(pid).desc = 'Transducer phase transfer: 2D data';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % RVD low-side impedance matrix (1D dependence, rows: freqs.)
    alginfo.inputs(pid).name = 'tr_Zlo_f';
    alginfo.inputs(pid).desc = 'RVD low-side impedance: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_Zlo_Rp';
    alginfo.inputs(pid).desc = 'RVD low-side impedance: parallel resistance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_Zlo_Cp';
    alginfo.inputs(pid).desc = 'RVD low-side impedance: parallel capacitance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % Transducer output terminals series impedance matrix (1D dependence, rows: freqs.)
    alginfo.inputs(pid).name = 'tr_Zca_f';
    alginfo.inputs(pid).desc = 'Transducer terminals series impedance: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_Zca_Ls';
    alginfo.inputs(pid).desc = 'Transducer terminals series impedance: series inductance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_Zca_Rs';
    alginfo.inputs(pid).desc = 'Transducer terminals series impedance: series resistance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % Transducer output terminals shunting admittance matrix (1D dependence, rows: freqs.)
    alginfo.inputs(pid).name = 'tr_Yca_f';
    alginfo.inputs(pid).desc = 'Transducer terminals shunting admittance: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_Yca_Cp';
    alginfo.inputs(pid).desc = 'Transducer terminals shunting admittance: parallel capacitance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'tr_Yca_D';
    alginfo.inputs(pid).desc = 'Transducer terminals shunting admittance: loss tangent';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % Cable(s) series impedance matrix (1D dependence, rows: freqs.)
    alginfo.inputs(pid).name = 'Zcb_f';
    alginfo.inputs(pid).desc = 'Cables series impedance: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'Zcb_Ls';
    alginfo.inputs(pid).desc = 'Cables series impedance: series inductance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'Zcb_Rs';
    alginfo.inputs(pid).desc = 'Cables series impedance: series resistance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    % Cable(s) shunting admittance matrix (1D dependence, rows: freqs.)
    alginfo.inputs(pid).name = 'Ycb_f';
    alginfo.inputs(pid).desc = 'Cables shunting admittance: frequency axis';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'Ycb_Cp';
    alginfo.inputs(pid).desc = 'Cables shunting admittance: parallel capacitance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;
    
    alginfo.inputs(pid).name = 'Ycb_D';
    alginfo.inputs(pid).desc = 'Cables series impedance: parallel capacitance';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;

    % outputs
    pid = 1;
    alginfo.outputs(pid).name = 'U';
    alginfo.outputs(pid).desc = 'RMS voltage';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'I';
    alginfo.outputs(pid).desc = 'RMS current';
    pid = pid + 1;
        
    alginfo.outputs(pid).name = 'P';
    alginfo.outputs(pid).desc = 'Active power';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'S';
    alginfo.outputs(pid).desc = 'Apparent power';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'Q';
    alginfo.outputs(pid).desc = 'Reactive power';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'PF';
    alginfo.outputs(pid).desc = 'Power factor';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'phi_ef';
    alginfo.outputs(pid).desc = 'Effective phase shift acos(PF) [rad]';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'Udc';
    alginfo.outputs(pid).desc = 'DC voltage component';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'Idc';
    alginfo.outputs(pid).desc = 'DC current component';
    pid = pid + 1;

    alginfo.outputs(pid).name = 'U_t';
    alginfo.outputs(pid).desc = 'RMS voltage';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'I_t';
    alginfo.outputs(pid).desc = 'RMS current';
    pid = pid + 1;
        
    alginfo.outputs(pid).name = 'P_t';
    alginfo.outputs(pid).desc = 'Active power';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'S_t';
    alginfo.outputs(pid).desc = 'Apparent power';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'Q_t';
    alginfo.outputs(pid).desc = 'Reactive power';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'PF_t';
    alginfo.outputs(pid).desc = 'Power factor';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'phi_ef_t';
    alginfo.outputs(pid).desc = 'Effective phase shift acos(PF) [rad]';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'Udc_t';
    alginfo.outputs(pid).desc = 'DC voltage component';
    pid = pid + 1;
    
    alginfo.outputs(pid).name = 'Idc_t';
    alginfo.outputs(pid).desc = 'DC current component';
    pid = pid + 1;
end % function alginfo = alg_info() %<<<1

% create a differential complement of the last input parameter in the list 'par'
function [par,pid] = add_diff_par(par,pid,prefix,name_prefix)
    par.inputs(pid) = par.inputs(pid - 1);
    par.inputs(pid).name = [prefix par.inputs(pid).name];
    par.inputs(pid).desc = [name_prefix par.inputs(pid).desc];
    pid = pid + 1;    
end
