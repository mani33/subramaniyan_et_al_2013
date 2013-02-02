function [data, col_names] = get_lag_slope_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_by_testing_day)
% function [data, col_names] = get_lag_slope_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_testing_day)
%-----------------------------------------------------------------------------------------
% get_lag_slope_testing_day_mon_hum - Get perceived lag and slope of psychometric
% functions over time for monkeys and humans for statistical analysis using PASW 18.
% For a given speed, all sessions within a day were pooled. The monkeys always had a
% single session in a day whereas many humans had more than one session per day.
% Note that for monkey H, some times more than one session contributed to each
% 'testing_day'; this was done to get enough trials for each subthreshold stimulus
% condition.
%
% example: [data, col_names] = get_lag_slope_testing_day_mon_hum(data_monkeys_by_testing_day,data_humans_testing_day)
%
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2012-10-10
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
for iSub = 1:nMon
    subject = dMon(iSub).subject;
    for iSpeed = 1:nSpeed
        speed = dMon(iSub).speed(iSpeed).speed_deg_per_sec;
        d = dMon(iSub).speed(iSpeed).grouped_sess_fit_data;
        nGrp = length(d);
        for iGrp = 1:nGrp
            c = c+1;
            r = {species_ind iSub speed d(iGrp).relative_testing_day d(iGrp).spatial_lag d(iGrp).slope subject};
            data(c,:) = r;
        end
    end
end


% Human
dHum = data_humans_by_testing_day;
speciesInd = 2;
% Subjects AT and JP did all sessions on a single day. So we exclude them from the data
% for lag change over days.
exclude_subj = {'AT','JP'};
all_subj = {dHum.subject};
dHum = dHum(~ismember(all_subj,exclude_subj));
nSub = length(dHum);

for iSub = 1:nSub
    subject = dHum(iSub).subject;
    for iSpeed = 1:nSpeed
        speed = dHum(iSub).speed(iSpeed).speed_deg_per_sec;
        d = dHum(iSub).speed(iSpeed).grouped_sess_fit_data;
        nGrp = length(d);
        for iGrp = 1:nGrp
            cs = d(iGrp);
            c = c+1;
            r = {speciesInd iSub+nMon speed cs.relative_testing_day cs.spatial_lag cs.slope subject};
            data(c,:) = r;
        end
    end
end
