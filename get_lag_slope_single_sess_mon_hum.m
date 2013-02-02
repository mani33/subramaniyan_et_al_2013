function [data, col_names] = get_lag_slope_single_sess_mon_hum(data_monkeys_by_testing_day,data_humans_single_sess)
% function [data, col_names] = get_lag_slope_single_sess_mon_hum(data_monkeys_by_testing_day,data_humans_single_sess)
%-----------------------------------------------------------------------------------------
% get_lag_slope_single_sess_mon_hum - Get perceived lag and slope of psychometric
% functions over time for monkeys and humans for statistical analysis using PASW 18.
% Each sitting has a data point in the case of humans. For monkey H, some times two or 
% more sessions had to be pooled to fit the psychometric functions.
%
% example: [data, col_names] = get_lag_slope_single_sess_mon_hum(data_monkeys_by_testing_day,data_humans_single_sess)
%
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2012-10-10
% Last revision: 2013-02-02
% Created in Matlab version: 7.14.0.739 (R2012a)
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
dHum = data_humans_single_sess;
speciesInd = 2;
nSub = length(dHum);

for iSub = 1:nSub
    subject = dHum(iSub).subject;
    for iSpeed = 1:nSpeed
        speed = dHum(iSub).speed(iSpeed).speed_deg_per_sec;
        d = dHum(iSub).speed(iSpeed).sess;
        nSess = length(d);
        for iSess = 1:nSess
            cs = d(iSess);
            c = c+1;
            r = {speciesInd iSub+nMon speed cs.relative_testing_day cs.spatial_lag cs.slope subject};
            data(c,:) = r;
        end
    end
end
