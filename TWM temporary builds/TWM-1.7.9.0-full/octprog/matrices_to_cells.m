function [diC] = matrices_to_cells(din) %<<<1
% Reorder data from the Cell diC of size N with structures with matrices to a
% Strucure with matrices of one dimension more. The added dimension will have
% size N.
% This is done with respect to the qwtb and TWM quantities, so parameter
% dimensions are not increased.
% If matrices diC{i}.Q.F and diC{j}.Q.F are not of same dimensions, they are
% padded by NaNs to the size of larger one.
% Structures in cells must have the same fields to whole depth.

% Reorder data from a structure with matrices of dimension N+1 into cells of structures
% with matrices of dimension N. The last dimension was used for different phases of the sampled system.
% This is done with respect to the qwtb and TWM quantities, so parameter
% dimensions are not increased.
% Script qwtb_exec_algorithm.m did the conversion from cell of structs to
% struct of N+1 matrices. If matrices were of incompatible sizes, padding by
% NaNs occured.
% This function removes the padding back.

% MUST recognize:
%   multiple quantities, all last dimensions N (count of to be cells) - OK to find automatically
%   multiple quantities, last dimensions various, because of target only single cell - OK to find automatically
%   multiple quantities, last dimensions the same by coincidence, but target only single cell - Impossible to autofind
%   single quantitiy, last dimensions N (count of to be cells) - found sort of automatically
%   single quantities, last dimensions any, target only single cell - impossible to autofind

% Parameter cells_to_matrices is required, because analysis of possible cases
% shows out that any automatic method will fail on some cases.
% (Qs: number of quantities in din )
% (last dims: size of last dimension of quantities, aka size(Q.v)(end) )
% (Target: the expected count of diC )
% ---|----------|-------|-----------------|-----------------------------------
% Qs |Last dims |Target |Automatic method | Target known from parameter cells_to_matrices.v
% ---|----------|-------|-----------------|-----------------------------------
% 1  | N        | 1     |unknown          |X just take it as output
%    |          | N     |unknown          |split
%    | != N     | 1     |unknown          |X just take it as output
%    |          | N     |    unknown ERR  |X   clear ERROR
% >1 | N all Q  | 1     |unknown          |X just take it as output
%    |          | N     |split            |split
%    | N some Q | 1     |unknown          |X just take it as output
%    |          | N     |    clear ERROR  |X   clear ERROR
%    | != N     | 1     |unknown          |X just take it as output
%    |          | N     |    clear ERROR  |X   clear ERROR


% The issue is if function cells_to_matrices got only one cell to convert into
% n-dimensional matrices, it created singleton last dimension for all
% quantities, however singleton dimensions are ommited by Octave/Matlab.
% Therefore the proper last dimension dissapear and this function
% matrices_to_cells has no idea what is proper target.

    if isfield(din, 'cells_to_matrices')
        target = din.cells_to_matrices.v;
        din = rmfield(din, 'cells_to_matrices');
    else
        target = -1;
    end

    % list of quantities of the algorithm:
    Qs = fieldnames(din);

    % Go through fields 'v' of all quantities and find size of the latest
    % dimension:
    max_dim = [];
    for q = 1:numel(Qs)
        Q = Qs{q};
        % Every quantity should get field 'par', that is added by QWTB. if not
        % so, assume it is not a parameter:
        if ~isfield(din.(Q), 'par')
            din.(Q).par = 0;
        end
        % only if not parameter:
        if not(din.(Q).par)
            % take size of last dimension:
            max_dim(end+1) = size(din.(Q).v)(end);
        end % if not(Q.par)
    end

    % solve case if target is known from parameter cells_to_matrices
    if target >= 0
        % Solve simple cases:
        if target == 1
            % target is 1 so easy case:
            diC = decell(din, Qs);
        else
            % Check obvious errrorneous cases:
            if not(all(max_dim == target))
                error('matrices_to_cells: The value of parameter "cells_to_matrices" is not the same as values of last dimensions of quantities. Either the parameter is leftover, or the matrices were not built up correctly.')
            end
            % make split
            diC = make_split(din, max_dim, Qs);
        end
    else % unknown target (missing parameter cells_to_matrices)
        if numel(Qs) == 1
            % Either target is 1 or last_dim or the matrices were built up
            % incorrectly, but there is no way how to find out. Unknown what to
            % do. Make warning and suppose target is 1:
            diC = decell(din, Qs);
        else
            if all(max_dim == max_dim(1))
                % Target is probably max_dim. The other possibility is the
                % target is 1 or the matrices were built up incorrectly, but
                % there is no way how to find out.
                % make split
                diC = make_split(din, max_dim, Qs);
            else
                % different max_dim in quantities, suppose the target is 1:
                diC = decell(din, Qs);
            end
        end % if numel(Qs)
    end % if isfield(din, 'cells_to_matrices')
