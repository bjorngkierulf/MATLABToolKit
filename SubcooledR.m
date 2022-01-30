function SuperState = SubcooledR(Prop1,Value1,Prop2,Value2,Table)


% Inputs Description:

% P: Temp
% Prop: Porperty 'T', 'v'
% Value:  Value of the Property
% Table:  Data Table



PVec = unique(Table.SubCooled.P);

Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;

T = Value1;

SatState.T = T;
SatState.P = interp1(Temp,Press,T,'linear','extrap');
SatState.vf = interp1(Temp,Vf,T,'linear','extrap');
SatState.vg = interp1(Temp,Vg,T,'linear','extrap');

    for i = 1:numel(PVec)        
        if (interp1(Press,Temp,PVec(i),'linear','extrap') < T)
            fprintf("throwing it out")
            PVec(i) = 0;
        end
    end
    
    PVec = PVec(PVec~=0);
    
    
    NewTable.P = PVec;
    NewTable.T = zeros(size(PVec));
    NewTable.v = zeros(size(PVec));
    NewTable.u = zeros(size(PVec));
    NewTable.h = zeros(size(PVec));
    NewTable.s = zeros(size(PVec));

%% First Property

% Exctracting Saturation Data

    switch Prop1
        
        case 'T'
        
        % First Property: T
        SuperState.T = Value1;

        for i = 1:numel(PVec)
        
           Ind = find(Table.SubCooled.P == PVec(i));
           NewTable.T(i) = Value1;
           NewTable.v(i) = interp1(Table.SubCooled.T(Ind),Table.SubCooled.v(Ind),Value1,'linear','extrap');
           NewTable.h(i) = interp1(Table.SubCooled.T(Ind),Table.SubCooled.h(Ind),Value1,'linear','extrap');
           NewTable.s(i) = interp1(Table.SubCooled.T(Ind),Table.SubCooled.s(Ind),Value1,'linear','extrap');
           NewTable.u(i) = interp1(Table.SubCooled.T(Ind),Table.SubCooled.u(Ind),Value1,'linear','extrap');
        
%            if (interp1(Press,Temp,PVec(i),'linear','extrap') < T)
%               fprintf("T too low")
%               NewTable.P(i) = 0;
%               NewTable.v(i) = 0;
%               NewTable.h(i) = 0;
%               NewTable.s(i) = 0;
%               NewTable.u(i) = 0;
%            end
           
               
        end
        
%         PVec = [PVec; SatState.P];
%         NewTable.T = [NewTable.T; Value1]
%         NewTable.v = [NewTable.v; SatState.vf]
%         NewTable.P = [NewTable.P; SatState.P]
%         NewTable.h = [NewTable.h; SatState.h]
%         NewTable.s = [NewTable.s; SatState.s]
%         NewTable.u = [NewTable.u; SatState.u]
%         
        
%         NewTable.v = NewTable.v(NewTable.v~=0);
%         NewTable.h = NewTable.h(NewTable.h~=0);
%         NewTable.s = NewTable.P(NewTable.s~=0);
%         NewTable.u = NewTable.u(NewTable.u~=0);
%         NewTable.P = NewTable.P(NewTable.P~=0);
%             
        
        case 'v'
            
        % First Property: v
        SuperState.v = Value1;

        for i = 1:numel(PVec)
            
           Ind = find(Table.SubCooled.P == PVec(i));
           NewTable.T(i) = interp1(Table.SubCooled.v(Ind),Table.SubCooled.T(Ind),Value1,'linear','extrap');
           NewTable.v(i) = Value1;
           NewTable.h(i) = interp1(Table.SubCooled.v(Ind),Table.SubCooled.h(Ind),Value1,'linear','extrap');
           NewTable.s(i) = interp1(Table.SubCooled.v(Ind),Table.SubCooled.s(Ind),Value1,'linear','extrap');
           NewTable.u(i) = interp1(Table.SubCooled.v(Ind),Table.SubCooled.u(Ind),Value1,'linear','extrap');
       
        end
        
        case 'u'
            
        % First Property: v
        SuperState.u = Value1;

        for i = 1:numel(PVec)
            
           Ind = find(Table.SubCooled.P == PVec(i));
           NewTable.T(i) = interp1(Table.SubCooled.u(Ind),Table.SubCooled.T(Ind),Value1,'linear','extrap');
           NewTable.u(i) = Value1;
           NewTable.h(i) = interp1(Table.SubCooled.u(Ind),Table.SubCooled.h(Ind),Value1,'linear','extrap');
           NewTable.s(i) = interp1(Table.SubCooled.u(Ind),Table.SubCooled.s(Ind),Value1,'linear','extrap');
           NewTable.v(i) = interp1(Table.SubCooled.u(Ind),Table.SubCooled.v(Ind),Value1,'linear','extrap');
       
        end
        
        case 'h'
            
        % First Property: h
        SuperState.h = Value1;

        for i = 1:numel(PVec)
            
           Ind = find(Table.SubCooled.P == PVec(i));
           NewTable.T(i) = interp1(Table.SubCooled.h(Ind),Table.SubCooled.T(Ind),Value1,'linear','extrap');
           NewTable.h(i) = Value1; 
           NewTable.u(i) = interp1(Table.SubCooled.h(Ind),Table.SubCooled.u(Ind),Value1,'linear','extrap');
           NewTable.s(i) = interp1(Table.SubCooled.h(Ind),Table.SubCooled.s(Ind),Value1,'linear','extrap');
           NewTable.v(i) = interp1(Table.SubCooled.h(Ind),Table.SubCooled.v(Ind),Value1,'linear','extrap');
       
        end
        
        case 's'
            
         for i = 1:numel(PVec)
            
           Ind = find(Table.SubCooled.P == PVec(i));
           NewTable.T(i) = interp1(Table.SubCooled.s(Ind),Table.SubCooled.T(Ind),Value1,'linear','extrap');
           NewTable.h(i) = interp1(Table.SubCooled.s(Ind),Table.SubCooled.h(Ind),Value1,'linear','extrap');
           NewTable.u(i) = interp1(Table.SubCooled.s(Ind),Table.SubCooled.u(Ind),Value1,'linear','extrap');
           NewTable.v(i) = interp1(Table.SubCooled.s(Ind),Table.SubCooled.v(Ind),Value1,'linear','extrap');
           NewTable.s(i) = Value1;
           
        end
        
    end


