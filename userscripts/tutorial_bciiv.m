% Attemping BCI IV 
% SWM 5/26/2017
clear traindata myapproach trainloss lastmodel laststats


filename_traindata = 'H:\\BCI\DataFromOutside\BCICIV_1_mat\BCICIV_calib_ds1a.mat';
filename_testdata = 'H:\\BCI\DataFromOutside\BCICIV_1_mat\BCICIV_calib_ds1e.mat';


% --- using the Common Spatial Pattern method with some custom options ---

% load the data set (BCI2000 format)
traindata = io_loadset(filename_traindata);%,'channels',1:29);


%
% define the approach 
% Note: The settings found in the GUI "Review/Edit Approach" Panel can be translated literally
%       into cell array representations as below. Each paradigm has a few top-level parameter groups
%       (for CSP: SignalProcessing, FeatureExtraction, etc), which in turn have sub-parameters
%       (e.g., SignalProcessing has EpochExtraction, SpectralSelection, Resampling, etc.), and so
%       on. Some parameters are numbers, strings, cell arrays, etc. You only need to specify those 
%	    parameters where you actually want to deviate from the paradigm's defaults.
%
% For illustratory purposes, we use a different window relative to the target markers (0.5s to 3s after),
% and a somewhat customized FIR frequency filter with a pass-band between ~7.5Hz and ~27Hz.
%myapproach = {'CSP' 'SignalProcessing',{'EpochExtraction',[.8 3.6],'FIRFilter',[9 10 14 15]}};
myapproach = {'CSP', 'SignalProcessing',{'EpochExtraction',[.8 3.6],'FIRFilter',[9 10 14 15]},...
    'Prediction',{'MachineLearning',...
    {'Learner',{'qda' 'WeightedBias',false}}}};

% learn a predictive model
[trainloss,lastmodel,laststats] = bci_train('Data',traindata,'Approach',myapproach,'TargetMarkers',{'-1','1'}); 
disp(['training mis-classification rate: ' num2str(trainloss*100,3) '%']);

% visualize results
bci_visualize(lastmodel)

% --- applying the CSP model to some data (here: training data) ---

% apply the previously learned model to a data set (querying it for each target marker in the data)
[prediction,loss,teststats,targets] = bci_predict(lastmodel,traindata);

% display the results
disp(['test mis-classification rate: ' num2str(loss*100,3) '%']);
disp(['  predicted classes: ',num2str(round(prediction{2}*prediction{3})')]);  % class probabilities * class values
disp(['  true classes     : ',num2str(round(targets)')]);

%% --- applying the CSP model to some data (here: test data) ---

% load feedback session
testdata = io_loadset(filename_testdata);

% apply the previously learned model to a data set (querying it for each target marker in the data)
[prediction,loss,teststats,targets] = bci_predict(lastmodel,testdata);

% display the results
disp(['test mis-classification rate: ' num2str(loss*100,3) '%']);
disp(['  predicted classes: ',num2str(round(prediction{2}*prediction{3})')]);  % class probabilities * class values
disp(['  true classes     : ',num2str(round(targets)')]);

%% --- test the learned model in simulated real-time processing ---
% ( click into the figure to stop the update (and make sure that your click was registered) )

% load feedback session
testdata = io_loadset(filename_testdata);

% play it back in real time
run_readdataset('Dataset',testdata);

% process data in real time using lastmodel, and visualize outputs
run_writevisualization('Model',lastmodel, 'VisFunction','bar(y);ylim([0 1])');

% make sure that the online processing gets terminated...
disp('Click into the figure to stop online processing.'); 
waitforbuttonpress; onl_clear; close(gcf);