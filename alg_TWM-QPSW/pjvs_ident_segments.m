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
% MRs -...
% MRe - how many samples are masked from beginning/end of the section to get
%   rid of possible voltage changes caused by multiplexer switches. If empty,
%   10 % of record is used.
%
% output:
% Spjvs - indexes of segments (samples just after PJVS step change happened).
%
function Spjvs = pjvs_ident_segments(y, MRs, MRe, segmentlen, dbg)
   pjvs_phase_method = 2;  %XXX move to sigconfig!

    % initialize %<<<1

    % check inputs %<<<1
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

    % find indexes of several segments (PJVS step changes) %<<<1
    % mask data from start and beginning of the section, and set the values to
    % voltage at end/start of the mask so no voltage change is added:
    y2 = y;
    y2(1 : MRs + 1) = y2(MRs + 1);
    y2(end - MRe : end) = y2(end - MRe);    % works even for MRe = 0;

    % call one of phase identification methods:
    switch pjvs_phase_method
        case 1
            Spjvs = highest_peak(y2, segmentlen);
        case 2
            Spjvs = split_and_highest_peak(y2, segmentlen);
        otherwise
            error('pjvs_ident_segments: uknown method for identification of PJVS phase')
    end % switch

    % ensure start and ends of record as PJVS segments
    if Spjvs(1) ~= 1
        Spjvs = [1 Spjvs];
    end
    if Spjvs(end) ~= numel(y2) + 1
         % because Spjvs marks start of step, next
        % step is after the last data sample
        Spjvs(end+1) = numel(y2) + 1;
    end

    % debug plots %<<<1
    if dbg.v
        ssec = sprintf('%03d-%03d_', dbg.section(1), dbg.section(2));

        if dbg.pjvs_ident_segments_10
            % plot samples and ids - first short version with only 10 PJVS segments after MRs:
            plotmax = MRs + 10*segmentlen;
            plotmax = min(plotmax, length(y));
            figure('visible',dbg.showplots)
            hold on
            plot( y(1:plotmax),'-x');
            plot(y2(1:plotmax),'-');
            plot([MRs MRs], ylim, '-k')
            tmpSpjvs = Spjvs(Spjvs < plotmax);
            plot(tmpSpjvs, y2(tmpSpjvs), 'o', 'linewidth', 2);
            legend('Samples', 'Samples with masked MRs, MRe', 'Identified start of segment', 'MRs')
            xlabel('Sample index')
            ylabel('Voltage (V)')
            title(sprintf('PJVS phase identification, section %03d-%03d\nfirst 10 segments after MRs', dbg.section(1), dbg.section(2)), 'interpreter', 'none')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_ident_segments_10']);
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
        end % if dbg.pjvs_identify_segments_10_segments

        if dbg.pjvs_ident_segments_all
            % plot samples and ids - this plot takes VERY long time to draw!
            disp('Plotting debug plot for identify_pjvs_segments_all. This will take a long time...')
            figure('visible',dbg.showplots)
            hold on
            plot(y,'-x');
            plot(y2,'-');
            plot(Spjvs(1:end-1), y2(Spjvs(1:end-1)), 'o', 'linewidth', 2);
            plot([MRs MRs], ylim, '-k')
            plot([MRe MRe], ylim, '-k')
            legend('Samples', 'Samples with masked MRs, MRe', 'Identified start of segment', 'MRs', 'MRe')
            xlabel('Sample index')
            ylabel('Voltage (V)')
            title(sprintf('PJVS phase identification, section %03d-%03d\nall data', dbg.section(1), dbg.section(2)), 'interpreter', 'none')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_ident_segments_all']);
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
            disp('Debug plot for identify_pjvs_segments_all finished.')
        end % if dbg.pjvs_ident_segments_all
    end % if debug

end % function Spjvs = identify_pjvs_segments

function Spjvs = highest_peak(y, segmentlen); %<<<1
% Finds phase based on highest peak of derivation. Highest peak is most
% hopefully a step change and not some noise or error. Method is fast.

    % find step changes:
    % derivation shows out voltage changes:
    ydiff = abs(diff(y));
    % get index of biggest derivation (biggest signal step);
    [~, maxid] = max(ydiff);
    maxid = maxid(1);
    % remainder of division is offset - number of samples at beginning before
    % first PJVS step happen:
    phase_offset = rem(maxid, segmentlen);
    % indexes of PJVS steps:
    Spjvs = [1:segmentlen:numel(y)] + phase_offset;
    % ensure integers:
    Spjvs = round(Spjvs);
    % ensure proper values of indexes:
    Spjvs(Spjvs < 1) = [];
    Spjvs(Spjvs > numel(y) + 1) = [];
        % Only for very detailed debuggging:
        % figure
        % hold on
        % plot(y,'-b')
        % plot(ydiff,'-k')
        % plot(maxid, y(maxid),'or', 'linewidth',2)
        % hold off
        % keyboard
end % function Spjvs = highest_peak(y, segmentlen);

function Spjvs = split_and_highest_peak(y, segmentlen); %<<<1
    % Finds phase based on highest peak of derivation. Data are first cut to
    % subsections of approximatly 50 pjvs periods (50*segmentlen).

    % Pad y to be multiple of segmentlen for easy cutting. Last value of y is
    % used to prevent derivations:
    rsl = round(segmentlen).*50;
    padlen = ceil(size(y,2)/rsl)*rsl - size(y,2);
    ypad = [y y(end).*ones(1,padlen)];

    Spjvs = [];
    for j = 1:size(ypad,2)./rsl % this should be divisible already
        tmp = highest_peak(ypad((j-1)*rsl + 1 : j*rsl), segmentlen);
        Spjvs = [Spjvs (tmp + (j-1)*rsl)];
    end % for j
    % Sometimes can happen there is difference of 1 between 2 consecutive Spjvs
    % indexes (like [... 340 350 351 361 ...]). This happens on the borders of two
    % subsections, because of rounding of the phase (previous run was slightly below
    % .5, next run slighly above .5). Therefore in previous run last point appeared,
    % and in this run first point appeared also. Such points are removed:
    idx = find(diff(Spjvs) == 1);
    Spjvs(idx) = [];
    % Sometimes also happens there is difference of 0, also to be removed:
    idx = find(diff(Spjvs) == 0);
    Spjvs(idx) = [];
    % remove all Spjvs for index bigger than unpadded data:
    Spjvs(Spjvs > size(y,2)) = [];
end % function Spjvs = split_and_highest_peak(y, segmentlen);

% tests  %<<<1
%XXX not finished %assert

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
