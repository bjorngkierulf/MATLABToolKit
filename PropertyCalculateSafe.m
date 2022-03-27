function [PropertyData,Out] = PropertyCalculateSafe(Prop1,Value1,Prop2,Value2,Table,critical)
% This function is partially copied from the main code, but uses new
% bounded functions, orders the input properties, and is robust to
% subcooled data being unavailable

%Sort input properties
[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2);
%sorts into order: {'P','T','v','u','h','s','x'}
%fprintf("HERE")

%Detect the state (subcooled, mixture, superheated) of the input data, but
%determine the properties later on
SampleData = StateDetectSafe(Prop1,Value1,Prop2,Value2,Table,critical);
State = SampleData.State;

useIncompressible = true;

stateLabels = {'Subcooled liquid', 'L-V mix', 'Superheated vapor', 'Incompressible liquid'};


switch State
    case 'Saturated'

        if strcmp(Prop1,'x')
            quality = Value1;
            notQuality = Value2;
            otherProp = Prop2;

        elseif strcmp(Prop2,'x')
            quality = Value2;
            notQuality = Value1;
            otherProp = Prop1;

        else %quality x is neither prop1 nor prop2, so call SaturatedAll function to calculate it
            Out = SaturatedAll(Prop1,Value1,Prop2,Value2,Table);
            quality = Out.x; %could redo this to give just x ... idk
            %choice here is arbitrary
            otherProp = Prop1;
            notQuality = Value1;

        end

        SatState = XSaturated(quality,otherProp,notQuality,Table);
        PropertyData = {'Saturated',SatState.P,SatState.T,SatState.v,SatState.u,SatState.h,SatState.s,SatState.x};

    case 'SuperHeat'
        SuperState = SuperHeatAll(Prop1,Value1,Prop2,Value2,Table,0);
        PropertyData = {stateLabels{3},SuperState.P,SuperState.T,SuperState.v,SuperState.u,SuperState.h,SuperState.s,'N/A'};

    case 'SubCooled'
        %Needs to be robust for the R134a case where there is no subcooled
        %liquid data

        if isempty(Table.SubCooled)
            %this means that the variable Table.SubCooled always must be
            %assigned, even if empty, at table generation
            fprintf("Subcooled data is not available")

            if useIncompressible
                %fprintf("Using incompressible assumption")
                IcoState = Incompressible(Prop1,Value1,Prop2,Value2,Table);
                PropertyData = {stateLabels{4},IcoState.P,IcoState.T,IcoState.v,IcoState.u,IcoState.h,IcoState.s,'N/A'};

            else

            PropertyData = {'Subcooled Data Unavailable' 0 0 0 0 0 0 0}; %dumb but it works

            end

        else
            fprintf("Subcooled data exists")
            SubState = SubCooledAll(Prop1,Value1,Prop2,Value2,Table);
            PropertyData = {stateLabels{1},SubState.P,SubState.T,SubState.v,SubState.u,SubState.h,SubState.s,'N/A'};

        end

end

%assign specific state name if quality is exactly 0 or 1
if strcmp(State,'Saturated')

    if SatState.x == 1
        PropertyData{1} = 'Saturated Vapor';
    elseif SatState.x ==0
        PropertyData{1} = 'Saturated Liquid';
    else
        PropertyData{1} = stateLabels{2};
    end

end

%out = PropertyData;
Out.State = PropertyData{1};
Out.P = PropertyData{2};
Out.T = PropertyData{3};
Out.v = PropertyData{4};
Out.u = PropertyData{5};
Out.h = PropertyData{6};
Out.s = PropertyData{7};
Out.x = PropertyData{8};

end %end function