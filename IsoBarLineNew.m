function Out = IsoBarLineNew(P,Table)

        N = 5;
       % Exctracting Saturation Data
       Temp = Table.Sat.T
       Press = Table.Sat.P
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       
       SatState.P = P;
       SatState.T = interp1(Press,Temp,P,'linear','extrap')
       SatState.vf = interp1(Press,Vf,P,'linear','extrap')
       SatState.vg = interp1(Press,Vg,P,'linear','extrap')
       
%% SubCooled Section 


        % Pressure Values
        PValuesSub = unique(Table.SubCooled.P); 

        if any(PValuesSub == P)       
            Ind = Table.SubCooled.P == P;
            vmin = min(Table.SubCooled.v(Ind));                
        else

        % Identifying the Pressure Span
        Ind = find(P<=PValuesSub,1,'first');

        if Ind == 1
            P1 = PValuesSub(Ind); P2 = PValuesSub(Ind+1); 
        else
            P1 = PValuesSub(Ind-1); P2 = PValuesSub(Ind); 
        end

        IndP1 = Table.SubCooled.P == P1;
        vmin1 = min(Table.SubCooled.v(IndP1));
        
        IndP2 = Table.SubCooled.P == P2;
        vmin2 = min(Table.SubCooled.v(IndP2));

        vmin = interp1([P1 P2],[vmin1 vmin2],P,'linear','extrap');
        
        end
        
        % Subcooled Span
        vSubVec = linspace(vmin,SatState.vf,N*3);
        vSatVec = linspace(SatState.vf,SatState.vg,N);
        
        
        %% SuperHeat Section
        
        % Pressure Values
        PValuesSuP = unique(Table.SuperHeat.P); 
        
        if any(PValuesSuP == P)       
            Ind = Table.SuperHeat.P == P;
            vMax = max(Table.SuperHeat.v(Ind));                
        else

        % Identifying the Pressure Span
        Ind = find(P<=PValuesSuP,1,'first');

        if Ind == 1
            P1 = PValuesSuP(Ind); P2 = PValuesSuP(Ind+1); 
        else
            P1 = PValuesSuP(Ind-1); P2 = PValuesSuP(Ind); 
        end

        IndP1 = Table.SuperHeat.P == P1;
        vMax1 = max(Table.SuperHeat.v(IndP1));
        
        IndP2 = Table.SuperHeat.P == P2;
        vMax2 = max(Table.SuperHeat.v(IndP2));

        vMax = interp1([P1 P2],[vMax1 vMax2],P,'linear','extrap');

        end
        
        vSupVec = linspace(SatState.vg,vMax,N);
        
        vVector = [vSubVec,vSatVec,vSupVec];
        TVector = zeros(size(vVector));
        
        for i = 1:numel(vVector)
            
            if vVector(i)<=SatState.vf || vVector(i)>=SatState.vg
                
                Data = StateDetect('P',P,'v',vVector(i),Table);
                
                switch Data.State
                    
                    case 'Saturated'
                        TVector(i) = Data.T;
                    case 'SuperHeat'
                        SuperState = SuperHeat(P,'v',vVector(i),Table);
                        TVector(i) = SuperState.T;
                    case 'SubCooled'
                        SubState = SubCooled(P,'v',vVector(i),Table);
                        TVector(i) = SubState.T;
                end
                
            else
                TVector(i) = SatState.T;
            end
            
        end
            

       Out.T = TVector;
       Out.P = P*ones(size(TVector));
       Out.v = vVector;