switch Prop2
    
    
    case 'T'
        
    P = interp1(NewTable.T,NewTable.P,Value2,'linear','extrap');
    u = interp1(NewTable.T,NewTable.u,Value2,'linear','extrap');
    v = interp1(NewTable.T,NewTable.v,Value2,'linear','extrap');
    h = interp1(NewTable.T,NewTable.h,Value2,'linear','extrap');
    s = interp1(NewTable.T,NewTable.s,Value2,'linear','extrap');

    
    SuperState.P = P;
    SuperState.T = Value2;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = s;
    
    
    case 'v'
        
    P = interp1(NewTable.v,NewTable.P,Value2,'linear','extrap');
    T = unique(NewTable.T);
    %T = interp1(NewTable.v,NewTable.T,Value2,'linear','extrap');
    u = 1;%interp1(NewTable.v,NewTable.u,Value2,'linear','extrap');
    h = 1;%interp1(NewTable.v,NewTable.h,Value2,'linear','extrap');
    s = 1;%interp1(NewTable.v,NewTable.s,Value2,'linear','extrap');

    
    SuperState.P = P;
    SuperState.T = T;
    SuperState.v = Value2;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = s;
    
    format long
    NewTable.P
    NewTable.T
    NewTable.v
    

    case 'u'
        
    P = interp1(NewTable.u,NewTable.P,Value2,'linear','extrap');
    T = interp1(NewTable.u,NewTable.T,Value2,'linear','extrap');
    v = interp1(NewTable.u,NewTable.v,Value2,'linear','extrap');
    h = interp1(NewTable.u,NewTable.h,Value2,'linear','extrap');
    s = interp1(NewTable.u,NewTable.s,Value2,'linear','extrap');

    
    SuperState.P = P;
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = Value2;
    SuperState.h = h;
    SuperState.s = s;
    
    case 'h'
        
    P = interp1(NewTable.h,NewTable.P,Value2,'linear','extrap');
    T = interp1(NewTable.h,NewTable.T,Value2,'linear','extrap');
    v = interp1(NewTable.h,NewTable.v,Value2,'linear','extrap');
    u = interp1(NewTable.h,NewTable.u,Value2,'linear','extrap');
    s = interp1(NewTable.h,NewTable.s,Value2,'linear','extrap');  

    SuperState.P = P;
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = Value2;
    SuperState.s = s;
    
    case 's'
        

    P = interp1(NewTable.s,NewTable.P,Value2,'linear','extrap');
    T = interp1(NewTable.s,NewTable.T,Value2,'linear','extrap');
    v = interp1(NewTable.s,NewTable.v,Value2,'linear','extrap');
    u = interp1(NewTable.s,NewTable.u,Value2,'linear','extrap');
    h = interp1(NewTable.s,NewTable.h,Value2,'linear','extrap');  

    SuperState.P = P;
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = Value2;
    
    
end




end