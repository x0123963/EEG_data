% call_eeglab_run_ica
% Lisa Chang 2021.9.5
% adapted from EEGLAB history

% run the script in the background by entering:
% nohup matlab -nodisplay -nosplash < call_eeglab_run_ica.m 1>running.log 2>running.err &

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs:
fname = '10-1_ref_shift.set';
fdir = '/home/x0123963/Data/';
eeglab_dir = '/home/x0123963/MATLAB/eeglab2021.1/';

cd(eeglab_dir);
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',fname,'filepath',fdir);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'chanind', [1:22 24:33]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = pop_saveset( EEG, 'savemode','resave');