% calculate adev for all segments in actual section
function pjvs_adev(s_y, Uref, Uref1period, dbg);
    % calculate and plot only if debug enabled, allan calc. enabled, and at least one plot output is enabled:
    if dbg.v && (dbg.pjvs_adev || dbg.pjvs_adev_all) && (dbg.saveplotsfig || dbg.saveplotspng)
        disp('calculating ALLAN')
        ssec = sprintf('%03d-%03d_', dbg.section(1), dbg.section(2));
        if dbg.pjvs_adev
            % calculate ADEVs for a single PJVS period:
            for j = 1:numel(Uref1period)
                DI.y.v = s_y(:, j);
                DI.y.v(isnan(DI.y.v)) = [];
                DI.y.v = DI.y.v(:)';
                DI.fs.v = 1;
                DO{j} = qwtb('OADEV',DI);
            end % for j

            % plot adevs
            figure('visible',dbg.showplots)
            hold on
            legc = {};
            for j = 1:numel(Uref1period)
                if ~isempty(DO{j}.oadev.v)
                    loglog(DO{j}.tau.v, DO{j}.oadev.v.*1e6, '-')
                    legc{end+1} = sprintf('U_{ref}=%.9f', Uref1period(j));
                end
            end
            legend(legc, 'location', 'eastoutside')
            title(sprintf('OADEV of segment samples, section %03d-%03d\nsamples from single segments (for first PJVS period)', dbg.section(1), dbg.section(2)), 'interpreter', 'none')
            xlabel('Observation period (samples)')
            ylabel('OADEV (uV)')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_oadev']);
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
        end % if dbg.pjvs_adev

        if dbg.pjvs_adev_all
            % calculate ADEVs for a all segments in whole section:
            printf('Calculating OADEV for whole section %03d-%03d, this can take time...\n', dbg.section(1), dbg.section(2))
            for j = 1:numel(Uref1period)
                idx = find(Uref == Uref1period(j));
                DI.y.v = s_y(:, idx);
                DI.y.v(isnan(DI.y.v)) = [];
                DI.y.v = DI.y.v(:)';
                DI.fs.v = 1;
                DOall{j} = qwtb('OADEV',DI);
            end % for j

            % plot results
            figure('visible',dbg.showplots)
            hold on
            legc = {};
            for j = 1:numel(Uref1period)
                loglog(DOall{j}.tau.v, DOall{j}.oadev.v.*1e6, '-')
                legc{end+1} = sprintf('U_{ref}=%.9f', Uref1period(j));
            end
            legend(legc, 'location', 'eastoutside')
            title(sprintf('OADEV of segment samples, section %03d-%03d\nsamples from all segment in whole section', dbg.section(1), dbg.section(2)), 'interpreter', 'none')
            xlabel('Observation period (samples)')
            ylabel('OADEV (uV)')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_oadev_all']);
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
            printf('OADEV for whole section %03d-%03d finished.\n', dbg.section(1), dbg.section(2))
        end % if dbg.pjvs_adev_all
end % function
