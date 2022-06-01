 function [Table,Critical] = GenTableNew()

% This Fucntion Generates A2-A6 Table of the Textbook

% Critical Point Properties

Critical.P = 220.9; % Bar
Critical.T = 374.1; % C
Critical.v = 3.155e-3;  % (m^3/Kg)
Critical.u = 2029.6;    % KJ/Kg
Critical.h = 2099.3;    % 
Critical.s = 4.4298;


%% Saturation Data

% Water Saturation Temperature Data
TDataSatNew= readmatrix('ThermoProp.xlsx','Sheet','A2');
TDataSatNew(:,[1 2]) = TDataSatNew(:,[2 1]);

% Water Saturation Pressure Data
PDataSatNew= readmatrix('ThermoProp.xlsx','Sheet','A3');


SatData = sortrows([PDataSatNew;TDataSatNew],1);

%this removes the the four rows of headers that were read in as NaN and
%cause interpolation issues. Another solution would be to add a range to
%the readmatrix
SatData(end-4:end,:) = [];
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

% Water Superheat Data
SuperHearData = readmatrix('ThermoProp.xlsx','Sheet','A4');

% Table - Pressure
Table.SuperHeat.P = SuperHearData(:,1); 
Table.SuperHeat.T = SuperHearData(:,2);
Table.SuperHeat.v = SuperHearData(:,3);
Table.SuperHeat.u = SuperHearData(:,4); 
Table.SuperHeat.h = SuperHearData(:,5);
Table.SuperHeat.s = SuperHearData(:,6);



%% Subcooled Data

% Water Superheat Data
SubCooledData = readmatrix('ThermoProp.xlsx','Sheet','A5');

% Table
Table.SubCooled.P = SubCooledData(:,1); 
Table.SubCooled.T = SubCooledData(:,2);
Table.SubCooled.v = SubCooledData(:,3)/1000;
Table.SubCooled.u = SubCooledData(:,4); 
Table.SubCooled.h = SubCooledData(:,5);
Table.SubCooled.s = SubCooledData(:,6);



%% Saturated Water (Solid Vapor) Data 

% Water Saturation Temperature Data
TDataSat= readmatrix('ThermoProp.xlsx','Sheet','A6');

% Table - Temperature
Table.SatSV.T = TDataSat(:,1); 
Table.SatSV.P = TDataSat(:,2)/100;
Table.SatSV.vi = TDataSat(:,3)/1e3;
Table.SatSV.vg = TDataSat(:,4);
Table.SatSV.ui = TDataSat(:,5);
Table.SatSV.ug = TDataSat(:,7);
Table.SatSV.hi = TDataSat(:,8);
Table.SatSV.hg = TDataSat(:,10);
Table.SatSV.si = TDataSat(:,11);
Table.SatSV.sg = TDataSat(:,13);






debug = true; %needs to be true or its bad news
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
        [uniqueInds,uniqueUg] = unique(var);

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
%ordering... We don't simply want to remove the rows, because only u? or h
%values are duplicate, the others values are fine

for i = 1:numel(names)
    
    unmodified = Table.Sat.(names(i));

    %allDupes.(names(i))
    %allDupeButOnlyOne.(names(i))

    unmodified(allDupeButOnlyOne.(names(i))) = unmodified(allDupeButOnlyOne.(names(i))) + 0.001;
    
    Table.Sat.(names(i)) = unmodified; %now a misnomer

end


end




%% This is in Ug, there are duplicate entries

% 
% uniqueInd =
% 
%     26    54    92   100
% 
% u(uniqueInd)
% 
% ans =
% 
%     2.4152
%     2.4945
%     2.6024
%     2.5805
% 
% 
% 
% find(u==2.4152)
% 
% ans =
% 
%     25
%     26
% 
%     find(u==2.4945)
% 
% ans =
% 
%     53
%     54
% 
%     find(u==2.6024)
% 
% ans =
% 
%     86
%     92
% 
% find(u==2.5805)
% 
% ans =
% 
%     78
%    100

%okay so that was a pain but these are the indices where Ug is duplicate
%25, 26. 53, 54. 86, 92. 78, 100.
