function Out = ProcConstVolLine(v,P1,P2,Table)


if P1>P2
   Pmid = P1;
   P1 = P2;
   P2 = Pmid;
end


       % Exctracting Saturation Data
%        Temp = Table.Sat.T;
%        Press = Table.Sat.P;
%        Vf = Table.Sat.vf;
%        Vg = Table.Sat.vg;
%        
    
       N = 10;
       
       PVector = linspace(P1,P2,N);
       TVector = zeros(size(PVector));
       SVector = zeros(size(PVector));
       
       
       for i = 1:numel(PVector)
            
            Data = StateDetect('P',PVector(i),'v',v,Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    TVector(i) = Data.T;
                    SVector(i) = Data.s;
                case 'SuperHeat'
                   SuperState = SuperHeat(PVector(i),'v',v,Table);
                   TVector(i) = SuperState.T;
                   SVector(i) = SuperState.s;
                case 'SubCooled'
                    SubState = SubCooled(PVector(i),'v',v,Table);
                    TVector(i) = SubState.T;
                    SVector(i) = SubState.s;
            end
            
      
        end

       Out.P = PVector;
       Out.v = v*ones(size(PVector));
       Out.T = TVector;


end