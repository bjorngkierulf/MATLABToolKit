function SubState = SubCooledAll(Prop1,Value1,Prop2,Value2,Table)

%This entire function is copied and pasted from SuperHeatAll because they
%work the exact same. If you wanted to combine them into a single function
%that takes subcooled / superheated state as input that would work

%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};

[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder);

%this allows the interpolation code to be further generalized

%initialize
PVec = unique(Table.SubCooled.P);
NewTable.P = PVec;
NewTable.T = zeros(size(PVec));
NewTable.v = zeros(size(PVec));
NewTable.u = zeros(size(PVec));
NewTable.h = zeros(size(PVec));
NewTable.s = zeros(size(PVec));

switch Prop1

    case 'T'
        Value1InterpArray = Table.SubCooled.T;

    case 'v'   
        Value1InterpArray = Table.SubCooled.v;

    case 'u'
        Value1InterpArray = Table.SubCooled.u;

    case 'h'
        Value1InterpArray = Table.SubCooled.h;

    case 's'
        Value1InterpArray = Table.SubCooled.s;

end

%Value1InterpArray

firstOne = false;
%general code:
for i = 1:numel(PVec)
    %find applicable rows indices in the superheated tables
    Ind = find(Table.SubCooled.P == PVec(i));
    a = Value1InterpArray(Ind);
    %Table.SubCooled.v(Ind)
    

    if Value1 > max(a) || Value1 < min(a)

        if firstOne
            firstOne = false;
            NewTable.T(i) = interp1(a,Table.SubCooled.T(Ind),Value1,'linear','extrap');
            NewTable.v(i) = interp1(a,Table.SubCooled.v(Ind),Value1,'linear','extrap');
            NewTable.h(i) = interp1(a,Table.SubCooled.h(Ind),Value1,'linear','extrap');
            NewTable.s(i) = interp1(a,Table.SubCooled.s(Ind),Value1,'linear','extrap');
            NewTable.u(i) = interp1(a,Table.SubCooled.u(Ind),Value1,'linear','extrap');
            fprintf("\nOut of bounds, data kept")
        else
        %Value1
        %min(a)
        %max(a)

        fprintf("\nLocally out of bounds, data discarded")
        NewTable.P(i) = 0;
        end

        

    else
        NewTable.T(i) = interp1(a,Table.SubCooled.T(Ind),Value1,'linear','extrap');
        NewTable.v(i) = interp1(a,Table.SubCooled.v(Ind),Value1,'linear','extrap');
        NewTable.h(i) = interp1(a,Table.SubCooled.h(Ind),Value1,'linear','extrap');
        NewTable.s(i) = interp1(a,Table.SubCooled.s(Ind),Value1,'linear','extrap');
        NewTable.u(i) = interp1(a,Table.SubCooled.u(Ind),Value1,'linear','extrap');

        %b = NewTable.v
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

%debug
%Value2InterpArray

%prop2 general code for real
if Value2 > max(Value2InterpArray) || Value2 < min(Value2InterpArray)
    fprintf("Second property out of range: %f",Value2)
end

%Value2InterpArray

SubState.T = interp1(Value2InterpArray,NewTable.T,Value2,'linear','extrap');
SubState.P = interp1(Value2InterpArray,NewTable.P,Value2,'linear','extrap');
SubState.v = interp1(Value2InterpArray,NewTable.v,Value2,'linear','extrap');
SubState.u = interp1(Value2InterpArray,NewTable.u,Value2,'linear','extrap');
SubState.h = interp1(Value2InterpArray,NewTable.h,Value2,'linear','extrap');
SubState.s = interp1(Value2InterpArray,NewTable.s,Value2,'linear','extrap');

%This can be generalized because there isn't an issue with passing
%something an interpolation where the output array is all the same. Ie if
%pressure is value2, both Value2InterpArray and NewTable.P are equal. Thus
%by asking for interpolation at value2 you get value2 back

end