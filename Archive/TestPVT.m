clc
clear
close all


%% Saturated
load SatDataSample.mat
P(P==0) = nan;

figure(1)

% P = P/(max(P(:)));
% T = T/(max(T(:)));
% 
% P = P/100;
vcr = 3.155e-3;
% v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);
VMAX = 10*(max(max(v(v>vcr))));
v(v>vcr) = v(v>vcr) / VMAX;
s1 = surf(v,T,P,'FaceColor',[0.6078,0.7882,0.8784],'EdgeColor','none');
set(gca,'XScale','log')
% xlim([0,10*vcr])
%  shading interp

hold on

%% Super Heat
load SHDataSampleCut.mat
figure(1)
v(v>0.1) = nan;
% v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);
% VMAX = 3*(max(max(v)));
v(v>vcr) = v(v>vcr) / VMAX;
s2 = surf(v,T,P,'FaceColor',[ 0.8118,0.9020,0.9255],'EdgeColor','none');

%  shading interp
% set(gca,'XScale','log')

hold on

%% SubCooled
load SCDataSampleCut.mat
figure(1)
% v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);

v = v / VMAX;
s3 = surf(v,T,P,'FaceColor',[ 0.3922,0.5843,0.7647],'EdgeColor','none');
%  shading interp
set(gca,'XScale','log')

%% Solid - Vapor
load VSSaturated.mat
figure(1)
% v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);
% v = v / VMAX;

s4 = surf(v,T,P,'FaceColor',[0.196,0.5961,0.7647],'EdgeColor','none');
%  shading interp
set(gca,'XScale','log')
% set(gca,'YScale','log')
xlabel('v')
ylabel('T')
zlabel('P')

%% Boundary

% Table  = GenTable();
% 
% v = [Table.Sat.Pressure.vf;Table.Sat.Pressure.vg];
% P = [Table.Sat.Pressure.P;Table.Sat.Pressure.P];
% T = [Table.Sat.Pressure.T;Table.Sat.Pressure.T];
% Ind = find(v<=0.1);
% Out = sortrows([v(Ind),T(Ind),P(Ind)],1);
% xlabel('v')
% ylabel('T')
% zlabel('P')
% axis square
% figure(1)
% plot3(Out(:,1),Out(:,2),Out(:,3),'-k','LineWidth',2)
% 
% 
% vs = [Table.SatSV.vi;Table.SatSV.vg];
% Ps = [Table.SatSV.P;Table.SatSV.P];
% Ts = [Table.SatSV.T;Table.SatSV.T];
% Inds = find(vs<=0.1);
% Out = sortrows([vs(Inds),Ts(Inds),Ps(Inds)],1);
% xlabel('v')
% ylabel('T')
% zlabel('P')
% axis square
% figure(1)
% plot3(Out(:,1),Out(:,2),Out(:,3),'-k','LineWidth',2)

