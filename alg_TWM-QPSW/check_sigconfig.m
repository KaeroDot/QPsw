% Checks sigconfig strucutre.
% Is used as definition of sigconfig.
% If some part of structure is missing, error is produced. User has to properly
% setup everything.

function sigconfig = check_sigconfig(sigconfig)
    if nargin ~= 1
        error('check_sigconfig: missing sigconfig structure.')
    end

    % check one field after another
    % MRs %<<<2
    % positive integer
    % Number of samples to be removed at start of section to prevent influence
    % of signal stabilization after the multiplexer switch.
    if ~isfield(sigconfig, 'MRs')
        error('check_sigconfig: MRs is not defined!')
    end
    % MRe %<<<2
    % positive integer
    % Number of samples to be removed at end of section to prevent influence
    % of signal stabilization before the multiplexer switch.
    if ~isfield(sigconfig, 'MRe')
        error('check_sigconfig: MRe is not defined!')
    end
    % PRs %<<<2
    % positive integer
    % Number of samples to be removed at start of segment to prevent influence
    % of signal stabilization after the change of quantum number of PJVS.
    if ~isfield(sigconfig, 'PRs')
        error('check_sigconfig: PRs is not defined!')
    end
    % PRe %<<<2
    % positive integer
    % Number of samples to be removed at end of segment to prevent influence
    % of signal stabilization before the change of quantum number of PJVS.
    if ~isfield(sigconfig, 'PRe')
        error('check_sigconfig: PRe is not defined!')
    end
    % fs %<<<2
    % positive float
    % Sampling frequency.
    if ~isfield(sigconfig, 'fs')
        error('check_sigconfig: fs is not defined!')
    end
    % fseg %<<<2
    % positive float
    % Frequency of the PJVS segments.
    if ~isfield(sigconfig, 'fseg')
        error('check_sigconfig: fseg is not defined!')
    end

end % function

