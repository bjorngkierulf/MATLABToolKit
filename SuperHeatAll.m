function SuperState = SuperHeatAll(Prop1,Value1,Prop2,Value2,Table,Critical,debug)

%MAKE IT A SCRIPT
%clc; clear; close all;

debug = true;

%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};
% 
% %Prop1
% %Prop2
% 
% 
% Prop1 = 'v';
% Value1 = .8123;
% Prop2 = 'T';
% Value2 = 140;
% % Prop1 = 'P';
% % Value1 = 2;
% 
% 
% [Table,~] = GenTableNew();

[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder);
%this allows the interpolation code to be further generalized

if debug
    fprintf("\nDebug Info for superheated")
    fprintf("\nProp1= " + Prop1 + ", Value1= %f, Prop2= " + Prop2 + ", Value2= %f",Value1,Value2);
end

%initialize
PVec = unique(Table.SuperHeat.P);
NewTable.P = PVec;
NewTable.T = zeros(size(PVec));
NewTable.v = zeros(size(PVec));
NewTable.u = zeros(size(PVec));
NewTable.h = zeros(size(PVec));
NewTable.s = zeros(size(PVec));

switch Prop1

    case 'T'
        Value1InterpArray = Table.SuperHeat.T;

    case 'v'
        Value1InterpArray = Table.SuperHeat.v;

    case 'u'
        Value1InterpArray = Table.SuperHeat.u;

    case 'h'
        Value1InterpArray = Table.SuperHeat.h;

    case 's'
        Value1InterpArray = Table.SuperHeat.s;

end

%general code:
for i = 1:numel(PVec)
    %find applicable rows indices in the superheated tables
    Ind1 = find(Table.SuperHeat.P == PVec(i));
    a = Value1InterpArray(Ind1);

    %min(a)
    %max(a)

    if Value1 > max(a) || Value1 < min(a)
%         if nonrobust
% 
%             %min(a)
%             %max(a)
% 
%             NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind1),Value1,'linear','extrap');
%             NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind1),Value1,'linear','extrap');
%             NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind1),Value1,'linear','extrap');
%             NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind1),Value1,'linear','extrap');
%             NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind1),Value1,'linear','extrap');
%             fprintf("\nOut of bounds, data kept")
%         else
            %Value1
            %min(a)
            %max(a)

            fprintf("\nLocally out of bounds, data discarded")
            NewTable.P(i) = 0;
%         end

    else
        NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind1),Value1,'linear','extrap');
        NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind1),Value1,'linear','extrap');
        NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind1),Value1,'linear','extrap');
        NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind1),Value1,'linear','extrap');
        NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind1),Value1,'linear','extrap');
    end

end

%remove zeroes
NewTable.T = NewTable.T(NewTable.P~=0);
NewTable.v = NewTable.v(NewTable.P~=0);
NewTable.h = NewTable.h(NewTable.P~=0);
NewTable.s = NewTable.s(NewTable.P~=0);
NewTable.u = NewTable.u(NewTable.P~=0);
NewTable.P = NewTable.P(NewTable.P~=0);


switch Prop2

    case 'T'
        Value2InterpArray = NewTable.T;

    case 'v'
        Value2InterpArray = NewTable.v;

    case 'u'
        Value2InterpArray = NewTable.u;

    case 'h'
        Value2InterpArray = NewTable.h;

    case 's'
        Value2InterpArray = NewTable.s;

    case 'P'
        Value2InterpArray = NewTable.P;
    otherwise
        fprintf("Unrecognized property")

end

%debug - a and b should always have the same length
%our break case occurs when the NewTable.xx each only have one element
%a = NewTable.T
%b = NewTable.v

%test point for R134a is .8 bar, -30 C

%we need a better way to detect for using this, because this only works on
%the lowest temperature range in the superheated table

%this works for input P, T
%what if the inputs are P, v or T, v (both necessary for iso-lines
% a = NewTable.P
% b = NewTable.v
% c = NewTable.T

switch Prop2
    case 'T'
        limitArray = NewTable.T
        %breakcase = sum(limitArray > Value2) < 1
    case 'P'
        limitArray = NewTable.P
        %breakcase = sum(limitArray > Value2) < 1
    case 'v'
        limitArray = NewTable.v
        %breakcase = sum(limitArray > Value2) < 1
    case 's'
        limitArray = NewTable.s;
        %breakcase = 0;%sum(limitArray > Value1) < 1
    case 'u'
        limitArray = NewTable.u;
        %breakcase = 0;%sum(limitArray > Value1) < 1
    case 'h'
        limitArray = NewTable.h;
        %breakcase = 0;%sum(limitArray > Value1) < 1
end

if debug
    Value1InterpArray
    Value2InterpArray
    limitArray
end

if Value2 > max(Value2InterpArray) || Value2 < min(Value2InterpArray)
    fprintf("Second property out of range: %f",Value2)
end

if Value2 <= max(limitArray) && Value2 >= min(limitArray) %if Value2 is on the array that we'd like to interpolate with
    %inclusive in the case of exact match
    breakcase = 0
else
    breakcase = 1
    fprintf("Data near saturation, using alternate algorithm")
end

%prop2 general code for real
if breakcase %does this break for u, h, v, s cases?
    SuperState = breakCaseSuperHeat(Prop1,Value1,Prop2,Value2,Table,Critical)
    return
    %     if ~nonrobust %guarantees that we don't cause recursion
%         Prop1
%         Value1
%         Prop2
%         Value2
%         NewTable
%         fprintf("break case")
% 
%         SuperState = SuperHeatAll(Prop1,Value1,Prop2,Value2,Table,1);%nonrobust
%     end
else

SuperState.T = interp1(Value2InterpArray,NewTable.T,Value2,'linear','extrap');
SuperState.P = interp1(Value2InterpArray,NewTable.P,Value2,'linear','extrap');
SuperState.v = interp1(Value2InterpArray,NewTable.v,Value2,'linear','extrap');
SuperState.u = interp1(Value2InterpArray,NewTable.u,Value2,'linear','extrap');
SuperState.h = interp1(Value2InterpArray,NewTable.h,Value2,'linear','extrap');
SuperState.s = interp1(Value2InterpArray,NewTable.s,Value2,'linear','extrap');

%This can be generalized because there isn't an issue with passing
%something an interpolation where the output array is all the same. Ie if
%pressure is value2, both Value2InterpArray and NewTable.P are equal. Thus
%by asking for interpolation at value2 you get value2 back

end


end