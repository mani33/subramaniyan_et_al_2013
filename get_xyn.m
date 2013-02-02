function xyn = get_xyn(trial_data)
% xyn = get_xyn(trial_data)
%-----------------------------------------------------------------------------------------
% GET_XYN - Get response data. 
%
% example: xyn = get_xyn(trial_data) where
% x (col-1) - stimulus values; y (col-2) - number of correct responses; n (col-3) -
% total number of responses.
%
% Author: Mani Subramaniyan
% Date created: 2013-01-11
% Last revision: 2013-01-11
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

% Get xyn for each session
% Consider only valid and reward block trials with flash locations closer to
% fovea. For Monkey-H, four flash locations were used. We will only include the two locations
% that were closer to the fovea. For Monkey-B and all humans, only two locations were
% used.

max_flash_loc_azimuth_deg = 2;

if isfield(trial_data,'reward_block_mode') % Monkeys
    trial_data = trial_data([trial_data.valid_trial] & [trial_data.reward_block_mode] & ...
        [trial_data.fixation_required] & abs([trial_data.flash_location_deg]) < max_flash_loc_azimuth_deg);
else % Humans
    trial_data = trial_data([trial_data.valid_trial]);
end
            
spatial_offsets = [trial_data.spatial_offset_deg];
responses = [trial_data.correct_response];

unique_offsets = unique(spatial_offsets);
nOffset = length(unique_offsets);
xyn = nan(nOffset,3);

for iOffset = 1:nOffset
    offset = unique_offsets(iOffset);
    sel_resp = responses(spatial_offsets==offset);
    n_trials = length(sel_resp);
    n_flash_lead_reports = sum(~sel_resp)*double(offset<0) + sum(sel_resp)*double(offset>=0);
    n_flash_lag_reports = n_trials - n_flash_lead_reports;
    % xyn: x = offset, y = number of flash_lag reports and n = number of trials.
    % This is the format that is need for psychometric function fit by psignifit
    % package.
    xyn(iOffset,:) = [-offset n_flash_lag_reports n_trials];
end