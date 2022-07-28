clc
clear
close all


[Table,Critical] = GenTableNew();
OutlierDetect = zeros(size(unique(Table.Sat.vf)));
VfUnique = unique((Table.Sat.vf));


% for i = 1:numel(unique(Table.Sat.vf))
%     
%   OutlierDetect(i) = sum(Table.Sat.vf == VfUnique(i));
% 
% end

Vf = Table.Sat.vf;
nf = numel(Vf);
Cf = linspace(1000,1,nf)';

Vg = Table.Sat.vg;
ng = numel(Vg);
Cg = linspace(1,0.001,ng)';


figure(1)
% N = 3e5;
% plot(Vf*N,Table.Sat.T,'-b')
% hold on
% grid on
% plot(max(Vf*N)+2e2*(Vg-max(Vf)),Table.Sat.T,'-r');

% N = 3e5;
plot(Vf.*Cf,Table.Sat.T,'-b')
hold on
grid on
plot(Vg.*fliplr(Cg),Table.Sat.T,'-r');


set(gca,'XScale','log')
% set(gca,'YScale','log')