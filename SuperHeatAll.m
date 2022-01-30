function SuperState = SuperHeatAll(Prop1,Value1,Prop2,Value2,Table)

%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};

%Prop1
%Prop2


[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder);
                             %InputSort(Prop1,Value1,Prop2,Value2,order)
%fprintf("NOW HERE")

%this allows the interpolation code to be further generalized

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

firstOne = false;

%general code:
for i = 1:numel(PVec)
    %find applicable rows indices in the superheated tables
    Ind = find(Table.SuperHeat.P == PVec(i));
    a = Value1InterpArray(Ind);

    %min(a)
    %max(a)

    if Value1 > max(a) || Value1 < min(a)
        if firstOne
            firstOne = false;

            %min(a)
            %max(a)

            NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind),Value1,'linear','extrap');
            NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind),Value1,'linear','extrap');
            NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind),Value1,'linear','extrap');
            NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind),Value1,'linear','extrap');
            NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind),Value1,'linear','extrap');
            fprintf("\nOut of bounds, data kept")
        else
        %Value1
        %min(a)
        %max(a)

        fprintf("\nLocally out of bounds, data discarded")
        NewTable.P(i) = 0;
        end

    else
        NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind),Value1,'linear','extrap');
        NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind),Value1,'linear','extrap');
        NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind),Value1,'linear','extrap');
        NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind),Value1,'linear','extrap');
        NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind),Value1,'linear','extrap');
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

end

%Value2InterpArray

%prop2 general code for real
if Value2 > max(Value2InterpArray) || Value2 < min(Value2InterpArray)
    fprintf("Second property out of range: %f",Value2)
end

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