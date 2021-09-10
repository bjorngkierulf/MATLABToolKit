function Out = ProcIsentropicLine(s,T1,T2,Table)

    if T1>T2
       S = T2;
       T1 = T2;
       T2 = S;
    end

%        % Exctracting Saturation Data
%        Temp = Table.Sat.T;
%        Press = Table.Sat.P;
%        Sf = Table.Sat.sf;
%        Sg = Table.Sat.sg;

       N = 10;
       
       TVector = linspace(T1,T2,N);
       PVector = zeros(size(TVector));
       vVector = zeros(size(TVector));
       
        for i = 1:numel(TVector)
            
            Data = StateDetect('T',TVector(i),'s',s,Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                    vVector(i) = Data.v;
                case 'SuperHeat'
                   SuperState = SuperHeatR('T',TVector(i),'s',s,Table);
                   PVector(i) = SuperState.P;
                   vVector(i) = SuperState.v;
                case 'SubCooled'
                    SubState = SubcooledR('T',TVector(i),'s',s,Table);
                    PVector(i) = SubState.P;
                    vVector(i) = SubState.v;
            end
            
      
        end

       Out.P = PVector;
       Out.s = s*ones(size(TVector));
       Out.T = TVector;
       Out.v = vVector;


end