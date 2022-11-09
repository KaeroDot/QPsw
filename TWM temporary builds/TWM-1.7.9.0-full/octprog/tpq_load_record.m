function [data] = tpq_load_record(header, group_id, repetition_id,data_ofs,data_lim,cfg)
% TracePQM: Loads record(s) from given path to memory.
%
% Usage:
%   data = tpq_load_record(header)
%   data = tpq_load_record(header, group_id)
%   data = tpq_load_record(header, group_id, repetition_id)
%   data = tpq_load_record(header, group_id, repetition_id, data_ofs)
%   data = tpq_load_record(header, group_id, repetition_id, data_ofs, data_lim)
%   data = tpq_load_record(header, group_id, repetition_id, data_ofs, data_lim, cfg)
%
% Inputs:
%   header - absolute path to the measurement header file (info-strings)
%   group_id - id of the measurement group (optional)
%            - each measurement can contain multiple measurement groups with
%              repeated measurements with identical setup. This parameter 
%              selects the group.
%            - note the value -1 means to load last group
%   repetition_id - id of the measurement in the group (optional)
%                 - note this parameter may be zero, then the loader
%                   will load all repetitions in the group and merge them in
%                   the single 2D matrix of channel waveforms
%                 - value -1 means to load last record from group
%   data_ofs - optional, non-zero value means to load sample data from offset
%              'data_ofs' samples. Default is 0 (start from first sample).
%   data_lim - optional, non-zero value to limit maximum loaded samples count
%              to 'data_lim'. Default is 0 (load all).
%   cfg.time_stamp_mode - time-stamp preprocessing:
%                         1  - enabled
%                         0  - disabled (override them to zero)
%                         -1 - override them to relative to first record
%               
% 
% Outputs:
%   data - structure of results containing:
%     groups_count - count of the measurement groups in the header
%     repetitions_count - number of repetitions in the group
%     channels_count - number of digitizer channels
%     is_temperature - measurement has temperature measured
%     sample_count - count of the samples per channel in the record
%     y - 2D matrix of sample data, one column per channel
%       - note if multiple repetition cycles are loaded, they are merged
%         by columns, so the order will be [ch1,ch2,ch1,ch2,ch1,ch2,...]
%     timestamp - relative timestamps in [s], row vector, one per channel
%               - note for multiple repet. they are merged as data.y
%     Ts - sampling period [s]
%     corr - structure of correction data containing:
%       phase_idx - phase ID of each digitizer channel
%                 - used to assign U and I channels to phases
%       tran - cell array of transducers containing struct with:
%         type - string defining transducer type 'shunt', 'divider' 
%         name - string with transducer's name
%         sn - string with transducer's serial
%         nominal - transducer's nominal ratio (Ohms or Vin/Vout)
%         channels - list of digitizer channel indexes associated with this tran.
%                    note: high-side first, low-side second for diff. connect. mode
%         is_diff - non-zero if channel is connected in diff. mode
%         * - correction tables, see transducer loader function
%
%
% This is part of the TWM - TracePQM WattMeter (https://github.com/smaslan/TWM).
% (c) 2017-2020, Stanislav Maslan, smaslan@cmi.cz
% The script is distributed under MIT license, https://opensource.org/licenses/MIT.                
%
    
    if nargin < 6
        % default config:
        cfg.time_stamp_mode = 1;
    end
    
    if nargin < 5
        % default sample data limit: all data:
        data_lim = 0;
    end
    
    if nargin < 4
        % default sample data start at offset 0:
        data_ofs = 0;
    end
    
    if nargin < 3
        % load last average cycle is not defined
        repetition_id = -1;
    end
    
    if nargin < 2
        % load last group if not defined 
        group_id = -1;
    end
    
    % try to load header file 
    inf = infoload(header);
    
    % parse the info file (faster usage): 
    inf = infoparse(inf);
       
    % get total groups count in the header file 
    data.groups_count = infogetnumber(inf,'groups count');
    
    if group_id < 1
        % select last available group if not speficified explicitly
        group_id = data.groups_count;
    end
    if group_id > data.groups_count
        error(sprintf('Measurement group #%d is out of range of available groups in the header!',group_id));
    end
    
    % fetch header section with desired group
    ginf = infogetsection(inf, sprintf('measurement group %d', group_id));
      
    % get available records count in the group
    data.repetitions_count = infogetnumber(ginf, 'repetitions count');
    
    % get sub-records count (averaging within main record)
    try
        data.subrec_count = infogetnumber(ginf, 'sub-records count');
    catch
        data.subrec_count = 1;
    end
        
    if repetition_id < 0
        % select last record in the average group
        repetition_id = data.repetitions_count;
    end
    
    if repetition_id > data.repetitions_count
        error(sprintf('Desired record #%d is out of range of available records in the header!',repetition_id));
    end
    
    
    % get sample data format descriptor
    data_format = infogettext(inf, 'sample data format');
    
    if ~any(strcmpi(data_format,{'mat-v4','tpqa-txt'}))
        error(sprintf('Format \"%s\" not supported!',data_format));
    end
    
    % get the data variable name 
    data_var_name = infogettext(inf, 'sample data variable name');
    
    % get channels count 
    data.channels_count = infogetnumber(inf, 'channels count');
    
    % is temperature available? 
    data.is_temperature = infogetnumber(inf, 'temperature available') > 0;
    
    % get names of the digitizer channels
    data.channel_names = infogettextmatrix(inf, 'channel descriptors');
    
    % was it time-multiplexing?
    try
        % multiplexing is enabled:
        data.is_multiplex = infogetnumber(inf, 'multiplexer enabled');
        % multiplexer sequence cycles count:
        data.multiplex_cycles = infogetnumber(inf, 'multiplexer sequence cycles');        
    catch
        % no multiplex:
        data.is_multiplex = 0;
        % assume one multiplex cycle for nonmultiplex mode:
        data.multiplex_cycles = 1;
    end
    
    
      
    
    % ====== GROUP SECTION ======
    
    % get desired sample counts
    data.sample_count = infogetnumber(ginf, 'samples count');
      
    % get measurement root folder
    data.meas_folder = fileparts(header);
    
    % get record file names
    record_names = infogettextmatrix(ginf, 'record sample data files');
    % convert filepaths for linux or for windows if needed. dos notation ('\') is kept because of
    % labview:
    record_names = path_dos2unix(record_names);
    
    % sample counts for each record in the average group
    sample_counts = infogetmatrix(ginf, 'record samples counts');
    
    % Ts for each record in the average group
    time_incerements = infogetmatrix(ginf, 'record time increments [s]');
    
    % record data gain for each record in the average group
    sample_gains = infogetmatrix(ginf, 'record sample data gains [V]');
    data.sample_gains = sample_gains;
    
    % record data offsets for each record in the average group
    sample_offsets = infogetmatrix(ginf, 'record sample data offsets [V]');
    data.sample_offsets = sample_offsets;
    
    % relative timestamps for each record in the average group
    relative_timestamps = infogetmatrix(ginf, 'record relative timestamps [s]');
    
    % get voltage ranges per channel:
    data.ranges = infogetmatrix(ginf, 'voltage ranges [V]');
    
    % get ADC bit resolution:
    data.bitres = infogetnumber(ginf, 'bit resolution');
    
    
    % preprocess timestamps:
    if isfield(cfg,'time_stamp_mode') && cfg.time_stamp_mode == 0
        relative_timestamps = 0*relative_timestamps;
    elseif isfield(cfg,'time_stamp_mode') && cfg.time_stamp_mode < 0
        relative_timestamps = bsxfun(@minus,relative_timestamps,relative_timestamps(1,:));
    end
         
    
    if data.is_temperature
        % relative timestamps for each record in the average group
        temperatures = infogetmatrix(ginf, 'record channel temperatures [deg C]');
    end
    
    % try to load aperture times:
    try
        apertures = infogetmatrix(ginf, 'aperture [s]');
    catch
        apertures = zeros(data.repetitions_count,1); % defaults    
    end
    
    
    % build list of average cycles to load
    if repetition_id
        ids = repetition_id;
    else
        ids = [1:data.repetitions_count];
    end
    
    % subrecords exist?
    has_subrec = data.is_multiplex || data.subrec_count > 1;
    
    if has_subrec
        % sub-records mode - load segmentation information:              
        
        % get offset of each cycle start in sample data
        %  rows: records, columns: mpx. cycles 
        subrec_offsets = infogetmatrix(ginf, 'sub-record sample offsets');
        
        % get relative time stamp of each cycle start in sample data
        %  rows: records, columns: mpx. cycles 
        subrec_timestamps = infogetmatrix(ginf, 'sub-record relative timestamps [s]');
        
        % multiplexer cycles count
        subrec_cycles = size(subrec_offsets,2);
        
        % check we have enough data for all sequence cycles
        if any((subrec_offsets(ids,end) + data.sample_count) > sample_counts(ids))
            error('TWM data loader: Some of the records is shorter than it should be to contain all multiplexing cycles! Possibly problem of TWM tool when saving data. May be caused by insufficient memory of the digitizer.')
        end       
        
    else
        % NORMAL MODE (no multiplex):
        
        if repetition_id && any(sample_counts(ids) ~= sample_counts(ids(1)))
            error('Sample counts in one of the loaded records does not match!');
        end
    
        % override samples count by actual samples count in the selected record
        data.sample_count = sample_counts(ids(1));
        
        % one fake multiplexing cycle
        subrec_cycles = 1;
        subrec_timestamps = zeros(data.repetitions_count,1);
        
    end
    
    % extract only the relevant timestamps (repetition cycles, channel) 
    relative_timestamps = relative_timestamps(ids,:);
          
    
    
    % limit sample data count by user initial offset:
    if (data.sample_count - data_ofs) < 1
        error(sprintf('User requires to start loading sample data at ''data_ofs = %d'', however there are only %d samples available! Change the ''data_ofs'' parameter value!',data_ofs,data.sample_count));
    end
    data.sample_count = data.sample_count - data_ofs;
    
    % limit sample data count by user limit:
    if data_lim
        data.sample_count = min(data.sample_count,data_lim);
    end
    data_ofs = data_ofs + 1;
    data_end = data_ofs + data.sample_count - 1; 
     
     
     
    % allocate sample data array
    data.y = zeros(data.sample_count, data.channels_count*data.multiplex_cycles, data.subrec_count*numel(ids));

    % ====== FETCH SAMPLE DATA ======

    % --- for each record (repetition):
    dc = 1; 
    for r = 1:numel(ids)
    
        % sample data file path
        sample_data_file = [data.meas_folder filesep() record_names{ids(r)}];
        
        % store record file name
        [fld, data.record_filenames{r}] = fileparts(sample_data_file);
           
        
        if strcmpi(data_format,'mat-v4')      
            % -- standard matlab format:
            
            % load sample binary data
            if isOctave()
              smpl = load('-v4',sample_data_file,data_var_name);
            else
              smpl = load('-mat',sample_data_file,data_var_name);
            end
            
            % --- scale the binary data
            %  y: rows - samples, columns - channels
            % ###note the bsxfun() is needed because Matlab introduced auto broadcasting in 2016b!
            % apply gain
            y = bsxfun(@times,getfield(smpl,data_var_name).',sample_gains(ids(r),:));
            % apply offset
            y = bsxfun(@plus,y,sample_offsets(ids(r),:));
                          
        elseif strcmpi(data_format,'tpqa-txt')
            % -- TPQA tool record format:
            
            % load raw sample data 
            y = tpqa_loader(sample_data_file);
            
            % apply gain and offset (scaling)
            y = bsxfun(@times,y,sample_gains(ids(r),:));
            y = bsxfun(@plus,y,sample_offsets(ids(r),:));
        
        else
            error(sprintf('TWM measurement session loader error: Unknown sample data format ''%s''!',data_format));            
        end
        
        if has_subrec
            % SUB-RECORDS MODE - reshape sample data and extract user segments (sample, channel, record):                         
            
            sr = 1;
            for n = 1:data.subrec_count                
                for m = 1:data.multiplex_cycles                    
                    data.y(:, 1+(m-1)*data.channels_count:m*data.channels_count, dc) = y((data_ofs + subrec_offsets(ids(r),sr)):(data_end + subrec_offsets(ids(r),sr)),:);
                    sr = sr + 1;
                end
                dc = dc + 1;
            end
            
        else
            % NORMAL MODE - just extract user defined segment: 
        
            % store sample data into output array:
            %  note: selecting the samples range as user requested
            data.y(:,:,r) = y(data_ofs:data_end,:);
            
        end
    
    end
    
    % return sampling period
    data.Ts = mean(time_incerements(ids));   
        
    % expand timestamps for the newly created channels for the multiplex mode:
    relative_timestamps = kron(relative_timestamps,ones([data.subrec_count data.multiplex_cycles]));    
    subres_timestamps = reshape(kron(subrec_timestamps(ids,:),ones([1 data.channels_count])).',[data.channels_count*data.multiplex_cycles data.subrec_count*numel(ids)]).';    
    relative_timestamps = bsxfun(@plus, relative_timestamps, subres_timestamps);
            
    % multiply number of channels by multiplexing cycles:        
    data.adc_channels_count = data.channels_count;
    data.channels_count = data.channels_count*data.multiplex_cycles;    
            
    % fix relative timestamps by the first sample offset based on eventual user segmentation:
    data.timestamp = relative_timestamps + (data_ofs - 1)*data.Ts;
        
    % return apertures as 1D matrix (records, 1):
    data.apertures = kron(apertures(ids),ones([data.subrec_count 1]));
    
    % expand ranges by multiplexed channels:
    data.ranges = kron(data.ranges, ones([1 data.multiplex_cycles]));
    
    % replicate source files for each sub-record:
    data.record_filenames = repmat(data.record_filenames,[data.subrec_count 1]);
    data.record_filenames = data.record_filenames(:);
    
      
    
    % ====== CORRECTIONS SECTION ======
    
    % load corrections section from meas. header
    cinf = infogetsection(inf, 'measurement setup configuration');
    
    % get phase index for each channel
    corr.phase_idx = infogetmatrix(cinf, 'channel phase indexes');    
    if isempty(corr.phase_idx)
        % generate default phase order if not available in the header: 
        corr.phase_idx = [1:data.channels_count].';    
    end
     
    
    
    % --- Transducer Corrections ---
    
    %disp('loading transducers')
    
    % get transducer paths
    transducer_paths = infogettextmatrix(cinf, 'transducer paths');
    % convert filepaths for linux or for windows if needed. dos notation ('\') is kept because of
    % labview:
    transducer_paths = path_dos2unix(transducer_paths);
    
    %###note: not needed - we just check later the channel indices are in valid range of available digitizer channels
    %if numel(corr.phase_idx) > data.channels_count || numel(transducer_paths) > data.channels_count
    %    error('TWM measurement loader: Transducers count is higher than digitizer channels count!');
    %end
    has_transducers = ~~numel(transducer_paths);
        
    % load transducer to digitizer mapping matrix:
    tr_map = infogetmatrix(cinf, 'transducer to digitizer channels mapping');      
    
    if numel(transducer_paths) && numel(transducer_paths) ~= size(tr_map,1)
        error('TWM measurement loader: Transducers count does not match number of rows in the ''transducer to digitizer channels mapping'' matrix!');
    end
    if isempty(tr_map)
        tr_map = [1:data.channels_count]';
    end  
    
    % remove unassigned channels from the mapping list:
    tr_map(tr_map == 0) = NaN;    
    
    TC = numel(transducer_paths);
    if ~TC
        
        if size(tr_map,1)
            % transducers count by mapping if available
            TC = size(tr_map,1);
        else
            % if no transducers are defined, generate fake ones, one for each digitizer channel:
            TC = data.channels_count;
        end
    end
    
    % load transducer to multiplexing cycle mapping:
    try
        mpx_map = infogetmatrix(cinf, 'transducer to multiplexing cycle mapping');
        if isempty(mpx_map)
            mpx_map = ones(TC,1);
        end
    catch
        % create default if not available
        mpx_map = ones(TC,1);        
    end
    if size(mpx_map,1) ~= TC
        error('TWM loader: Multiplexer mapping matrix size does not match transducers count!');
    end
    
        
    % load tranducer correction files
    tr_chn_all = [];
    corr.tran = {struct()};
    for t = 1:TC
      
        % build absolute transducer correction path
        if has_transducers
            
            t_file = [data.meas_folder filesep() transducer_paths{t}];
            if ~exist(t_file,'file')
                % possibly absolute path?
                t_file = transducer_paths{t};
            end             
        else
            t_file = '';
        end        
        
        % try to load the correction
        corr.tran{t} = correction_load_transducer(t_file);
        
        % load list of digitzer channels attached to this transducer:
        tr_chn = tr_map(t,:);
        tr_chn = tr_chn(~isnan(tr_chn));
        
        % check valid range of the digitizer channels:
        if any(tr_chn == 0)
            error(sprintf('TWM measurement loader: Some of the assigned digitizer indexes for channel #%d is out of range of available digitizer channels in matrix ''transducer to digitizer channels mapping''!',t));
        end
        
        % select multiplexing cycle:
        %  ###note: combining ADC channels with multiplexer channel to get multiplexed channel id in the record matrix
        tr_chn = tr_chn + (mpx_map(t) - 1)*data.adc_channels_count;
                
        % check valid range of the digitizer channels:
        % XXX commented only for testing!!!: 
        % if any(tr_chn > data.channels_count) || any(tr_chn == 0)
            % error(sprintf('TWM measurement loader: Some of the assigned digitizer indexes for channel #%d is out of range of available digitizer channels in matrix ''transducer to digitizer channels mapping''!',t));
        % end
                
        % store the channel list for this transducer:
        corr.tran{t}.channels = tr_chn;
        
        % is transducer connected differentially?:
        corr.tran{t}.is_diff = numel(tr_chn) > 1;
        
        % collect all used channel indexes:        
        tr_chn_all = [tr_chn_all, tr_chn];
      
    end
    
    % check for duplicate digitizer channels in the mapping: 
    if numel(unique(tr_chn_all)) ~= numel(tr_chn_all)
        % ###note: changed to warning because se we can now use the same ADC channel for multiple phases, e.g. 1 voltage and 2 different current channels making 2 phases 
        disp(sprintf('TWM measurement loader warning: It seems there are duplicate digitizer channel indexes in the matrix ''transducer to digitizer channels mapping''.'));    
    end
    
  
    % --- Digitizer Corrections ---
        
    %disp('loading digitizer')
    
    % get digitizer corrections path:
    digitizer_path = infogettext(cinf, 'digitizer corrections path');
    % convert filepaths for linux or for windows if needed. dos notation ('\') is kept because of
    % labview:
    digitizer_path = path_dos2unix(digitizer_path);
        
    % load digitizer corrections:
    corr.dig = correction_load_digitizer(digitizer_path, inf, data, 1, group_id);
    
    % return corrections
    data.corr = corr;

end
