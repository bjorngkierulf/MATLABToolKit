clc; clear; close all;
[Table,Critical] = GenTableNew();

%% break case test
P = 4; %bar
T = 145; %C
vTrue = 0.46425;

out1 = SuperHeatR('P',P,'T',T,Table)
out2 = SuperHeatAll('P',P,'T',T,Table,0)

out1.v
out2.v


%% isoline test script
if 1

isotherms = [120]

Out = IsoLine('T',120,Table,Critical,[],1)

end










% %% test script
% vols = [0.8:0.001:3]; %m3/kg
% %temp = 140; %C
% press = 2; %bar
% temps = zeros(size(vols));
% pressOut = zeros(size(vols));
% 
% 
% [tab,crit] = GenTableNew();
% 
% for i = 1:length(vols)
% 
%     outState = SuperHeatTest('P',press,'v',vols(i),tab);
%     temps(i) = outState.T; %find temp based on pressure - this should be good
% 
%     %then interpolate back for pressure based on the break case method
%     out2 = SuperHeatTest('T',temps(i),'v',vols(i),tab)
%     
%     pressOut(i) = out2.P;
% end
% 
% close all
% 
% figure(1)
% plot(vols,temps)
% xlabel("v")
% ylabel("T")
% 
% figure(2)
% plot(pressOut)
% 
% 
% 
% % for i = 1:length(vols)
% % 
% %     outState = SuperHeatTest('P',press,'v',vols(i),tab);
% %     temps(i) = outState.T; %find temp based on pressure - this should be good
% % 
% %     %then interpolate back for pressure based on the break case method
% %     out2 = SuperHeatTest('T',temps(i),'v',vols(i),tab)
% % 
% % end
% % 
% % 
% % plot(vols,temps)
% % xlabel("v")
% % ylabel("T")
% 
