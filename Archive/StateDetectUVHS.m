function Out = StateDetectUVHS(Prop1,Value1,Prop2,Value2,Table)



% Table:  Data Table

       % Exctracting Saturation Data

       Vf = Table.Sat.vf;
       Vg = Table.Sat.vg;
       Uf = Table.Sat.uf;
       Ug = Table.Sat.ug;
       Hf = Table.Sat.hf;
       Hg = Table.Sat.hg;      
       Sf = Table.Sat.sf;
       Sg = Table.Sat.sg;      



% First Independent Property 
 switch Prop1
     
     case 'v'
         
         switch Prop2
             
             case 'u'
                 ug = interp1(Vg,Ug,Value1,'linear','extrap');
                 if Value2>ug
                     Out = 'SuperHeat';
                 else
                     uf = interp1(Vf,Uf,Value1,'linear','extrap');
                     if Value2>uf
                         Out = 'Saturated';
                     else
                         Out = 'SubCooled';
                     end
                     
                 end
                 
             
             case 'h'
                 
                 
             case 's'
                 
                 
         end
             

       
     case 'v' 
         

       
 end

             
 

         
   




end