function varargout = psychErrorbarX(EX,EY,varargin)
% h = psychErrorbarX(EX,EY,param1,paramVal1,param2,paramVal2,...)
%-----------------------------------------------------------------------------------------
% PSYCHERRORBARX - Puts a horizontal errorbar for psychometric functions
% which have the y-range to be typically [0 1];
%
% example: h = psychErrorbarX([0 0.2],[0.5 0.5]) - This will put a
% horizontal line between points (0,0.5) and (0.2,0.5).
%
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also: 

% Author: Mani Subramaniyan
% Date created: 2011-10-20
% Last revision: 2011-10-20
% Created in Matlab version: 7.5.0.342 (R2007b)
%-----------------------------------------------------------------------------------------
params.Color = [0 0 0];
params = parseVarArgs(params,varargin{:});
c = 0.0075;
hold on;
% Simple line first
h = plot(EX,EY,'Color',params.Color);

% Then tiny vertical bars at the extremes
for iB = 1:2
    bx = [EX(iB) EX(iB)];
    by = [EY(iB)-c EY(iB)+c];
    plot(bx,by,'Color',params.Color);
end

if nargout
    varargout{1} = h;
end