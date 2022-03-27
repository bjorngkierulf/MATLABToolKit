function Out = IsoLine(Prop,Value,Table,Critical,~,DebugPlot)
    % This function serves as a general iso-line creation tool, which will
    % be robust enough to handle iso T, P, v, and s lines on TV, PV, and TS
    % diagrams

%number of points in each region - at the top for visibility
NSubcooled = 5;
NSaturated = 3;
NSuperheated = 20;

a = Table
%grab saturation data, why ever not?
Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;
Sf = Table.Sat.sf;
Sg = Table.Sat.sg;

%grab the minimum and maximum. In general specific volume works, we could
%use specific entropy just as well though? It only works when either of
%them is the iso-line
%vMin = Bounds.PV(1);
%vMax = Bounds.PV(1);

%first one is brief, just for subcooled
if isempty(Table.SubCooled)
    %easy, just assume incompressible and take the minimum in saturated
    %liquid table
    vMin = min(Table.Sat.vf);

else

    switch Prop
        case 'P' %isobar
            validSubcooledVector = Table.SubCooled.v(Table.SubCooled.P < Value);
            validSuperHeatVector = Table.SuperHeat.v(Table.SubCooled.P > Value);
        case 'T' %isotherm
            validSubcooledVector = Table.SubCooled.v(Table.SubCooled.T < Value); %?
            validSuperHeatVector = Table.SuperHeat.v(Table.SubCooled.T > Value);

        case 'v' %isovolumetric
            %validSubcooledVector = Table.SubCooled.T(Table.SubCooled.v
            %< Value);??
        case 's' %isentropic

    end

    vMin = min(validSubcooledVector)
    %this guarantees that the minimum specific volume value is within the
    %bounds for the input pressure?
end

%this needs to go outside because of the if empty. We still need the max
%value for v regardless of whether subcooled data exists
switch Prop
    case 'P' %isobar
        validSuperHeatVector = Table.SuperHeat.v(Table.SuperHeat.P > Value);
        InterpArray = Press;
    case 'T' %isotherm
        validSuperHeatVector = Table.SuperHeat.v(Table.SuperHeat.T > Value);
        InterpArray = Temp;

    case 'v' %isovolumetric
        %validSubcooledVector = Table.SubCooled.T(Table.SubCooled.v
        %< Value);??
    case 's' %isentropic

end

vMax = max(validSuperHeatVector)


SatState.P = interp1(InterpArray,Press,Value,'linear','extrap');
SatState.T = interp1(InterpArray,Temp,Value,'linear','extrap');
SatState.vf = interp1(InterpArray,Vf,Value,'linear','extrap');
SatState.vg = interp1(InterpArray,Vg,Value,'linear','extrap');
SatState.sf = interp1(InterpArray,Sf,Value,'linear','extrap');
SatState.sg = interp1(InterpArray,Sg,Value,'linear','extrap');



%create base vector for interpolation
vVector = [linspace(vMin,SatState.vf,NSubcooled),linspace(SatState.vf,SatState.vg,NSaturated),linspace(SatState.vg,vMax,NSuperheated)];
%we're duplicating points on the saturation curve. Just use Xsaturated for
%those

%now find all the other values at those specific volumes, for the given
%input pressure

%what if the combination of input pressure and given volume is outside the
%table range?
%possibility eliminated by bounds finding function above

%now we switch again to do the actual calculations
%this could be an if and?
switch Prop
    case 'P' %isobar
        xProp = 'v';
        xValues = vVector;

    case 'T' %isotherm
        xProp = 'v';
        xValues = vVector;

    case 'v' %isovolumetric
        %validSubcooledVector = Table.SubCooled.T(Table.SubCooled.v
        %< Value);??
    case 's' %isentropic

end

Out.v = zeros(size(xValues));
Out.T = zeros(size(xValues));
Out.P = zeros(size(xValues));
Out.s = zeros(size(xValues));



%all of this should be general, excepting the case of v and s as Prop?
for i = 1:numel(xValues)
    %switch based on state (known for elements in vVector)
    if i < NSubcooled %if it equals NSubcooled, use saturated
        if isempty(Table.SubCooled)
            data = Incompressible(xProp,xValues(i),Prop,Value,Table); %is it better to simply use xSaturated?

        else
        data = SubCooledAll(xProp,xValues(i),Prop,Value,Table); %this is where generalizing starts to be big money
    
        end    
    
    elseif i <= NSubcooled + NSaturated        
        %quick sort for Saturated all
        [Prop1Sat, Value1Sat, Prop2Sat, Value2Sat] = InputSort(xProp,xValues(i),Prop,Value);% might be fucked, and need to be changed?
        %calculate quality robustly
        SatState = SaturatedAll(Prop1Sat, Value1Sat, Prop2Sat, Value2Sat, Table);
        data = XSaturated(SatState.x,Prop,Value,Table);
        %XSaturated does not rely on the input being pressure or temperature

    else
        data = SuperHeatAll(xProp,xValues(i),Prop,Value,Table,0);
    end
    
    Out.v(i) = data.v; %should also match
    Out.T(i) = data.T;
    Out.P(i) = data.P; %should match, otherwise bad news
    Out.s(i) = data.s;

end


if DebugPlot
    close all
    figure(1)
    plot(Out.v,Out.P)
    xlabel("v")
    ylabel("P")
    title("P-V")
    set(gca, 'XScale', 'log') %specific volume logarithmic

    figure(2)
    plot(Out.v,Out.T)
    xlabel("v")
    ylabel("T")
    title("T-V")
    set(gca, 'XScale', 'log') %specific volume logarithmic

    figure(3)
    plot(Out.s,Out.T)
    xlabel("s")
    ylabel("T")
    title("T-s")

end

end