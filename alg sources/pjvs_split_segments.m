% splits section with PJVS signal into particular segments. Removes data before
% MRs and after MRe. Calculates mean and std for segments, removes PRs and PRe

function [s_y, s_mean, s_std, s_uA] = pjvs_split_segments(y, Spjvs, MRs, MRe, PRs, PRe, dbg)

    % Remove points masked by MRs and MRe
    y = y(MRs + 1 : end - MRe);
    % Change Spjvs indexes to match removed points:
    Spjvs = Spjvs - MRs;
    Spjvs(Spjvs > numel(y) + 1) = [];

    % ensure start and ends of record as PJVS segments
    Spjvs(Spjvs < 1) = [];
    Spjvs(Spjvs > numel(y) + 1) = [];
    if Spjvs(1) ~= 1
        Spjvs = [1 Spjvs];
    end
    if Spjvs(end) ~= numel(y) + 1
        % because Spjvs marks start of step, next
        % step is after the last data sample
        Spjvs(end+1) = numel(y) + 1;
    end

    % Loop to cut into segments. Segments can be of different length. Also
    % calculates means and std for case of removed PRs and PRe to save
    % processing time.
    % initliaze variables:
    maxsegmentlen = max(diff(Spjvs));
    s_y = nan.*zeros(maxsegmentlen, numel(Spjvs) - 1);
    % Because basic Matlab does not contain nanmean and nanstd, two methods
    % available. Second method is 10x slower.
    if exist('nanmean')
        % faster version
        for j = 1:numel(Spjvs) - 1
            % get one segment
            actlen = Spjvs(j+1) - Spjvs(j);
            tmp = y(Spjvs(j) : Spjvs(j+1) - 1);
            if numel(tmp) > PRs + PRe
                tmp = tmp(1 + PRs : end-PRe);
                s_y(1:numel(tmp), j) = tmp;
            else
                if j == 1
                    % it is first segment, lets neglect it
                    disp(sprintf('Not enough samples in segment after start and end removal, section %d-%d, segment %d, PRs: %d, PRe: %d. It is first segment, neglecting.', dbg.section(1), dbg.section(2), j, PRs, PRe));
                elseif j == numel(Spjvs) - 1
                    % it is last segment, lets neglect it
                    disp(sprintf('Not enough samples in segment after start and end removal, section %d-%d, segment %d, PRs: %d, PRe: %d. It is last segment, neglecting.', dbg.section(1), dbg.section(2), j, PRs, PRe));
                else
                    error(sprintf('Not enough samples in segment after start and end removal, section %d-%d, segment %d', dbg.section(1), dbg.section(2), j));
                end
            end
        end
        % remove neglected:
        if all(isnan(s_y(:,1)))
            % first segment was neglected, remove it from matrices:
            s_y(:,1) = [];
        end
        if all(isnan(s_y(:,end)))
            % last segment was neglected, remove it from matrices:
            s_y(:,end) = [];
        end
        s_mean = nanmean(s_y, 1);
        s_std = nanstd(s_y, 0, 1);
        s_uA = s_std./sqrt(sum(~isnan(s_y),1));
    else
        % slow version for basic Matlab without nanmean
        s_mean = nan.*zeros(1, numel(Spjvs) - 1);
        s_std = nan.*zeros(1, numel(Spjvs) - 1);
        for j = 1:length(Spjvs) - 1
            % get one segment
            actlen = Spjvs(j+1) - Spjvs(j);
            tmp = y(Spjvs(j) : Spjvs(j+1) - 1);
            if numel(tmp) > PRs + PRe
                tmp = tmp(1 + PRs : end-PRe);
                s_y(1:numel(tmp), j) = tmp;
            else
                if j == 1
                    % it is first segment, lets neglect it
                    disp(sprintf('Not enough samples in segment after start and end removal, section %d-%d, segment %d, PRs: %d, PRe: %d. It is first segment, neglecting.', dbg.section(1), dbg.section(2), j, PRs, PRe));
                elseif j == numel(Spjvs) - 1
                    % it is last segment, lets neglect it
                    disp(sprintf('Not enough samples in segment after start and end removal, section %d-%d, segment %d, PRs: %d, PRe: %d. It is last segment, neglecting.', dbg.section(1), dbg.section(2), j, PRs, PRe));
                else
                    error(sprintf('Not enough samples in segment after start and end removal, section %d-%d, segment %d', dbg.section(1), dbg.section(2), j));
                end
            end
            % remove neglected:
            if all(isnan(s_y(:,1)))
                % first segment was neglected, remove it from matrices:
                s_y(1,:) = [];
            end
            if all(isnan(s_y(:,end)))
                % last segment was neglected, remove it from matrices:
                s_y(:,end) = [];
            end
            s_mean(j)        = mean(tmp);
            s_std(j)         =  std(tmp);
            s_uA(j) = s_std(j)./sqrt(numel(tmp));
        end % for j = 1:length(Spjvs) - 1
    end % if exist('nanmean')

end % function
