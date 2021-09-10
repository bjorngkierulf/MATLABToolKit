clc
clear
close all
[Table,Critical] = GenTableNew();

%% Saturated
load SaturatedData.mat

figure(1)

s1 = surf(Sat.v,Sat.T,Sat.P,'FaceColor',[0.6078,0.7882,0.8784],'EdgeColor','none');

hold on

%% Super Heat
load SuperHeatData.mat
figure(1)

s2 = surf(Sup.v,Sup.T,Sup.P,'FaceColor',[ 0.8118,0.9020,0.9255],'EdgeColor','none');

set(gca,'XScale','log')

%% SubCooled
% load SCDataSampleCut.mat
% figure(1)
% s3 = surf(v,T,P,'FaceColor',[ 0.3922,0.5843,0.7647],'EdgeColor','none');
% 
% set(gca,'XScale','log')
% 
% xlabel('volume')
% ylabel('Temperature')
% zlabel('Pressure')

%% Solid - Vapor
% load VSSaturated.mat
% figure(1)
% 
% s4 = surf(v,T,P,'FaceColor',[0.196,0.5961,0.7647],'EdgeColor','none');
% 
% set(gca,'XScale','log')
% 
% xlabel('v')
% ylabel('T')
% zlabel('P')

%% Boundary
figure(1)
plot3(Table.Sat.vf,Table.Sat.T,Table.Sat.P,'-k')
plot3(Table.Sat.vg,Table.Sat.T,Table.Sat.P,'-k')

xlabel('volume')
ylabel('Temperature')
zlabel('Pressure')

