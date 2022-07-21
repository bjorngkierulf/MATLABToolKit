function SatState = XSaturated(x,Prop,Value,Table,debug)
% this function does not need any bounds checking, because the given value
% of quality is already checked and guaranteed to be between 0 and 1. And
% all the second property needs to be is within the absolute bounds of the
% saturation table, which has already been checked via absBoundsCheck

% Inputs Description:

% x: Quality

% Prop: Second Porperty 'V', 'U', 'H'
% Value: Value of the Property
% Table:  Data Table


% Inputs
SatState.x = x;

% Exctracting Sat - Press Table

Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;
Uf = Table.Sat.uf;
Ug = Table.Sat.ug;
Hf = Table.Sat.hf;
Hg = Table.Sat.hg;
Sf = Table.Sat.sf;
Sg = Table.Sat.sg;
% Calculate Corresponding Property with x

vVec = (1-x)*Vf + x*Vg ;
% vVec = Vf + x*(Vg-Vf) ;
uVec = (1-x)*Uf + x*Ug ;
hVec = (1-x)*Hf + x*Hg ;
sVec = (1-x)*Sf + x*Sg ;

% First Independent Property
switch Prop

    case 'v'
        % Saturation Data
        SatState.P = interp1(vVec,Press,Value,'linear','extrap');
        SatState.T = interp1(vVec,Temp,Value,'linear','extrap');
        SatState.u = interp1(vVec,uVec,Value,'linear','extrap');
        SatState.h = interp1(vVec,hVec,Value,'linear','extrap');
        SatState.s = interp1(vVec,sVec,Value,'linear','extrap');
        SatState.v = Value;

    case 'u'
        % Saturation Data
        SatState.P = interp1(uVec,Press,Value,'linear','extrap');
        SatState.T = interp1(uVec,Temp,Value,'linear','extrap');
        SatState.v = interp1(uVec,vVec,Value,'linear','extrap');
        SatState.h = interp1(uVec,hVec,Value,'linear','extrap');
        SatState.s = interp1(uVec,sVec,Value,'linear','extrap');
        SatState.u = Value;

    case 'h'
        % Saturation Data
        SatState.P = interp1(hVec,Press,Value,'linear','extrap');
        SatState.T = interp1(hVec,Temp,Value,'linear','extrap');
        SatState.u = interp1(hVec,uVec,Value,'linear','extrap');
        SatState.v = interp1(hVec,vVec,Value,'linear','extrap');
        SatState.s = interp1(hVec,sVec,Value,'linear','extrap');
        SatState.h = Value;

    case 's'
        % Saturation Data
        SatState.P = interp1(sVec,Press,Value,'linear','extrap');
        SatState.T = interp1(sVec,Temp,Value,'linear','extrap');
        SatState.u = interp1(sVec,uVec,Value,'linear','extrap');
        SatState.v = interp1(sVec,vVec,Value,'linear','extrap');
        SatState.h = interp1(sVec,hVec,Value,'linear','extrap');
        SatState.s = Value;

    case 'P'
        SatState.P = Value;
        SatState.T = interp1(Press,Temp,Value,'linear','extrap');

        vf = interp1(Press,Vf,Value,'linear','extrap');
        vg = interp1(Press,Vg,Value,'linear','extrap');
        SatState.v = (1-x)*vf + x*vg ;

        uf = interp1(Press,Uf,Value,'linear','extrap');
        ug = interp1(Press,Ug,Value,'linear','extrap');
        SatState.u = (1-x)*uf + x*ug ;

        hf = interp1(Press,Hf,Value,'linear','extrap');
        hg = interp1(Press,Hg,Value,'linear','extrap');
        SatState.h = (1-x)*hf + x*hg ;

        sf = interp1(Press,Sf,Value,'linear','extrap');
        sg = interp1(Press,Sg,Value,'linear','extrap');
        SatState.s = (1-x)*sf + x*sg ;

    case 'T'

        SatState.T = Value;
        SatState.P = interp1(Temp,Press,Value,'linear','extrap');

        vf = interp1(Temp,Vf,Value,'linear','extrap');
        vg = interp1(Temp,Vg,Value,'linear','extrap');
        SatState.v = (1-x)*vf + x*vg ;

        uf = interp1(Temp,Uf,Value,'linear','extrap');
        ug = interp1(Temp,Ug,Value,'linear','extrap');
        SatState.u = (1-x)*uf + x*ug ;

        hf = interp1(Temp,Hf,Value,'linear','extrap');
        hg = interp1(Temp,Hg,Value,'linear','extrap');
        SatState.h = (1-x)*hf + x*hg ;

        sf = interp1(Temp,Sf,Value,'linear','extrap');
        sg = interp1(Temp,Sg,Value,'linear','extrap');
        SatState.s = (1-x)*sf + x*sg ;

end


end