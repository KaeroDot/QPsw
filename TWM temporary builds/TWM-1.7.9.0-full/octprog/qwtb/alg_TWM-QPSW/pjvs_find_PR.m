% automatically finds out 'optimal' value for PRs and PRe

function [PRs, PRe] = pjvs_find_PR(yc, Spjvs, sigconfig, dbg)

    % CONSTANT: maximum number of points in one axis:
    maxP = 20;
    % make axes for PRs and PRe         %<<<1
    % length of shortest segment
    % PRs + PRe + 1 must be <= minseglen
    minseglen = min(diff(Spjvs)(2:end-1));
    % first or last diff is not taken into account, because it can be trailing
    % (i.e. smaller number of samples in segment than typical). Trailing
    % segments are not taken into account.

    if minseglen < 20
        % for small number of samples per segment (e.g. HP3458):
        PR = 0:1:minseglen -  1;
    else
        % for large number of samples per segment (e.g. NI5922):
        PR = floor(linspace(0, floor(minseglen./2) - 1, 20));
    end

    [XX, YY] = meshgrid(PR, PR);
    std_max = nan.*zeros(size(XX));
    std_mean = nan.*zeros(size(XX));
    printf('Searching PRs & PRe for values:\n')
    disp(PR)
    for j = 1:size(XX, 1);
        for k = 1:(size(XX, 2) - j + 1)
            printf('.')
            [~, s_mean{j,k}, s_std{j,k}, s_uA{j,k}] = pjvs_split_segments(yc, Spjvs, sigconfig.MRs, sigconfig.MRe, XX(j,k), YY(j,k), dbg);
            std_mean(j,k) = mean(s_std{j,k});
            std_max(j,k) = max(s_std{j,k});
        end % k
    end % j
    printf('\n')

    % find PRs, PRe, for which the mean std is not greater than 110 % of smallest mean_std
    metric = std_max;
    map = metric < min(min(metric)).*1.1;
    [idx, idy] = find(map);
    idx = idx(1);
    idy = idy(1);
    PRs = PR(idx);
    PRe = PR(idy);
    printf('Selected PRs: %d, PRe: %d\n', PRs, PRe);

    if dbg.v
        if dbg.pjvs_find_PR
            figure('visible',dbg.showplots)
            surfc(XX, YY, log10(metric));
            view(110,30);
            colormap jet;
            colorbar;
            title(sprintf('log10 of average standard deviation of PJVS steps\nminimal value: %g', min(min(metric))));
            xlabel('PRse');
            ylabel('PRse');
            ssec = sprintf('%03d-%03d_', dbg.section(1), dbg.section(2));
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_find_PR']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            tmp = [nan XX(1,:); YY(:,1) metric];
            dlmwrite([fn '.txt'], tmp, '\t')
            close
        end % if dbg.
    end % if dbg.v

end % function
