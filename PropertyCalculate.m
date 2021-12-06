function Out = PropertyCalculate(Prop1,Value1,Prop2,Value2,Table)
%This function is copied in it's interety from the main code, in the
%calculate button pushed callback function


% State Identification
if strcmp(Prop1,'x') || strcmp(Prop2,'x')
    State = 'Saturated';
else
    SampleData= StateDetect(Prop1,Value1,Prop2,Value2,Table);
    State = SampleData.State;
end


switch State

    case 'Saturated'

        if strcmp(Prop1,'x') || strcmp(Prop2,'x')
            if strcmp(Prop1,'x')
                SatState = XSaturated(Value1,Prop2,Value2,Table);
            else
                SatState = XSaturated(Value2,Prop1,Value1,Table);
            end
            PropertyData = {'Saturated',SatState.P,SatState.T,SatState.v,SatState.u,SatState.h,SatState.s,SatState.x};
        else
            SatState = StateDetect(Prop1,Value1,Prop2,Value2,Table);
            PropertyData = {'Saturated',SatState.P,SatState.T,SatState.v,SatState.u,SatState.h,SatState.s,SatState.x};

        end

    case 'SuperHeat'

        if strcmp(Prop1,'P') || strcmp(Prop2,'P')
            if strcmp(Prop1,'P')
                SuperState = SuperHeat(Value1,Prop2,Value2,Table);
            else
                SuperState = SuperHeat(Value2,Prop1,Value1,Table);
            end
            PropertyData = {'SuperHeat',SuperState.P,SuperState.T,SuperState.v,SuperState.u,SuperState.h,SuperState.s,'N/A'};
        else
            SuperState = SuperHeatR(Prop1,Value1,Prop2,Value2,Table);
            PropertyData = {'SuperHeat',SuperState.P,SuperState.T,SuperState.v,SuperState.u,SuperState.h,SuperState.s,'N/A'};
        end

    case 'SubCooled'

        if strcmp(Prop1,'P') || strcmp(Prop2,'P')
            if strcmp(Prop1,'P')
                SubState = SubCooled(Value1,Prop2,Value2,Table);
            else
                SubState = SubCooled(Value2,Prop1,Value1,Table);
            end
            PropertyData = {'SubCooled',SubState.P,SubState.T,SubState.v,SubState.u,SubState.h,SubState.s,'N/A'};
        else
            SubState = SubCooledR(Prop1,Value1,Prop2,Value2,Table);
            PropertyData = {'SubCooled',SubState.P,SubState.T,SubState.v,SubState.u,SubState.h,SubState.s,'N/A'};
        end

end

if strcmp(State,'Saturated')

    if SatState.x == 1
        PropertyData{1} = 'Saturated Vapor';
    elseif SatState.x ==0
        PropertyData{1} = 'Saturated Liquid';
    else
        PropertyData{1} = 'Mixure';
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