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
       
       TMax = 400; Tmin = 10;
       N = 100;

%        PMax = 100;
%        PMin = .5;

%        if s <= Critical.s
%           PMid =  interp1(Sf,Press,s,'linear','extrap'); 
%        else
%            PMid =  interp1(Sg,Press,s,'linear','extrap');
%        end
%        
       TVector = unique([linspace(Tmin,TMid,N),linspace(TMid,TMax,N)]);
       PVector = zeros(size(TVector));
%         PVector = unique([linspace(Pmin,PMid,N),linspace(PMid,PMax,N)]);
%         TVector = zeros(size(PVector));
%         
       vVector = zeros(size(TVector));
        
        for i = 1:numel(TVector)
            
            %Data = StateDetect('T',TVector(i),'s',s,Table);
            Data = StateDetect('T',TVector(i),'s',s,Table);

            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                    vVector(i) = Data.v;
                case 'SuperHeat'
                   %SuperState = SuperHeatR('T',TVector(i),'s',s,Table);
                   SuperState = SuperHeatAll('T',TVector(i),'s',s,Table,0);
                   
                   PVector(i) = SuperState.P;
                   vVector(i) = SuperState.v;
                case 'SubCooled'
                    SubState = SubCooledAll('T',TVector(i),'s',s,Table,0);
                    PVector(i) = SubState.P;
                    vVector(i) = SubState.v;
            end
            
      
        end
       
        Out.P = PVector;
        Out.s = s*ones(size(TVector));
        Out.T = TVector;
        Out.v = vVector;


end