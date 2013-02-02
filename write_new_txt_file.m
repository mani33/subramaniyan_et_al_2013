function write_new_txt_file(file_name,data,column_headings,varargin)
% write_new_txt_file(file_name,data,column_headings,param1,paramVal1,param2,paramVal2,...)
%-----------------------------------------------------------------------------------------
% WRITE_NEW_TXT_FILE - Write txt file. The contents of the text file can
% then be copied to other applications.
%
% example: write_new_txt_file(filename,data,column_headings)
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

[f1,f2,ext] = fileparts(file_name); %#ok
if isempty(ext)
    file_name = [file_name '.txt'];
end

if exist(file_name,'file')
    error('The file ''%s'' already exists at (%s)! You need to delete it first',file_name, which(file_name))
else
    % Get data writing format
    % subject column is string data type; others are doubles
    sub_ind = strcmp(column_headings,'subject');
    mov_to_nl = '\n';
    if ispc
        mov_to_nl = '\r\n';
    end
    [nRow,nCol] = size(data);
    hformat = repmat('%s\t',[1 nCol]);
    hformat = [hformat mov_to_nl];
    dformat = repmat({'%3.3f\t'},[1,nCol]);
    dformat(sub_ind) = {'%s\t'};
    dformat = [[dformat{:}] mov_to_nl];
    
    
    fid = fopen(file_name,'w');
    % Write column headings
    fprintf(fid,hformat,column_headings{:});
    % Write data
    for iRow = 1:nRow
        dd = data(iRow,:);
        fprintf(fid,dformat,dd{:});
    end
    fclose(fid);
    
end