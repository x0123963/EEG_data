% Combined PhonoVioLIPSBrainVision_27April2022.m and PV_Analysis_Script.m
% Lisa Chang October 17, 2022

% EEGLAB ver 2022.1 (with bva-io v1.71 to read Brain Vision data)
% ERPLAB ver 9.00

% Start eeglab
cd C:\Users\USER\OneDrive\文件\MATLAB\eeglab2022.1
[ALLEEG, EEG CURRENTSET ALLCOM] = eeglab;

%% Import data
subj = 'S061';
fname = ['PhonoVioLIPS_' subj '.vhdr'];
fpath = 'F:\PhonoVio_JesseLab';
EEG = pop_loadbv(fpath, fname);

EEG.setname = [subj '_raw'];
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
% channel info is also attached

% create subject-level folder
subj_folder = [fpath '\' subj];
status = mkdir(subj_folder);

%% eventlist and binlister
EEG = pop_creabasiceventlist(EEG, 'AlphanumericCleaning', 'on', ...
     'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' });
EEG = pop_binlister(EEG, 'BDF', ['C:\Users\USER\OneDrive\文件\UMass\PhonoVio\' 'PhonoVio_suffix_bdf.txt']);

EEG.setname = [subj '_elist'];
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset(EEG);

%% Re-referencing (from TP9 to linked mastoids)
linked_mastref = 0.5*EEG.data(20,:);
EEG.data=bsxfun(@minus,EEG.data,linked_mastref(:)');
EEG = pop_select(EEG,'nochannel',20);

EEG.setname = [subj '_elist_ref'];
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset(EEG);

%% filters
pop_spectopo(EEG,1); %before filtering

EEG = pop_basicfilter(EEG,  1:64 , 'Cutoff',  [0.1 100], 'Design', 'butter', ...
    'Filter', 'bandpass', 'Order',  2 );
EEG = pop_basicfilter(EEG,  1:64 , 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180);
pop_spectopo(EEG,1);

EEG.setname = [subj '_elist_ref_filt'];
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset(EEG);
EEG = pop_saveset(EEG, 'filename', [subj '_elist_ref_filt'], 'filepath', subj_folder);

%% Epochs w/ baseline correction
EEG = pop_epochbin(EEG, [-100.0  500.0],  'pre');
EEG.setname = [subj, '_elist_ref_filt_epoch_bl'];
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset(EEG);
EEG = pop_saveset(EEG, 'filename', [subj '_elist_ref_filt_epoch_bl'], 'filepath', subj_folder);

%% Artifact rejection
EEG = pop_artmwppth(EEG, 'Channel',  63, 'Flag', [1 2], 'Threshold', 100, 'Twindow', [ -99.6 498], 'Windowsize',  200, 'Windowstep', 100 );
EEG = pop_artstep(EEG, 'Channel', 64, 'Flag', [1 3], 'Threshold',  150, 'Twindow', [ -99.6 498], 'Windowsize',  200, 'Windowstep', 50 );
EEG = pop_artmwppth(EEG, 'Channel',  [1:62], 'Flag', [1 4], 'Threshold',  200, 'Twindow', [ -99.6 498], 'Windowsize',  200, 'Windowstep',  100 );

EEG.setname = [subj, '_elist_ref_filt_epoch_bl_ar'];
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
EEG = eeg_checkset(EEG);
EEG = pop_saveset(EEG, 'filename', [subj '_elist_ref_filt_epoch_bl_ar'], 'filepath', subj_folder);
[EEG, tprej, acce, rej, histoflags ] = pop_summary_AR_eeg_detection(EEG, [subj_folder '\' subj '_ar_summary.txt']);

%% Average
ERP = pop_averager( EEG , 'Criterion', 'good', 'SEM', 'on');
ERP.erpname = [subj '_clean']; 
ERP = pop_ploterps( ERP,  4:6,  1:62 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 8 8], 'ChLabel', 'on',...
 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 23.8 5.53846 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -100.0 498.0   -100:100:400 ], 'YDir', 'normal' );

ALLERP = ERP;
erplab redraw;

ERP = pop_averager(EEG , 'Criterion', 'all', 'SEM', 'on');
ERP.erpname = [subj '_all_trials']; 
ERP = pop_ploterps( ERP,  4:6,  1:62 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 8 8], 'ChLabel', 'on',...
 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 23.8 5.53846 106.9 31.9231], 'Style', 'Topo', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -100.0 498.0   -100:100:400 ], 'YDir', 'normal' );

ALLERP(2) = ERP;
erplab redraw;

% Save ERP to disk
ERP = pop_savemyerp(ERP, 'erpname', [subj '_ERP'], 'filename', [subj '_ERP.erp'], 'filepath', subj_folder);  