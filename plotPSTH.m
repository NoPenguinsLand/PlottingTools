%%
% binsize in ms
% fs in Hz
% endt in ms

function psthY = plotPSTH(spikes,binsize,ntrials,fs,endt,newWind)

binsizef = binsize/1000*fs;
windowTimes = 0:binsizef:(endt/1000)*fs;
centered_bins = windowTimes(1:end-1)+(diff(windowTimes))/2;%for plotting

psthY = [];
name={num2str(binsizef/(fs*2))};
for k = 2:length(windowTimes)
    spkCnt = sum(spikes(1,windowTimes(k-1)+1:windowTimes(k)),2);
    [psthY] = [psthY, (spkCnt/(ntrials*(binsizef/fs)))];%Spikes/second
    if mod(k,20)==0
        name{1,k/20}=num2str(windowTimes(k)/fs+(windowTimes(k)/fs-windowTimes(k-1)/fs)/2);
    end
end

if newWind == 1
    figure();
end
bar(centered_bins,psthY,1,'k','EdgeColor','k');
%set(gca,'xticklabel',name)
xlabel('Sample');
ylabel('FR [Hz]');
title(['Non-overlapping PSTH. Binsize: ',num2str(binsize),'ms']);
axis([0 fs*(endt/1000) 0 max(psthY)+20])

end