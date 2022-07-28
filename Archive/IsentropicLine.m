function Out = IsentropicLine(s,Table,Critical)

       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Sf = Table.Sat.sf;
       Sg = Table.Sat.sg;
       
 
       if s <= Critical.s
          TMid =  interp1(Sf,Temp,s,'linear','extrap'); 
       else
           TMid =  interp1(Sg,Temp,s,'linear','extrap');
       end
       

% 
%         %how to determine TMax, well it depends on what v is. We follow a
%         %similar procedure to what we do in the superheat algorithm
%         %initialize
%         PVec = unique(Table.SuperHeat.P);
% NewTable.P = PVec;
% NewTable.T = zeros(size(PVec));
% NewTable.v = zeros(size(PVec));
% NewTable.u = zeros(size(PVec));
% NewTable.h = zeros(size(PVec));
% NewTable.s = zeros(size(PVec));
% 
% 
%         Value1InterpArray = Table.SuperHeat.s;
% Value1 = s;
% %     case 's'
% %         Value1InterpArray = Table.SuperHeat.s;
% 
% 
% 
% %general code:
% for i = 1:numel(PVec)
%     %find applicable rows indices in the superheated tables
%     Ind1 = find(Table.SuperHeat.P == PVec(i));
%     a = Value1InterpArray(Ind1);
% 
%     %min(a)
%     %max(a)
% 
%     if Value1 > max(a) || Value1 < min(a)
%             fprintf("\nLocally out of bounds, data discarded")
%             NewTable.P(i) = 0;
%     else
%         NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind1),Value1,'linear','extrap');
%         NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind1),Value1,'linear','extrap');
%         NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind1),Value1,'linear','extrap');
%         NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind1),Value1,'linear','extrap');
%         NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind1),Value1,'linear','extrap');
%     end
% 
% end
% 
% %remove zeroes
% NewTable.T = NewTable.T(NewTable.P~=0);
% NewTable.v = NewTable.v(NewTable.P~=0);
% NewTable.h = NewTable.h(NewTable.P~=0);
% NewTable.s = NewTable.s(NewTable.P~=0);
% NewTable.u = NewTable.u(NewTable.P~=0);
% NewTable.P = NewTable.P(NewTable.P~=0);
% 
% 
% a = NewTable.T
% TMax = max(NewTable.T)
% %specific maximum bound based on the maximum value of T in the new table
% %(where it has been interpolated for v = v iso). If v = v iso is not in the
% %P = Pvec(i), section of the table, then no T is added as that would be out
% %of bounds
% 

[localMin,localMax] = localBoundsCheck('s',s,Table,Critical)

TMax = localMax.T;
TMin = localMin.T;
       %TMax = 400; 
       %Tmin = 10;
       N = 100;

%        PMax = 100;
%        PMin = .5;

%        if s <= Critical.s
%           PMid =  interp1(Sf,Press,s,'linear','extrap'); 
%        else
%            PMid =  interp1(Sg,Press,s,'linear','extrap');
%        end
%        
       TVector = unique([linspace(TMin,TMid,N),linspace(TMid,TMax,N)]);
       PVector = zeros(size(TVector));
%         PVector = unique([linspace(Pmin,PMid,N),linspace(PMid,PMax,N)]);
%         TVector = zeros(size(PVector));
%         
       vVector = zeros(size(TVector));
        
        for i = 1:numel(TVector)
            if 0
            %Data = StateDetect('T',TVector(i),'s',s,Table);
            Data = StateDetect('T',TVector(i),'s',s,Table);

            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                    vVector(i) = Data.v;
                case 'SuperHeat'
                   %SuperState = SuperHeatR('T',TVector(i),'s',s,Table);
                   SuperState = SuperHeatAll('T',TVector(i),'s',s,Table,Critical,0);
                   
                   PVector(i) = SuperState.P;
                   vVector(i) = SuperState.v;
                case 'SubCooled'
                    SubState = SubCooledAll('T',TVector(i),'s',s,Table,0);
                    PVector(i) = SubState.P;
                    vVector(i) = SubState.v;
            end
            else
                [~,State] = PropertyCalculateSafe('T',TVector(i),'s',s,Table,Critical);
                if State.P == 0
                    TVector(i) = 0; % used break case at supercritical, remove data
                end
                PVector(i) = State.P;
                vVector(i) = State.v;
            end
      
            end

            %remove zero points from incompressible liquid        
        PVector = PVector(TVector~=0)
        vVector = vVector(TVector~=0)
        TVector = TVector(TVector~=0)
       
        Out.P = PVector;
        Out.s = s*ones(size(TVector));
        Out.T = TVector;
        Out.v = vVector;


        



end