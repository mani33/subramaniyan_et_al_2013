function fit_data = collect_psych_fcn_fit_data(data)
% fit_data = collect_psych_fcn_fit_data(data)
%-----------------------------------------------------------------------------------------
% COLLECT_PSYCH_FCN_FIT_DATA - Fit psychometric function for data sets using psignifit3.0.
%
% example: fit_data = collect_psych_fcn_fit_data(data)
% Input: 'data' is the output of 'get_xyn_pooled' function call.
%
% This function is called by:
% This function calls: get_psych_fcn_fit_data
% MAT-files required:
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-10
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

fit_data = struct;

nSub = length(data);
for iSub = 1:nSub
    fit_data(iSub).subject = data(iSub).subject;
    nSpeed = length(data(iSub).speed);
    for iSpeed = 1:nSpeed
        xyn = data(iSub).speed(iSpeed).xyn;       
        temp = get_psych_fcn_fit_data(xyn);
        temp.speed_deg_per_sec = data(iSub).speed(iSpeed).speed_deg_per_sec;
        fit_data(iSub).speed(iSpeed) = temp;
    end
end

