% Generator for 1PPSSYNPH algorithm
function [DO, DI] = alg_generator(DI)
        % DO - input for algorithm
        % DI - actual values of DI (after randomization)
% generates signal based on input quantities. if none given, basic signal is constructed.

% used quantities:
% f - main signal frequency, list of spurious/harmonics frequencies
% A - main signal amplitude, list of spurious/harmonics amplitudes
% ph - main signal phase, list of spurious/harmonics phases
% O - main signal offset, list of spurious/harmonics offsets
% dc - dc component
% Np - scalar real, number of main signal periods in the record ( Ns/fs = Np/f(1) )
% ssr - ratio of sampling to signal frequency, ssr = fs/f(1).
% SFDR - scalar, spurious free dynamic ratio
% jitter - standard deviation of jitter [s]
% noise - standard deviation of noise [V]
% smr - spurious to main signal frequency multiple
% t_offset - offset of correct starttime (time error)
%
% calculated quantities:
% fs - scalar integer, sampling frequency
% Ns - scalar integer, record length (samples count)
%
% output quantities
%

    if ~exist('DI', 'var')
        DI = struct();
    end

    % set initial values and randomize input quantities %<<<1
    % signal properties:
    [DI, f]             = setQ(DI, 'f',                    50,          0);
    [DI, A]             = setQ(DI, 'A',                     1,          0);
    [DI, ph]            = setQ(DI, 'ph',                    0,          0);
    [DI, O]             = setQ(DI, 'O',                     0,          0);
    [DI, dc]            = setQ(DI, 'dc',                    0,          0);
    [DI, Np]            = setQ(DI, 'Np',                  110,          0);
    [DI, ssr]           = setQ(DI, 'ssr',                10e3,          0); % 500 kSa/s
    [DI, SFDR]          = setQ(DI, 'SFDR',                120,          0);
    [DI, jitter]        = setQ(DI, 'jitter',            1e-12,          0);
    [DI, noise]         = setQ(DI, 'noise',                 0,          0);
    [DI, smr]           = setQ(DI, 'smr',                   5,          0);
    [DI, t_offset]      = setQ(DI, 't_offset',              0,          0);
    [DI, t_slope]       = setQ(DI, 't_slope',               1,          0);
    [DI, time_stamp]    = setQ(DI, 'time_stamp',   1660000000,          0);
    % other:
    [DI, alg]           = setQ(DI, 'alg',               'PSFE',         0);
    % digitizer corrections
    [DI, adc_Yin_Cp]    = setQ(DI, 'adc_Yin_Cp',        1e-12,          0);
    [DI, adc_Yin_Gp]    = setQ(DI, 'adc_Yin_Gp',        1e-12,          0);
    [DI, adc_Yin_f]     = setQ(DI, 'adc_Yin_f',            [],         []);
    [DI, adc_aper_corr] = setQ(DI, 'adc_aper_corr',         1,          0);
    [DI, adc_bits]      = setQ(DI, 'adc_bits',             30,          0);
    [DI, adc_freq]      = setQ(DI, 'adc_freq',              0,          0);
    [DI, adc_gain]      = setQ(DI, 'adc_gain',              1,          0);
    [DI, adc_gain_a]    = setQ(DI, 'adc_gain_a',           [],         []);
    [DI, adc_gain_f]    = setQ(DI, 'adc_gain_f',           [],         []);
    [DI, adc_jitter]    = setQ(DI, 'adc_jitter',            0,          0);
    [DI, adc_nrng]      = setQ(DI, 'adc_nrng',             10,          0); % range make according signal at ADC XXX FIXME
    [DI, adc_offset]    = setQ(DI, 'adc_offset',            1,          0);
    [DI, adc_phi]       = setQ(DI, 'adc_phi',               0,          0);
    [DI, adc_phi_a]     = setQ(DI, 'adc_phi_a',            [],         []);
    [DI, adc_phi_f]     = setQ(DI, 'adc_phi_f',            [],         []);
    [DI, adc_sfdr]      = setQ(DI, 'adc_sfdr',            200,          0);
    [DI, adc_sfdr_a]    = setQ(DI, 'adc_sfdr_a',           [],         []);
    [DI, adc_sfdr_f]    = setQ(DI, 'adc_sfdr_f',           [],         []);
    % cable corrections:
    [DI, Ycb_Cp]        = setQ(DI, 'Ycb_Cp',            1e-15,          0);
    [DI, Ycb_D]         = setQ(DI, 'Ycb_D',                 0,          0);
    [DI, Ycb_f]         = setQ(DI, 'Ycb_f',                [],         []);
    [DI, Zcb_Ls]        = setQ(DI, 'Zcb_Ls',            1e-12,          0);
    [DI, Zcb_Rs]        = setQ(DI, 'Zcb_Rs',             1e-9,          0);
    [DI, Zcb_f]         = setQ(DI, 'Zcb_f',                [],         []);
    % transducer corrections:
    [DI, tr_Yca_Cp]     = setQ(DI, 'tr_Yca_Cp',         1e-15,          0);
    [DI, tr_Yca_D]      = setQ(DI, 'tr_Yca_D',              0,          0);
    [DI, tr_Yca_f]      = setQ(DI, 'tr_Yca_f',             [],         []);
    [DI, tr_Zbuf_Ls]    = setQ(DI, 'tr_Zbuf_Ls',            0,          0);
    [DI, tr_Zbuf_Rs]    = setQ(DI, 'tr_Zbuf_Rs',            0,          0);
    [DI, tr_Zbuf_f]     = setQ(DI, 'tr_Zbuf_f',            [],         []);
    [DI, tr_Zca_Ls]     = setQ(DI, 'tr_Zca_Ls',         1e-12,          0);
    [DI, tr_Zca_Rs]     = setQ(DI, 'tr_Zca_Rs',          1e-9,          0);
    [DI, tr_Zca_f]      = setQ(DI, 'tr_Zca_f',             [],         []);
    [DI, tr_Zcal_Ls]    = setQ(DI, 'tr_Zcal_Ls',        1e-12,          0);
    [DI, tr_Zcal_Rs]    = setQ(DI, 'tr_Zcal_Rs',         1e-9,          0);
    [DI, tr_Zcal_f]     = setQ(DI, 'tr_Zcal_f',            [],         []);
    [DI, tr_Zcam]       = setQ(DI, 'tr_Zcam',           1e-12,          0);
    [DI, tr_Zcam_f]     = setQ(DI, 'tr_Zcam_f',            [],         []);
    [DI, tr_Zlo_Cp]     = setQ(DI, 'tr_Zlo_Cp',             0,          0);
    [DI, tr_Zlo_Rp]     = setQ(DI, 'tr_Zlo_Rp',          1000,          0);          % XXX strange value FIXME
    [DI, tr_Zlo_f]      = setQ(DI, 'tr_Zlo_f',             [],         []);
    [DI, tr_gain]       = setQ(DI, 'tr_gain',               1,          0);
    [DI, tr_gain_a]     = setQ(DI, 'tr_gain_a',            [],         []);
    [DI, tr_gain_f]     = setQ(DI, 'tr_gain_f',            [],         []);
    [DI, tr_phi]        = setQ(DI, 'tr_phi',                0,          0);
    [DI, tr_phi_a]      = setQ(DI, 'tr_phi_a',             [],         []);
    [DI, tr_phi_f]      = setQ(DI, 'tr_phi_f',             [],         []);
    [DI, tr_sfdr]       = setQ(DI, 'tr_sfdr',             200,          0);
    [DI, tr_sfdr_a]     = setQ(DI, 'tr_sfdr_a',            [],         []);
    [DI, tr_sfdr_f]     = setQ(DI, 'tr_sfdr_f',            [],         []);
    [DI, tr_type]       = setQ(DI, 'tr_type',       'divider',          0);


    % calculate and set other needed quantities %<<<1
    % sampling frequency
    fs = ssr.*f(1);
    % samples count:
    Ns = fix(Np.*fs./f(1));

    % generate voltage signal %<<<1
    % XXX errors and correcitons should be implemented into the signal!
    % add one single spurious based on SFDR and smr:
    % A = [A 10^(-1.*SFDR/20)];
    A = [A A./SFDR];
    f = [f smr.*f];
    O = [O 0];
    ph = [ph 0];
    DI.A.v = A;
    DI.f.v = f;
    DI.O.v = O;
    DI.ph.v = ph;
    % time series
    t = [0 : Ns-1]./fs - t_offset; % here offset is subtracted
    % set t uncertainty as jitter:
    ut = jitter.*ones(size(t));
    % sampled values:
    % (to save memory, use for cycle instead of matrix multiplication)
    y = dc + zeros(size(t));
    for j = 1:numel(A)
        y = y + A(j).*sin(2.*pi.*f(j).*t + ph(j)) + O(j);
    end
    % add noise to the data:
    uy = noise.*ones(size(y));

    % 1PPS signal %<<<1
    % this time is Tue, 09. Aug 2022, 01:06:40 
    starttime = 1660000000;
    [t_t, t_y, starttime] = getRTC_sim(numel(y), fs, starttime, t_offset, t_slope); %<<<1

    % add newly calculated values to 'inputs' %<<<1
    [DI, fs]     = setQ(DI, 'fs',      fs,      0);
    [DI, Ts]     = setQ(DI, 'Ts',    1/fs,  ut(1));
    [DI, adc_aper]      = setQ(DI, 'adc_aper',        DI.Ts.v,    DI.Ts.u);
    [DI, Ns]     = setQ(DI, 'Ns',      Ns,      0);

    % datain cell for sampled voltage %<<<1
    DO = cell();
    DO{1}.y.v = y;
    DO{1}.y.u = uy;

    DO{1}.fs.v = fs;
    DO{1}.fs.u = 0;

    DO{1}.time_stamp = DI.time_stamp;

    % add corrections to DO:
    DO{1}.alg            = DI.alg;
    DO{1}.adc_Yin_Cp     = DI.adc_Yin_Cp;
    DO{1}.adc_Yin_Gp     = DI.adc_Yin_Gp;
    DO{1}.adc_Yin_f      = DI.adc_Yin_f;
    DO{1}.adc_aper       = DI.adc_aper;
    DO{1}.adc_aper_corr  = DI.adc_aper_corr;
    DO{1}.adc_bits       = DI.adc_bits;
    DO{1}.adc_freq       = DI.adc_freq;
    DO{1}.adc_gain       = DI.adc_gain ;
    DO{1}.adc_gain_a     = DI.adc_gain_a;
    DO{1}.adc_gain_f     = DI.adc_gain_f;
    DO{1}.adc_jitter     = DI.adc_jitter;
    DO{1}.adc_nrng       = DI.adc_nrng;
    DO{1}.adc_offset     = DI.adc_offset;
    DO{1}.adc_phi        = DI.adc_phi;
    DO{1}.adc_phi_a      = DI.adc_phi_a;
    DO{1}.adc_phi_f      = DI.adc_phi_f;
    DO{1}.adc_sfdr       = DI.adc_sfdr;
    DO{1}.adc_sfdr_a     = DI.adc_sfdr_a;
    DO{1}.adc_sfdr_f     = DI.adc_sfdr_f;
    DO{1}.Ycb_Cp         = DI.Ycb_Cp;
    DO{1}.Ycb_D          = DI.Ycb_D;
    DO{1}.Ycb_f          = DI.Ycb_f;
    DO{1}.Zcb_Ls         = DI.Zcb_Ls;
    DO{1}.Zcb_Rs         = DI.Zcb_Rs;
    DO{1}.Zcb_f          = DI.Zcb_f;
    DO{1}.tr_Yca_Cp      = DI.tr_Yca_Cp;
    DO{1}.tr_Yca_D       = DI.tr_Yca_D;
    DO{1}.tr_Yca_f       = DI.tr_Yca_f;
    DO{1}.tr_Zbuf_Ls     = DI.tr_Zbuf_Ls;
    DO{1}.tr_Zbuf_Rs     = DI.tr_Zbuf_Rs;
    DO{1}.tr_Zbuf_f      = DI.tr_Zbuf_f;
    DO{1}.tr_Zca_Ls      = DI.tr_Zca_Ls;
    DO{1}.tr_Zca_Rs      = DI.tr_Zca_Rs;
    DO{1}.tr_Zca_f       = DI.tr_Zca_f;
    DO{1}.tr_Zcal_Ls     = DI.tr_Zcal_Ls;
    DO{1}.tr_Zcal_Rs     = DI.tr_Zcal_Rs;
    DO{1}.tr_Zcal_f      = DI.tr_Zcal_f;
    DO{1}.tr_Zcam        = DI.tr_Zcam;
    DO{1}.tr_Zcam_f      = DI.tr_Zcam_f;
    DO{1}.tr_Zlo_Cp      = DI.tr_Zlo_Cp;
    DO{1}.tr_Zlo_Rp      = DI.tr_Zlo_Rp;
    DO{1}.tr_Zlo_f       = DI.tr_Zlo_f;
    DO{1}.tr_gain        = DI.tr_gain;
    DO{1}.tr_gain_a      = DI.tr_gain_a;
    DO{1}.tr_gain_f      = DI.tr_gain_f;
    DO{1}.tr_phi         = DI.tr_phi;
    DO{1}.tr_phi_a       = DI.tr_phi_a;
    DO{1}.tr_phi_f       = DI.tr_phi_f;
    DO{1}.tr_sfdr        = DI.tr_sfdr;
    DO{1}.tr_sfdr_a      = DI.tr_sfdr_a;
    DO{1}.tr_sfdr_f      = DI.tr_sfdr_f;
    DO{1}.tr_type        = DI.tr_type;

    % datain cell for 1PPS %<<<1
    DO{2} = DO{1};
    % DO{2}.t.v = t_t;
    DO{2}.y.v = t_y;

    ai = alg_info;
    DO = cells_to_matrices(DO, ai);
