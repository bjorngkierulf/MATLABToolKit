function SuperState = SuperHeatNew(T,Prop,Value,Table)


    % SuperHear Verification
%     Sample  = StateDetect('P',P,Prop,Value,Table);
% 
%     if ~strcmp(Sample.State , 'SuperHeat')
%             disp('SuperHeat Data Error!!')
%             SuperState = [];
%         return
%     end

% Inputs Description:

% P: Pressure
% Prop: Porperty 'T', 'v'
% Value:  Value of the Property
% Table:  Data Table

% Output - Pressure
SuperState.T = T;

% Pressure Values
TValues = unique(Table.SuperHeat.Temp.P);

% Identifying the Pressure Span
Ind = find(P<=TValues,1,'first');

if Ind == 1
    T1 = TValues(Ind); T2 = TValues(Ind+1); 
else
    T1 = TValues(Ind-1); T2 = TValues(Ind); 
end

IndP1 = find(Table.SuperHeat.Pressure.P == T1);
IndP2 = find(Table.SuperHeat.Pressure.P == T2);

switch Prop
    
    case 'T'
    vP1 = interp1(Table.SuperHeat.Pressure.T(IndP1),Table.SuperHeat.Pressure.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SuperHeat.Pressure.T(IndP2),Table.SuperHeat.Pressure.v(IndP2),Value,'linear','extrap');
    v = interp1([T1,T2],[vP1,vP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SuperHeat.Pressure.T(IndP1),Table.SuperHeat.Pressure.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SuperHeat.Pressure.T(IndP2),Table.SuperHeat.Pressure.u(IndP2),Value,'linear','extrap');
    u = interp1([T1,T2],[uP1,uP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SuperHeat.Pressure.T(IndP1),Table.SuperHeat.Pressure.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SuperHeat.Pressure.T(IndP2),Table.SuperHeat.Pressure.h(IndP2),Value,'linear','extrap');
    h = interp1([T1,T2],[hP1,hP2],P,'linear','extrap');
    
    SuperState.T = Value;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = h;
    

    case 'v'
        
    TP1 = interp1(Table.SuperHeat.Pressure.v(IndP1),Table.SuperHeat.Pressure.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SuperHeat.Pressure.v(IndP2),Table.SuperHeat.Pressure.T(IndP2),Value,'linear','extrap');
    T = interp1([T1,T2],[TP1,TP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SuperHeat.Pressure.v(IndP1),Table.SuperHeat.Pressure.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SuperHeat.Pressure.v(IndP2),Table.SuperHeat.Pressure.u(IndP2),Value,'linear','extrap');
    u = interp1([T1,T2],[uP1,uP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SuperHeat.Pressure.v(IndP1),Table.SuperHeat.Pressure.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SuperHeat.Pressure.v(IndP2),Table.SuperHeat.Pressure.h(IndP2),Value,'linear','extrap');
    h = interp1([T1,T2],[hP1,hP2],P,'linear','extrap');
    
    SuperState.T = T;
    SuperState.v = Value;
    SuperState.u = u;
    SuperState.h = h;
    
    
    case 'u'
        
    TP1 = interp1(Table.SuperHeat.Pressure.u(IndP1),Table.SuperHeat.Pressure.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SuperHeat.Pressure.u(IndP2),Table.SuperHeat.Pressure.T(IndP2),Value,'linear','extrap');
    T = interp1([T1,T2],[TP1,TP2],P,'linear','extrap');
    
    vP1 = interp1(Table.SuperHeat.Pressure.u(IndP1),Table.SuperHeat.Pressure.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SuperHeat.Pressure.u(IndP2),Table.SuperHeat.Pressure.v(IndP2),Value,'linear','extrap');
    v = interp1([T1,T2],[vP1,vP2],P,'linear','extrap');
    
    hP1 = interp1(Table.SuperHeat.Pressure.u(IndP1),Table.SuperHeat.Pressure.h(IndP1),Value,'linear','extrap');
    hP2 = interp1(Table.SuperHeat.Pressure.u(IndP2),Table.SuperHeat.Pressure.h(IndP2),Value,'linear','extrap');
    h = interp1([T1,T2],[hP1,hP2],P,'linear','extrap');
    
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = Value;
    SuperState.h = h;
    
    case 'h'
        
    TP1 = interp1(Table.SuperHeat.Pressure.h(IndP1),Table.SuperHeat.Pressure.T(IndP1),Value,'linear','extrap');
    TP2 = interp1(Table.SuperHeat.Pressure.h(IndP2),Table.SuperHeat.Pressure.T(IndP2),Value,'linear','extrap');
    T = interp1([T1,T2],[TP1,TP2],P,'linear','extrap');
    
    vP1 = interp1(Table.SuperHeat.Pressure.h(IndP1),Table.SuperHeat.Pressure.v(IndP1),Value,'linear','extrap');
    vP2 = interp1(Table.SuperHeat.Pressure.h(IndP2),Table.SuperHeat.Pressure.v(IndP2),Value,'linear','extrap');
    v = interp1([T1,T2],[vP1,vP2],P,'linear','extrap');
    
    uP1 = interp1(Table.SuperHeat.Pressure.h(IndP1),Table.SuperHeat.Pressure.u(IndP1),Value,'linear','extrap');
    uP2 = interp1(Table.SuperHeat.Pressure.h(IndP2),Table.SuperHeat.Pressure.u(IndP2),Value,'linear','extrap');
    u = interp1([T1,T2],[uP1,uP2],P,'linear','extrap');
    
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = Value;
    
    
end




end