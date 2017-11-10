function [ ] = vizData( mytempdata,PhotodiodeStimulationChannel,Stim1, Stim2 )
    figure %new figure
    realDat = mytempdata.data(PhotodiodeStimulationChannel,:).'; %get photodiode channel data
    myX = linspace(0,length(realDat)/1000,length(realDat)); %convert to seconds
    plot(realDat) %display data
    hold on
    i = 1
    color = 'N';
    maxD = max(realDat);
    minD = min(realDat);
    while i <= length(mytempdata.event)
        if(strcmp(mytempdata.event(i).type, '100') || strcmp(mytempdata.event(i).type, '200'))
            color = 'magenta';
        elseif(max(strcmp(mytempdata.event(i).type, Stim1(1))))
            color = 'g';
        elseif(max(strcmp(mytempdata.event(i).type, Stim2(1))))
            color = 'r';    
        else
            color = 'N';  
        end
        if(~strcmp(color, 'N'))
            plot([mytempdata.event(i).latency, mytempdata.event(i).latency],[minD,maxD],color)
        end
        i = i +1;
    end
    hold off

end

