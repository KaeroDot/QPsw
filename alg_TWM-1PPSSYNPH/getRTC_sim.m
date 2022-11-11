## Copyright (C) 2022 Martin Šíra %<<<1
##

## -*- texinfo -*-
## @deftypefn {Function File} [@var{t}, @var{u}, @var{starttime}] = getRTC (@var{N}, @var{fs}, @var{starttime}, @var{t_offset}, @var{t_slope})
## Script generates a simulated signal for testing the getRTC function.
## 
## Inputs:
## @table @in
## @item @var{N}
##      Number of samples of the simulated signal.
## @item @var{fs}
##      Sampling frequency of the simulated signal.
## @item @var{corrstarttime}
##      Corrected starttime of the first sample in the time series.
## @item @var{t_offset}
##      Offset error of the simulated digitizer timebase.
## @item @var{t_slope}
##      SLope error of the simualted digitizer timebase.
## @end table
## 
## Outputs:
## @table @out
## @item @var{t}
##      time series of sampled data.
## @item @var{u}
##      voltage series of sampled 1PPS signal.
## @item @var{starttime}
##      approximate real time of the beginning of sampling as the number
##      of seconds since the epoch (see help time). The precision should
##      be better than 0.4 second.
## @end table
## @end deftypefn

function [t, u, starttime] = getRTC_sim(N, fs, starttime, t_offset, t_slope) %<<<1
% Constants:
% real widht of a 1 PPS pulse in seconds:
pulselen = 1.5e-6;
pulselen = 1.5e-3;
% pulse voltage:
pulseamp = 5;

% add offset error to the starttime:
starttime = starttime - t_offset;
% make time axis:
t = [0:N-1]./fs;
% record:
u = zeros(size(t));

% calculate maximum number of pulses in the record:
% total time of the record:
tt = t(end).*t_slope;
% because one pulse per second, tt is the number of pulses in the record.
pulseid = (rem(starttime, 1) + ([1:ceil(tt) + 1] - 2)).*t_slope.*fs;

% find length of the pulse in samples:
pulselen_samples = pulselen.*fs;

for j = 1:numel(pulseid)
    % get index of the pulse start, but not less than 1:
    ps = max(1, pulseid(j));
    % get index of the pulse end, but not more than length of the data:
    pe = min(numel(t), ps + pulselen_samples);
    % set voltage to pulse amplitude:
    u(fix(ps):ceil(pe)) = pulseamp;
    if pulseid(j) > 1
        % simulate rising edge of the pulse (only if it is not first sample,
        % because first sample is probably part of pulse that started before
        % the sampling itself)
        u(fix(ps)) = (1 - rem(ps, 1)).*pulseamp;
    end
    if ceil(pe) < numel(t)
        % simulate trailing edge of the pulse (only if it is not last sample, 
        % because last sample is probably continuing after the end of sampling)
        u(ceil(pe)) = (1 - rem(pe, 1)).*pulseamp;
    end
end

end % function


%!test
% error in sampling frequency 0.1 ppm, in starttime 0.001 s:
%! [t, u, starttime] = getRTC_sim(60e6, 15e6, 0, 1e-3, 1.0000001);
%! [corrstarttime, p, fsr, fsrerr] = getRTC(t, u, 0, 0);
%! assert(fsrerr, -1e-7, 0.1)
%! assert(p(2), 0.001, 0.0001)
