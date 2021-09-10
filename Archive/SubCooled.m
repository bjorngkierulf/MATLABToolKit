function SubState = SubCooled(P,Prop,Value,Table)



    % SuperHear Verification
    Sample  = StateDetect('P',P,Prop,Value,Table);

    if ~strcmp(Sample.State , 'SubCooled')
            disp('SubCooled Data Error!!')
            SubState = [];
        return
    end

% Inputs Description:

% P: Pressure
% Prop: Porperty 'T', 'v'
% Value:  Value of the Property
% Table:  Data Table

% Output - Pressure
SubState.P = P;

% Pressure Values
PValues = unique(Table.SubCooled.P);

% Identifying the Pressure Span
Ind = find(P<=PValues,1,'first');

if Ind == 1
    P1 = PValues(Ind); P2 = PValues(Ind+1); 
else
    P1 = PValues(Ind-1); P2 = PValues(Ind); 
end

IndP1 = find(Table.SubCooled.P == P1);
IndP2 = find(Table.SubCooled.P == P2);

switch Prop
    
    case 'T'
    vP1 = interp1(Table.SubCooled.T(IndP1),Table.SubCooled.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SubCooled.T(IndP2),Table.SubCooled.v(IndP2),Value,'linear','extrap');
    v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SubCooled.T(IndP1),Table.SubCooled.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SubCooled.T(IndP2),Table.SubCooled.u(IndP2),Value,'linear','extrap');
    u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SubCooled.T(IndP1),Table.SubCooled.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SubCooled.T(IndP2),Table.SubCooled.h(IndP2),Value,'linear','extrap');
    h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
    
    SubState.T = Value;
    SubState.v = v;
    SubState.u = u;
    SubState.h = h;
    

    case 'v'
        
    TP1 = interp1(Table.SubCooled.v(IndP1),Table.SubCooled.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SubCooled.v(IndP2),Table.SubCooled.T(IndP2),Value,'linear','extrap');
    T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SubCooled.v(IndP1),Table.SubCooled.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SubCooled.v(IndP2),Table.SubCooled.u(IndP2),Value,'linear','extrap');
    u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SubCooled.v(IndP1),Table.SubCooled.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SubCooled.v(IndP2),Table.SubCooled.h(IndP2),Value,'linear','extrap');
    h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
    
    SubState.T = T;
    SubState.v = Value;
    SubState.u = u;
    SubState.h = h;
    
    
    case 'u'
        
    TP1 = interp1(Table.SubCooled.u(IndP1),Table.SubCooled.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SubCooled.u(IndP2),Table.SubCooled.T(IndP2),Value,'linear','extrap');
    T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
    
    vP1 = interp1(Table.SubCooled.u(IndP1),Table.SubCooled.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SubCooled.u(IndP2),Table.SubCooled.v(IndP2),Value,'linear','extrap');
    v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SubCooled.u(IndP1),Table.SubCooled.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SubCooled.u(IndP2),Table.SubCooled.h(IndP2),Value,'linear','extrap');
    h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
    
    SubState.T = T;
    SubState.v = v;
    SubState.u = Value;
    SubState.h = h;
    
    case 'h'
        
    TP1 = interp1(Table.SubCooled.h(IndP1),Table.SubCooled.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SubCooled.h(IndP2),Table.SubCooled.T(IndP2),Value,'linear','extrap');
    T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
    
    vP1 = interp1(Table.SubCooled.h(IndP1),Table.SubCooled.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SubCooled.h(IndP2),Table.SubCooled.v(IndP2),Value,'linear','extrap');
    v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SubCooled.h(IndP1),Table.SubCooled.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SubCooled.h(IndP2),Table.SubCooled.u(IndP2),Value,'linear','extrap');
    u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
    
    SubState.T = T;
    SubState.v = v;
    SubState.u = u;
    SubState.h = Value;
    
    
end


end