function Out = SVStateDetect(Prop1,Value1,Prop2,Value2,Table)


% Inputs Description:


% Prop1: First Porperty 'T', 'P'
% Value1:  Value of the First Property

% Prop2: Second Porperty 'T', 'v', 'P'
% Value2: Value of the Second Property

% Table:  Data Table


% First Independent Property 
 switch Prop1
     
     case 'T'
       
       % Exctracting Sat - Temp Table
       Temp = Table.SatSV.T;
       Press = Table.SatSV.P;
       Vi = Table.SatSV.vi;
       Vg = Table.SatSV.vg;
       
       % Saturation Data
       
       SatState.T = Value1;
       SatState.P = interp1(Temp,Press,Value1,'linear','extrap'); 
       SatState.vi = interp1(Temp,Vi,Value1,'linear','extrap'); 
       SatState.vg = interp1(Temp,Vg,Value1,'linear','extrap'); 
       
       % Output
       Out.T = Value1;
       
     case 'P'
         
       % Exctracting Sat - Press Table 
       Temp = Table.SatSV.T;
       Press = Table.SatSV.P;
       Vf = Table.SatSV.vf;
       Vg = Table.SatSV.vg; 
       
       % Saturation Data
       SatState.P = Value1;
       SatState.T = interp1(Press,Temp,Value1,'linear','extrap'); 
       SatState.vi = interp1(Press,Vf,Value1,'linear','extrap'); 
       SatState.vg = interp1(Press,Vg,Value1,'linear','extrap'); 
       
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
         end
         
         % Output
         Out.P = Value2;
         
     case 'v'
         
         % Identifying Phase State
         if Value2 > SatState.vg
             Out.State = 'SuperHeat';
         elseif Value2 < SatState.vi
             Out.State = 'SubCooled';
         else
             Out.State = 'Saturated';

             % Output - Pressure
             Out.P = SatState.P;
             Out.T = SatState.T;
             Out.v = Value2;
             
             % Output - Quality
%              Out.x = (Value2-SatState.vf)/(SatState.vg-SatState.vf);
            
         end
         
         
 end





end