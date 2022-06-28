function [localMin,localMax] = localBoundsCheck(Prop1,Value1,Table,Critical)
    % determines the maximum and minimum of each value, given an input
    % value. Like what is the max v, s in the table for T = 150 C

%     Prop1 = 'v';
%     Value1 = 0.1;
%     [Table,Critical] = GenTableNew();
%     % initialize maxes and mins
    mins = struct('P',[],'T',[],'v',[],'s',[],'u',[],'h',[]);
    maxes = struct('P',[],'T',[],'v',[],'s',[],'u',[],'h',[]);

    fn = fieldnames(mins); %should equal maxes as well

%% first add a max and a min based on saturated liquid / vapor

NewTable.P = Table.Sat.P;
NewTable.T = Table.Sat.T;
NewTable.v = [Table.Sat.vf,Table.Sat.vg];
NewTable.s = [Table.Sat.sf,Table.Sat.sg];
NewTable.u = [Table.Sat.uf,Table.Sat.ug];
NewTable.h = [Table.Sat.hf,Table.Sat.hg];

for i = 1:length(fn)
%     maxes.(fn{i}) = [maxes.(fn{i}), max(NewTable.(fn{i}))];
    mins.(fn{i}) = [mins.(fn{i}), min(NewTable.(fn{i}))];
end

    mins
    maxes

    %% then look at subcooled liquid
    if ~isempty(Table.SubCooled)
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
    Ind1 = find(Table.SubCooled.P == PVec(i));
    a = Value1InterpArray(Ind1);

    %min(a)
    %max(a)

    if Value1 > max(a) || Value1 < min(a)
        fprintf("\nLocally out of bounds, data discarded")
        NewTable.P(i) = 0;
    else
        NewTable.T(i) = interp1(a,Table.SubCooled.T(Ind1),Value1,'linear','extrap');
        NewTable.v(i) = interp1(a,Table.SubCooled.v(Ind1),Value1,'linear','extrap');
        NewTable.h(i) = interp1(a,Table.SubCooled.h(Ind1),Value1,'linear','extrap');
        NewTable.s(i) = interp1(a,Table.SubCooled.s(Ind1),Value1,'linear','extrap');
        NewTable.u(i) = interp1(a,Table.SubCooled.u(Ind1),Value1,'linear','extrap');
    end

end

%remove zeroes
NewTable.T = NewTable.T(NewTable.P~=0);
NewTable.v = NewTable.v(NewTable.P~=0);
NewTable.h = NewTable.h(NewTable.P~=0);
NewTable.s = NewTable.s(NewTable.P~=0);
NewTable.u = NewTable.u(NewTable.P~=0);
NewTable.P = NewTable.P(NewTable.P~=0);

for i = 1:length(fn)
    maxes.(fn{i}) = [maxes.(fn{i}), max(NewTable.(fn{i}))];
    mins.(fn{i}) = [mins.(fn{i}), min(NewTable.(fn{i}))];
end

    end

    mins
    maxes

    %% then look at superheated
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
        fprintf("\nLocally out of bounds, data discarded")
        NewTable.P(i) = 0;
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

for i = 1:length(fn)
    maxes.(fn{i}) = [maxes.(fn{i}), max(NewTable.(fn{i}))];
    mins.(fn{i}) = [mins.(fn{i}), min(NewTable.(fn{i}))];
end
%specific maximum bound based on the maximum value of T in the new table
%(where it has been interpolated for v = v iso). If v = v iso is not in the
%P = Pvec(i), section of the table, then no T is added as that would be out
%of bounds

%the min and max of the property that was input will be equal to the input
%value. For example the max and min of v for v = 0.1 is 0.1

    %% then synthesize for the absolute max and min of each value
    for i = 1:length(fn)
    localMax.(fn{i}) = max(maxes.(fn{i}));
    localMin.(fn{i}) = min(mins.(fn{i}));
    end



end