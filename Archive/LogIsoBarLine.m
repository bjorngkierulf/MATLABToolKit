function Out = LogIsoBarLine(P,Table)


 global Critical

       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       
       SatState.P = P;
       SatState.T = interp1(Press,Temp,P,'linear','extrap'); 
       SatState.vf = interp1(Press,Vf,P,'linear','extrap'); 
       SatState.vg = interp1(Press,Vg,P,'linear','extrap');
       

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
        
        N = 10;
        vVector = [linspace(vmin,SatState.vf,N),linspace(SatState.vf,SatState.vg,N) ...
            ,linspace(SatState.vg,vMax,N)];
        TVector = zeros(size(vVector));
        
        for i = 1:numel(vVector)
            
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
            
            
            
        end


        figure(1)
%         plot((Table.Sat.vf),(Table.Sat.T),'-b',(Table.Sat.vg),(Table.Sat.T),'-b',(vVector),(TVector),'.-r')
        n = 90;
        Vf = Table.Sat.vf; Vf(Vf<=Critical.v) = Vf(Vf<=Critical.v)*n; 
        Vf(Vf>Critical.v) = Vf(Vf>Critical.v) + Critical.v*n;
        
        Vg = Table.Sat.vg; 
        Vg = Vg + Critical.v*n;
        
        plot(Vf,(Table.Sat.T),'-r',Vg,(Table.Sat.T),'-b')

        %                 hold on 
%         plot(vVector,TVector,'.-r')

        set(gca,'XScale','log')
        xlabel('V')
        ylabel('T')
%         pbaspect([5 1 1])
%         axis equal
        
        
%         figure(2)
%         plot(Table.Sat.vf,Table.Sat.P,'-b',Table.Sat.vg,Table.Sat.P,'-b',vVector,P*ones(size(vVector)),'.-r')
% %                 hold on 
% %         plot(vVector,P*ones(size(vVector)),'.-r')
% 
%         set(gca,'XScale','log')
%         xlabel('V')
%         ylabel('P')
     

       Out.T = TVector;
       Out.P = P*ones(size(TVector));
       Out.v = vVector;


end