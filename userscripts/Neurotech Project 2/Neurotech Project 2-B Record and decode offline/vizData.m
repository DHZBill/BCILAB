function [ ] = vizData( mytempdata,PhotodiodeStimulationChannel,Stim1, Stim2 )
    figure %new figure
    realDat = mytempdata.data(PhotodiodeStimulationChannel,:).'; %get photodiode channel data
    myX = linspace(0,length(realDat)/1000,length(realDat)); %convert to seconds
    plot(realDat) %display data
    i = 1
    color = 'N'
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
            vline(mytempdata.event(i).latency,color)
        end
        i = i +1;
    end

end

