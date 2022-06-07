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

function Uref = pjvs_ident_Uref(y, MRs, MRe, Spjvs, Uref1period, dbg)
    % % check inputs %<<<1
    % XXX FINISH
    % if isempty(max_adc_noise)
    %     max_adc_noise = 1e-5;
    % end
    % if isempty(Rs)
    %     Rs = fix(numel(y).*0.1);
    % end
    % if isempty(Re)
    %     Re = fix(numel(y).*0.1);
    % end
    % if Rs < 0
    %     error('identify_pjvs_steps: negative number of samples to be removed at start of section!')
    % end
    % if Re < 0
    %     error('identify_pjvs_steps: negative number of samples to be removed at end of section!')
    % end
    % if numel(y) - Rs - Re < 1
    %     error('identify_pjvs_steps: no samples left after masking samples at beginning and end of the record');
    % end

    % replicate reference voltages of one period to whole signal %<<<1
    % number of segments in the record:
    segments = numel(Spjvs) - 1;
    % approx. number of PJVS periods in record:
    per = ceil(segments./numel(Uref1period));
    Uref = repmat(Uref1period(:)', 1, per);
    % now Uref should contain Uref voltages for whole number of PJVS periods

    % calculate average voltages in the segments %<<<1
    ymn = zeros(size(Spjvs) - 1);
    for j = 1:numel(Spjvs)-1
        ymn(j) = mean(y( Spjvs(j) : Spjvs(j+1)-1) );
    end

    % find out how many steps are masked at beginning and end %<<<1
    % (this is used for removing bad averages when finding phase)
    mask_start_count = sum(Spjvs <= MRe);
    mask_end_count = sum(Spjvs >= numel(y) - MRe);
    masked_ymn = ymn;
    masked_ymn(1 : mask_start_count) = 0;
    masked_ymn(end - mask_end_count : end) = 0;

    % find out phase for reference voltages %<<<1
    % Try to find out the 'phase' of the reference voltages and fit it to
    % recorded segments. Move reference voltages around and calculate total
    % difference of voltages, select solution with smallest difference.

    distance = [];
    UrefM = [];
    for j = 1:numel(Uref1period)
        tmp = circshift(Uref, j, 2);
        tmp = tmp(1:numel(ymn));
        UrefM(end+1,:) = tmp;
        masked_tmp = tmp;
        masked_tmp(1:mask_start_count) = 0;
        masked_tmp(end - mask_end_count : end) = 0;
        % distance is calculated as sqrt(sum(root))
        % but only from segments not in MRs, MRe:
        distance(j) = sqrt(sum((masked_ymn - masked_tmp).^2));
    end

    [mindistance, id] = min(distance);
    Uref = UrefM(id, :);

    % XXX check value of distance and WARNING if too large!

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
            ylabel('distance of Uref1period and UrefM')
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
            plot(y, '-x')
            plot(Spjvs(1:numel(Uref1period)), Uref1period, '+')
            plot(Spjvs(1:end-1), Uref, 'o')
            yl = ylim;
            plot(MRs.*[1 1], yl, '-k')
            plot((numel(y) - MRe).*[1 1], yl, '-k')
            legend('samples', 'input data: Uref1period', 'replicated and matched Uref', 'masking limits')
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
