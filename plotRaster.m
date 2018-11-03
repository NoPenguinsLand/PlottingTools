function [] = plotRaster(spikeMat,newWind)
if newWind == 1
    figure();;
end
hold all;
for trialCount = 1:size(spikeMat,1)
    spikePos = find(spikeMat(trialCount,:));
    for spikeCount = 1:length(spikePos)
        plot([spikePos(spikeCount) spikePos(spikeCount)], ...
            [trialCount-0.4 trialCount+0.4], 'k');
    end
end
ylim([0 size(spikeMat, 1)+1]);
xlim([0 size(spikeMat,2)]);
title('Raster Plot');
xlabel('Sample');
ylabel('Trial');