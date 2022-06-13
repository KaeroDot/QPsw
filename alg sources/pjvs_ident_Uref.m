% Automatically finds out relevant PJVS reference voltages for section with
% with PJVS steps. Input is values of PJVS reference voltages for 1 period of
% PJVS signal. Output is reference voltages matched to the sample signal, for
% the number of periods as in the signal, with correct phase.
%
% Developed in the scope of the EMPIR QPower.
% MIT license
%
% inputs:
% y - record of PJVS steps
% MRs -...
% MRe - how many samples are masked from beginning/end of the record to get
%   rid of possible voltage changes caused by multiplexer switches. If empty,
%   10 % of record is used.
% Spjvs - indexes of samples before PJVS step change happened (indexes
%   of starts of PJVS segments).
% Uref1period - PJVS reference voltages for 1 period of PJVS signal.
%
% output:
% Uref - reference voltages matched to the sample signal, for the number of
%   periods as in the signal.

function Uref = pjvs_ident_Uref(s_mean, Uref1period, dbg);

    % replicate reference voltages of one period to whole signal %<<<1
    % total number of segments in the record:
    segments = numel(s_mean);
    % approx. number of PJVS periods in record:
    per = ceil(segments./numel(Uref1period));
    Uref = repmat(Uref1period(:)', 1, per);
    % now Uref should contain Uref voltages for whole number of PJVS periods,
    % only phase is not yet known.

    % find out phase for reference voltages %<<<1
    % Try to find out the 'phase' of the reference voltages and fit it to
    % recorded segments. Move reference voltages around and calculate total
    % difference of voltages, select solution with smallest difference.

    distance = [];
    Urefshifted = nan.*zeros(numel(Uref1period), segments);
    for j = 1:numel(Uref1period)
        actUref = circshift(Uref, j, 2);
        actUref = actUref(1:segments);
        Urefshifted(j, :) = actUref;
        % distance is calculated as sqrt(sum(root))
        distance(j) = sqrt(sum((s_mean - actUref).^2));
    end

    [mindistance, id] = min(distance);
    % Uref with proper phase:
    Uref = Urefshifted(id, :);

    % DEBUG plots and messages %<<<1
    if dbg.v
        ssec = sprintf('00%d-00%d_', dbg.section(1), dbg.section(2));

        if dbg.pjvs_ident_Uref_phase
            % plot matches of ids for various 'phase' of steplen
            figure('visible',dbg.showplots)
            hold on
            plot(1:numel(distance), distance, 'x-')
            plot(id, distance(id), 'ok')
            xlabel('Uref phase')
            ylabel('distance of Uref1period and Urefshifted')
            legend('calculated distances', 'selected phase')
            title(sprintf('Identification of phase of PJVS reference values\nphase, minimum distance is %.6f V', mindistance));
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_ident_Uref_phase']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.pjvs_ident_Uref_phase

        % plot samples and Uref
        if dbg.pjvs_ident_Uref_all
            figure('visible',dbg.showplots)
            hold on
            plot(s_mean, '-x')
            plot(Uref1period, '+')
            plot(Uref, 'o')
            yl = ylim;
            legend('segment means', 'Uref1period', 'replicated and matched Uref')
            title(sprintf('Identification of phase of PJVS reference values\nwaveforms'))
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_ident_Uref_all']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.pjvs_ident_Uref_all

    end % if DEBUG

end % function Spjvs = identify_pjvs_steps

% tests %<<<1
% XXX missing

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
