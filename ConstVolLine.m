function Out = ConstVolLine(v,Table,Critical)



       % Exctracting Saturation Data
%        Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       
 
       if v <= Critical.v
          PMid =  interp1(Vf,Press,v,'linear','extrap'); 
       else
          PMid =  interp1(Vg,Press,v,'linear','extrap');
       end
       
       PMax = 300; Pmin = 0.01; 
       N = 5;
       
       PVector = unique([linspace(Pmin,PMid,N),linspace(PMid,PMax,N)]);
       TVector = zeros(size(PVector));
        
        for i = 1:numel(PVector)
            
            Data = StateDetect('P',PVector(i),'v',v,Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    TVector(i) = Data.T;
                case 'SuperHeat'
                   SuperState = SuperHeat(PVector(i),'v',v,Table);
                   TVector(i) = SuperState.T;
                case 'SubCooled'
                    SubState = SubCooled(PVector(i),'v',v,Table);
                    TVector(i) = SubState.T;
            end
            
      
        end

       Out.P = PVector;
       Out.v = v*ones(size(PVector));
       Out.T = TVector;


end