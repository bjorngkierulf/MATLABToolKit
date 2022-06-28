function Out = Incompressible(Prop1,Value1,Prop2,Value2,Table)

%re-sort input properties so that P is last
order = {'T','v','u','h','s','x','P'};
[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,order);

% Exctracting Saturation Data
Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Uf = Table.Sat.uf;
Hf = Table.Sat.hf;
Sf = Table.Sat.sf;

% check if either property is specific volume
if strcmp(Prop1,'v') || strcmp(Prop2,'v')
    fprintf('Incompressible model poorly posed using specific volume as input')
end

% First Independent Property
switch Prop1

    case 'P'
        Value1InterpArray = Press;
        fprintf("It should be sorted such that this never happens..")

    case 'T'
        Value1InterpArray = Temp;

    case 'v'
        %Value1InterpArrayUpper = Vg;
        Value1InterpArray = Vf;

    case 'u'
        %Value1InterpArrayUpper = Ug;
        Value1InterpArray = Uf;

    case 'h'
        %Value1InterpArrayUpper = Hg;
        Value1InterpArray = Hf;

    case 's'
        %Value1InterpArrayUpper = Sg;
        Value1InterpArray = Sf;

    case 'x'
        fprintf("Using incompressible model when quality is input - something is wrong")

end

%interp for the saturated liquid data. This is the incompressible
%assumption - that the partial derivative of all quantities WRT pressure is zero

Out.T = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
Out.v = interp1(Value1InterpArray,Vf,Value1,'linear','extrap');
Out.u = interp1(Value1InterpArray,Uf,Value1,'linear','extrap');
Out.h = interp1(Value1InterpArray,Hf,Value1,'linear','extrap');
Out.s = interp1(Value1InterpArray,Sf,Value1,'linear','extrap');

%pressure is the only tricky one
%if pressure is one of the inputs (it would only be the second because of
%sorting), then return the input pressure. Otherwise return an error /
%indeterminate? Or just return saturation pressure, for the sake of
%graphing

if strcmp(Prop2,"P")
    Out.P = Value2;
else
    Out.P = interp1(Value1InterpArray,Press,Value1,'linear','extrap');
end

%then identifying the state is easy, as it is already known
Out.State = 'SubCooled';

end %end func