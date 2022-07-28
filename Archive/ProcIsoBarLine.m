function Out = ProcIsoBarLine(P,v1,v2,Table)

       %N = 5;
       N = 40;

       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       
       SatState.P = P;
       SatState.T = interp1(Press,Temp,P,'linear','extrap'); 
       SatState.vf = interp1(Press,Vf,P,'linear','extrap'); 
       SatState.vg = interp1(Press,Vg,P,'linear','extrap');

       
        vVector = linspace(v1,v2,N);
        TVector = zeros(size(vVector));
        SVector = zeros(size(vVector));
        for i = 1:numel(vVector)
            
            if vVector(i)<=SatState.vf || vVector(i)>=SatState.vg
                
                Data = StateDetect('P',P,'v',vVector(i),Table);
                
                switch Data.State
                    
                    case 'Saturated'
                        TVector(i) = Data.T;
                        SVector(i) = Data.s;
                    case 'SuperHeat'
                        SuperState = SuperHeat(P,'v',vVector(i),Table);
                        TVector(i) = SuperState.T;
                        SVector(i) = SuperState.s;
                    case 'SubCooled'
                        SubState = SubCooled(P,'v',vVector(i),Table);
                        TVector(i) = SubState.T;
                        SVector(i) = SubState.s;
                end
                
            else
                TVector(i) = SatState.T;
                Data = StateDetect('P',P,'v',vVector(i),Table);
                SVector(i) = Data.s;
            end
 
        end

       Out.T = TVector;
       Out.P = P*ones(size(TVector));
       Out.v = vVector;
       Out.s = SVector;


