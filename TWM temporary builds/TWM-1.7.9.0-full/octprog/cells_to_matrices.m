function [din] = cells_to_matrices(diC, alginfo)
% Reorder data from the Cell diC of size N with structures with matrices to a
% Strucure with matrices of one dimension more. The added dimension will have
% size N.
% This is done with respect to the qwtb and TWM quantities, so parameter
% dimensions are not increased.
% If matrices diC{i}.Q.F and diC{j}.Q.F are not of same dimensions, they are
% padded by NaNs to the size of larger one.
% Structures in cells must have the same fields to whole depth.

% List of possible quantity fields in QWTB:
QWTBf = {'v', 'u', 'd', 'c', 'r'};

% list of quantities of the algorithm:
Qs = fieldnames(diC{1});

if isempty(alginfo)
    Qparams = {};
else
    % list of quantities that are parameters:
    ids = logical([[alginfo.inputs].parameter]);
    Qparams = {[alginfo.inputs].name}(ids);
end

% Go one quantity Q after another and concatenate quantity matrices from cells
% to one matrix with dimension increased by 1:
for q = 1:numel(Qs)
    Q = Qs{q};
    if any(strcmp(Q, Qparams))
        % If Q is parameter type, concatenate all values into a cells, because
        % parameter can take any values inside.
        for c = 1:numel(diC)
            din.(Q).v{c} = diC{c}.(Q).v;
        end
    else
        % Q is not of parameter type, concatenate values together.
        % For every field of quantity Q:
        for f = 1:numel(QWTBf)
            F = QWTBf{f};
            Fc = {};
            % Sizes of matrices in Q.F for every cell:
            Fsizes = {};
            % Dimensions of matrices in Q.F for every cell:
            Fdims = [];
            % Get sizes and dimensions of matrices in Q.F before concatenating
            % so we will know how to padd it if needed:
            for c = 1:numel(diC)
                if isfield(diC{c}.(Q), F);
                    Fc{end+1} = diC{c}.(Q).(F);
                else
                    Fc{end+1} = [];
                end % isfield F
                Fsizes{end+1} = size(Fc{end});
                Fdims(end+1) = ndims(Fc{end});
            end
            % The maximal dimension is:
            max_dim = max(Fdims);
            % Check if all matrices got the same number of dimensions:
            if all(Fdims == Fdims(1))
                % Number of dimensions are same for all matrices in all cells
                % for actual Q.F.
                Fsizesmat = cat(1, Fsizes{:});
                % Now check if all matrices are of same sizes:
                if all(Fsizesmat(1, :) == Fsizesmat(:, :), 1)
                    % Concatenate matrices into matrix of N+1 dimension
                    % directly, because all matrices got same sizes. No padding
                    % is needed:
                    din.(Q).(F) = cat(max_dim + 1, Fc{:});
                else
                    % Matrices are not of the same size and must be paded by
                    % NaN to concatenate.
                    % Create matrix of NaNs of dimensions equal to maximal
                    % dimensions:
                    Fsizesmatmax = max(Fsizesmat, [], 1);
                    Osizes = [max(Fsizesmat, [], 1) numel(diC)];
                    O = NaN + zeros(Osizes);
                    % Make a structure for subscript assignement:
                    S.subs = cell(numel(Fsizesmatmax) + 1, 1);
                    S.type = '()';
                    % Through all cells assign matrices to O:
                    for c = 1:numel(Fc)
                        for d = 1:numel(Fsizes{c})
                            S.subs{d} = 1:Fsizes{c}(d);
                        end
                        S.subs{end} = c;
                        O = subsasgn(O, S, Fc{c});
                    end
                    din.(Q).(F) = O;
                end % if all(Fsizesmat(1, :) == Fsizesmat(:, :), 1)
            else
                % Number of dimensions is different for matrices in cells for
                % actual Q.F.
                error('Concatenating matrices with different number of dimensions. This should not happen. Internal error.')
            end % if all(Fdims == Fdims(1))
        end % for f = 1:numel(QWTBf)
    end % if any(strcmp(Q, Qparams))
end % for q = 1:numel(Qs)

din.cells_to_matrices.v = numel(diC);
din.cells_to_matrices.par = 1;

end % function [din] = cells_to_matrices(diC, alginfo)

