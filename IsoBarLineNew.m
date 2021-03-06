function Out = IsoBarLineNew(P,Table)

        N = 15;
       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       Sf = Table.Sat.sf;
       Sg = Table.Sat.sg;
       
       SatState.P = P;
       SatState.T = interp1(Press,Temp,P,'linear','extrap');
       SatState.vf = interp1(Press,Vf,P,'linear','extrap');
       SatState.vg = interp1(Press,Vg,P,'linear','extrap');
       %to be implemented
       SatState.sf = interp1(Press,Sf,P,'linear','extrap');
       SatState.sg = interp1(Press,Sg,P,'linear','extrap');

       
%% SubCooled Section 
if isempty(Table.SubCooled)
        fprintf("Incompressible liquid - isobar will not be generated in subcooled region")
        vSubVec = [];
else
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
        
        %override because this is dumb
        vmin = 1.1*10^-3;
        % Subcooled Span
        vSubVec = linspace(vmin,SatState.vf,N*3);

end %robust to R134a
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

%         a = Table.SuperHeat.P
%         b = P1

        IndP1 = Table.SuperHeat.P == P1;
        vMax1 = max(Table.SuperHeat.v(IndP1));
        
        IndP2 = Table.SuperHeat.P == P2;
        vMax2 = max(Table.SuperHeat.v(IndP2));

        vMax = interp1([P1 P2],[vMax1 vMax2],P,'linear','extrap');

        end
        
        vSupVec = linspace(SatState.vg,vMax,N);
        
        vVector = [vSubVec,vSatVec,vSupVec];
        TVector = zeros(size(vVector));
        sVector = zeros(size(vVector));

        for i = 1:numel(vVector)
            
            if vVector(i)<=SatState.vf || vVector(i)>=SatState.vg
                
                Data = StateDetect('P',P,'v',vVector(i),Table);
                
                switch Data.State
                    
                    case 'Saturated'
                        TVector(i) = Data.T;
                        sVector(i) = Data.s;
                        %sVector = [sVector, Data.s];
                    case 'SuperHeat'
                        SuperState = SuperHeat(P,'v',vVector(i),Table);
                        TVector(i) = SuperState.T;
                        %sVector(i) = SuperState.s;
                        sVector(i) = SuperState.s;
                    case 'SubCooled'
                        SubState = SubCooled(P,'v',vVector(i),Table);
                        TVector(i) = SubState.T;
                        %sVector = [sVector, SubState.s];
                        sVector(i) = SubState.s;
                end
                
            else
                TVector(i) = SatState.T;
                fprintf("here")
                sVector(i) = SatState.sf; %just either will work
                %sVector(i) = SatState.s;
                %sVector = [sVector, SatState.sf, SatState.sg];
                %sVector = [sVector, SatState.sf]
            end
            
        end
            

       Out.T = TVector;
       Out.P = P*ones(size(TVector));
       Out.v = vVector;
       % add compatibility for T-S diagrams
       Out.s = sVector;


