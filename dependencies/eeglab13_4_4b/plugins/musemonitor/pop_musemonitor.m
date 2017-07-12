% pop_musemonitor() - import data from Muse Monitor Android or iOS app
%
% Usage:
%   >> [EEG, com] = pop_musemonitor; % pop-up window mode
%   >> [EEG, com] = pop_musemonitor(filename);
%
% Optional inputs:
%   filename  - name of Muse Monitor .csv file
%
% Outputs:
%   EEG       - EEGLAB EEG structure
%   com       - history string
%
% Author: Arnaud Delorme, 2017-

% Copyright (C) 2017 Arnaud Delorme, arno@ucsd.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Id: pop_loadbv.m 53 2010-05-22 21:57:38Z arnodelorme $
% Revision 1.5 2010/03/23 21:19:52 roy
% added some lines so that the function can deal with the space lines in the ASCII multiplexed data file

function [EEG, com] = pop_musemonitor(fileName)

com = '';
EEG = [];

if nargin < 1
    [fileName, filePath] = uigetfile2({ '*.csv' '*.CSV' }, 'Select Muse Monitor .csv file - pop_musemonitor()');
    if fileName(1) == 0, return; end
    fileName = fullfile(filePath, fileName);
end

M = importdata(fileName, ',');
headerNames =  M.textdata(1,:);
if length(headerNames) == 1, headerNames = strsplit(headerNames{1}, ','); end;
realChans   = find(cellfun(@(x)~isempty(strmatch('RAW', x)), headerNames));
if size(M.data,2) < length(headerNames)-1, realChans = realChans-1; end;
EEG = eeg_emptyset;
EEG.data = M.data(:,realChans)';

% should add discontinuity here for all the NaN segments
nanPos = find(any(isnan(EEG.data)));
EEG.data(:,any(isnan(EEG.data))) = [];

%EEG.data = bsxfun(@minus, EEG.data, mean(EEG.data,2));
EEG.chanlocs = struct('labels', cellfun(@(x)x(5:end), headerNames(realChans), 'uniformoutput', false));
EEG.pnts   = size(EEG.data,2);
EEG.nbchan = size(EEG.data,1);
EEG.xmin = 0;
EEG.trials = 1;
EEG.srate = 300;
EEG = eeg_checkset(EEG);

com = sprintf('EEG = pop_musemonitor(''%s'');', fileName);