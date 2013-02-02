function data = get_fit_data_testing_day_humans(raw_data_human)
% data = get_fit_data_testing_day_humans(raw_data_human)
%-----------------------------------------------------------------------------------------
% GET_FIT_DATA_TRAINING_DAY_HUMANS - Combine sessions within the same day and compute
% spatial lag and slope.
%
% example: data = get_fit_data_testing_day_humans(raw_data_human)
%
% Author: Mani Subramaniyan
% Date created: 2013-01-16
% Last revision: 2013-01-16
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

rdata = raw_data_human;
clear raw_data_human


nSub = length(rdata);

cfToDay = 1/(1000*60*60*24);
nSpeed = 3;

data = struct;
for iSub = 1:nSub
    fprintf('iSubject: %u\n',iSub)
    data(iSub).subject = rdata(iSub).subject;
    t0 = min([rdata(iSub).speed(1).session.session_start_time_ms rdata(iSub).speed(2).session.session_start_time_ms ...
        rdata(iSub).speed(3).session.session_start_time_ms]);
    
    all_unique_dates = cell(1,nSpeed);
    for iSpeed = 1:nSpeed
        fprintf(' iSpeed: %u\n',iSpeed)
        data(iSub).speed(iSpeed).speed_deg_per_sec = rdata(iSub).speed(iSpeed).speed_deg_per_sec;
        sdata = rdata(iSub).speed(iSpeed).session;
        
        sess_start = [sdata.session_start_time_ms];
        [sess_start, ind] = sort(sess_start);
        sdata = sdata(ind);
        
        % Group sessions within the same day
        sess_dates = cellfun(@(x) x(1:10),{sdata.session_timestamp},'UniformOutput',false);
        [uSessDates,foo,IC] = unique(sess_dates);%#ok
        all_unique_dates{iSpeed} = uSessDates';
        nU = length(uSessDates);
        sess_grp_ind = cell(1,nU);
        for iU = 1:nU
            sess_grp_ind{iU} = find(IC==iU);
        end
        
        % Go by session groups
        nSessGrp = length(sess_grp_ind);
        for iGrp = 1:nSessGrp
            sess_ind = sess_grp_ind{iGrp};
            
            % Combine trial_data for the selected group of sessions
            trial_data = [rdata(iSub).speed(iSpeed).session(sess_ind).trial_data];
            
            % Filter sessions by valid trial
            trial_data = trial_data([trial_data.valid_trial]);
            
            offsets = unique([trial_data.spatial_offset_deg]);
            nOffsets = length(offsets);
            
            if nSessGrp==1
                % when all sessions for a given speed were on a single day, we
                % take the first session time as session time so that for each
                % speed, the relative_sess_time_day param is unique.
                meanSessTime = min(sess_start(sess_ind));
            else
                meanSessTime = mean(sess_start(sess_ind));
            end
            % Get relative session time in days
            relative_sess_time_day = (meanSessTime - t0)*cfToDay;
            
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
            temp.xyn = xyn;
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
            
            temp.grouped_sess_ind = sess_ind; % which consecutive sessions were grouped for this data point
            
            data(iSub).speed(iSpeed).grouped_sess_fit_data(iGrp) = temp;
        end
    end
    
    
    % Get relative testing day for each speed
    allRelTime = cell(1,nSpeed);
    for iSpeed = 1:nSpeed
        allRelTime{iSpeed} = [data(iSub).speed(iSpeed).grouped_sess_fit_data.relative_sess_time_day];
    end
    allRelTime = [allRelTime{:}];
    sortedTimes = sort(allRelTime);
    [foo1,foo2, c] = unique(floor(sortedTimes));%#ok
    testDays = c + (sortedTimes-floor(sortedTimes))-1;
    
    for iSpeed = 1:nSpeed
        rd = [data(iSub).speed(iSpeed).grouped_sess_fit_data.relative_sess_time_day];
        rd_ind = find(ismember(sortedTimes,rd));
        for iGrp = 1:length(rd_ind)
            data(iSub).speed(iSpeed).grouped_sess_fit_data(iGrp).relative_testing_day = testDays(rd_ind(iGrp));
        end
    end
end
