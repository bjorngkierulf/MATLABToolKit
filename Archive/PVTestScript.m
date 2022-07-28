clc; clear; close all;
[Table,Critical] = GenTableNew();
%% range
plotLimitsWater = struct();
plotLimitsR134a = struct();

plotLimitsWater.TV = [1*10^-5, 1*10^-1, 10, 500];
plotLimitsWater.PV = [10^-3, 5*10^-1, 0, 250];
plotLimitsWater.TS = [0, 9, 0, 500];

plotLimitsR134a.TV = [6*10^-4, 1.3*10^-1, -40, 100];
plotLimitsR134a.PV = [6*10^-4, 1.3*10^-1, 0, 40];
plotLimitsR134a.TS = [0, 1, -40, 100];

%size and initialize arrays
N_T = 50;
N_v = 50;
temps = linspace(plotLimitsWater.TV(3),plotLimitsWater.TV(4),N_T); %temp bounds
vols = logspace(-3,0,N_v); %temp bounds

PVT = struct();
[PVT.v, PVT.T] = meshgrid(vols,temps);
PVT.P = zeros(size(PVT.v)); %column vector
PVT.phase = {};
PVT.phaseColor = zeros(size(PVT.v));


%% iterate through a range of T, v and calculate properties

for i = 1:N_v
    for j = 1:N_T

        %property calculation
        properties = PropertyCalculateSafe('T',temps(j),'v',vols(i),Table,Critical);
        
        %extract outputs
        temp = properties{3};
        vol = properties{4};
        press = properties{2};
        phase = properties{1};

        %repackage
        PVT.T(i,j) = temp;
        PVT.v(i,j) = vol;
        PVT.P(i,j) = press;
        if strcmp(phase,'Superheated vapor')
            PVT.phaseColor(i,j) = 5;
        elseif strcmp(phase,'Subcooled liquid')
            PVT.phaseColor(i,j) = 1;
            PVT.P(i,j) = 300; %bar, incompressible liq
        else %LV-mix, saturated liquid or saturated vapor. solid is not implemented
            PVT.phaseColor(i,j) = 2.5;
        end

    end
end

%% draw plot

figure(1);
%surf(liq.v,liq.T,liq.P,'FaceColor',[ 0.8118,0.9020,0.9255],'EdgeColor','none')
%surf(LV.v,LV.T,LV.P,'FaceColor',[ 0.3922,0.5843,0.7647],'EdgeColor','none')
%surf(super.v,super.T,super.P,'FaceColor',[0.196,0.5961,0.7647],'EdgeColor','none')

surf(PVT.v,PVT.T,PVT.P,PVT.phaseColor);%,PVT.phaseColor)

title("PVT Surface")
xlabel("Specific volume (m^3/kg)")
ylabel(["Temperature ("+char(0176)+'C)'])
zlabel("Pressure (bar)")
%colorbar

set(gca,'xScale','log')
set(gca,'FontSize',16)


% 
% 
% N_comb = N_T * N_v;
% 
% PVT = struct();
% PVT.T = zeros(N_comb,1); %column vector
% PVT.v = zeros(N_comb,1); %column vector
% PVT.P = zeros(N_comb,1); %column vector
% PVT.phase = {}; %column vector
% PVT.phaseColor = zeros(N_comb,1);
% 
% 
% %% iterate through a range of T, v and calculate properties
% 
% for i = 1:N_T
%     for j = 1:N_v
%         %full array index
%         i
%         j
%         k = (i-1)*N_v + j
% 
%         %property calculation
%         properties = PropertyCalculateSafe('T',temps(i),'v',vols(j),Table,Critical);
%         
%         %extract outputs
%         temp = properties{3};
%         vol = properties{4};
%         press = properties{2};
%         phase = properties(1);
% 
%         %repackage
%         PVT.T(k) = temp;
%         PVT.v(k) = vol;
%         PVT.P(k) = press;
%         PVT.phase(k) = phase;
% 
%     end
% end
% 
% %% divide data into regions based on phases
% 
% liqInds = zeros(N_comb,1);
% LVInds = zeros(N_comb,1);
% superInds = zeros(N_comb,1);
% 
% liq = struct();
% LV = struct();
% super = struct();
% 
% for k = 1:N_comb %no logical indexing for cell arrays
%     if strcmp(PVT.phase{k},'Superheated vapor')
%         superInds(k) = 1;
%         PVT.phaseColor(k) = 20;
%     elseif strcmp(PVT.phase{k},'Subcooled liquid')
%         liqInds(k) = 1;
%         PVT.phaseColor(k) = 1;
%     else %LV-mix, saturated liquid or saturated vapor. solid is not implemented
%         LVInds(k) = 1;
%         PVT.phaseColor(k) = 7;
%     end
% end
% 
% %make arrays "logical" - silly but apparently necessary because earlier I
% %manually assigned values to be 1 or zero
% superInds = logical(superInds);
% liqInds = logical(liqInds);
% LVInds = logical(LVInds);
% 
% %get data
% liq.T = PVT.T(liqInds);
% liq.v = PVT.v(liqInds);
% liq.P = PVT.P(liqInds);
% 
% LV.T = PVT.T(LVInds);
% LV.v = PVT.v(LVInds);
% LV.P = PVT.P(LVInds);
% 
% super.T = PVT.T(superInds);
% super.v = PVT.v(superInds);
% super.P = PVT.P(superInds);
% 
% %% draw plot
% 
% figure(1);
% %surf(liq.v,liq.T,liq.P,'FaceColor',[ 0.8118,0.9020,0.9255],'EdgeColor','none')
% %surf(LV.v,LV.T,LV.P,'FaceColor',[ 0.3922,0.5843,0.7647],'EdgeColor','none')
% %surf(super.v,super.T,super.P,'FaceColor',[0.196,0.5961,0.7647],'EdgeColor','none')
% 
% [V,T] = meshgrid(PVT.v,PVT.T)
% surf(V,T,P);%,PVT.phaseColor)
% 
% 
% xlabel("v")
% ylabel("T")
% zlabel("P")
