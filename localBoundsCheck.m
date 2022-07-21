function [localMin,localMax] = localBoundsCheck(Prop1,Value1,Table,Critical,debug)
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
%this should be predicated on the value being between the triple point and
%the critical point

switch Prop1
    case 'P'
        satValues = Table.Sat.P;
        couldBeSupercrit = true;
    case 'T'
        satValues = Table.Sat.T;
        couldBeSupercrit = true;
    case 'v'
        satValues = Table.Sat.vf;
        couldBeSupercrit = false;
    case 'u'
        satValues = Table.Sat.uf;
        couldBeSupercrit = false;
    case 'h'
        satValues = Table.Sat.hf;
        couldBeSupercrit = false;
    case 's'
        satValues = Table.Sat.sf;
        couldBeSupercrit = false;
end


if Value1 > min(satValues) && ~(Value1 > Critical.(Prop1) && couldBeSupercrit)
    %its only supercrit if input is pressure or temperature. Otherwise it
    %is unknown
    %value is within mixture range, add mins and maxes

    if strcmp(Prop1,'P') || strcmp(Prop1,'T')
        [~,satF] = PropertyCalculateSafe(Prop1,Value1,'x',0,Table,Critical);
        [~,satG] = PropertyCalculateSafe(Prop1,Value1,'x',1,Table,Critical);

        % satF = XSaturated(0,Prop1,Value1,Table);%,Critical);
        % satG = XSaturated(1,Prop1,Value1,Table);%,Critical);


        NewTable.P = satF.P;
        NewTable.T = satF.T;
        NewTable.v = [satF.v,satG.v];
        NewTable.s = [satF.s,satG.s];
        NewTable.u = [satF.u,satG.u];
        NewTable.h = [satF.h,satG.h];

        %remove zeros that can come from property calculate via out of bounds

        for i = 1:length(fn)
            if debug
                a = NewTable.(fn{i})
            end
            NewTable.(fn{i}) = a(a~=0);
            if debug
                a = NewTable.(fn{i})
            end
            maxes.(fn{i}) = [maxes.(fn{i}), max(NewTable.(fn{i}))];
            mins.(fn{i}) = [mins.(fn{i}), min(NewTable.(fn{i}))];
        end

    elseif strcmp(Prop1,'v') || strcmp(Prop1,'s') || strcmp(Prop1,'u') || strcmp(Prop1,'h')

        switch Prop1 %only pull the values for which the input variable is between saturated liquid and vapor values
            case 'v'
                validInds = find(Value1 >= Table.Sat.vf & Value1 <= Table.Sat.vg);
            case 's'
                validInds = find(Value1 >= Table.Sat.sf & Value1 <= Table.Sat.sg); %apparently single & can do vector equals, double && is for a single value. TIL
            case 'u'
                validInds = find(Value1 >= Table.Sat.uf & Value1 <= Table.Sat.ug);
            case 'h'
                validInds = find(Value1 >= Table.Sat.hf & Value1 <= Table.Sat.hg);
        end
        NewTable.P = Table.Sat.P(validInds);
        NewTable.T = Table.Sat.T(validInds);
        NewTable.v = [Table.Sat.vf(validInds),Table.Sat.vg(validInds)];
        NewTable.s = [Table.Sat.sf(validInds),Table.Sat.sg(validInds)];
        NewTable.u = [Table.Sat.uf(validInds),Table.Sat.ug(validInds)];
        NewTable.h = [Table.Sat.hf(validInds),Table.Sat.hg(validInds)];

        for i = 1:length(fn)
            maxes.(fn{i}) = [maxes.(fn{i}), max(NewTable.(fn{i}))];
            mins.(fn{i}) = [mins.(fn{i}), min(NewTable.(fn{i}))];
        end
    else
        fprintf("\nInvalid property: " + Prop1)
    end

else
    %add nothing to mins and maxes struct

end

if debug
    fprintf("\nSaturated:")
    mins
    maxes
end
clear('NewTable')

%pause


