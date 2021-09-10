function Out = IsentropicLine(s,Table,Critical)



       % Exctracting Saturation Data
       Temp = Table.Sat.T;
%        Press = Table.Sat.P;
       Sf = Table.Sat.sf;
       Sg = Table.Sat.sg;
       
 
       if s <= Critical.s
          TMid =  interp1(Sf,Temp,s,'linear','extrap'); 
       else
           TMid =  interp1(Sg,Temp,s,'linear','extrap');
       end
       
       TMax = 550; Tmin = 1;
       N = 5;
       
       TVector = unique([linspace(Tmin,TMid,N),linspace(TMid,TMax,N)]);
       PVector = zeros(size(TVector));
        
        for i = 1:numel(TVector)
            
            Data = StateDetect('T',TVector(i),'s',s,Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                case 'SuperHeat'
                   SuperState = SuperHeatR('T',TVector(i),'s',s,Table);
                   PVector(i) = SuperState.P;
                case 'SubCooled'
                    SubState = SubcooledR('T',TVector(i),'s',s,Table);
                    PVector(i) = SubState.P;
            end
            
      
        end

       Out.P = PVector;
       Out.s = s*ones(size(TVector));
       Out.T = TVector;


end