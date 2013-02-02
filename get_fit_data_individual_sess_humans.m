function data = get_fit_data_individual_sess_humans(raw_data_human)
% data = get_fit_data_individual_sess_humans(raw_data_human)
%-----------------------------------------------------------------------------------------
% get_fit_data_individual_sess_humans - Compute perceived lag and slope for each
% sitting/session separately. Here we do not combine sessions/sittings. These data will be
% used for performing statistical tests.
%
% example: data = get_fit_data_individual_sess_humans(raw_data_human)
%
% This function is called by: stat_analysis
% This function calls:
% MAT-files required:
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2012-07-28
% Last revision: 2012-09-11
% Created in Matlab version: 7.14.0.739 (R2012a)
%-----------------------------------------------------------------------------------------

rdata = raw_data_human;
nSub = length(rdata);

data = struct;
cfToDay = 1/(1000*60*60*24);
nSpeed = 3;

for iSub = 1:nSub
    fprintf('iSubject: %u\n',iSub)
    data(iSub).subject = rdata(iSub).subject;
    t0 = min([rdata(iSub).speed(1).session.session_start_time_ms rdata(iSub).speed(2).session.session_start_time_ms ...
        rdata(iSub).speed(3).session.session_start_time_ms]);
    for iSpeed = 1:nSpeed
        fprintf(' iSpeed: %u\n',iSpeed)
        data(iSub).speed(iSpeed).speed_deg_per_sec = rdata(iSub).speed(iSpeed).speed_deg_per_sec;
        sdata = rdata(iSub).speed(iSpeed).session;
        sess_start = [sdata.session_start_time_ms];
        [foo, ind] = sort(sess_start);%#ok
        sdata = sdata(ind);
        nSess = length(sdata);
        for iSess = 1:nSess
            trial_data = sdata(iSess).trial_data;
            % Exclude invalid trials
            trial_data = trial_data([trial_data.valid_trial]);
            offsets = unique([trial_data.spatial_offset_deg]);
            nOffsets = length(offsets);
            
            % Get relative session time in days
            relative_sess_time_day = (sdata(iSess).session_start_time_ms - t0)*cfToDay;
            ttt = struct;
            for iOff = 1:nOffsets
                offset = offsets(iOff);
                sel_trials = [trial_data.spatial_offset_deg]==offset;
                resp = [trial_data(sel_trials).correct_response];
                nTrials = length(resp);
                nFlashLeadReports = sum(~resp)*double(offset<0) + sum(resp)*double(offset>=0);
                % Save nCorrect trials as flash lag reports instead of flash lead reports
                ttt.nCorrect(iOff,1) = nTrials - nFlashLeadReports;
                ttt.nTrials(iOff,1) = nTrials;
            end
            % Flip sign of offsets so that when we plot the psychometric function, we
            % will have the function that is shaped as 'S'.
            offsets = -offsets(:);
            xyn = [offsets ttt.nCorrect ttt.nTrials];
            
            % Fit psychometric function
            fit_data = get_psych_fcn_fit_data(xyn);
            temp = fit_data;
            temp.relative_sess_time_day = relative_sess_time_day;
            
            % Calculate errorbar upper and lower bounds from the confidence intervals
            % Spatial lags
            ci = fit_data.conf_int_spatial_lag;
            lag = fit_data.spatial_lag;
            
            temp.lag_errorbar_lb = lag - ci(1);
            temp.lag_errorbar_ub = ci(2) - lag;
            
            % slopes
            sl = fit_data.slope;
            ci = fit_data.conf_int_slope;
            
            temp.slope_errorbar_lb = sl - ci(1);
            temp.slope_errorbar_ub = ci(2) - sl;
            
            data(iSub).speed(iSpeed).sess(iSess) = temp;
        end
    end
    % Get relative testing day for each speed
    allRelTime = cell(1,nSpeed);
    for iSpeed = 1:nSpeed
        allRelTime{iSpeed} = [data(iSub).speed(iSpeed).sess.relative_sess_time_day];
    end
    allRelTime = [allRelTime{:}];
    sortedTimes = sort(allRelTime);
    [~,~, c] = unique(floor(sortedTimes));
    testDays = c + (sortedTimes-floor(sortedTimes))-1;
    
    for iSpeed = 1:nSpeed
        rd = [data(iSub).speed(iSpeed).sess.relative_sess_time_day];
        rd_ind = find(ismember(sortedTimes,rd));
        nSess = length(data(iSub).speed(iSpeed).sess);
        for iSess = 1:nSess
            data(iSub).speed(iSpeed).sess(iSess).relative_testing_day = testDays(rd_ind(iSess));
        end
    end
end