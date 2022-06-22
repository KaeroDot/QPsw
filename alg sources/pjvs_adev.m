% calculate adev for all segments in actual section
function pjvs_adev(s_y, Uref, Uref1period, dbg);
    if dbg.v 
        if dbg.pjvs_adev
            % calculate ADEVs for a single PJVS period:
            for j = 1:numel(Uref1period)
                DI.y.v = s_y(:, j);
                DI.y.v(isnan(DI.y.v)) = [];
                DI.y.v = DI.y.v(:)';
                DI.fs.v = 1;
                DO{j} = qwtb('OADEV',DI);
            end % for j

            % plot results
            ssec = sprintf('00%d-00%d_', dbg.section(1), dbg.section(2));
            if dbg.pjvs_adev
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
                title(sprintf('OADEV of segments in first pjvs period'))
                xlabel('samples')
                ylabel('OADEV (uV)')
                hold off
                fn = fullfile(dbg.plotpath, [ssec 'pjvs_oadev']);
                if dbg.saveplotsplt printplt(fn) end
                if dbg.saveplotspng print([fn '.png'], '-dpng') end
                close
            end % if dbg.pjvs_adev
        end % if dbg.pjvs_adev

        if dbg.pjvs_adev_all
            % calculate ADEVs for a all segments in whole section:
            disp('Calculating OADEV from whole section, this can take time...')
            for j = 1:numel(Uref1period)
                idx = find(Uref == Uref1period(j));
                DI.y.v = s_y(:, idx);
                DI.y.v(isnan(DI.y.v)) = [];
                DI.y.v = DI.y.v(:)';
                DI.fs.v = 1;
                DOall{j} = qwtb('OADEV',DI);
            end % for j

            % plot results
            ssec = sprintf('00%d-00%d_', dbg.section(1), dbg.section(2));
            % plot adevs
            figure('visible',dbg.showplots)
            hold on
            legc = {};
            for j = 1:numel(Uref1period)
                loglog(DOall{j}.tau.v, DOall{j}.oadev.v.*1e6, '-')
                legc{end+1} = sprintf('U_{ref}=%.9f', Uref1period(j));
            end
            legend(legc, 'location', 'eastoutside')
            title(sprintf('OADEV of all segments in whole section'))
            xlabel('samples')
            ylabel('OADEV (uV)')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'pjvs_oadev_all']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
            disp('OADEV from whole section finished.')
        end % if dbg.pjvs_adev_all
end % function
