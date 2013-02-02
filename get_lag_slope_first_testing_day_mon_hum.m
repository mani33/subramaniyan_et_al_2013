function [data, col_names] = get_lag_slope_first_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_by_testing_day)
% [data, col_names] = get_lag_slope_first_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_by_testing_day)
%-----------------------------------------------------------------------------------------
% Here we pick the perceived lag and slope from the first testing day from monkeys and
% humans.
%
% example: [data, col_names] = get_lag_slope_first_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_by_testing_day)
%
%
% Author: Mani Subramaniyan
% Date created: 2013-01-17
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

col_names = {'species','subject_id','speed','testing_day','spatial_lag','slope','subject'};

dMon = data_monkeys_by_testing_day;
nMon = length(dMon);
c = 0;
species_ind = 1; % monkey = 1; human = 2;
nSpeed = 3;

data = cell(1,7);
iGrp = 1;
for iSub = 1:nMon
    subject = dMon(iSub).subject;
    for iSpeed = 1:nSpeed
        speed = dMon(iSub).speed(iSpeed).speed_deg_per_sec;
        d = dMon(iSub).speed(iSpeed).grouped_sess_fit_data;
        c = c+1;
        r = {species_ind iSub speed d(iGrp).relative_testing_day d(iGrp).spatial_lag d(iGrp).slope subject};
        data(c,:) = r;
    end
end


% Human
dHum = data_humans_by_testing_day;
speciesInd = 2;
nSub = length(dHum);
iGrp = 1;
for iSub = 1:nSub
    subject = dHum(iSub).subject;
    for iSpeed = 1:nSpeed
        speed = dHum(iSub).speed(iSpeed).speed_deg_per_sec;
        d = dHum(iSub).speed(iSpeed).grouped_sess_fit_data;
        cs = d(iGrp);
        c = c+1;
        r = {speciesInd iSub+nMon speed cs.relative_testing_day cs.spatial_lag cs.slope subject};
        data(c,:) = r;
    end
end












