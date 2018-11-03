function plotISI(train,titlename)
indx = find(train==1);
ISI = diff(indx);
figure;
histogram(ISI);
title(['Histogram of ISI for: ',titlename]);
xlabel('Interval [ms]');
ylabel('Count');
end