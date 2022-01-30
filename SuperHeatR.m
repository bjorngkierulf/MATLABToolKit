function SuperState = SuperHeatR(Prop1,Value1,Prop2,Value2,Table)


%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};

[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder);

%this allows the interpolation code to be further generalized




% Inputs Description:

% P: Temp
% Prop: Porperty 'T', 'v'
% Value:  Value of the Property
% Table:  Data Table
    
    PVec = unique(Table.SuperHeat.P);
    NewTable.P = PVec;
    NewTable.T = zeros(size(PVec));
    NewTable.v = zeros(size(PVec));
    NewTable.u = zeros(size(PVec));
    NewTable.h = zeros(size(PVec));
    NewTable.s = zeros(size(PVec));

%% First Property

    switch Prop1
        
        case 'T'

        % First Property: T
        %SuperState.T = Value1;

        for i = 1:numel(PVec)
            
           Ind = find(Table.SuperHeat.P == PVec(i));

            %okay now check specific bounds
            %a = min(Table.SuperHeat.T(Ind))
            %Value1
            if Value1 > max(Table.SuperHeat.T(Ind)) || Value1 < min(Table.SuperHeat.T(Ind))
                fprintf("Locally out of bounds, data discarded")
                NewTable.P(i) = 0;
            else

                %this will mean the outputs may have zeroes mixed in with
                %them

                NewTable.T(i) = Value1;
                NewTable.v(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.v(Ind),Value1,'linear','extrap');
                NewTable.h(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.h(Ind),Value1,'linear','extrap');
                NewTable.s(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.s(Ind),Value1,'linear','extrap');
                NewTable.u(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.u(Ind),Value1,'linear','extrap');
                

            end

        end

        case 'v'
            
        % First Property: v
        %SuperState.v = Value1;

        for i = 1:numel(PVec)
            
           Ind = find(Table.SuperHeat.P == PVec(i));


           if Value1 > max(Table.SuperHeat.v(Ind)) || Value1 < min(Table.SuperHeat.v(Ind))
               fprintf("Locally out of bounds, data discarded")
               NewTable.P(i) = 0;
           else
               NewTable.T(i) = interp1(Table.SuperHeat.v(Ind),Table.SuperHeat.T(Ind),Value1,'linear','extrap');
               NewTable.v(i) = Value1;
               NewTable.h(i) = interp1(Table.SuperHeat.v(Ind),Table.SuperHeat.h(Ind),Value1,'linear','extrap');
               NewTable.s(i) = interp1(Table.SuperHeat.v(Ind),Table.SuperHeat.s(Ind),Value1,'linear','extrap');
               NewTable.u(i) = interp1(Table.SuperHeat.v(Ind),Table.SuperHeat.u(Ind),Value1,'linear','extrap');


           end

        end
        
        case 'u'
            
        % First Property: v
        %SuperState.u = Value1;

        for i = 1:numel(PVec)
            
            Ind = find(Table.SuperHeat.P == PVec(i));


            if Value1 > max(Table.SuperHeat.v(Ind)) || Value1 < min(Table.SuperHeat.v(Ind))
                fprintf("Locally out of bounds, data discarded")
                NewTable.P(i) = 0;
            else
                NewTable.T(i) = interp1(Table.SuperHeat.u(Ind),Table.SuperHeat.T(Ind),Value1,'linear','extrap');
                NewTable.u(i) = Value1;
                NewTable.h(i) = interp1(Table.SuperHeat.u(Ind),Table.SuperHeat.h(Ind),Value1,'linear','extrap');
                NewTable.s(i) = interp1(Table.SuperHeat.u(Ind),Table.SuperHeat.s(Ind),Value1,'linear','extrap');
                NewTable.v(i) = interp1(Table.SuperHeat.u(Ind),Table.SuperHeat.v(Ind),Value1,'linear','extrap');


            end

        end

        case 'h'
            
            % First Property: h
            %SuperState.h = Value1;

            for i = 1:numel(PVec)

                Ind = find(Table.SuperHeat.P == PVec(i));

                if Value1 > max(Table.SuperHeat.h(Ind)) || Value1 < min(Table.SuperHeat.h(Ind))
                    fprintf("Locally out of bounds, data discarded")
                    NewTable.P(i) = 0;
                else


                    NewTable.T(i) = interp1(Table.SuperHeat.h(Ind),Table.SuperHeat.T(Ind),Value1,'linear','extrap');
                    NewTable.h(i) = Value1;
                    NewTable.u(i) = interp1(Table.SuperHeat.h(Ind),Table.SuperHeat.u(Ind),Value1,'linear','extrap');
                    NewTable.s(i) = interp1(Table.SuperHeat.h(Ind),Table.SuperHeat.s(Ind),Value1,'linear','extrap');
                    NewTable.v(i) = interp1(Table.SuperHeat.h(Ind),Table.SuperHeat.v(Ind),Value1,'linear','extrap');

                end

            end

        case 's'

         for i = 1:numel(PVec)
            
             Ind = find(Table.SuperHeat.P == PVec(i));


             if Value1 > max(Table.SuperHeat.s(Ind)) || Value1 < min(Table.SuperHeat.s(Ind))
                 fprintf("Locally out of bounds, data discarded")
                 NewTable.P(i) = 0;
             else
                 NewTable.T(i) = interp1(Table.SuperHeat.s(Ind),Table.SuperHeat.T(Ind),Value1,'linear','extrap');
                 NewTable.h(i) = interp1(Table.SuperHeat.s(Ind),Table.SuperHeat.h(Ind),Value1,'linear','extrap');
                 NewTable.u(i) = interp1(Table.SuperHeat.s(Ind),Table.SuperHeat.u(Ind),Value1,'linear','extrap');
                 NewTable.v(i) = interp1(Table.SuperHeat.s(Ind),Table.SuperHeat.v(Ind),Value1,'linear','extrap');
                 NewTable.s(i) = Value1;

             end

         end

    end