end % function [diC] = matrices_to_cells(din)

function diC = make_split(din, max_dim, Qs)
% last dimensions of all quantities must be equal to max_dim, check it before this subfunction!
% din - datain
% max_dim - value of last dimension of all quantities
% Qs - fieldnames of quantities

    % List of possible quantity fields in QWTB:
    QWTBf = {'v', 'u', 'd', 'c', 'r'};

    % XXX DELETE
    % not(all(max_dim(1) == max_dim))
    % keyboard
    % if not(all(max_dim(1) == max_dim))
    %     max_dim = 1
    %     keyboard
    %     diC{1} = din;
    % else
    %     max_dim = max_dim(1);


    % Prepare output cells:
    diC = cell(max_dim, 1);

    % For all quantities in the structure, for all fields, split matrices by last
    % dimension and put them into cells of structures.
    % From din.Q_j.F_k of size (m x n x i) -> diC{i}.Q_j.F_k of sizes (m x n)
    for q = 1:numel(Qs)
        Q = Qs{q};
        if isfield(din.(Q), 'par') && din.(Q).par
        % If quantity is parameter type, values are stored in cells.
            for f = 1:numel(QWTBf)
                F = QWTBf{f};
                if isfield(din.(Q), F);
                    for c = 1:max_dim
                        diC{c}.(Q).(F) = din.(Q).(F){c};
                    end
                end % if isfield(din.(Q), F);
            end
        else
            % Q is not of parameter type, split matrix into cells:
            for f = 1:numel(QWTBf)
                F = QWTBf{f};
                % check existence of field! XXX
                if isempty(din.(Q).(F))
                    for c = 1:max_dim
                        diC{c}.(Q).(F) = [];
                    end
                else
                    % use subscript reference assignement because number of
                    % dimensions of the matrices is not known:
                    mat = din.(Q).(F);
                    S.subs = repmat({':'}, 1, ndims(mat));
                    S.type = '()';
                    for c = 1:max_dim
                        S.subs{end} = c;
                        diC{c}.(Q).(F) = subsref(mat, S);
                    end
                end % if isempty
            end % for f
        end % if din.(Q).par
    end % for q
end % function diC = make_split(din, max_dim, Qs)

function diC = decell(din, Qs)

    % List of possible quantity fields in QWTB:
    QWTBf = {'v', 'u', 'd', 'c', 'r'};

    % Prepare output cells:
    diC = cell(1, 1);

    % For all quantities in the structure, for all fields, split matrices by last
    % dimension and put them into cells of structures.
    % From din.Q_j.F_k of size (m x n x i) -> diC{i}.Q_j.F_k of sizes (m x n)
    for q = 1:numel(Qs)
        Q = Qs{q};
        for f = 1:numel(QWTBf)
            F = QWTBf{f};
            if isfield(din.(Q), F);
                if iscell(din.(Q).(F))
                    diC{1}.(Q).(F) = din.(Q).(F){1};
                else
                    diC{1}.(Q).(F) = din.(Q).(F);
                end
            end
        end
    end % for q
end % function

%!test
%!shared D, correct_output, diC
%! % ----- Test single quantity input:
%! D.a.v = 1:5;
%! D.a.u = D.a.v;
%! D.a.r = D.a.v;
%! D.a.c = D.a.v;
%! D.a.d = D.a.v;
%! correct_output{1} = D;
%! correct_output{1}.a.par = 0;
%! diC = matrices_to_cells(D);
%!assert(isequal(diC, correct_output))
%! D.cells_to_matrices.v = 1;
%! diC = matrices_to_cells(D);
%!assert(isequal(diC, correct_output))
%! % ----- Test multiple quantity input, different dimensions:
%! D.b.v = 1:3;
%! D.b.u = D.b.v;
%! D.b.r = D.b.v;
%! D.b.c = D.b.v;
%! D.b.d = D.b.v;
%! correct_output{1}.b = D.b;
%! correct_output{1}.b.par = 0;
%! D = rmfield(D, 'cells_to_matrices');
%! diC = matrices_to_cells(D);
%!assert(isequal(diC, correct_output))
%! D.cells_to_matrices.v = 1;
%! diC = matrices_to_cells(D);
%!assert(isequal(diC, correct_output))
%FIXME XXX add cases with bad inputs
