function Out = ProcIsoThermLine(T,v1,v2,Table)

        %all of these need to be redone
        %just have them call the iso line function, then cut out all data
        %greater or less than v1, v2. Then add back in the first and last
        %points
        %oh shit these also need to be reimplemented to work with specific
        %entropy as well as volume, yeahhhh
        %no nevermind maybe it's ok

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


        %N = 10;
        N = 150;
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