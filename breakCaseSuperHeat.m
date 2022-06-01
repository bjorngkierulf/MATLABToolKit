function SuperState = breakCaseSuperHeat(Prop1,Value1,Prop2,Value2,Table)
%break case is detected when there is less than 1 (should it be 2?) values
%in the new table that are within range of the Value2
%really we should check that there are at least two values in newTable,
%then check if Value2 is between them. Then call this function


% %MAKE IT A SCRIPT
% clc; clear; close all;
%

%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};
%
%Prop1
%Prop2


% Prop1 = 'P';
% Value1 = 0.5;
% Prop2 = 'T';
% Value2 = 85;

% Prop1 = 'T';
% Value1 = 85;
% Prop2 = 'v';
% Value2 = 3.4499;

% [Table,~] = GenTableNew();

%% first section
[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder);

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

%%
if ~(strcmp(Prop1,'T') && strcmp(Prop2,'v')) %works
    %% working P input, T or v input

    PInput = Value2;
    xInput = Value1; %temp


    %NewTable.P should only have one element
    %actually it could have many values. Is taking the maximum justified? I
    %think so at least for superheated, probably not for subcooled

    %NewTable.P should only have the element where the pressure was not out
    %of bounds


    switch Prop1
        case 'T'
            firstIsoBarInd = find(PVec==max(NewTable.P)); %index of the lower isobar
            firstIsoBarValue = PVec(firstIsoBarInd)
            %secondIsoBarInd = firstIsoBarInd + 1; %always true?
            secondIsoBarInd = firstIsoBarInd + 1; %always true?

        case 'v'
            firstIsoBarInd = find(PVec==min(NewTable.P)); %index of the lower isobar
            %firstIsoBarValue = PVec(firstIsoBarInd)
            %for v, we get the pressures above the one we want, because it is
            %looking for value on the table is less than value input (volume
            %decreases with increasing temperature)

            %really what we need to do is swap them as well
            secondIsoBarInd = firstIsoBarInd;
            %secondIsoBarValue = firstIsoBarValue;

            %unused? no it is
            firstIsoBarInd = firstIsoBarInd - 1
            %firstIsoBarInd = firstIsoBarInd + 1;

            firstIsoBarValue = PVec(firstIsoBarInd) %resets this
            %secondIsoBarInd = firstIsoBarInd - 1; %always true?



        otherwise
            fprintf("must be T or v")
    end
    secondIsoBarValue = PVec(secondIsoBarInd)


    %the isotherm is based on the first temperature (saturation?) of the second isobar
    %indices in table data for the second isobar pressure
    Ind1 = find(Table.SuperHeat.P == secondIsoBarValue);
    secondIsoBarTemps = Table.SuperHeat.T(Ind1)
    secondIsoBarVols = Table.SuperHeat.v(Ind1)
    secondIsoBarSpecEntropys = Table.SuperHeat.s(Ind1)

    isoTherm = secondIsoBarTemps(1) % is it always the first (lowest) temperature here?

    Ind2 = find(Table.SuperHeat.P == firstIsoBarValue);
    firstIsoBarTemps = Table.SuperHeat.T(Ind2)
    firstIsoBarVols = Table.SuperHeat.v(Ind2)
    firstIsoBarSpecEntropys = Table.SuperHeat.s(Ind2)

    %we now have temperature and specific volume arrays for the first and
    %second isobars

    %now we calcuate the specific volume at each of the points on the
    %isobar
    secondIsoBarVol = secondIsoBarVols(1); %should just be the first?
    secondIsoBarSpecEntropy = secondIsoBarSpecEntropys(1);

    firstIsoBarVol = interp1(firstIsoBarTemps,firstIsoBarVols,isoTherm,'linear','extrap');
    firstIsoBarSpecEntropy = interp1(firstIsoBarTemps,firstIsoBarSpecEntropys,isoTherm,'linear','extrap');
    %where along the first isobar does it intersect with the isotherm
    %created by the second isobar

    %next we can calculate the specific volume at the isotherm temperature, for
    %an arbitrary pressure between the two isobars


    qVIsotherm = interp1([firstIsoBarValue,secondIsoBarValue],[firstIsoBarVol,secondIsoBarVol],PInput,'linear','extrap')
    qSIsotherm = interp1([firstIsoBarValue,secondIsoBarValue],[firstIsoBarSpecEntropy,secondIsoBarSpecEntropy],PInput,'linear','extrap')

    %next we can interpolate for saturation data to get the saturation
    %properties for the isobar corresponding to the input pressure
    %we need to find saturation based on pressure and not based on
    %temperature, even if we are given temperature. Because we are
    %explicitly looking at the variation along an isobar of the input
    %pressure, using the other variables to find the position along said
    %isobar
    qTSat = interp1(Table.Sat.P,Table.Sat.T,PInput,'linear','extrap')
    qVSat = interp1(Table.Sat.P,Table.Sat.vg,PInput,'linear','extrap')
    qSSat = interp1(Table.Sat.P,Table.Sat.sg,PInput,'linear','extrap')



    if strcmp(Prop1,'T')
        %now we interpolate between the saturation for the queried isobar, and
        %the values on that isobar at the isotherm temperature. This should be
        %locally linear
        qV = interp1([qTSat,isoTherm],[qVSat,qVIsotherm],xInput,'linear','extrap');
        qS = interp1([qTSat,isoTherm],[qSSat,qSIsotherm],xInput,'linear','extrap')

        %then getting all the other properties u, v, h, s is trivial

        SuperState.T = Value1;
        SuperState.P = PInput;
        SuperState.v = qV;
        SuperState.u = 0;
        SuperState.h = 0;
        SuperState.s = qS;

    elseif strcmp(Prop1,'v')
        qT = interp1([qVSat,qVIsotherm],[qTSat,isoTherm],xInput,'linear','extrap'); %double check on this but I think it just flips
        %qS = interp1([qTSat,isoTherm],[qSSat,qSIsotherm],xInput,'linear','extrap')
        qS = interp1([qVSat,qVIsotherm],[qSSat,qSIsotherm],xInput,'linear','extrap')

        %then getting all the other properties u, v, h, s is trivial

        SuperState.T = qT;
        SuperState.P = PInput;
        SuperState.v = Value1;
        SuperState.u = 0;
        SuperState.h = 0;
        SuperState.s = qS;


    else
        fprintf("s, h, u, properties not supported for this type of interpolation")
        %also fuck
    end



