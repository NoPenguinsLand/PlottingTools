%%
% binsize in ms
% fs in Hz
% endt in ms
% stepsize in ms

function [psthY, spkCnt, centered_bins] = plotPSTHSlidingGaussian(spikes,binsize,ntrials,fs,endt,newWind,stepsize)

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

centered_bins = sTimes + (eTimes-sTimes)/2;
%centered_bins = sTimes + (binsizef)/2;

% Set up Gaussian window
window = @(x) 1/(sqrt(2*pi)*binsizef).*exp(-x.^2/(2*binsizef^2));
windowt = @(x) 1/(sqrt(2*pi)*binsize).*exp(-x.^2/(2*binsize^2));

% % Test Gaussian Window
% %interval = sTimes(1):eTimes(1);
% %interval = (-20000*sTimes(1)):(5*eTimes(1));
% interval = sTimes(1):eTimes(end);
% spike_interval = spikes(interval);
% time_diff = (interval-centered_bins(1));
% testG = window(time_diff);
% figure();
% subplot(2,1,1);
% plot(time_diff,testG);
% subplot(2,1,2);
% plot(time_diff,spike_interval.*testG);

psthY = zeros(1,length(sTimes));
spkCnt = zeros(1,length(sTimes));
%name={num2str(binsizef/(fs*2))};
for k = 1:length(sTimes)
    interval = sTimes(k):eTimes(k);
    spike_interval = spikes(1,sTimes(k):eTimes(k));
    time_diff = (interval-centered_bins(k))/fs;
    spkCnt(k) = sum(spike_interval.*windowt(time_diff));
    %spkCnt = sum(spikes(1,sTimes(k):eTimes(k)),2);
    psthY(k) = (spkCnt(k)/(ntrials*(binsizef/fs)));%Spikes/second
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
ylabel('FR [AU]');
title(['Gaussian Window. Bin size: ',num2str(binsize),' Step size: ',num2str(stepsize)]);
axis([0 length(spikes) 0 max(psthY)])

end