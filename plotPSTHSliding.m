%%
% binsize in ms
% fs in Hz
% endt in ms
% stepsize in ms

function [psthY, centered_bins] = plotPSTHSliding(spikes,binsize,ntrials,fs,endt,newWind,stepsize)

binsizef = binsize/1000*fs;
stepsizef = stepsize/1000*fs;
endtf = endt/1000*fs;

if binsize > stepsize
    numbin = ceil((endt-(binsize-1))/stepsize);
elseif binsize == stepsize
    numbin = ceil(endt/binsize);
else
    return;
end

sTimes = 1:stepsizef:(endtf-binsizef+1);
eTimes = (binsizef):stepsizef:endtf;
if mod((endtf-binsizef),stepsizef) ~= 0
    eTimes = [eTimes endtf];
end

if length(eTimes)~=length(sTimes)
    % Artifact. Either one is fine but latter code line give nice looking
    % psth
    %sTimes = [sTimes eTimes(1,end)-binsizef];
    sTimes = [sTimes sTimes(1,end)+binsizef];
end

disp(['Equal? ',num2str(length(sTimes)==numbin)]);

%centered_bins = sTimes + (eTimes-sTimes)/2;
centered_bins = sTimes + (binsizef)/2;

psthY = [];
%name={num2str(binsizef/(fs*2))};
for k = 1:length(sTimes)
    spkCnt = sum(spikes(1,sTimes(k):eTimes(k)),2);
    [psthY] = [psthY, (spkCnt/(ntrials*(binsizef/fs)))];%Spikes/second
    if mod(k,20)==0
        %name{1,k/20}=num2str(windowTimes(k)/fs+(windowTimes(k)/fs-windowTimes(k-1)/fs)/2);
    end
end

if newWind == 1
    figure();
end
bar(centered_bins,psthY,1,'k','EdgeColor','k');
%set(gca,'xticklabel',name)
xlabel('Sample');
ylabel('FR [Hz]');
title(['Sliding step: ',num2str(stepsize),'ms. Bin size: ',num2str(binsize),' ms.']);
axis([0 length(spikes) 0 max(psthY)+20])

end