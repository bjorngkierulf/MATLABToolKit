function Out = ProcIsoThermLine(T,v1,v2,Table)


        if v1>v2
            vmid = v1;
            v1 = v2;
            v2 = vmid;
        end

       % Exctracting Saturation Data
%        Temp = Table.Sat.T;
%        Press = Table.Sat.P;
%        Vf = Table.Sat.vf;
%        Vg = Table.Sat.vg;
       
%        SatState.T = T;
%        SatState.P = interp1(Press,Temp,T,'linear','extrap'); 
%        SatState.vf = interp1(Temp,Vf,T,'linear','extrap'); 
%        SatState.vg = interp1(Temp,Vg,T,'linear','extrap');


        N = 10;
        vVector = linspace(v1,v2,N);
        PVector = zeros(size(vVector));
        SVector = zeros(size(vVector));
        
        for i = 1:numel(vVector)
            
            Data = StateDetect('T',T,'v',vVector(i),Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                    SVector(i) = Data.s;
                case 'SuperHeat'
                   SuperState = SuperHeatR('T',T,'v',vVector(i),Table);
                   PVector(i) = SuperState.P;
                   SVector(i) = SuperState.s;
                case 'SubCooled'
                    SubState = SubcooledR('T',T,'v',vVector(i),Table);
                    PVector(i) = SubState.P;
                    SVector(i) = SubState.s;
            end
            
      
        end

       Out.P = PVector;
       Out.T = T*ones(size(PVector));
       Out.v = vVector;
       Out.s = SVector;


end