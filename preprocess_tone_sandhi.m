% preprocessing tone 3 sandhi datasets
% Lisa Chang 2021.10.26

% start EEGLAB
clear;
cd /home/x0123963/MATLAB/eeglab2021.1
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;

% import BIDS
filepath        = '/home/x0123963/toneSandhi/bids_try';
[STUDY, ALLEEG] = pop_importbids(filepath, 'bidsevent','on','bidschanloc','on', ...
    'studyName','toneSandhi');
ALLEEG = pop_select( ALLEEG, 'nochannel',{'TRIGGER'});
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];

% high-pass filter
EEG = pop_eegfiltnew(EEG,0.1,[]);

% re-reference to average
EEG = pop_reref( EEG,[],'interpchan',[]);

% Run ICA and flag artifactual components using IClabel
% criteria: above 85% muscle, eye, line noise, channel noise
for s=1:size(EEG,2)
    EEG(s) = pop_runica(EEG(s), 'icatype','runica','concatcond','on',...
                                'options',{'pca',-1});
    EEG(s) = pop_iclabel(EEG(s),'default');
    EEG(s) = pop_icflag(EEG(s),[NaN NaN;0.85 1;0.85 1;NaN NaN;0.85 1;0.85 1;NaN NaN]);
    EEG(s) = pop_subcomp(EEG(s), find(EEG(s).reject.gcompreject), 0);
end
EEG    = pop_saveset(EEG, 'savemode', 'resave');
disp('!!!!!!!!!!!!!!!!!!ICA correction end!!!!!!!!!!!!!!Saved after ICA');

% Extract data epochs (no baseline removed)
EEG    = pop_epoch(EEG,{1,2,3,4,5},[-0.2 0.8] ,'epochinfo','yes');
EEG    = pop_saveset(EEG, 'savemode', 'resave');
disp('data epoch!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');