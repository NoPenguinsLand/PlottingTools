%% Centered
% binsize in ms
% fs in Hz
% endt in ms
% stepsize in ms

function [psthY, centered_bins] = plotPSTHSlidingCentered(spikes,binsize,ntrials,fs,endt,newWind,stepsize)

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

mTimes = 1:stepsizef:(endtf+1);
sTimes = max(1,mTimes-(binsizef/2));
eTimes = min(endtf,mTimes+(binsizef/2));
% if mod((endtf-binsizef),stepsizef) ~= 0
%     eTimes = [eTimes endtf];
% end

if length(eTimes)~=length(sTimes)
    % Artifact. Either one is fine but latter code line give nice looking
    % psth
    %sTimes = [sTimes eTimes(1,end)-binsizef];
    sTimes = [sTimes sTimes(1,end)+binsizef];
end

disp(['Equal? ',num2str(length(sTimes)==numbin)]);

%centered_bins = sTimes + (eTimes-sTimes)/2;
centered_bins = mTimes;

psthY = [];
%name={num2str(binsizef/(fs*2))};
for k = 1:length(mTimes)
    spkCnt = 0;
    for j =1:ntrials
        spkCnt = spkCnt + sum(spikes(j,sTimes(k):eTimes(k)),2);
    end
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
title('Centered Window');
axis([0 length(spikes) 0 max(psthY)+20])

end