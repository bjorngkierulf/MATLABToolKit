 function [Table,Critical] = GenTableR134a()

% This Fucntion Generates A10-A12 Table of the Textbook, properties for
% R134a

% Critical Point Properties

%critical data approximated by properties at T = 100 C, which is not the
%critical point. Real critical point is 101 something

Critical.P = 39.742; % Bar
Critical.T = 100; % C
Critical.v = 0.0027;  % (m^3/Kg)
Critical.u = 248.49;    % KJ/Kg
Critical.h = 259.13;    % 
Critical.s = 0.8117;
Critical.s = 0.8; %this is below the lowest value of saturated vapour and 
% above the highest value of saturated liquid. This is required by the iso
% lines algorithm


%% Saturation Data

% R134a Saturation Temperature Data
TDataSatNew= readmatrix('ThermoProp.xlsx','Sheet','A10');
TDataSatNew(:,[1 2]) = TDataSatNew(:,[2 1]);

% R134a Saturation Pressure Data
PDataSatNew= readmatrix('ThermoProp.xlsx','Sheet','A11');


SatData = sortrows([PDataSatNew;TDataSatNew],1);

%this removes the the four rows of headers that were read in as NaN and
%cause interpolation issues. Another solution would be to add a range to
%the readmatrix
SatData(end-3:end,:) = [];
%This also removes the double T = 220.9 points, which were also causing
%issues with interp1

% Table - Saturated State
Table.Sat.P = SatData(:,1);
Table.Sat.T = SatData(:,2); 
Table.Sat.vf = SatData(:,3)/1e3;
Table.Sat.vg = SatData(:,4);
Table.Sat.vfg =Table.Sat.vg - Table.Sat.vf ;
Table.Sat.uf = SatData(:,5);
Table.Sat.ug = SatData(:,6);
Table.Sat.ufg =Table.Sat.ug - Table.Sat.uf ;
Table.Sat.hf = SatData(:,7);
Table.Sat.hfg =SatData(:,8);
Table.Sat.hg = SatData(:,9);
Table.Sat.sf = SatData(:,10);
Table.Sat.sg = SatData(:,11);
Table.Sat.sfg =Table.Sat.sg - Table.Sat.sf ;



%% Superheat Data

% R134a Superheat Data
SuperHeatData = readmatrix('ThermoProp.xlsx','Sheet','A12');

% Table - Pressure
Table.SuperHeat.P = SuperHeatData(:,1); 
Table.SuperHeat.T = SuperHeatData(:,2);
Table.SuperHeat.v = SuperHeatData(:,3);
Table.SuperHeat.u = SuperHeatData(:,4); 
Table.SuperHeat.h = SuperHeatData(:,5);
Table.SuperHeat.s = SuperHeatData(:,6);



% %% Subcooled Data
% 
% %data does not exist
% 
% % R134a subcooled Data
% SubCooledData = readmatrix('ThermoProp.xlsx','Sheet','A5');
% 
% % Table
% Table.SubCooled.P = SubCooledData(:,1); 
% Table.SubCooled.T = SubCooledData(:,2);
% Table.SubCooled.v = SubCooledData(:,3)/1000;
% Table.SubCooled.u = SubCooledData(:,4); 
% Table.SubCooled.h = SubCooledData(:,5);
% Table.SubCooled.s = SubCooledData(:,6);
% 
% 
% 
% %% Saturated Water (Solid Vapor) Data 
% 
% %data does not exist
% 
% % R134a Saturation Temperature Data
% TDataSat= readmatrix('ThermoProp.xlsx','Sheet','A6');
% 
% % Table - Temperature
% Table.SatSV.T = TDataSat(:,1); 
% Table.SatSV.P = TDataSat(:,2)/100;
% Table.SatSV.vi = TDataSat(:,3)/1e3;
% Table.SatSV.vg = TDataSat(:,4);
% Table.SatSV.ui = TDataSat(:,5);
% Table.SatSV.ug = TDataSat(:,7);
% Table.SatSV.hi = TDataSat(:,8);
% Table.SatSV.hg = TDataSat(:,10);
% Table.SatSV.si = TDataSat(:,11);
% Table.SatSV.sg = TDataSat(:,13);
% 




% Assign empty values as made necessary by the fact that exist() doesn't
% seem to work on structs

Table.SubCooled = [];
Table.SatSV = [];


%graphing and duplicate removal

debug = true;
graph = false;

names = ["vg","ug","hg","sg"];
vars = [Table.Sat.vg,Table.Sat.ug,Table.Sat.hg,Table.Sat.sg];
allDupes = struct();

if debug
    close all %this now, not in the loop
    for v = 1:numel(names) %numel(vars) gives too many things
        var = vars(:,v);

        %this gives the unique entries. This leaves one of the two of every
        %duplicate pair
        %[~,uniqueUg] = unique(Table.Sat.ug)
        [~,uniqueUg] = unique(var);

        %initialize as the whole thing, then remove the duplicates
        %duplicateUg = Table.Sat.ug;
        duplicateUg = var;
        duplicateUg(uniqueUg) = [];


        %uniqueUg
        %only for removing them later
        duplicateInds = 1:numel(var);
        duplicateInds(uniqueUg) = [];

        dupes = [];
        for i = 1:numel(duplicateUg)
            %preallocating here would potentially cause a problem if there were
            %three of a value
            %dupes = [dupes; find(Table.Sat.ug == duplicateUg(i))] %column vector
            dupes = [dupes; find(var == duplicateUg(i))]; %column vector


        end %end inner for, to find the actaul duplicates


        if graph
        %plot the output WRT pressure and temperature
        figure(v)
        title(names(v))
        subplot(2,1,1)
        plot(Table.Sat.P,var)
        hold on
        plot(Table.Sat.P(dupes),var(dupes))
        legend("All","Duplicates")
        xlabel("P")
        ylabel(names(v))

        subplot(2,1,2)
        plot(Table.Sat.T,var)
        hold on
        plot(Table.Sat.T(dupes),var(dupes))
        legend("All","Duplicates")
        xlabel("T")
        ylabel(names(v))

        %shared?
        %title(names(v))
        end

        %pack outputs for ordering graphing
        allDupes.(names(v)) = dupes;
        allDupeButOnlyOne.(names(v)) = duplicateInds;


    end %end outer for, to loop through the variables

    %order = {'P','T','v','u','h','s','x'};
    %nested for, lets get the combinations
    for i = 1:numel(names)
        xVar = vars(:,i);
        xDupes = allDupes.(names(i));
        for j = 1:numel(names)
            yVar = vars(:,j);
            yDupes = allDupes.(names(j));

            localDupes = unique([xDupes;yDupes]); %not the most elegant but it works

            if graph
            figure(numel(names)+i)
            subplot(2,2,j)
            plot(xVar,yVar)
            hold on
            plot(xVar(localDupes),yVar(localDupes))
            legend("All","Duplicates")
            xlabel(names(i))
            ylabel(names(j))
            end

        end

    end %end debug if

end


%Now, we correct the duplicate entries. We don't have to worry about things
%being nonmonotonic and causing extreme discontinuities during
%interpolation, because that is being handled in the interpolation
%ordering...

for i = 1:numel(names)
    
    unmodified = Table.Sat.(names(i));

    %allDupes.(names(i))
    %allDupeButOnlyOne.(names(i))

    unmodified(allDupeButOnlyOne.(names(i))) = unmodified(allDupeButOnlyOne.(names(i))) + 0.001;
    
    Table.Sat.(names(i)) = unmodified; %now a misnomer

end





end