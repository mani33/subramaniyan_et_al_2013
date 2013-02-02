function write_new_excel_file(file_name,data,column_headings,file_format,varargin)
% write_new_excel_file(file_name,data,column_headings,file_format,param1,paramVal1,param2,paramVal2,...)
%-----------------------------------------------------------------------------------------
% WRITE_NEW_EXCEL_FILE - Write a new excel file.
%
% example: write_new_excel_file('stat_data',{1,'SM'},{'subject_id','subject'},'xlsx')
%
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also: 

% Author: Mani Subramaniyan
% Date created: 2013-01-17
% Last revision: 2013-01-17
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------

file_name = [file_name '.' file_format];
if exist(file_name,'file')
    error('The file ''%s'' already exists in MATLAB path! You need to delete it first',file_name)
else
    xlswrite(file_name,column_headings,1,'A1');
    xlswrite(file_name,data,1,'A2');
end
