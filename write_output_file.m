function write_output_file(filename,data,column_headings,args,varargin)
% write_output_file(filename,data,column_headings,args,param1,paramVal1,param2,paramVal2,...)
%-----------------------------------------------------------------------------------------
% WRITE_OUTPUT_FILE - Write excel or txt file
%
% example: write_output_file(filename,data,column_headings,args)
%
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also: 

% Author: Mani Subramaniyan
% Date created: 2013-01-31
% Last revision: 2013-01-31
% Created in Matlab version: 8.0.0.783 (R2012b)
%-----------------------------------------------------------------------------------------


switch args.file_format
    case {'xls','xlsx'}
        write_new_excel_file(filename,data,column_headings,args.file_format)
    case 'txt'
        write_new_txt_file(filename,data,column_headings)
    otherwise
        error('File format should be csv, xls or xlsx')
end