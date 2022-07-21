function [outOfBounds,supercritical] = absBoundsCheck(Prop1,Value1,Prop2,Value2,Table,Critical,debug)
% function assigns two bools, global out of bounds and if the fluid is
% supercritical

outOfBounds = false; %default
supercritical = 0; %default

[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,[],debug);
%inputs should already be sorted but let's do it again

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
    mins(3) = min([Table.Sat.vf;Table.SuperHeat.v]);

    %u
    mins(4) = min([Table.Sat.uf;Table.SuperHeat.u]);

    %h
    mins(5) = min([Table.Sat.hf;Table.SuperHeat.h]);

    %s
    mins(6) = min([Table.Sat.sf;Table.SuperHeat.s]);

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

if Value1 < mins(ind1) || Value1 > maxes(ind1)
    if debug
        fprintf("Value out of range: %f", Value1)
    end

    outOfBounds = true;
end

if Value2 < mins(ind2) || Value2 > maxes(ind2)
    if debug
        fprintf("Value out of range: %f", Value2)
    end
    outOfBounds = true;
end


criticals = zeros(size(allProperties));
criticals(1) = Critical.P;
criticals(2) = Critical.T;
criticals(3) = Critical.v;
criticals(4) = Critical.u;
criticals(5) = Critical.h;
criticals(6) = Critical.s;
criticals(7) = 0; %quality doesn't have a critical value


if debug
fprintf('\nValue1=%f, Value2=%f, Ind1=%f, Ind2=%f',Value1,Value2,ind1,ind2)
end

% for the purpose of this, I am defining supercritical as - either temp or
% press is above supercritical threshold. Then, if it is on the vapor side,
% ie data likely to be in superheated vapor tables, return supercritical =
% 1, otherwise if data likely to be in subcooled liquid tables, return
% supercritical = 0
%criticals(ind2)
if ind2 == 7 %ind2 is quality, x. it should not be supercritical
    if Value1 > criticals(ind1)
        if debug
            fprintf("ERROR: fluid property supercritical, but quality was specified")
        end
        outOfBounds = 1;
        supercritical = 0;
    else
        supercritical = 0;
    end
else %only if ind2 is not quality, do the other things

    if ind1 == 3 || ind1 == 6 %ind1 is v or s
        %only look at value 2
        if Value2 > criticals(ind2)
            %it is supercritical, check which side
            if Value1 >= criticals(ind1)
                %vapor side, data likely in vapor tables
                supercritical = 1;
            else
                %liquid side, data likely in subcooled tables
                supercritical = 2;
            end
        else
            supercritical = 0;
        end
    elseif ind2 == 3 || ind2 == 6
        %only look at value 1
        if Value1 > criticals(ind1)
            %it is supercritical, check which side
            if Value2 >= criticals(ind2)
                %vapor side, data likely in vapor tables
                supercritical = 1;
            else
                %liquid side, data likely in subcooled tables
                supercritical = 2;
            end
        end
    else
        %if neither is v or s
        if Value1 > criticals(ind1) || Value2 > criticals(ind2)
            %if either is supercritical, it is supercritical. But what side is it on?
            if Value1 > criticals(ind1) && Value2 > criticals(ind2)
                %both supercritical, data likely on vapor side
                supercritical = 1;
            else
                %only one supercritical, the other not
                %.. to be implemented. for now assume data on vapor side
                supercritical = 1;

            end

        end
    end
end

end %end func