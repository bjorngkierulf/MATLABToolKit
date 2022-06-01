function Out = IsoThermLine(T,Table)
%Just for now
%[Table,Critical] = GenTableNew;



% Exctracting Saturation Data
Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;
Sf = Table.Sat.sf;
Sg = Table.Sat.sg;

SatState.T = T;
SatState.P = interp1(Temp,Press,T,'linear','extrap');
SatState.vf = interp1(Temp,Vf,T,'linear','extrap');
SatState.vg = interp1(Temp,Vg,T,'linear','extrap');
SatState.sf = interp1(Temp,Sf,T,'linear','extrap');
SatState.sg = interp1(Temp,Sg,T,'linear','extrap');


%this method is not that big a deal because all it's doing
%is trying to get a minimum and maximum. But it's clunky and
%not necessarily bounded at all. So let's clean it up

if isempty(Table.SubCooled)
    fprintf("Incompressible liquid - isobar will not be generated in subcooled region")
    satState = XSaturated(0,'T',T,Table);
    vmin = satState.v; %specific volume for saturated liquid at input T
else

    PVec = unique(Table.SubCooled.P);
    NewTable.v = zeros(size(PVec));

    for i = 1:numel(PVec)
        Ind = find(Table.SubCooled.P == PVec(i));
        NewTable.v(i) = interp1(Table.SubCooled.T(Ind),Table.SubCooled.v(Ind),T,'linear','extrap');
    end
    vmin = min(NewTable.v);

end

PVec = unique(Table.SuperHeat.P);
NewTable.v = zeros(size(PVec));

for i = 1:numel(PVec)
    Ind = find(Table.SuperHeat.P == PVec(i));
    NewTable.v(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.v(Ind),T,'linear','extrap');
end

%vMax = max(NewTable.v);
%manual override vMax
vMax = 1; %m^3/kg


N = 10;
vVector = [linspace(vmin,SatState.vf,N),linspace(SatState.vf,SatState.vg,N) ...
    ,linspace(SatState.vg,vMax,N)];
PVector = zeros(size(vVector));
sVector = zeros(size(vVector));

for i = 1:numel(vVector)

    Data = StateDetect('T',T,'v',vVector(i),Table);

    switch Data.State

        case 'Saturated'
            PVector(i) = Data.P;
            sVector(i) = Data.s;
        case 'SuperHeat'
            %SuperState = SuperHeatR('T',T,'v',vVector(i),Table);
            SuperState = SuperHeatAll('T',T,'v',vVector(i),Table,0);

            PVector(i) = SuperState.P;
            sVector(i) = SuperState.s;
        case 'SubCooled'
            %T
            %vVector(i)
            %SubState = SubcooledR('T',T,'v',vVector(i),Table);
            SubState = SubCooledAll('T',T,'v',vVector(i),Table,0);
            PVector(i) = SubState.P;
            sVector(i) = SubState.s;
    end


end


%         figure(1)
%         plot(Table.Sat.vf,Table.Sat.T,'-b',Table.Sat.vg,Table.Sat.T,'-b',vVector,T*ones(size(vVector)),'.-r')
%                 hold on
% %         plot(vVector,T*ones(size(vVector)),'.-r')
%
%         set(gca,'XScale','log')
%         xlabel('V')
%         ylabel('T')
%
%
%         figure(2)
%         plot(Table.Sat.vf,Table.Sat.P,'-b',Table.Sat.vg,Table.Sat.P,'-b',vVector,PVector,'.-r')
%                 hold on
% %         plot(vVector,PVector,'.-r')
%
%         set(gca,'XScale','log')
%         xlabel('V')
%         ylabel('P')

Out.P = PVector;
Out.T = T*ones(size(PVector));
Out.v = vVector;
Out.s = sVector;


end