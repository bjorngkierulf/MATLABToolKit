function Out = StateDetect(Prop1,Value1,Prop2,Value2,Table)


% Inputs Description:


if strcmp(Prop2,'T') || strcmp(Prop2,'P') 
    
        MidProp = Prop1;
        MidValue = Value1;
        
        Prop1 = Prop2;
        Value1 = Value2;
        
        Prop2 = MidProp;
        Value2 = MidValue;
    
end


% Prop1: First Porperty 'T', 'P'
% Value1:  Value of the First Property

% Prop2: Second Porperty 'T', 'v', 'P'
% Value2: Value of the Second Property

% Table:  Data Table

       % Exctracting Saturation Data
       Temp = Table.Sat.T;
       Press = Table.Sat.P;
       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       Vfg = Table.Sat.vfg;
       Uf = Table.Sat.uf;
       Ug = Table.Sat.ug;
       Ufg = Table.Sat.ufg;
       Hf = Table.Sat.hf;
       Hg = Table.Sat.hg;      
       Hfg = Table.Sat.hfg;
       Sf = Table.Sat.sf;
       Sg = Table.Sat.sg;      
       Sfg = Table.Sat.sfg;


% First Independent Property 
 switch Prop1
     
     case 'T'
     
       SatState.T = Value1;
       SatState.P = interp1(Temp,Press,Value1,'linear','extrap'); 
       SatState.vf = interp1(Temp,Vf,Value1,'linear','extrap'); 
       SatState.vg = interp1(Temp,Vg,Value1,'linear','extrap');
       SatState.uf = interp1(Temp,Uf,Value1,'linear','extrap'); 
       SatState.ug = interp1(Temp,Ug,Value1,'linear','extrap');
       SatState.hf = interp1(Temp,Hf,Value1,'linear','extrap'); 
       SatState.hg = interp1(Temp,Hg,Value1,'linear','extrap');
       SatState.sf = interp1(Temp,Sf,Value1,'linear','extrap');
       SatState.sg = interp1(Temp,Sg,Value1,'linear','extrap');
       % Output
       Out.T = Value1;
       
     case 'P' 
         
            
       % Saturation Data
       SatState.P = Value1;
       SatState.T = interp1(Press,Temp,Value1,'linear','extrap'); 
       SatState.vf = interp1(Press,Vf,Value1,'linear','extrap'); 
       SatState.vg = interp1(Press,Vg,Value1,'linear','extrap'); 
       SatState.uf = interp1(Press,Uf,Value1,'linear','extrap'); 
       SatState.ug = interp1(Press,Ug,Value1,'linear','extrap'); 
       SatState.hf = interp1(Press,Hf,Value1,'linear','extrap'); 
       SatState.hg = interp1(Press,Hg,Value1,'linear','extrap');
       SatState.sf = interp1(Press,Sf,Value1,'linear','extrap');
       SatState.sg = interp1(Press,Sg,Value1,'linear','extrap');
       % Output
       Out.P = Value1;
       
 end

 
 switch Prop2
     
     case 'T'
         
         % Identifying Phase State
         if Value2 < SatState.T
             Out.State = 'SubCooled';
         elseif Value2 > SatState.T
             Out.State = 'SuperHeat';
         else
             Out.State = 'Saturated';
                        
             Out.P = SatState.P;
             Out.vf = SatState.vf;
             Out.vg = SatState.vg;
             Out.uf = SatState.uf;
             Out.ug = SatState.ug;
             Out.hf = SatState.hf;
             Out.hg = SatState.hg;
             
         end
             
         % Output
         Out.T = Value2;
         
     case 'P'

         % Identifying Phase State
         if Value2 > SatState.P
             Out.State = 'SubCooled';
         elseif Value2 < SatState.P
             Out.State = 'SuperHeat';
         else
             Out.State = 'Saturated';
             
             Out.T = SatState.T;
             Out.vf = SatState.vf;
             Out.vg = SatState.vg;
             Out.uf = SatState.uf;
             Out.ug = SatState.ug;
             Out.hf = SatState.hf;
             Out.hg = SatState.hg;
         end
         
         % Output
         Out.P = Value2;
         
     case 'v'
         
         % Identifying Phase State
         if Value2 > SatState.vg
             Out.State = 'SuperHeat';
         elseif Value2 < SatState.vf
             Out.State = 'SubCooled';
         else
             Out.State = 'Saturated';

             % Output - Pressure
             Out.P = SatState.P;
             Out.T = SatState.T;
             Out.v = Value2;
  
             % Output - Quality
             Out.x = (Value2-SatState.vf)/(SatState.vg-SatState.vf);
             Out.u = SatState.uf +  Out.x * (SatState.ug - SatState.uf);
             Out.h = SatState.hf +  Out.x * (SatState.hg - SatState.hf);
             Out.s = SatState.sf +  Out.x * (SatState.sg - SatState.sf);
         end
         
     case 'u'
         
         % Identifying Phase State
         if Value2 > SatState.ug
             Out.State = 'SuperHeat';
         elseif Value2 < SatState.uf
             Out.State = 'SubCooled';
         else
             Out.State = 'Saturated';

             % Output - Pressure
             Out.P = SatState.P;
             Out.T = SatState.T;
             Out.u = Value2;
  
             % Output - Quality
             Out.x = (Value2-SatState.uf)/(SatState.ug-SatState.uf);
             Out.v = SatState.vf +  Out.x * (SatState.vg - SatState.vf);
             Out.h = SatState.hf +  Out.x * (SatState.hg - SatState.hf);
             Out.s = SatState.sf +  Out.x * (SatState.sg - SatState.sf);
         end
         
     case 'h'
         % Identifying Phase State
         if Value2 > SatState.hg
             Out.State = 'SuperHeat';
         elseif Value2 < SatState.hf
             Out.State = 'SubCooled';
         else
             Out.State = 'Saturated';
             
             % Output - Pressure
             Out.P = SatState.P;
             Out.T = SatState.T;
             Out.h = Value2;
             
             % Output - Quality
             Out.x = (Value2-SatState.hf)/(SatState.hg-SatState.hf);
             Out.u = SatState.uf +  Out.x * (SatState.ug - SatState.uf);
             Out.v = SatState.vf +  Out.x * (SatState.vg - SatState.vf);
             Out.s = SatState.sf +  Out.x * (SatState.sg - SatState.sf);
         end
         
     case 's'
         % Identifying Phase State
         if Value2 > SatState.sg
             Out.State = 'SuperHeat';
         elseif Value2 < SatState.sf
             Out.State = 'SubCooled';
         else
             Out.State = 'Saturated';
             
             % Output - Pressure
             Out.P = SatState.P;
             Out.T = SatState.T;
             Out.s = Value2;
             
             % Output - Quality
             Out.x = (Value2-SatState.sf)/(SatState.sg-SatState.sf);
             Out.u = SatState.uf +  Out.x * (SatState.ug - SatState.uf);
             Out.v = SatState.vf +  Out.x * (SatState.vg - SatState.vf);
             Out.h = SatState.hf +  Out.x * (SatState.hg - SatState.hf);
         end
   
 end


end