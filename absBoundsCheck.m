function bool = absBoundsCheck(Prop1,Value1,Prop2,Value2,Table,critical)

    % function assigns true to output bool if the inputs are out of bounds

%clc; clear; close all;
%
%Prop1 = 'x';
%Value1 = 1.5;
%Prop1 = 'P';
%Value1 = 5;

%Prop2 = 's';
%Value2 = 1;
% 
% Prop1 = 'h';
% Value1 = 855;

% Prop2 = 's';
% Value2 = 3.2;

%Prop2 = 'T';
%Value2 = 179.9;


%[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2);


%[Table,critical] = GenTableNew();


    % function will do a simple check on each of the properties and their
    % values

    allProperties = {'P','T','v','u','h','s','x'};

    ind1 = find(strcmp(allProperties,Prop1));
    ind2 = find(strcmp(allProperties,Prop2));


    %get the absolute max and min for each property
    maxes = zeros(size(allProperties));
    mins = zeros(size(allProperties));
    
    if isempty(Table.SubCooled)
        %no subcooled data, exclude it from max / min
    %P
    maxes(1) = max([Table.Sat.P; Table.SuperHeat.P]);

    %T
    maxes(2) = max([Table.Sat.T; Table.SuperHeat.T]);

    %v
    maxes(3) = max(Table.SuperHeat.v);

    %u
    maxes(4) = max(Table.SuperHeat.u);

    %h
    maxes(5) = max(Table.SuperHeat.h);

    %s
    maxes(6) = max(Table.SuperHeat.s);

    %x
    maxes(7) = 1;


    %P
    mins(1) = min([Table.Sat.P; Table.SuperHeat.P]);

    %T
    mins(2) = min([Table.Sat.T; Table.SuperHeat.T]);

    %v
    mins(3) = min(Table.SuperHeat.v);

    %u
    mins(4) = min(Table.SuperHeat.u);

    %h
    mins(5) = min([Table.SuperHeat.h]);

    %s
    mins(6) = min([Table.SuperHeat.s]);

    %x
    mins(7) = 0;

    else
        %subcooled data exists, work as normal

    %P
    maxes(1) = max([Table.SubCooled.P; Table.Sat.P; Table.SuperHeat.P]);

    %T
    maxes(2) = max([Table.SubCooled.T; Table.Sat.T; Table.SuperHeat.T]);

    %v
    maxes(3) = max([Table.SubCooled.v; Table.SuperHeat.v]);

    %u
    maxes(4) = max([Table.SubCooled.u; Table.SuperHeat.u]);

    %h
    maxes(5) = max([Table.SubCooled.h; Table.SuperHeat.h]);

    %s
    maxes(6) = max([Table.SubCooled.s; Table.SuperHeat.s]);

    %x
    maxes(7) = 1;


    %P
    mins(1) = min([Table.SubCooled.P; Table.Sat.P; Table.SuperHeat.P]);

    %T
    mins(2) = min([Table.SubCooled.T; Table.Sat.T; Table.SuperHeat.T]);

    %v
    mins(3) = min([Table.SubCooled.v; Table.SuperHeat.v]);

    %u
    mins(4) = min([Table.SubCooled.u; Table.SuperHeat.u]);

    %h
    mins(5) = min([Table.SubCooled.h; Table.SuperHeat.h]);

    %s
    mins(6) = min([Table.SubCooled.s; Table.SuperHeat.s]);

    %x
    mins(7) = 0;

    end
    
    bool = false; %default

    if Value1 < mins(ind1) || Value1 > maxes(ind1)
        fprintf("Value out of range: %f", Value1)
        bool = true;
    end

    if Value2 < mins(ind2) || Value2 > maxes(ind2)
        fprintf("Value out of range: %f", Value2)
        bool = true;
    end
    

    criticals = zeros(size(allProperties));
    criticals(1) = critical.P;
    criticals(2) = critical.T;
    criticals(3) = critical.v;
    criticals(4) = critical.u;
    criticals(5) = critical.h;
    criticals(6) = critical.s;
    criticals(7) = 0; %quality doesn't have a critical value


    % Supercritical check
    if Value1 > criticals(ind1) && (ind1 ~=7 && ind1 ~=3)
        fprintf("Value Supercritical': %f", Value1)
        bool = true;
    end

    if Value2 > criticals(ind2) && (ind2 ~=7 && ind2 ~=3)
        fprintf("Value Supercritical': %f", Value2)
        bool = true;
    end






end %end func