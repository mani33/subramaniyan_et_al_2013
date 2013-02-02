function out = get_xyn_pooled(data)
% out = get_xyn_pooled(data)
%-----------------------------------------------------------------------------------------
% GET_XYN_POOLED - For each subject(monkey or human), for each spatial offset, pool responses across
% all motion directions and flash locations across all sessions.
%
% input: the variable that is loaded by load('raw_data_monkey.mat') or load('raw_data_human.mat') function call.
%
% example: out = get_xyn_pooled(data);
%
% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-10
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

nSub = length(data);
out = struct;

% For Monkey-H, four flash locations were used. We will only include the two locations
% that were closer to the fovea. For Monkey-B and all humans, only two locations were
% used.
max_flash_loc_azimuth_deg = 2; 

for iSub = 1:nSub
    nSpeed = length(data(iSub).speed);
    out(iSub).subject = data(iSub).subject;
    for iSpeed = 1:nSpeed
        out(iSub).speed(iSpeed).speed_deg_per_sec = data(iSub).speed(iSpeed).speed_deg_per_sec;
        nSess = length(data(iSub).speed(iSpeed).session);
        spatial_offsets = cell(1,nSess);
        responses = cell(1,nSess);
        for iSess = 1:nSess
            % Get xyn for each session
            trial_data = data(iSub).speed(iSpeed).session(iSess).trial_data;
            % Consider only valid and reward block trials with flash locations closer to
            % fovea
            if isfield(trial_data,'reward_block_mode') % Monkeys
                trial_data = trial_data([trial_data.valid_trial] & [trial_data.reward_block_mode] & ...
                    [trial_data.fixation_required] & abs([trial_data.flash_location_deg]) < max_flash_loc_azimuth_deg);
            else % Humans 
                trial_data = trial_data([trial_data.valid_trial]);
            end
            spatial_offsets{iSess} = [trial_data.spatial_offset_deg];
            responses{iSess} = [trial_data.correct_response];
        end
        
        % Pool data across sessions
        spatial_offsets = [spatial_offsets{:}];
        responses = [responses{:}];
        
        unique_offsets = unique(spatial_offsets);
        nOffset = length(unique_offsets);
        
        for iOffset = 1:nOffset
            offset = unique_offsets(iOffset);
            sel_resp = responses(spatial_offsets==offset);
            n_trials = length(sel_resp);
            n_flash_lead_reports = sum(~sel_resp)*double(offset<0) + sum(sel_resp)*double(offset>=0);
            n_flash_lag_reports = n_trials - n_flash_lead_reports;
            % xyn: x = offset, y = number of flash_lag reports and n = number of trials.
            % This is the format that is need for psychometric function fit by psignifit
            % package.
            out(iSub).speed(iSpeed).xyn(iOffset,:) = [-offset n_flash_lag_reports n_trials];
        end
    end
end