%This is the main script to load your desired data

%When reviewing this, you should be familiar with general experiment design
%for binary classification of eeg data, especially the function of markers

filename = 'OCtesting';%Dictates which file to load
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%These variables and code should be constant regardless of which data you use
%so please do not change these
Stim1 = {'149' '151'};
Stim2 = {'151' '149'};
StimArr = {'149','151','12','0','200'};
StimArr2 = {'151','149','12','0','200'};
PhotodiodeStimulationChannel = 3;
load(strcat(filename,'.mat'))

fakeBrains = mytraindata;
numPoints = length(fakeBrains.times);
ss =1;
sr = 500;
timeL = numPoints/sr;

% Fs = [3 8 10 15 30 35 40 50];
% Fs;
% stims= round(linspace(2*sr,numPoints-2*sr, (timeL-1) / 10));
Stim1Freq = [10 12 15];
Stim1Coeff = [.5 .2 .1];
Stim2Freq = [28 32 36];
Stim2Coeff = [.5 .2 .1];
offset = 5 * sr;
    
for k = 1:4
    y = zeros(1,numPoints);
    for i = 2:length(y)
        y(i) = y(i-1) +rand -0.5 - y(i-1)/500;
    end
    b = 1;
    f = 10;
    t = 1:numPoints;
    y = y + b * sin(2*pi*f*(t/sr + rand));
    y = awgn(y,10);
    t = 0:1/sr:5;
    for j = 1:length(fakeBrains.event)
        if(strcmp(fakeBrains.event(j).type, Stim1(1)) && (k == 2 || k ==3))
            for i = 1:length(Stim1Freq)
                f = Stim1Freq(i);
                b = Stim1Coeff(i);
                place = [fakeBrains.event(j).latency, fakeBrains.event(j).latency + offset];
                y(place(1):place(2)) = awgn(y(place(1):place(2)) + b * sin(2*pi*f*(t + rand)),10);
            end
        elseif(strcmp(fakeBrains.event(j).type, Stim2(1))&& (k == 2 || k ==3))
            for i = 1:length(Stim2Freq)
                f = Stim2Freq(i);
                b = Stim2Coeff(i);
                place = [fakeBrains.event(j).latency, fakeBrains.event(j).latency + offset];
                y(place(1):place(2)) = awgn(y(place(1):place(2)) + b * sin(2*pi*f*(t + rand)),10);
            end    
         end
    end
    fakeBrains.data(k,:)= y;  
end
% vizData(fakeBrains, PhotodiodeStimulationChannel,Stim1, Stim2)
save('fakeData.mat', 'fakeBrains')







% for i = 1:length(blinks)
%     blinks(i) = blinks(i) + randi([-2*sr 2*sr]);
% end



% for i = 1:length(blinks)
%     spikeh = 30*(1 + 3 * rand);
%     rate = 2;
%     for j = i:i+sr/4
%         y(blinks(i) + j) = y(blinks(i) + j-1) + (y(blinks(i)) + spikeh - y(blinks(i) + j-1))/rate + rand;
%         
%     end
%     for j = i+sr/4:i+sr/4 + sr/8
%         y(blinks(i) + j) = y(blinks(i) + j-1) + (y(blinks(i)) - .5 * spikeh - y(blinks(i) + j-1))/rate + rand;
%     end
%     for j = i+sr/4 +round(sr/8):i+sr/4 + sr/4
%         y(blinks(i) + j) = y(blinks(i) + j-1) + (y(blinks(i) + j-1))/rate + rand;
%     end
%     
%     
% end
% for i = 1:length(Fs)
%     y = y + sin(2*pi*Fs(i)*(t + rand))/(Fs(i)^1.5) + cos(2*pi*Fs(i)*(t + rand))/(Fs(i)^1.5);
% end
% y = awgn(y,5);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


