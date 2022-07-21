function SubState = SubCooledAll(Prop1,Value1,Prop2,Value2,Table,debug)

%This entire function is copied and pasted from SuperHeatAll because they
%work the exact same. If you wanted to combine them into a single function
%that takes subcooled / superheated state as input that would work

%debug = true;

%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};

[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder,debug);
%this allows the interpolation code to be further generalized

if debug
    fprintf("\nDebug Info for subcooled")
    fprintf("\nProp1= " + Prop1 + ", Value1= %f, Prop2= " + Prop2 + ", Value2= %f",Value1,Value2);
end

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

%general code:
for i = 1:numel(PVec)
    %find applicable rows indices in the superheated tables
    Ind = find(Table.SubCooled.P == PVec(i));
    a = Value1InterpArray(Ind);
    %Table.SubCooled.v(Ind)
    
    if Value1 > max(a) || Value1 < min(a)
        if debug
            fprintf("\nLocally out of bounds, data discarded")
        end
        NewTable.P(i) = 0;
    else
        NewTable.T(i) = interp1(a,Table.SubCooled.T(Ind),Value1,'linear','extrap');
        NewTable.v(i) = interp1(a,Table.SubCooled.v(Ind),Value1,'linear','extrap');
        NewTable.h(i) = interp1(a,Table.SubCooled.h(Ind),Value1,'linear','extrap');
        NewTable.s(i) = interp1(a,Table.SubCooled.s(Ind),Value1,'linear','extrap');
        NewTable.u(i) = interp1(a,Table.SubCooled.u(Ind),Value1,'linear','extrap');
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

switch Prop2
    case 'T'
        limitArray = NewTable.T;
        %breakcase = sum(limitArray > Value2) < 1
    case 'P'
        limitArray = NewTable.P;
        %breakcase = sum(limitArray > Value2) < 1
    case 'v'
        limitArray = NewTable.v;
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
    fprintf("\nValue1 Interp\n")
    Value1InterpArray

    fprintf("\nValue2 Interp\n")
    Value2InterpArray

    fprintf("\nLimit Array\n")
    limitArray
end

if ~isempty(limitArray) && (Value2 > max(Value2InterpArray) || Value2 < min(Value2InterpArray))
    if debug, fprintf("Second property out of range: %f",Value2); end
end

%before we compare to limitArray - the bigger break case for subcooled is
%if there simply isn't any data in range at all. Because the table starts
%so high of pressure
if isempty(limitArray) || Value2 > max(limitArray) || Value2 < min(limitArray) || (size(unique(limitArray),1) > 1)
    %not all the same to machine precision
    %inclusive in the case of exact match

    if debug
        fprintf("\nNo data available or value 2 out of bounds, using incompressible assumption")
    end
    %if it is not high enough pressure to be on the table, use saturated
    %liquid data. Pressure, if given, is going to be the second input, so just pass the first input here 
    %out = XSaturated(quality,otherProp,notQuality,Table)
    SubState = XSaturated(0,Prop1,Value1,Table);
    
    % set the two properties to their input values. This eliminates some
    % issues
    SubState.(Prop1) = Value1;
    SubState.(Prop2) = Value2;
%     if strcmp(Prop2,'P')
%         SubState.P = Value2;
%     else
%         fprintf("Interpolation poorly posed to calculate pressure, using saturation pressure at input conditions")
%     end
    return
end

if debug
    Value2InterpArray
    Value2
end

%prop2 general code for real
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