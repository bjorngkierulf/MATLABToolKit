function SuperState = SuperHeatT(T,Prop,Value,Table)


    % SuperHear Verification
    Sample  = StateDetect('T',T,Prop,Value,Table);

    if ~strcmp(Sample.State , 'SuperHeat')
            disp('SuperHeat Data Error!!')
            SuperState = [];
        return
    end

% Inputs Description:

% P: Temp
% Prop: Porperty 'T', 'v'
% Value:  Value of the Property
% Table:  Data Table

% Output - Temp
SuperState.T = T;

PVec = unique(Table.SuperHeat.P);

NewTable.P = PVec;
% NewTable.T = zeros(size(PVec));
NewTable.v = zeros(size(PVec));
NewTable.u = zeros(size(PVec));
NewTable.h = zeros(size(PVec));
NewTable.s = zeros(size(PVec));


for i = 1:numel(PVec)
    
   Ind = find(Table.SuperHeat.P == PVec(i));
   NewTable.v(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.v(Ind),T,'linear','extrap');
   NewTable.h(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.h(Ind),T,'linear','extrap');
   NewTable.s(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.s(Ind),T,'linear','extrap');
   NewTable.u(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.u(Ind),T,'linear','extrap');

end


switch Prop
    
    case 'v'
        
    P = interp1(NewTable.v,NewTable.P,Value,'linear','extrap');
    u = interp1(NewTable.v,NewTable.u,Value,'linear','extrap');
    h = interp1(NewTable.v,NewTable.h,Value,'linear','extrap');
    s = interp1(NewTable.v,NewTable.s,Value,'linear','extrap');

    
    SuperState.P = P;
    SuperState.v = Value;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = s;

    case 'u'
        
    P = interp1(NewTable.u,NewTable.P,Value,'linear','extrap');
    v = interp1(NewTable.u,NewTable.v,Value,'linear','extrap');
    h = interp1(NewTable.u,NewTable.h,Value,'linear','extrap');
    s = interp1(NewTable.u,NewTable.s,Value,'linear','extrap');

    
    SuperState.P = P;
    SuperState.v = v;
    SuperState.u = Value;
    SuperState.h = h;
    SuperState.s = s;
    
    case 'h'
        
    P = interp1(NewTable.h,NewTable.P,Value,'linear','extrap');
    v = interp1(NewTable.h,NewTable.v,Value,'linear','extrap');
    u = interp1(NewTable.h,NewTable.u,Value,'linear','extrap');
    s = interp1(NewTable.h,NewTable.s,Value,'linear','extrap');  

    SuperState.P = P;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = Value;
    SuperState.s = s;
    
    case 's'
        

    P = interp1(NewTable.s,NewTable.P,Value,'linear','extrap');
    v = interp1(NewTable.s,NewTable.v,Value,'linear','extrap');
    u = interp1(NewTable.s,NewTable.u,Value,'linear','extrap');
    h = interp1(NewTable.s,NewTable.h,Value,'linear','extrap');  

    SuperState.P = P;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = Value;
    
    
end




end