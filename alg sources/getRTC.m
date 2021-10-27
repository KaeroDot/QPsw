## Copyright (C) 2015 Martin Šíra %<<<1
##

## -*- texinfo -*-
## @deftypefn {Function File} [@var{corrstarttime}, @var{p}, @var{fsr}, @var{fsrerr}] = getRTC (@var{t}, @var{u}, @var{starttime}, @var{verbose}=0)
## Script calibrate time axis of sampled 1PPS (one puls per second).
## Real time of the sampled series can be calculated as:
## @example
##      corrstarttime + polyval(p, t)
## @example end
## 
## Inputs:
## @table @in
## @item @var{t}
##      time series of sampled data.
## @item @var{u}
##      voltage series of sampled 1PPS signal.
## @item @var{starttime}
##      approximate real time of the beginning of sampling as the number
##      of seconds since the epoch (see help time). The precision should
##      be better than 0.4 second.
## @item @var{verbose}
##      shows all plots and display some results.
## @end table
## 
## Outputs:
## @table @out
## @item @var{corrstarttime}
##      Corrected starttime of the first sample in the time series.
## @item @var{p}
##      polynomial coefficients, output of polyfit, first order.
## @item @var{fsr}
##      real calculated sampling frequency.
## @item @var{fsrerr}
##      error of real calculated sampling frequency (based on sampling frequency
##      reported by the sampling data)
## @end table
## @end deftypefn

## Author: Martin Šíra <msiraATcmi.cz>
## Created: 2015
## Version: 0.1
## Script quality:
##   Tested: no
##   Contains help: yes
##   Contains example in help: no
##   Checks inputs: no
##   Contains tests: no
##   Contains demo: yes
##   Optimized: N/A

function [corrstarttime, p, fsr, fsrerr] = getRTC(t, u, starttime, verbose = 0) %<<<1

% reformat t and u to rows:
t = t(:)';
u = u(:)';

% remove offset of voltage series:
u = u - mean(u);

% remove noise by threshold:
threshold = 0.5;
l = threshold.*max(u);
d = u>l;
% get derivation and only positive slopes:
% (d is one sample shorter, as it is in between of two samples)
d = diff(d);
d = d==1;

% check at least two positive slopes were found:
if (sum(d) < 2)
        error('not enough positive slopes found!')
endif

% time of ticks in sampled time:
% (half of sample is added because of derivation)
tmarks = t(d) + (t(2)-t(1))/2;

% check time of first tick:
if ( tmarks(1)-t(1) > 1.01 )
        error(sprintf('error in PPS detection, sampling time of first detected 1PPS is %f, should be better than 1.01 s', tmarks(1) - t(1) ))
endif

% check first second is identified correctly:
% (required precision to 0.4 second)
% first puls per second real time:
fppsrt = starttime + tmarks(1) - t(1);
fppsrterr  = round(fppsrt) - fppsrt;
disp(sprintf('error of the first identified PPS is %f, limits are -0.4 -- 0.4.', fppsrterr))
if (fppsrterr < -0.4 || fppsrterr > 0.4)
        error('unable to correctly identify real time of first PPS')
endif
% generate ideal seconds after starttime second:
if ( tmarks(1) - t(1) > 0.5 )
        sass = [1:sum(d)];
else
        sass = [0:sum(d)-1];
endif

% fit tics:
[p, s] = polyfit(tmarks, sass, 1);

% get original sampling frequency:
fs = (length(t)-1)/(t(end) - t(1));

% get real sampling frequency:
fsr = (length(t)-1)/(polyval(p, t(end)) - polyval(p, t(1)));
% real sampling frequency error:
fsrerr = (fs-fsr)/fsr;

% calculate corrected starttime:
corrstarttime = round(starttime + fppsrterr);

if verbose
        disp(sprintf('sampling frequency based on data is: %.10f', fs))
        disp(sprintf('real sampling frequency is: %.10f', fsr))
        disp(sprintf(['real sampling frequency uncertainty possibly greater than ' num2str(1/((t(2)-t(1))*1e6)) ' uHz']));
        disp(sprintf('real sampling frequency error is %f ppm', fsrerr*1e6));
        fsrt = corrstarttime + polyval(p, t(1));
        disp(sprintf('real time of the first sample is %s.%0.6d', strftime('%Y-%m-%dT%H:%M:%S', localtime(fsrt)), localtime(fsrt).usec));

        % plot identified tics:
        figure
        plot(t,u,'-b',tmarks,d(d==1).*l,'*r')
        legend('original data','identified positive slopes')
        xlabel('sampling time (s)')
        ylabel('voltage (V)')
        for j = 1:length(tmarks)
                ts = corrstarttime + polyval(p, tmarks(j));
                text(tmarks(j), l*1.10, strftime('%S',localtime(ts)));
        endfor
        title(['1PPS, numbers are real time seconds after ' strftime('%Y-%m-%dT%H:%M', localtime(corrstarttime)) ':00.000 local time']);

        % plot linear fitting:
        figure
        plot(tmarks, sass, '+-');
        xlabel('time of tics in sampling time (s)')
        tmp = strftime('%Y-%m-%dT%H:%M:%S', localtime(corrstarttime));
        ylabel(['identified 1PPS tics in real time (seconds after corrected start time ' tmp '.000 local time)'])
        title(['sampling frequency error: ' num2str(fsrerr*1e6) ' ppm']);

        % plot errors of fit:
        figure
        plot(tmarks, (s.yf-sass).*1e6, '+-');
        xlabel('time of tics in sampling time (s)')
        ylabel('error from ideal fit (us)')
        title('errors of fit. values at approx. 3e-9 are rounding errors')
endif

endfunction

% --------------------------- demo: %<<<1

%!demo
%! %%%% generate starttime:
%! starttime = mktime(strptime("2015-04-01T12:13:14", "%Y-%m-%dT%H:%M:%S"));
%! %%%% add offset error of starttime:
%! starttime = starttime - 0.5;
%! %%%% make time axis, 10 seconds with sample point every 10 miliseconds:
%! t = [0:999]';
%! t = t./100;
%! %%%% make voltage values:
%! u = zeros(size(t));
%! %%%% create 1 puls per second ticks:
%! o = -50; % this is offset error of measurement (-50 == 500 ms)
%! u(101+o) = 1;
%! u(201+o:204+o) = 1;
%! u(301+o) = 1;
%! u(401+o:420+o) = 1;
%! u(501+o) = 1;
%! u(601+o) = 1;
%! u(701+o) = 1;
%! u(801+o:814+o) = 1;
%! u(901+o) = 1;
%! %%%% add noise:
%! u = u + randn(size(u)).*0.01;
%! [corrstarttime, p, fsr, fsrerr] = getRTC(t, u, starttime, 1) %<<<1

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=1000
