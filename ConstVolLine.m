function Out = ConstVolLine(v,Table,Critical)



       % Exctracting Saturation Data
%        Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       %Sf = Table.Sat.sf;
       %Sg = Table.Sat.sg;
       
 
       if v <= Critical.v
          PMid =  interp1(Vf,Press,v,'linear','extrap'); 
       else
          PMid =  interp1(Vg,Press,v,'linear','extrap');
       end
       
       PMax = 300; Pmin = 0.01; 
       TMax = 700; %arbitrary, but stops it from going up to ~1500C easily
       N = 100;
       
       PVector = unique([linspace(Pmin,PMid,N),linspace(PMid,PMax,N)]);
       TVector = zeros(size(PVector));
       sVector = zeros(size(PVector));
        
        for i = 1:numel(PVector)
            
            Data = StateDetect('P',PVector(i),'v',v,Table);
            
            switch Data.State 
                
                case 'Saturated'             
                    TVector(i) = Data.T;
                    sVector(i) = Data.s;
                case 'SuperHeat'
                   SuperState = SuperHeat(PVector(i),'v',v,Table);
                   TVector(i) = SuperState.T;
                   sVector(i) = SuperState.s;
                case 'SubCooled'
                    SubState = SubCooled(PVector(i),'v',v,Table);
                    TVector(i) = SubState.T;
                    sVector(i) = SubState.s;
            end
            
      
        end
        
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