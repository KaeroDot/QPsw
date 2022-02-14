function alginfo = alg_info() %<<<1
% Part of QWTB. Info script for algorithm TWM-QPSW
%
% See also qwtb

    % info %<<<1
    alginfo.id = 'TWM-QPSW';
    alginfo.name = 'Quantum Power Software';
    alginfo.desc = 'Data reordering after sampling using Quantum Power System.';
    alginfo.citation = 'somethingXXX';
    alginfo.remarks = 'somethingXXX';
    alginfo.license = 'MIT';
    alginfo.providesGUF = 0;
    alginfo.providesMCM = 0;    

    % --- input quantities %<<<1
    pid = 1;

    % --- TWM flags %<<<2
    % note: presence of these parameters signalizes caller capabilities of the algoirthm
    % XXX mozna udelat jeden pro differentiall inputs, a druhy pro nedifferential, protoze i
    % zpracovani bude uplne jine
    % alginfo.inputs(pid).name = 'support_diff';
    % alginfo.inputs(pid).desc = 'Algorithm supports differential input data';
    % alginfo.inputs(pid).alternative = 0;
    % alginfo.inputs(pid).optional = 1;
    % alginfo.inputs(pid).parameter = 1;
    % pid = pid + 1;

    % alg must process all subrecords at once
    alginfo.inputs(pid).name = 'support_multi_inputs';
    alginfo.inputs(pid).desc = 'Algorithm supports processing of a multiple waveforms at once';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
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
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;

    % --- pjvs data %<<<2
    alginfo.inputs(pid).name = 'Uref';
    alginfo.inputs(pid).desc = 'PJVS reference values (V)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Spjvs';
    alginfo.inputs(pid).desc = 'PJVS switches (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 0;
    alginfo.inputs(pid).parameter = 0;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Rs';
    alginfo.inputs(pid).desc = 'PJVS remove after switch (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    alginfo.inputs(pid).name = 'Re';
    alginfo.inputs(pid).desc = 'PJVS remove before switch (samples)';
    alginfo.inputs(pid).alternative = 0;
    alginfo.inputs(pid).optional = 1;
    alginfo.inputs(pid).parameter = 1;
    pid = pid + 1;

    % --- standard TWM inputs %<<<2
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

    for k = 1:6
        alginfo.inputs(pid).name = sprintf('y%d',k);
        alginfo.inputs(pid).desc = 'Sampled signal';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 0;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('y_lo%d',k);
        alginfo.inputs(pid).desc = 'Sampled signal low-side';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('time_shift_lo%d',k);
        alginfo.inputs(pid).desc = 'Low-side channel timeshift';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % ADC setup
        alginfo.inputs(pid).name = sprintf('adc_bits%d',k);
        alginfo.inputs(pid).desc = 'ADC resolution';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_nrng%d',k);
        alginfo.inputs(pid).desc = 'ADC nominal range';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_lsb%d',k);
        alginfo.inputs(pid).desc = 'ADC LSB voltage';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC jitter:
        alginfo.inputs(pid).name = sprintf('adc_jitter%d',k);
        alginfo.inputs(pid).desc = 'ADC rms jitter';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC apperture effect correction:
        % this set to non-zero value will enable auto correction of the aperture effect by algorithm
        alginfo.inputs(pid).name = sprintf('adc_aper_corr%d',k);
        alginfo.inputs(pid).desc = 'ADC aperture effect correction switch';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % apperture value must be passed if the 'adc_aper_corr' is non-zero:
        alginfo.inputs(pid).name = sprintf('adc_aper%d',k);
        alginfo.inputs(pid).desc = 'ADC aperture value';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;     

        % ADC jitter [s]:
        alginfo.inputs(pid).name = sprintf('adc_jitter%d',k);
        alginfo.inputs(pid).desc = 'ADC jitter value';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC offset [V]:
        alginfo.inputs(pid).name = sprintf('adc_offset%d',k);
        alginfo.inputs(pid).desc = 'ADC offset voltage';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC gain calibration matrix (2D dependence, rows: freqs., columns: harmonic amplitudes)
        alginfo.inputs(pid).name = sprintf('adc_gain_f%d',k);
        alginfo.inputs(pid).desc = 'ADC gain transfer: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_gain_a%d',k);
        alginfo.inputs(pid).desc = 'ADC gain transfer: voltage axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_gain%d',k);
        alginfo.inputs(pid).desc = 'ADC gain transfer: 2D data';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC phase calibration matrix (2D dependence, rows: freqs., columns: harmonic amplitudes)
        alginfo.inputs(pid).name = sprintf('adc_phi_f%d',k);
        alginfo.inputs(pid).desc = 'ADC phase transfer: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');    

        alginfo.inputs(pid).name = sprintf('adc_phi_a%d',k);
        alginfo.inputs(pid).desc = 'ADC phase transfer: voltage axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_phi%d',k);
        alginfo.inputs(pid).desc = 'ADC phase transfer: 2D data';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC SFDR (2D dependence, rows: fund. freqs., columns: fund. harmonic amplitudes)
        alginfo.inputs(pid).name = sprintf('adc_sfdr_f%d',k);
        alginfo.inputs(pid).desc = 'ADC SFDR: fundamental frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_sfdr_a%d',k);
        alginfo.inputs(pid).desc = 'ADC SFDR: fundamental harmonic amplitude';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');    

        alginfo.inputs(pid).name = sprintf('adc_sfdr%d',k);
        alginfo.inputs(pid).desc = 'ADC SFDR: 2D data';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % ADC input admittance matrices (1D dependences, rows: freqs.)
        alginfo.inputs(pid).name = sprintf('adc_Yin_f%d',k);
        alginfo.inputs(pid).desc = 'ADC input admittance: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_Yin_Cp%d',k);
        alginfo.inputs(pid).desc = 'ADC input admittance: parallel capacitance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        alginfo.inputs(pid).name = sprintf('adc_Yin_Gp%d',k);
        alginfo.inputs(pid).desc = 'ADC input admittance: parallel conductance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
        [alginfo,pid] = add_diff_par(alginfo,pid,'lo_','low ');

        % Transducer phase calibration matrix (2D dependence, rows: freqs., columns: input rms levels)
        alginfo.inputs(pid).name = sprintf('tr_gain_f%d',k);
        alginfo.inputs(pid).desc = 'Transducer gain: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_gain_a%d',k);
        alginfo.inputs(pid).desc = 'Transducer gain: rms level axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_gain%d',k);
        alginfo.inputs(pid).desc = 'Transducer gain: 2D data';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % Transducer phase calibration matrix (2D dependence, rows: freqs., columns: input rms levels)
        alginfo.inputs(pid).name = sprintf('tr_phi_f%d',k);
        alginfo.inputs(pid).desc = 'Transducer phase transfer: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_phi_a%d',k);
        alginfo.inputs(pid).desc = 'Transducer phase transfer: rms level axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_phi%d',k);
        alginfo.inputs(pid).desc = 'Transducer phase transfer: 2D data';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % RVD low-side impedance matrix (1D dependence, rows: freqs.)
        alginfo.inputs(pid).name = sprintf('tr_Zlo_f%d',k);
        alginfo.inputs(pid).desc = 'RVD low-side impedance: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_Zlo_Rp%d',k);
        alginfo.inputs(pid).desc = 'RVD low-side impedance: parallel resistance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_Zlo_Cp%d',k);
        alginfo.inputs(pid).desc = 'RVD low-side impedance: parallel capacitance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % Transducer output terminals series impedance matrix (1D dependence, rows: freqs.)
        alginfo.inputs(pid).name = sprintf('tr_Zca_f%d',k);
        alginfo.inputs(pid).desc = 'Transducer terminals series impedance: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_Zca_Ls%d',k);
        alginfo.inputs(pid).desc = 'Transducer terminals series impedance: series inductance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_Zca_Rs%d',k);
        alginfo.inputs(pid).desc = 'Transducer terminals series impedance: series resistance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % Transducer output terminals shunting admittance matrix (1D dependence, rows: freqs.)
        alginfo.inputs(pid).name = sprintf('tr_Yca_f%d',k);
        alginfo.inputs(pid).desc = 'Transducer terminals shunting admittance: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_Yca_Cp%d',k);
        alginfo.inputs(pid).desc = 'Transducer terminals shunting admittance: parallel capacitance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('tr_Yca_D%d',k);
        alginfo.inputs(pid).desc = 'Transducer terminals shunting admittance: loss tangent';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % Cable(s) series impedance matrix (1D dependence, rows: freqs.)
        alginfo.inputs(pid).name = sprintf('Zcb_f%d',k);
        alginfo.inputs(pid).desc = 'Cables series impedance: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('Zcb_Ls%d',k);
        alginfo.inputs(pid).desc = 'Cables series impedance: series inductance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('Zcb_Rs%d',k);
        alginfo.inputs(pid).desc = 'Cables series impedance: series resistance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        % Cable(s) shunting admittance matrix (1D dependence, rows: freqs.)
        alginfo.inputs(pid).name = sprintf('Ycb_f%d',k);
        alginfo.inputs(pid).desc = 'Cables shunting admittance: frequency axis';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('Ycb_Cp%d',k);
        alginfo.inputs(pid).desc = 'Cables shunting admittance: parallel capacitance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;

        alginfo.inputs(pid).name = sprintf('Ycb_D%d',k);
        alginfo.inputs(pid).desc = 'Cables series impedance: parallel capacitance';
        alginfo.inputs(pid).alternative = 0;
        alginfo.inputs(pid).optional = 1;
        alginfo.inputs(pid).parameter = 0;
        pid = pid + 1;
    end % k 

    % --- outputs quantities%<<<1
    pid = 1;

    alginfo.outputs(pid).name = 'some output';
    alginfo.outputs(pid).desc = 'Output TWM quantities';
    pid = pid + 1;
end

% create a differential complement of the last input parameter in the list 'par'
function [par,pid] = add_diff_par(par,pid,prefix,name_prefix)
    par.inputs(pid) = par.inputs(pid - 1);
    par.inputs(pid).name = [prefix par.inputs(pid).name];
    par.inputs(pid).desc = [name_prefix par.inputs(pid).desc];
    pid = pid + 1;    
end

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
