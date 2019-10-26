%2019.10.24
%Lisa Chang
%cut.m: cutting the time points of the longer ERP waveforms to match the 2
%ERP waveforms
ERP_new = ERP2;
ERP_new.pnts = ERP.pnts;
ERP_new.xmin = ERP.xmin;
ERP_new.xmax = ERP.xmax;
ERP_new.times = ERP.times(51:950);
ERP_new.bindata = ERP.bindata(:,51:950,:);
ERP_new.binerror = ERP.binerror(:,51:950,:);