else %P is not an input, so we have T and v. Prop1 is T, Prop2 is v
    %%
    TInput = Value1
    vInput = Value2

    %selecting data is pretty similar to the P, v case because we are still
    %selecting values for NewTable based on comparing to values of v
    %   actually no it's more like T

    firstIsoBarInd = find(PVec==max(NewTable.P)); %index of the highest isobar
    firstIsoBarValue = PVec(firstIsoBarInd) %resets this

    Ind2 = find(Table.SuperHeat.P == firstIsoBarValue);
    firstIsoBarTemps = Table.SuperHeat.T(Ind2)
    firstIsoBarVols = Table.SuperHeat.v(Ind2)
    firstIsoBarSpecEntropys = Table.SuperHeat.s(Ind2)
    firstIsoBarSpecEntropyTInput = interp1(firstIsoBarTemps,firstIsoBarSpecEntropys,TInput,'linear')
    firstIsoBarVolTInput = interp1(firstIsoBarTemps,firstIsoBarVols,TInput,'linear')

    %we still need the values at the saturation point, but this time the
    %saturation point is defined by temperature
    qPSat = interp1(Table.Sat.T,Table.Sat.P,TInput,'linear')
    qVSat = interp1(Table.Sat.T,Table.Sat.vg,TInput,'linear')
    qSSat = interp1(Table.Sat.T,Table.Sat.sg,TInput,'linear')

    qP = interp1([qVSat,firstIsoBarVolTInput],[qPSat,firstIsoBarValue],vInput,'linear')
    qS = interp1([qVSat,firstIsoBarVolTInput],[qSSat,firstIsoBarSpecEntropyTInput],vInput,'linear')

    SuperState.P = qP;
    SuperState.T = TInput;
    SuperState.v = vInput;
    SuperState.u = 0;
    SuperState.h = 0;
    SuperState.s = qS;


end %end if switching between P input and not P input


end %function end