%% then look at subcooled liquid
if ~isempty(Table.SubCooled) && ~strcmp(Prop1,'P')

    if strcmp(Prop1,'P') %typical method doesn't work for pressure

        PVec = unique(Table.SubCooled.P);

        if Value1 > min(PVec) && Value1 < max(PVec)
            %value is within range
            PVec = unique(Table.SubCooled.P);
            NewTable.P = PVec;
            %find the index on either side of the input pressure
            lowerInd = find(PVec < Value1,1,'last');
            upperInd = find(PVec > Value1,1,'first');
            indRangeLower = find(Table.SubCooled.P==PVec(lowerInd));
            indRangeUpper = find(Table.SubCooled.P==PVec(upperInd));


            %a = Table.SubCooled.T(indRangeLower)
            %             %interpolate values between those two
            %             NewTable.T = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SubCooled.T(indRangeLower)';Table.SubCooled.T(indRangeUpper)'],Value1,'linear','extrap')
            %             NewTable.v = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SubCooled.v(indRangeLower)';Table.SubCooled.v(indRangeUpper)'],Value1,'linear','extrap')
            %             NewTable.u = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SubCooled.u(indRangeLower)';Table.SubCooled.u(indRangeUpper)'],Value1,'linear','extrap')
            %             NewTable.h = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SubCooled.h(indRangeLower)';Table.SubCooled.h(indRangeUpper)'],Value1,'linear','extrap')
            %             NewTable.s = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SubCooled.s(indRangeLower)';Table.SubCooled.s(indRangeUpper)'],Value1,'linear','extrap')
            %

            %upper range is higher pressure -> lower volume, entropy, u, h
            %lower range is lower pressure -> lower temperature
            NewTable.T = Table.SubCooled.T(indRangeLower);
            NewTable.v = Table.SubCooled.v(indRangeUpper);
            NewTable.u = Table.SubCooled.u(indRangeUpper);
            NewTable.h = Table.SubCooled.h(indRangeUpper);
            NewTable.s = Table.SubCooled.s(indRangeUpper);

            %Ind1 = find(Table.SubCooled.P == PVec(i));
        else
            %value is out of range, add nothing to the min or max
            %PVec = [];
            NewTable.P = [];
            NewTable.T = [];
            NewTable.v = [];
            NewTable.u = [];
            NewTable.h = [];
            NewTable.s = [];
        end

        for i = 1:length(fn)
            maxes.(fn{i}) = [maxes.(fn{i}), max(NewTable.(fn{i}))];
            mins.(fn{i}) = [mins.(fn{i}), min(NewTable.(fn{i}))];
        end

        %elseif strcmp(Prop1,'s')
        %add nothing to mins and maxes. it will end at saturation line

    else

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
                if debug
                    fprintf("\nLocally out of bounds, data discarded")
                end
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




end

if debug
    fprintf("\nSubcooled:")
    mins
    maxes

    clear('NewTable')
end


%% then look at superheated

if strcmp(Prop1,'P') %typical method doesn't work for pressure
    PVec = unique(Table.SuperHeat.P);

    if Value1 > min(PVec) && Value1 < max(PVec)
        PVec = unique(Table.SuperHeat.P);
        NewTable.P = PVec;

        %value is within range
        %find the index on either side of the input pressure
        lowerInd = find(PVec < Value1,1,'last');
        upperInd = find(PVec > Value1,1,'first');
        indRangeLower = find(Table.SuperHeat.P==PVec(lowerInd));
        indRangeUpper = find(Table.SuperHeat.P==PVec(upperInd));

        if debug
            fprintf("\nlowerInd=%f, upperInd=%f, indRangeLower=%f, indRangeUpper=%f",lowerInd,uppwerInd,indRangeLower,indRangeUpper)
        end

        %         a = Table.SuperHeat.T(indRangeLower)
        %         %interpolate values between those two
        %         NewTable.T = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SuperHeat.T(indRangeLower)';Table.SuperHeat.T(indRangeUpper)'],Value1,'linear','extrap')
        %         NewTable.v = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SuperHeat.v(indRangeLower)';Table.SuperHeat.v(indRangeUpper)'],Value1,'linear','extrap')
        %         NewTable.u = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SuperHeat.u(indRangeLower)';Table.SuperHeat.u(indRangeUpper)'],Value1,'linear','extrap')
        %         NewTable.h = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SuperHeat.h(indRangeLower)';Table.SuperHeat.h(indRangeUpper)'],Value1,'linear','extrap')
        %         NewTable.s = interp1([PVec(lowerInd),PVec(upperInd)],[Table.SuperHeat.s(indRangeLower)';Table.SuperHeat.s(indRangeUpper)'],Value1,'linear','extrap')

        %Ind1 = find(Table.SuperHeat.P == PVec(i));

        %upper range is higher pressure -> lower volume, entropy, u, h
        %lower range is lower pressure -> lower temperature
        NewTable.T = Table.SuperHeat.T(indRangeLower);
        NewTable.v = Table.SuperHeat.v(indRangeUpper);
        NewTable.u = Table.SuperHeat.u(indRangeUpper);
        NewTable.h = Table.SuperHeat.h(indRangeUpper);
        NewTable.s = Table.SuperHeat.s(indRangeUpper);

        if debug
            b = NewTable.T
            b = NewTable.v
            b = NewTable.u
            b = NewTable.h
            b = NewTable.s
        end


    else
        %value is out of range, add nothing to the min or max
        PVec = [];
        NewTable.P = [];
        NewTable.T = [];
        NewTable.v = [];
        NewTable.u = [];
        NewTable.h = [];
        NewTable.s = [];
    end

else


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
            if debug
                fprintf("\nLocally out of bounds, data discarded")
            end
            NewTable.P(i) = 0;
        else
            %b = Table.SuperHeat.s(Ind1)

            NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind1),Value1,'linear','extrap');
            NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind1),Value1,'linear','extrap');
            NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind1),Value1,'linear','extrap');
            NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind1),Value1,'linear');
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

end


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

if debug
    fprintf("\nSuperheated:")
    mins
    maxes
end

clear('NewTable')

%% then synthesize for the absolute max and min of each value
for i = 1:length(fn)
    localMax.(fn{i}) = max(maxes.(fn{i}));
    localMin.(fn{i}) = min(mins.(fn{i}));
end

end