%remove zeroes step can be in between the two switches


%a = NewTable.P
%b = NewTable.v
%remove zeroes
NewTable.T = NewTable.T(NewTable.P~=0);
NewTable.v = NewTable.v(NewTable.P~=0);
NewTable.h = NewTable.h(NewTable.P~=0);
NewTable.s = NewTable.s(NewTable.P~=0);
NewTable.u = NewTable.u(NewTable.P~=0);
NewTable.P = NewTable.P(NewTable.P~=0);

%a = NewTable.P
%c = NewTable.T

%b = NewTable.s





switch Prop2
    
    
    case 'T'
        
        if Value2 > max(NewTable.T) || Value2 < min(NewTable.T)
            fprintf("Second property out of range: %f",Value2)
        end

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
        % Prop1 T is bounded. check if prop2 v input value is in the range
        % of the smaller table that corresponds to the input temperature
    if Value2 > max(NewTable.v) || Value2 < min(NewTable.v)
        fprintf("Second property out of range: %f",Value2)
    end



    P = interp1(NewTable.v,NewTable.P,Value2,'linear','extrap');
    T = interp1(NewTable.v,NewTable.T,Value2,'linear','extrap');
    u = interp1(NewTable.v,NewTable.u,Value2,'linear','extrap');
    h = interp1(NewTable.v,NewTable.h,Value2,'linear','extrap');
    s = interp1(NewTable.v,NewTable.s,Value2,'linear','extrap');

    
    SuperState.P = P;
    SuperState.T = T;
    SuperState.v = Value2;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = s;

    case 'u'

        if Value2 > max(NewTable.u) || Value2 < min(NewTable.u)
        fprintf("Second property out of range: %f",Value2)
        end

        
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

        if Value2 > max(NewTable.h) || Value2 < min(NewTable.h)
        fprintf("Second property out of range: %f",Value2)
        end

        
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

        if Value2 > max(NewTable.s) || Value2 < min(NewTable.s)
        fprintf("Second property out of range: %f",Value2)
        end
        

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

    case 'P'
    
        %Value2;
        %a = NewTable.P;

        if Value2 > max(NewTable.P) || Value2 < min(NewTable.P)
        fprintf("Second property out of range: %f",Value2)
        %specifically for pressure, if it was out of range it should have
        %been caught earlier
        end
        

    %P = interp1(NewTable.s,NewTable.P,Value2,'linear','extrap');
    T = interp1(NewTable.P,NewTable.T,Value2,'linear','extrap');
    v = interp1(NewTable.P,NewTable.v,Value2,'linear','extrap');
    u = interp1(NewTable.P,NewTable.u,Value2,'linear','extrap');
    h = interp1(NewTable.P,NewTable.h,Value2,'linear','extrap');
    s = interp1(NewTable.P,NewTable.s,Value2,'linear','extrap');  


    SuperState.P = Value2;
    SuperState.T = T;
    SuperState.v = v;
    SuperState.u = u;
    SuperState.h = h;
    SuperState.s = s;
    
    
end




end