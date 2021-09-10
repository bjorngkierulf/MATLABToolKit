function SuperState = SuperHeat(P,Prop,Value,Table)


    % SuperHear Verification

% Inputs Description:

% P: Pressure
% Prop: Porperty 'T', 'v'
% Value:  Value of the Property
% Table:  Data Table

% Output - Pressure
SuperState.P = P;

% Pressure Values
PValues = unique(Table.SuperHeat.P);

% Identifying the Pressure Span
Ind = find(P<=PValues,1,'first');

if Ind == 1
    P1 = PValues(Ind); P2 = PValues(Ind+1); 
else
    P1 = PValues(Ind-1); P2 = PValues(Ind); 
end

IndP1 = find(Table.SuperHeat.P == P1);
IndP2 = find(Table.SuperHeat.P == P2);

switch Prop
    
    case 'T'
    vP1 = interp1(Table.SuperHeat.T(IndP1),Table.SuperHeat.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SuperHeat.T(IndP2),Table.SuperHeat.v(IndP2),Value,'linear','extrap');
    v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SuperHeat.T(IndP1),Table.SuperHeat.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SuperHeat.T(IndP2),Table.SuperHeat.u(IndP2),Value,'linear','extrap');
    u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SuperHeat.T(IndP1),Table.SuperHeat.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SuperHeat.T(IndP2),Table.SuperHeat.h(IndP2),Value,'linear','extrap');
    h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
    
    sP1 = interp1(Table.SuperHeat.T(IndP1),Table.SuperHeat.s(IndP1),Value,'linear','extrap');
    sP2 = interp1(Table.SuperHeat.T(IndP2),Table.SuperHeat.s(IndP2),Value,'linear','extrap');
    s = interp1([P1,P2],[sP1,sP2],P,'linear','extrap');
    
    SuperState.T = Value;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = h; 
    SuperState.s = s;

    case 'v'
        
    TP1 = interp1(Table.SuperHeat.v(IndP1),Table.SuperHeat.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SuperHeat.v(IndP2),Table.SuperHeat.T(IndP2),Value,'linear','extrap');
    T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SuperHeat.v(IndP1),Table.SuperHeat.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SuperHeat.v(IndP2),Table.SuperHeat.u(IndP2),Value,'linear','extrap');
    u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SuperHeat.v(IndP1),Table.SuperHeat.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SuperHeat.v(IndP2),Table.SuperHeat.h(IndP2),Value,'linear','extrap');
    h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
    
    sP1 = interp1(Table.SuperHeat.v(IndP1),Table.SuperHeat.s(IndP1),Value,'linear','extrap');
    sP2 = interp1(Table.SuperHeat.v(IndP2),Table.SuperHeat.s(IndP2),Value,'linear','extrap');
    s = interp1([P1,P2],[sP1,sP2],P,'linear','extrap');
    
    
    SuperState.T = T;
    SuperState.v = Value;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = s;
    
    case 'u'
        
    TP1 = interp1(Table.SuperHeat.u(IndP1),Table.SuperHeat.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SuperHeat.u(IndP2),Table.SuperHeat.T(IndP2),Value,'linear','extrap');
    T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
    
    vP1 = interp1(Table.SuperHeat.u(IndP1),Table.SuperHeat.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SuperHeat.u(IndP2),Table.SuperHeat.v(IndP2),Value,'linear','extrap');
    v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SuperHeat.u(IndP1),Table.SuperHeat.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SuperHeat.u(IndP2),Table.SuperHeat.h(IndP2),Value,'linear','extrap');
    h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
    
    sP1 = interp1(Table.SuperHeat.u(IndP1),Table.SuperHeat.s(IndP1),Value,'linear','extrap');
    sP2 = interp1(Table.SuperHeat.u(IndP2),Table.SuperHeat.s(IndP2),Value,'linear','extrap');
    s = interp1([P1,P2],[sP1,sP2],P,'linear','extrap');
    
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = Value;
    SuperState.h = h;
    SuperState.s = s;
    
    case 'h'
        
    TP1 = interp1(Table.SuperHeat.h(IndP1),Table.SuperHeat.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SuperHeat.h(IndP2),Table.SuperHeat.T(IndP2),Value,'linear','extrap');
    T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
    
    vP1 = interp1(Table.SuperHeat.h(IndP1),Table.SuperHeat.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SuperHeat.h(IndP2),Table.SuperHeat.v(IndP2),Value,'linear','extrap');
    v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SuperHeat.h(IndP1),Table.SuperHeat.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SuperHeat.h(IndP2),Table.SuperHeat.u(IndP2),Value,'linear','extrap');
    u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
    
    sP1 = interp1(Table.SuperHeat.h(IndP1),Table.SuperHeat.s(IndP1),Value,'linear','extrap');
    sP2 = interp1(Table.SuperHeat.h(IndP2),Table.SuperHeat.s(IndP2),Value,'linear','extrap');
    s = interp1([P1,P2],[sP1,sP2],P,'linear','extrap');
    
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = Value;
    SuperState.s = s;
    
    case 's'
        
        TP1 = interp1(Table.SuperHeat.s(IndP1),Table.SuperHeat.T(IndP1),Value,'linear','extrap');
        TP2 = interp1(Table.SuperHeat.s(IndP2),Table.SuperHeat.T(IndP2),Value,'linear','extrap');
        T = interp1([P1,P2],[TP1,TP2],P,'linear','extrap');
        
        vP1 = interp1(Table.SuperHeat.s(IndP1),Table.SuperHeat.v(IndP1),Value,'linear','extrap');
        vP2 = interp1(Table.SuperHeat.s(IndP2),Table.SuperHeat.v(IndP2),Value,'linear','extrap');
        v = interp1([P1,P2],[vP1,vP2],P,'linear','extrap');
        
        uP1 = interp1(Table.SuperHeat.s(IndP1),Table.SuperHeat.u(IndP1),Value,'linear','extrap');
        uP2 = interp1(Table.SuperHeat.s(IndP2),Table.SuperHeat.u(IndP2),Value,'linear','extrap');
        u = interp1([P1,P2],[uP1,uP2],P,'linear','extrap');
        
        hP1 = interp1(Table.SuperHeat.s(IndP1),Table.SuperHeat.h(IndP1),Value,'linear','extrap');
        hP2 = interp1(Table.SuperHeat.s(IndP2),Table.SuperHeat.h(IndP2),Value,'linear','extrap');
        h = interp1([P1,P2],[hP1,hP2],P,'linear','extrap');
        
        SuperState.T = T;
        SuperState.v = v;
        SuperState.u = u;
        SuperState.h = h;
        SuperState.s = Value;
    
    
    
end




end