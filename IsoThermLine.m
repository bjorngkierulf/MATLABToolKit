function Out = IsoThermLine(T,Table)



       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       
       SatState.T = T;
       SatState.P = interp1(Temp,Press,T,'linear','extrap'); 
       SatState.vf = interp1(Temp,Vf,T,'linear','extrap'); 
       SatState.vg = interp1(Temp,Vg,T,'linear','extrap');



    PVec = unique(Table.SubCooled.P);
    NewTable.v = zeros(size(PVec));

        for i = 1:numel(PVec)
           Ind = find(Table.SubCooled.P == PVec(i));
           NewTable.v(i) = interp1(Table.SubCooled.T(Ind),Table.SubCooled.v(Ind),T,'linear','extrap');
        end   
        vmin = min(NewTable.v);


    PVec = unique(Table.SuperHeat.P);
    NewTable.v = zeros(size(PVec));

        for i = 1:numel(PVec)
           Ind = find(Table.SuperHeat.P == PVec(i));
           NewTable.v(i) = interp1(Table.SuperHeat.T(Ind),Table.SuperHeat.v(Ind),T,'linear','extrap');
        end   
        vMax = max(NewTable.v);
     
        N = 10;
        vVector = [linspace(vmin,SatState.vf,N),linspace(SatState.vf,SatState.vg,N) ...
            ,linspace(SatState.vg,vMax,N)];
        PVector = zeros(size(vVector));
        
        for i = 1:numel(vVector)
            
            Data = StateDetect('T',T,'v',vVector(i),Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                case 'SuperHeat'
                   SuperState = SuperHeatR('T',T,'v',vVector(i),Table);
                   PVector(i) = SuperState.P;
                case 'SubCooled'
                    SubState = SubcooledR('T',T,'v',vVector(i),Table);
                    PVector(i) = SubState.P;
            end
            
      
        end


%         figure(1)
%         plot(Table.Sat.vf,Table.Sat.T,'-b',Table.Sat.vg,Table.Sat.T,'-b',vVector,T*ones(size(vVector)),'.-r')
%                 hold on 
% %         plot(vVector,T*ones(size(vVector)),'.-r')
% 
%         set(gca,'XScale','log')
%         xlabel('V')
%         ylabel('T')
%         
%         
%         figure(2)
%         plot(Table.Sat.vf,Table.Sat.P,'-b',Table.Sat.vg,Table.Sat.P,'-b',vVector,PVector,'.-r')
%                 hold on 
% %         plot(vVector,PVector,'.-r')
% 
%         set(gca,'XScale','log')
%         xlabel('V')
%         ylabel('P')
     

       Out.P = PVector;
       Out.T = T*ones(size(PVector));
       Out.v = vVector;


end