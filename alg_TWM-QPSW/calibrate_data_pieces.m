% Determines digitizer calibration for data pieces
% Developed in the scope of the EMPIR QPower.
% MIT license
%
% Inputs:
% yc - data pieces in cell
% M - multiplexer matrix
% S - indexes of samples of new data piece start
% Rs - how many samples will be removed at start of segment (samples)
% Re - how many samples will be removed at end of segment (samples)
% Outputs:
% cal - calibration output XXX

function ycal = calibrate_data_pieces(yc, M, S, Uref, Spjvs, Rs, Re)
    % calibration curves for whole sampled data %<<<2
    % get calibration data for every quantum data piece %<<<2
    empty_ycal.coefs = [];
    empty_ycal.exponents = [];
    empty_ycal.func = [];
    empty_ycal.model = [];
    empty_ycal.yhat = [];
    for i = 1:rows(yc)
            for j = 1:columns(yc)
                    % check if quantum measurement:
                    if M(i, j) < 0
                            % do calibration
                            % cut Spjvs and subtract to get indexes of the
                            % cutted yc{i,j}
                            idx = find(Spjvs >= S(j) & Spjvs < S(j+1));
                            tmpSpjvs = Spjvs(idx) - S(j) + 1;
                            tmpUref = Uref(idx);
                            if tmpSpjvs(1) ~= 1
                                tmpSpjvs = [1 tmpSpjvs];
                                % add one Uref before, because first switch was
                                % not at position 1
                                tmpUref = [Uref(idx(1)-1) tmpUref];
                            end
                            if tmpSpjvs(end) ~= size(yc{i,j},2) + 1
                                tmpSpjvs = [tmpSpjvs size(yc{i,j},2) + 1];
                                % no need to add Uref, it is already there
                            end
                            ycal(i,j) = adc_pjvs_calibration(yc{i,j}, tmpSpjvs, tmpUref, Rs, Re);
                    else
                            ycal(i,j) = empty_ycal;
                    end % if M(i, j) < 0
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)

    % set calibration values for all sampled data %<<<1
    for i = 1:rows(ycal)
            lastcal = empty_ycal;
            firstcalfound = 0;
            for j = 1:columns(ycal)
                    if isempty(ycal(i, j).coefs)
                            ycal(i, j) = lastcal;
                    else
                            lastcal = ycal(i, j);
                            if firstcalfound == 0
                                    % copy calibrations to previous elements:
                                    for k = 1:j-1
                                            ycal(i, k) = ycal(i,j);
                                    end % for k
                                    firstcalfound = 1;
                            end % firstcalfound = 0
                    end % isempty(ycal(i,j))
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)
end

% missing tests... XXX
