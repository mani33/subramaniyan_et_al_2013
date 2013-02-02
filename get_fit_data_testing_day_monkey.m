function data = get_fit_data_testing_day_monkey(raw_data_monkey)
%-----------------------------------------------------------------------------------------
% GET_FIT_DATA_TRAINING_DAY_MONKEY - Collect data for creating Figure 5-panel-B.
%
% example: get_fit_data_testing_day_monkey()
%
% Author: Mani Subramaniyan
% Date created: 2013-01-16
% Last revision: 2013-01-16
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

% Load raw data
% load('raw_data_monkey.mat')
rdata = raw_data_monkey;
clear raw_data_monkey

subjects = {'B','H'};
nSub = length(subjects);
cfToDay = 1/(1000*60*60*24); % conversion factor to get day from ms
nSpeed = 3;
max_flash_loc_azimuth_deg = 2;

data = struct;

for iSub = 1:nSub
    subject = subjects{iSub};
    data(iSub).subject = subject;
    for iSpeed = 1:nSpeed
        data(iSub).speed(iSpeed).speed_deg_per_sec = rdata(iSub).speed(iSpeed).speed_deg_per_sec;
        sdata = rdata(iSub).speed(iSpeed).session;
        nSess = length(sdata);
        % Sort sessions by session start time
        start_times = [sdata.session_start_time_ms];
        [foo,ind] = sort(start_times);%#ok
        sdata = sdata(ind);
        for iSess = 1:nSess
            csdata = sdata(iSess);
            data(iSub).speed(iSpeed).sess(iSess).session_start_time_ms = csdata.session_start_time_ms;
            
            trial_data = csdata.trial_data([csdata.trial_data.valid_trial] & [csdata.trial_data.reward_block_mode] & ...
                [csdata.trial_data.fixation_required] & abs([csdata.trial_data.flash_location_deg]) < max_flash_loc_azimuth_deg);
            
            offsets = unique([trial_data.spatial_offset_deg]);
            n_offsets = length(offsets);
            flash_locs = unique([trial_data.flash_location_deg]);
            n_flash_locs = length(flash_locs);
            resp = [trial_data.correct_response];
            
            for iOff = 1:n_offsets
                offset = offsets(iOff);
                % Split by individual condition - by flash location and motion direction
                ccc = 0;
                n_correct = nan(1,1);
                for iLoc = 1:n_flash_locs
                    loc = flash_locs(iLoc);
                    for iDir = 1:2
                        move_dir = iDir-1; % 0 - left to right; 1- right to left
                        ccc = ccc + 1;
                        % Filter responses by stimulus condition
                        sel_trials = ([trial_data.spatial_offset_deg]==offset) & ([trial_data.flash_location_deg]==loc) & ...
                            ([trial_data.move_dir]==move_dir);
                        sel_resp = resp(sel_trials);
                        n_correct(ccc) = sum(~sel_resp)*double(offset<0) + sum(sel_resp)*double(offset>=0);
                        data(iSub).speed(iSpeed).sess(iSess).n_trials_by_cond(iOff,ccc) = length(sel_resp);
                    end
                end
                n_trials = sum(data(iSub).speed(iSpeed).sess(iSess).n_trials_by_cond(iOff,:));
                n_flash_lead_resp = sum(n_correct);
                
                % Change flash lead responses to flash lag responses
                data(iSub).speed(iSpeed).sess(iSess).n_correct(iOff,1) = n_trials - n_flash_lead_resp;
                data(iSub).speed(iSpeed).sess(iSess).n_trials(iOff,1) = n_trials;
            end
            % Flip sign of offsets for plotting convenience
            data(iSub).speed(iSpeed).sess(iSess).offsets = -offsets(:);
        end
    end
end

% Group enough sessions so that we get atleast 5 trials per stimulus condition.
min_trials_per_cond = 5;

for iSub = 1:nSub
    fprintf('Subject: %u  \n',iSub)
    
    t0 = min([data(iSub).speed(1).sess.session_start_time_ms data(iSub).speed(2).sess.session_start_time_ms ...
        data(iSub).speed(3).sess.session_start_time_ms]);
    for iSpeed = 1:nSpeed
        fprintf('Speed: %u\n',iSpeed)
        sdata = data(iSub).speed(iSpeed).sess;
        nSess = length(sdata);
        offsets = mean([sdata.offsets],2);
        isProbeOffset = abs(offsets) < 1.5;
        
        done = false;
        indStart = 1;
        indEnd = indStart;
        g = 0;
        while ~done
            sess_ind = indStart:indEnd;
            nsInd = length(sess_ind);
            nProbeTrialByCond = cell(1,nsInd);
            for iInd = 1:nsInd
                nProbeTrialByCond{iInd} = mean(data(iSub).speed(iSpeed).sess(sess_ind(iInd)).n_trials_by_cond(isProbeOffset,:),1);
            end
            nProbeTrialByCond = cat(1,nProbeTrialByCond{:});
            totAvgProbeTrialsByCond = sum(nProbeTrialByCond,1);
            if any(totAvgProbeTrialsByCond < min_trials_per_cond)
                indEnd = indEnd + 1;
            else
                g = g + 1;
                indStart = indEnd+1;
                indEnd = indStart;
                % Now fit psychometric function after grouping responses
                nt = cell(1,nsInd);
                nc = nt;
                for iGs = 1:nsInd
                    nc{iGs} = data(iSub).speed(iSpeed).sess(sess_ind(iGs)).n_correct;
                    nt{iGs} = data(iSub).speed(iSpeed).sess(sess_ind(iGs)).n_trials;
                end
                x = mean([data(iSub).speed(iSpeed).sess(sess_ind).offsets],2);
                nc = sum(cat(2,nc{:}),2);
                nt = sum(cat(2,nt{:}),2);
                xyn = [x nc nt];
                fit_data = get_psych_fcn_fit_data(xyn);
                temp = fit_data;
                temp.xyn = xyn;
                
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
                
                avgSessTime = mean([data(iSub).speed(iSpeed).sess(sess_ind).session_start_time_ms]);
                relTimeDays = (avgSessTime-t0)*cfToDay;
                temp.relative_sess_time_day = relTimeDays; % testing day relative to the first test day
                
                temp.avg_sub_threshold_trials_per_cond = totAvgProbeTrialsByCond; % For each stimulus condition, how many trials were there on average
                data(iSub).speed(iSpeed).grouped_sess_fit_data(g) = temp;
            end
            if nSess==1 || indEnd > nSess
                done = true;
            end
        end
    end
    % Sort the relSessTimeInDays and assign testing day for each
    allRelDays = cell(1,nSpeed);
    for iSpeed = 1:nSpeed
        allRelDays{iSpeed} = [data(iSub).speed(iSpeed).grouped_sess_fit_data.relative_sess_time_day];
    end
    allRelDays = [allRelDays{:}];
    daysSorted = sort(allRelDays);
    for iSpeed = 1:nSpeed
        rd = [data(iSub).speed(iSpeed).grouped_sess_fit_data.relative_sess_time_day];
        sInd = find(ismember(daysSorted,rd))-1; % -1 for making day 1 as zero
        for iGrp = 1:length(sInd)
            data(iSub).speed(iSpeed).grouped_sess_fit_data(iGrp).relative_testing_day = sInd(iGrp);
        end
    end
end
