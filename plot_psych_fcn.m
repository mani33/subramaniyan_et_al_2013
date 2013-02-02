function varargout = plot_psych_fcn(xyn,fit_data,varargin)
% h = plot_psych_fcn(xyn,fit_data,param1,va1,param2,val2,...)
%-----------------------------------------------------------------------------------------
% PLOT_PSYCH_FCN - Plot psychometric function.
%
% example: h = plot_psych_fcn(xyn,fit_data,'axes',axisHandle)
% Inputs: xyn - raw data (nOffsets-by-3; column1-spatial offset; column2-number of correct responses; 
% column3-total number of trials); fit_data - psychometric function fit data.
%
% Author: Mani Subramaniyan
% Date created: 2013-01-10
% Last revision: 2013-01-10
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

params.Color = [0 0 0];
params.LineWidth = 1;
params.FontSize = 7;
params.FontName = 'Arial';
params.MarkerSize = 4;
params.Marker = 'O';
params.fitLineStyle = '-';
params.MarkerFaceColor = 'None';
params.errorbar = true;
params.plotRawData = true;
params.axes = [];
params = parseVarArgs(params,varargin{:});

if isempty(params.axes)
    params.axes = gca;
end

axes(params.axes)

% Plot raw data
if params.plotRawData
    h = plot(xyn(:,1),xyn(:,2)./xyn(:,3),params.Marker,'MarkerSize',params.MarkerSize,...
        'MarkerEdgeColor',params.Color,'MarkerFaceColor',params.MarkerFaceColor);
    hold on;
end

% Plot fit data
xy = fit_data.psych_curve_xy;
plot(xy(:,1),xy(:,2),params.fitLineStyle,'color', ...
    params.Color,'LineWidth',params.LineWidth);
y = fit_data.errorbar_loc_y;
ci = fit_data.conf_int_threshold;

% Add horizontal errorbar
psychErrorbarX(ci, [y,y],'Color', params.Color );


axis([xy(1)-0.1 xy(end,1)+0.1 0 1])
hold on
set(gca,'FontSize',params.FontSize,'FontName',params.FontName)

if nargout
    varargout{1} = h;
end