end

function [DI, val] = setQ(DI, Qn, v, u) %<<<1
% ensure the quantity is set in DI,
% set default values for .v and .u if missing,
% randomize quantity.
    % if quantitiy missing
    if ~isfield(DI, Qn)
        DI.(Qn).v = v;
        DI.(Qn).u = u;
    end
    % if uncertainty missing 
    if ~isfield(DI.(Qn), 'u')
        DI.(Qn).u = u;
    end
    % randomize if possible:
    if isnumeric(v)
        DI.(Qn).v = normrnd(DI.(Qn).v, DI.(Qn).u, size(DI.(Qn).v));
    end
    val = DI.(Qn).v;
end % function setQ

% function A = harmonic_series(THD, N) %<<<1
% % Spectrum made using geometric series
% % N is number of harmonics
% % A_1 is given (value is 1)
% % A_2 is calculated from THD value in a such way that:
% % A_3..A_N is function of A_2: A_i = A_2/(i-1) for i=2..N
% % so:
% % harmonic id:      A_1     A_2     A_3     A_4     A_5     A_N
% % harmonic number:  given   calc    A_2/2   A_2/3   A_2/4   A_2/(N-1)
%
%     A(1) = 1;
%
%     if N > 1
%         S = sum(1./[1:N-1].^2);
%         A(2) = THD.*A(1)./sqrt(S);
%         A(2:N) = A(2)./[2-1:N-1];
%     else
%         A = 1;
%     end
%
% % selfcheck:
% % error = sum(A(2:end).^2)^0.5/A(1) - THD:
%
% end % function harmonic_series

