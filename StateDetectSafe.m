function Out = StateDetectSafe(Prop1,Value1,Prop2,Value2,Table,critical)

%this method of state detection works based on assuming that value1 is
%either a saturated liquid or saturated vapour property value. Then it
%finds the row in the saturation tables that corresponds to if it was a
%two phase mixture - this is one row if pressure or temperature is given.
%But multiple rows if something else is given, because it is necessary to
%look at both if it were saturated liquid and saturated vapour





%lets try to generalize this a bit further
%also, this should return all the properties P, T, s, u, h, x... but ONLY
%for liquid-vapour mixture. If it isn't LV mix, then those can be assigned
%as zero

%generalize first, then assess how difficult it would be to implement. If
%it would be a lot more code / complexity, just switch to using
%propertycalculatesafe everywhere




% clc; clear; close all;
% %
% Prop1 = 's';
% Value1 = 10.3;
% %Prop1 = 'P';
% %Value1 = 5;
%
% %Prop2 = 's';
% %Value2 = 1;
% %
% % Prop1 = 'h';
% % Value1 = 855;
%
% % Prop2 = 's';
% % Value2 = 3.2;
%
% Prop2 = 'T';
% Value2 = 200;
%
%
% [Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2);
%
%
% [Table,critical] = GenTableNew();
%

if absBoundsCheck(Prop1,Value1,Prop2,Value2,Table,critical)
    %print statement is in the function, for abs bounds and supercritical
    %fprintf("Invalid Input")
end


%now incorrect
%this function computes the state as saturated, subcooled or superheated given prop 1,
%prop 2 as anything. This state detection works for any properties. But
%this function only assigns a value to out.h, out.s, etc. if the state is
%saturated liquid-vapour mixture. If the state is subcooled or superheated,
%then the properties u, h, s, etc must be computed in a later step by
%StateDetectUVHS()

% Exctracting Saturation Data
Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;
%Vfg = Table.Sat.vfg;
Uf = Table.Sat.uf;
Ug = Table.Sat.ug;
%Ufg = Table.Sat.ufg;
Hf = Table.Sat.hf;
Hg = Table.Sat.hg;
%Hfg = Table.Sat.hfg;
Sf = Table.Sat.sf;
Sg = Table.Sat.sg;
%Sfg = Table.Sat.sfg;


% First Independent Property
switch Prop1

    case 'P'
        Value1InterpArray = Press;

    case 'T'
        Value1InterpArray = Temp;

    case 'v'
        Value1InterpArrayUpper = Vg;
        Value1InterpArrayLower = Vf;

    case 'u'
        Value1InterpArrayUpper = Ug;
        Value1InterpArrayLower = Uf;

    case 'h'
        Value1InterpArrayUpper = Hg;
        Value1InterpArrayLower = Hf;

    case 's'
        Value1InterpArrayUpper = Sg;
        Value1InterpArrayLower = Sf;

    case 'x'
        %DOES NOT ASSIGN THE INTERP ARRAY  - THIS IS AN ISSUE
        if 0 <= Value1 && 1 >= Value1
            %both inclusive as 0 and 1 are valid
            Out.State = 'Saturated';
        else
            fprintf("Invalid input, quality should be between 0 and 1")
        end

end

%interp for the saturation data

%value1 is of the same unit / property as value1interparray. for instance
%the array will be 2bar, 4bar, 6bar, and the value will be 3.5bar

%Value1InterpArray
%Press

if strcmp(Prop1,'P') || strcmp(Prop1,'T')

    % Saturation Data
    SatState.P = interp1(Value1InterpArray,Press,Value1,'linear','extrap');
    SatState.TUpper = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
    SatState.TLower = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
    SatState.vf = interp1(Value1InterpArray,Vf,Value1,'linear','extrap');
    SatState.vg = interp1(Value1InterpArray,Vg,Value1,'linear','extrap');
    SatState.uf = interp1(Value1InterpArray,Uf,Value1,'linear','extrap');
    SatState.ug = interp1(Value1InterpArray,Ug,Value1,'linear','extrap');
    SatState.hf = interp1(Value1InterpArray,Hf,Value1,'linear','extrap');
    SatState.hg = interp1(Value1InterpArray,Hg,Value1,'linear','extrap');
    SatState.sf = interp1(Value1InterpArray,Sf,Value1,'linear','extrap');
    SatState.sg = interp1(Value1InterpArray,Sg,Value1,'linear','extrap');

else %neither property is P, T - UVHS section
    absLowerLimit = 0;
    absUpperLimit = 10^7; %idk large number, bad practice probably

    %interpolate for saturated liquid sf, vf properties
    if Value1 > min(Value1InterpArrayLower) && Value1 < max(Value1InterpArrayLower)
        SatState.TLower = interp1(Value1InterpArrayLower,Temp,Value1,'linear','extrap');
        SatState.vf = interp1(Value1InterpArrayLower,Vf,Value1,'linear','extrap');
        SatState.uf = interp1(Value1InterpArrayLower,Uf,Value1,'linear','extrap');
        SatState.hf = interp1(Value1InterpArrayLower,Hf,Value1,'linear','extrap');
        SatState.sf = interp1(Value1InterpArrayLower,Sf,Value1,'linear','extrap');
    else
        SatState.TLower = absLowerLimit;
        SatState.vf = absLowerLimit;
        SatState.uf = absLowerLimit;
        SatState.hf = absLowerLimit;
        SatState.sf = absLowerLimit;
    end
    
    %interpolate for saturated vapour sg, vg properties
    if Value1 > min(Value1InterpArrayUpper) && Value1 < max(Value1InterpArrayUpper)

        SatState.TUpper = interp1(Value1InterpArrayUpper,Temp,Value1,'linear','extrap');
        SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
        SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
        SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
        SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');

    elseif Value1 > min(Value1InterpArrayLower) && Value1 < max(Value1InterpArrayLower)
        %Value1InterpArrayUpper
        %Temp
        SatState.TUpper = interp1(Value1InterpArrayUpper,Temp,Value1,'linear','extrap');
        SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
        SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
        SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
        SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');

    else
        SatState.TUpper = absUpperLimit;
        SatState.vg = absUpperLimit;
        SatState.ug = absUpperLimit;
        SatState.hg = absUpperLimit;
        SatState.sg = absUpperLimit;

    end

end

%now do a prop2 switch
%P is not included as P will never be prop2
%and in fact is problematic if its prop 2 as well...

switch Prop2

    case 'T'
        Value2UpperLimit = SatState.TUpper;
        Value2LowerLimit = SatState.TLower;

    case 'v'
        Value2UpperLimit = SatState.vg;
        Value2LowerLimit = SatState.vf;

    case 'u'
        Value2UpperLimit = SatState.ug;
        Value2LowerLimit = SatState.uf;

    case 'h'
        Value2UpperLimit = SatState.hg;
        Value2LowerLimit = SatState.hf;

    case 's'
        Value2UpperLimit = SatState.sg;
        Value2LowerLimit = SatState.sf;

    case 'x'
        Value2UpperLimit = 1;
        Value2LowerLimit = 0;

        %SPECIAL TREATMENT?
        if 0 <= Value2 && 1 >= Value2
            %both inclusive as 0 and 1 are valid
            Out.State = 'Saturated';
        else
            fprintf("Invalid input, quality should be between 0 and 1")
        end

end

%then identifying the state is easy
% Identifying Phase State
if Value2 < Value2LowerLimit
    Out.State = 'SubCooled';
elseif Value2 > Value2UpperLimit
    Out.State = 'SuperHeat';
else
    Out.State = 'Saturated';
end


end %end func



