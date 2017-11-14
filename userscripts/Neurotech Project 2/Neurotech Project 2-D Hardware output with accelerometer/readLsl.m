%% Initialize Muse to read in accelerometer data
% 1) Connect to Muse via bluetooth
% 2) Use muse-io to connect over lsl
%       a) cd C:\Program Files (x86)\Muse
%       b) muse-io.exe --lsl-acc museacc
% 3) Run code below to read in acc data from Muse

bci_stream_name = 'museacc';  
lib = lsl_loadlib();
disp('Resolving a BCI stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'name',bci_stream_name,1,1); end
inlet = lsl_inlet(result{1});
disp('Now receiving data...');

% Confirm that you are getting data
vis_stream('museacc');
% Close the vis_stream window
input();
pause(1);

while 1
    % get data from the inlet (timeout: 1 second)
    [tempdataacc,temptimestampacc] = inlet.pull_chunk();
    if ~isempty(temptimestampacc)
        disp(tempdataacc)
    end    
    pause(0.01);
end
onl_clear(); % Shutdown connection to lsl (Clear all online streams and predictors.)
