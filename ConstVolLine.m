function Out = ConstVolLine(v,Table,Critical)

if isempty(Table.SubCooled)
           PMax = 20;
           fprintf("Constant volume line functionality not currently supported for R134a")
           Out = []

           
else


       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       %Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       %Sf = Table.Sat.sf;
       %Sg = Table.Sat.sg;
       
 
       if v <= Critical.v
          TMid =  interp1(Vf,Temp,v,'linear','extrap'); 
       else
          TMid =  interp1(Vg,Temp,v,'linear','extrap');
       end
       
       TMax = 500; %C
       TMin = 10; %C

       %change PMax if the fluid is R134a
       
       PMax = 50; %arbitrary, but stops it from going up to ~1500C easily

       %TMax = 700; %arbitrary, but stops it from going up to ~1500C easily
       N = 50;
       
       TVector = unique([linspace(TMin,TMid,N),linspace(TMid,TMax,N)]);
       PVector = zeros(size(TVector));
       sVector = zeros(size(TVector));
        
        for i = 1:numel(TVector)
            
            Data = StateDetect('T',TVector(i),'v',v,Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    PVector(i) = Data.P;
                    sVector(i) = Data.s;
                case 'SuperHeat'
                   SuperState = SuperHeatAll('T',TVector(i),'v',v,Table,0);
                   PVector(i) = SuperState.P;
                   sVector(i) = SuperState.s;
                case 'SubCooled'
                    if isempty(Table.SubCooled)
                        fprintf("Incompressible liquid - isobar will not be generated in subcooled region")
                        TVector(i) = 0;
                        PVector(i) = 0;
                        sVector(i) = 0;
                    else
                        
                    SubState = SubCooledAll('T',TVector(i),'v',v,Table,0);
                    PVector(i) = SubState.P;
                    sVector(i) = SubState.s;
                    end
            end
            
      
        end

        %remove zero points from incompressible liquid        
        PVector = PVector(TVector~=0)
        sVector = sVector(TVector~=0)
        TVector = TVector(TVector~=0)



%         TVectorLimited = TVector;
%         PVectorLimited = PVector;
%         sVectorLimited = sVector;

        %limit based on temperature
%         for i = 1:numel(PVector)
% 
%             if TVector(i) > TMax
%                 TVectorLimited(i) = [];
%                 PVectorLimited(i) = [];
%                 sVectorLimited(i) = [];
%             end
% 
%         end

        TVectorLimited = TVector(TVector <= TMax);
        PVectorLimited = PVector(TVector <= TMax);
        sVectorLimited = sVector(TVector <= TMax);


       Out.P = PVectorLimited;
       Out.v = v*ones(size(PVectorLimited));
       Out.T = TVectorLimited;
       Out.s = sVectorLimited;


end


% 
%        % Exctracting Saturation Data
% %        Temp = Table.Sat.T;
%        Press = Table.Sat.P;
%        Vf = Table.Sat.vf;
%        Vg = Table.Sat.vg;
%        %Sf = Table.Sat.sf;
%        %Sg = Table.Sat.sg;
%        
%  
%        if v <= Critical.v
%           PMid =  interp1(Vf,Press,v,'linear','extrap'); 
%        else
%           PMid =  interp1(Vg,Press,v,'linear','extrap');
%        end
%        
%        PMax = 300; Pmin = 0.01; 
%        PMax = 30;
% 
%        %change PMax if the fluid is R134a
%        
%        TMax = 700; %arbitrary, but stops it from going up to ~1500C easily
%        N = 100;
%        
%        PVector = unique([linspace(Pmin,PMid,N),linspace(PMid,PMax,N)]);
%        TVector = zeros(size(PVector));
%        sVector = zeros(size(PVector));
%         
%         for i = 1:numel(PVector)
%             
%             Data = StateDetect('P',PVector(i),'v',v,Table);
%             
%             switch Data.State 
%                 
%                 case 'Saturated'             
%                     TVector(i) = Data.T;
%                     sVector(i) = Data.s;
%                 case 'SuperHeat'
%                    SuperState = SuperHeatAll('P',PVector(i),'v',v,Table,0);
%                    TVector(i) = SuperState.T;
%                    sVector(i) = SuperState.s;
%                 case 'SubCooled'
%                     if isempty(Table.SubCooled)
%                         fprintf("Incompressible liquid - isobar will not be generated in subcooled region")
%                         TVector(i) = 0;
%                         sVector(i) = 0;
%                     else
%                         
%                     SubState = SubCooled(PVector(i),'v',v,Table);
%                     TVector(i) = SubState.T;
%                     sVector(i) = SubState.s;
%                     end
%             end
%             
%       
%         end
%         
%         PVector = PVector(TVector~=0)
%         sVector = sVector(TVector~=0)
%         TVector = TVector(TVector~=0)
%         %remove zero points from incompressible liquid
% 
% 
% 
% %         TVectorLimited = TVector;
% %         PVectorLimited = PVector;
% %         sVectorLimited = sVector;
% 
%         %limit based on temperature
% %         for i = 1:numel(PVector)
% % 
% %             if TVector(i) > TMax
% %                 TVectorLimited(i) = [];
% %                 PVectorLimited(i) = [];
% %                 sVectorLimited(i) = [];
% %             end
% % 
% %         end
% 
%         TVectorLimited = TVector(TVector <= TMax);
%         PVectorLimited = PVector(TVector <= TMax);
%         sVectorLimited = sVector(TVector <= TMax);
% 
% 
%        Out.P = PVectorLimited;
%        Out.v = v*ones(size(PVectorLimited));
%        Out.T = TVectorLimited;
%        Out.s = sVectorLimited;
% 
% 
% end

end