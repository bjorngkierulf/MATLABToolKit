function Out = ProcessLine(Prop,Value,xMin,xMax,Table,Critical,DebugPlot,debug)
    % This function serves as a general process-line creation tool, which will
    % be robust enough to handle iso T, P, v, and s lines on TV, PV, and TS
    % diagrams. This will not handle unknown processes, polytropic
    % processes, or other exotic processes.

%     Prop = 's';
%     Value = 3;
%     [Table,Critical] = GenTableNew();
%     DebugPlot = 1;

%number of points in each region - at the top for visibility
Ndivisions = 20;

% a = Table
% %grab saturation data, why ever not?
% Temp = Table.Sat.T;
% Press = Table.Sat.P;
% Vf = Table.Sat.vf;
% Vg = Table.Sat.vg;
% Sf = Table.Sat.sf;
% Sg = Table.Sat.sg;

%switch to define variable on x axis and detect if supercritical. v and s
%cannot be supercritical
switch Prop
    case 'P' %isobar
        xProp = 'v';

    case 'T' %isotherm
        xProp = 'v';

    case 'v' %isovolumetric
        xProp = 'T';

    case 's' %isentropic
        xProp = 'T';

end

if debug
    %function inputs
    fprintf('\nxMin=%f, xMax=$f',xMin,xMax)
end

switch xProp
    case 'v'
        
        if Value > max(Table.Sat.(Prop))
            xValues = linspace(xMin,xMax,Ndivisions);

        elseif Value < min(Table.Sat.(Prop))
            if debug
                fprintf("Error - property out of bounds (below triple point)")
                xValues = [];
            end

        else %isobar / isotherm will be Liquid-Vapour mixture somewhere..
            vf = interp1(Table.Sat.(Prop),Table.Sat.vf,Value,'linear','extrap');
            vg = interp1(Table.Sat.(Prop),Table.Sat.vf,Value,'linear','extrap');
            
            % check where bounds are relative to saturation. We want a
            % point, in order, at saturation - if it is in range
            if (vf > xMin && vf < xMax) && (vg > xMin && vg < xMax)
                xValues = [linspace(xMin,vf,Ndivisions),linspace(vg,xMax,Ndivisions)];

            elseif (vf > xMin && vf < xMax)
                xValues = [linspace(xMin,vf,Ndivisions),linspace(vf,xMax,Ndivisions)];

            elseif (vg > xMin && vg < xMax)
                xValues = [linspace(xMin,vg,Ndivisions),linspace(vg,xMax,Ndivisions)];

            else

                xValues = linspace(xMin,xMax,Ndivisions);
            end

        end

    case 'T'
        xValues = linspace(xMin,xMax,Ndivisions);

end

if debug, disp(xValues);end

Out.v = zeros(size(xValues));
Out.T = zeros(size(xValues));
Out.P = zeros(size(xValues));
Out.s = zeros(size(xValues));

for i = 1:numel(xValues)

    [~,State] = PropertyCalculateSafe(Prop,Value,xProp,xValues(i),Table,Critical,debug);
    
    %bundle the four outputs we'd need for plotting
    Out.v(i) = State.v;
    Out.s(i) = State.s;
    Out.T(i) = State.T;
    Out.P(i) = State.P;

    shouldBeEqual = State.(Prop);
    if abs(shouldBeEqual - Value) / Value > 0.01
        if debug
            disp(xValues(i));
            pause
        end
    end

    if debug
        disp(State)
    end

end

%remove values that are zero
Out.v(Out.P==0) = [];
Out.s(Out.P==0) = [];
Out.T(Out.P==0) = [];
Out.P(Out.P==0) = [];

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