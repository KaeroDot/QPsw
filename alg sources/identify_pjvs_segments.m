% Automatically finds out indexes of starts of PJVS segments from sampled signal
% with PJVS steps. Script use naive heuristic method.
% (PJVS segment is part of signal containing one stabilized PJVS step and
% transitions from one step to another.)
%
% Developed in the scope of the EMPIR QPower.
% MIT license
%
% inputs:
% y - record of PJVS steps
% max_adc_noise - maximum distance of measured value and PJVS step value (ADC
%   noise). This is to filter out nosie of ADC before detecting sudden voltage
%   changes caused by changing PJVS quantum number (step to step voltage
%   change). If empty, value of 100 uV is used. 
%   It should be less than half of one quantum junction voltage (max_adc_noise
%   must be lower than 1*f_m/K_J, where f_m is microwave frequency and K_J is
%   josephson constant). 
% MRs -...
% MRe - how many samples are masked from beginning/end of the section to get
%   rid of possible voltage changes caused by multiplexer switches. If empty,
%   10 % of record is used.
%
% output:
% Spjvs - indexes of segments (samples just after PJVS step change happened).
%
function Spjvs = identify_pjvs_segments(y, MRs, MRe, max_adc_noise, segmentlen, dbg)
    % initialize %<<<1

    % check inputs %<<<1
    if isempty(max_adc_noise)
        max_adc_noise = 1e-4;
    end
    if isempty(MRs)
        MRs = fix(numel(y).*0.1);
    end
    if isempty(MRe)
        MRe = fix(numel(y).*0.1);
    end
    if MRs < 0
        error('identify_pjvs_segments: negative number of samples to be removed at start of segment!')
    end
    if MRe < 0
        error('identify_pjvs_segments: negative number of samples to be removed at end of segment!')
    end
    if numel(y) - MRs - MRe < 1
        error('identify_pjvs_segments: no samples left after masking samples at beginning and end of the record');
    end

    % CONSTANTS
    segment_precision_uncertainty = 1;

    % find indexes of several segments (PJVS step changes) %<<<1
    % mask data from start and beginning of the section, and set the values to
    % voltage at end/start of the mask so no voltage change is added:
    y2 = y;
    y2(1 : MRs) = y2(MRs);                  % works even for MR = 0;
    y2(end - MRe : end) = y2(end - MRe);    % works even for MRe = 0;
    % find step changes:
    % derivation shows out voltage changes:
    y3 = abs(diff(y2));
    % mask out small voltage changes caused by ADC noise:
    y3(y3 < max_adc_noise) = 0;
    % get indexes of the found segments, i.e. starts of PJVS steps. These
    % indexes can still contain false positives or negatives:
    ids = find(y3);

    % get length of one segment %<<<1
    if ~isempty(segmentlen)
        disp('used fseg') %XXX delete in future
    else
        % One possible method, but this never worked to 100 % for differently bad signals. Maybe should be removed to prevent any confusion.
        % XXX remove?
        % get spectrum (frequency is 1, as one sample):
        [F, AMP] = ampphspectrum(y3, 1, 0, '', 'blackman');
        % remove possible dc and alias near nyquist frequency (mask 10 % from start
        % and end):
        len = fix(numel(F).*0.1);
        AMP(1 : len) = 0;
        AMP(end-len : end) = 0;
        % and get highest amplitude, that is most probable frequency of big voltage
        % changes, i.e. frequency of PJVS setup, or segment length in samples
        % (float):
        [~, maxid] = max(AMP);
        segmentlen = 1/F(maxid);
    end

    % find PJVS phase %<<<1
    % segmentlength is known, but not the phase, because ids (indexes of segment starts) can contain false
    % positively and false negatively identified segment starts, and ids(1) can be
    % false positive.  So create all possible ids (indexes) for actual
    % segmentlength. Than try to find this set of new ids than match most of ids
    % (indexes of segment starts).
    for sl = 1:segmentlen
        % create list of new ids for actual segmentlen and 'phase':
        SLM{sl} = round(sl : segmentlen : numel(y));
        % calculate 'distance' function, i.e. how many indexes from SLM{} are same as ids, +- uncertainty.
        count(sl) = 0;
        for n = 1:numel(SLM{sl})
            num = SLM{sl}(n);
            if any(num > ids - segment_precision_uncertainty & num < ids + segment_precision_uncertainty);
                count(sl) = count(sl) + 1;
            end
        end
    end % for sl

    % make PJVS values %<<<1
    % Most probable indexes of PJVS changes are:
    % (+1 is for off-by-one error caused by diff. We need idnex of start of
    % segment instead of index of end of segment)
    % select best SLM based on 'distance':
    [~, tmpid] = max(count);
    Spjvs = SLM{tmpid};

    % ensure start and ends of record as PJVS segments
    if Spjvs(1) ~= 1
        Spjvs = [1 Spjvs];
    end
    if Spjvs(end) ~= numel(y) + 1
         % because Spjvs marks start of step, next
        % step is after the last data sample
        Spjvs(end+1) = numel(y) + 1;
    end

    % DEBUG plots (takes long time to plot!) %<<<1
    if dbg.v
        ssec = sprintf('00%d-00%d_', dbg.section(1), dbg.section(2));
        % plot matches of ids for various 'phase' of segmentlen
        figure('visible',dbg.showplots)
        hold on
        plot(1:numel(count), count, 'x-')
        plot(tmpid, max(count), 'ok')
        xlabel('segmentlen phase')
        ylabel(['number of matched indexes +- ' num2str(segment_precision_uncertainty)])
        title('PJVS section with PJVS phase identification')
        hold off
        fn = fullfile(dbg.plotpath, [ssec 'segment_identify_phase']);
        if dbg.saveplotsplt printplt(fn) end
        if dbg.saveplotspng print([fn '.png'], '-dpng') end

        % plot samples and ids
        % this plot takes long time to draw!)
        disp('plotting DEBUG plot for identify_pjvs_segments. This will take a long time...')
        figure('visible',dbg.showplots)
        hold on
        plot(y,'-x');
        plot(y2,'-');
        plot(y3,'-x');
        ylims = ylim;
        plot([0, numel(y)], [max_adc_noise max_adc_noise])
        plot(ids, y3(ids), 'ok')
        plotx = [Spjvs; Spjvs];
        ploty = repmat(ylims', 1, numel(Spjvs));
        plot(plotx, ploty, '--c');
        legend('samples', 'samples with masked start/end', 'abs(diff(y))', 'max_adc_noise', 'ids - first identified segment starts', 'final segment starts')
        title('PJVS section with PJVS phase identification')
        hold off
        fn = fullfile(dbg.plotpath, [ssec '_pjvs_identify_segments_all']);
        if dbg.saveplotsplt printplt(fn) end
        if dbg.saveplotspng print([fn '.png'], '-dpng') end
    end % if DEBUG

end % function Spjvs = identify_pjvs_segments

% tests  %<<<1
%XXX not finished %assert

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
