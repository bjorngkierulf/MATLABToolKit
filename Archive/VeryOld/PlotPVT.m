function PlotPVT()


%% Saturated
load SatDataSample.mat
P(P==0) = nan;

figure(1)

% P = P/(max(P(:)));
% T = T/(max(T(:)));
% 
% P = P/100;
vcr = 3.155e-3;
v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);
s1 = surf(v,T,P,'FaceColor',[0.6078,0.7882,0.8784],'EdgeColor','none');

% xlim([0,10*vcr])
%  shading interp

hold on

%% Super Heat
load SHDataSampleCut.mat
figure(1)
v(v>0.1) = nan;
v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);

s2 = surf(v,T,P,'FaceColor',[ 0.8118,0.9020,0.9255],'EdgeColor','none');

%  shading interp
% set(gca,'XScale','log')

hold on

%% SubCooled
load SCDataSampleCut.mat
figure(1)
v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);

s3 = surf(v,T,P,'FaceColor',[ 0.3922,0.5843,0.7647],'EdgeColor','none');
%  shading interp
% set(gca,'XScale','log')

%% Solid - Vapor
load VSSaturated.mat
figure(1)
v(v>3.155e-3) =vcr + (1*vcr)*(v(v>3.155e-3)-vcr)/(0.1-vcr);

s4 = surf(v,T,P,'FaceColor',[0.196,0.5961,0.7647],'EdgeColor','none');
%  shading interp
% set(gca,'XScale','log')

xlabel('v')
ylabel('T')
zlabel('P')


end