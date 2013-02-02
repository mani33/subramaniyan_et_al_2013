function fit_data = fit_psychometric_function(xyn,priors)
% fit_data = fit_psychometric_function(xyn,priors)
%-----------------------------------------------------------------------------------------
% FIT_PSYCHOMETRIC_FUNCTION - Fit psychometric function using psignifit3.0 toolbox.
%
% example: fit_data = fit_psychometric_function(xyn)
%
% This function is called by:
% This function calls: BootstrapInference
% MAT-files required:
%
% See also:

% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-10
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

cuts = 0.5;
sigmoid = 'logistic';
core = 'mw0.1';
nafc = 1;


if nargin < 2
    priors.m_or_a = 'None';
    priors.w_or_b = 'None';
    priors.lambda = 'Uniform(0, 0.1)';
    priors.gamma = 'Uniform(0, 0.1)';
end
fit_data = BootstrapInference(xyn, priors, 'cuts',cuts,'sigmoid',sigmoid,'core',core,'nafc',nafc,'gammaislambda');
