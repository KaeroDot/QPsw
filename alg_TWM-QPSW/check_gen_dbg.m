% Generates debug structure with default values
% Is used as check and definition of dbg.
% If input dbg is empty, debug level is set to 1 and minmal set of plots is generated.
% If input dbg is 0, all debug is turned off.
% If input dbg is 1, minimal set of plots is generated.
% If input dbg is 2, more plots is generated.
% If input dbg is 3, even allan deviation plots are generated
% If input dbg is 4, all plots, and fig files are generated
% If dbg structure is set as input, values are preserved and function ensures
% the dbg structure is correct.

function dbg = check_gen_dbg(dbg)
    %% check inputs %<<<1
    if nargin == 0
        % no input, ensure minimal plots:
        debug_level = 1;
        dbg = struct();
    else
        if isempty(dbg)
            % no input, ensure minimal plots:
            debug_level = 1;
            dbg = struct();
        elseif isstruct(dbg)
            % input is a structure, only fills in missing fields with zero values
            debug_level = 0;
        elseif not(isempty(dbg)) && isnumeric(dbg)
            % input is debug_level value
            debug_level = dbg(1);
            debug_level = max(0, round(debug_level));  % ensure nonnegative integer value
            dbg = struct();
        else
            % some nonsense input
            debug_level = 0;
            dbg = struct();
        end % if isstruct(dbg)
    end % if nargin == 0

    %% check one field after another %<<<1

    % fields initialized at all debug levels %<<<2
    dbg = check_set_bool(dbg, 'section', 0); % this is used only for plotting, to store actual section of the data
    dbg = check_set_bool(dbg, 'segment', 0); % this is used only for plotting, to store actual PVJS segment of a section of the data
    % plotpath - char ('.')
    % Path where to save plots
    if isfield(dbg, 'plotpath')
        if not(ischar(dbg.plotpath))
            % generate some basic plot path
            dbg.plotpath = 'QPSW_plots';
        end
    else
        dbg.plotpath = 'QPSW_plots';
    end
    % showplots - char ('off')
    % If on, plots are shown (if generated)
    if isfield(dbg, 'showplots')
        % check if string is either 'on' or 'off'
        if not(strcmp(dbg.showplots, 'off') || strcmp(dbg.showplots, 'on'))
            dbg.showplots = 'off';
        end
    else
        dbg.showplots = 'off';
    end

    % fields that are enabled at debug level 1 %<<<2
    % this level sets minimal plots
    debug_offset = 0;
    dbg = check_set_bool(dbg, 'v', debug_level - debug_offset);  % enables debug mode. enables plots to be plotted (png or fig must be also enabled)
    dbg = check_set_bool(dbg, 'saveplotspng', debug_level - debug_offset); % saves plots to png format
    dbg = check_set_bool(dbg, 'pjvs_ident_segments_10', debug_level - debug_offset); % plot identification of segments, first 10 segments
    dbg = check_set_bool(dbg, 'pjvs_segments_first_period', debug_level - debug_offset); % plot pjvs segments in first PJVS period
    dbg = check_set_bool(dbg, 'sections_1', debug_level - debug_offset); % plot data sections, first 4
    dbg = check_set_bool(dbg, 'adc_calibration_gains', debug_level - debug_offset); % plot adc calibration gains

    % fields that are enabled at debug level 2 %<<<2
    debug_offset = 1;
    dbg = check_set_bool(dbg, 'sections_10', debug_level - debug_offset); % plot data sections, 10th, 20th, 30th and 40th
    dbg = check_set_bool(dbg, 'pjvs_ident_Uref_phase', debug_level - debug_offset); % plot identification of PJVS phase, first period
    dbg = check_set_bool(dbg, 'pjvs_segments_mean_std', debug_level - debug_offset); % plot mean and std of PJVS segments
    dbg = check_set_bool(dbg, 'pjvs_find_PR', debug_level - debug_offset); % XXXXX originally was 1
    dbg = check_set_bool(dbg, 'signal_amplitudes', debug_level - debug_offset); % plot signal amplitudes
    dbg = check_set_bool(dbg, 'signal_offsets', debug_level - debug_offset); % plot signal offsets
    dbg = check_set_bool(dbg, 'adc_calibration_fit', debug_level - debug_offset); % plot adc calibration fit
    dbg = check_set_bool(dbg, 'adc_calibration_fit_errors', debug_level - debug_offset); % plot errors from adc calibration fit
    dbg = check_set_bool(dbg, 'adc_calibration_fit_errors_time', debug_level - debug_offset); % plot gains of adc, in time
    dbg = check_set_bool(dbg, 'adc_calibration_offsets', debug_level - debug_offset);  % plot offsets of adc, in time
    dbg = check_set_bool(dbg, 'signal_spectrum', debug_level - debug_offset); % plot signal spectrum
    dbg = check_set_bool(dbg, 'simulator_signals', debug_level - debug_offset); % plot simulator signals
    dbg = check_set_bool(dbg, 'demultiplexed', debug_level - debug_offset); % plot demultiplexed waveforms

    % fields that are enabled at debug level 3 %<<<2
    debug_offset = 2;
    dbg = check_set_bool(dbg, 'pjvs_ident_segments_all', debug_level - debug_offset); % plot identification of segments, all
    dbg = check_set_bool(dbg, 'pjvs_ident_Uref_all', debug_level - debug_offset); % plot identification of PJVS phase, all periods
    dbg = check_set_bool(dbg, 'pjvs_adev', debug_level - debug_offset); % plot allan deviation of PJVS segmetns, fist PJVS period
    dbg = check_set_bool(dbg, 'pjvs_adev_all', debug_level - debug_offset); % plot allan deviation of PJVS segmetns, all

    % fields that are enabled at debug level 4 %<<<2
    debug_offset = 3;
    dbg = check_set_bool(dbg, 'saveplotsfig', debug_level - debug_offset); % save plots to fig format

end % function

function dbg = check_set_bool(dbg, fieldname, defaultvalue) %<<<1
% Checks if fieldname exist, if so, ensure it is of int8. Also checks value is 0
% or 1, if not set to default.
    % ensures default value is 0 or 1, so a negative or too big value can be used as input:
    defaultvalue = max(defaultvalue, 0); 
    defaultvalue = min(defaultvalue, 1); 
    if ~isfield(dbg, fieldname)
        dbg.(fieldname) = defaultvalue;
    else
        if ~isinteger(dbg.(fieldname))
            dbg.(fieldname) = int8(dbg.(fieldname));
            dbg.(fieldname) = dbg.(fieldname)(1);
        end
    end
end % function dbg, check_set_int8(dbg, fieldname, defaultvalue)

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
