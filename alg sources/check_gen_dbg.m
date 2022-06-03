% Generates debug structure with default values
% Is used as definition of dbg. If dbg structure is set as input, if ensures
% the dbg structure is correct and returns it.

function dbg = check_gen_dbg(dbg)
    if nargin == 0
        % create a new debug structure with any values
        dbg = struct();
    end
    % check one field after another

    % v - debug switch %<<<2
    % integer (0)
    % If nonzero debug is enabled. Plots will be plotted.
    if ~isfield(dbg, 'v')
        dbg.v = 1;
    else
        if ~isinteger(dbg.v)
            dbg.v = int8(dbg.v)(1);
        end
    end
    % section - section of the data, in between multiplexer switches %<<<2
    % integer (0)
    % Used for plot titles
    if ~isfield(dbg, 'section')
        dbg.section = 0;
    else
        if ~isinteger(dbg.section)
            dbg.section = int8(dbg.section)(1);
        end
    end
    % segment - segment of the data, in between PJVS step changes %<<<2
    % integer (0)
    % Used for plot titles
    if ~isfield(dbg, 'segment')
        dbg.segment = 0;
    else
        if ~isinteger(dbg.segment)
            dbg.segment = int8(dbg.segment)(1);
        end
    end
    % showplots - show generated plots?
    % char ('off')
    % If on, plots are shown (if generated)
    if ~isfield(dbg, 'showplots')
        dbg.showplots = 'off';
    else
        if not(strcmp(dbg.showplots, 'off') || strcmp(dbg.showplots, 'on'))
            dbg.showplots = 'off';
        end
    end
    % saveplotsplt - save plots to plt files %<<<2
    % integer (0)
    % If nonzero, plots are saved as plt files
    if ~isfield(dbg, 'saveplotsplt')
        dbg.saveplotsplt = 0;
    else
        if ~isinteger(dbg.saveplotsplt)
            dbg.saveplotsplt = int8(dbg.saveplotsplt)(1);
        end
    end
    % saveplotspng - save plots to png files %<<<2
    % integer (0)
    % If nonzero, plots are saved as png files
    if ~isfield(dbg, 'saveplotspng')
        dbg.saveplotspng = 0;
    else
        if ~isinteger(dbg.saveplotspng)
            dbg.saveplotspng = int8(dbg.saveplotspng)(1);
        end
    end
    % plotpath - path to save plots
    % char ('.')
    % All plots will be saved to the specified path
    if ~isfield(dbg, 'plotpath')
        dbg.plotpath = '.';
    end

end % function
