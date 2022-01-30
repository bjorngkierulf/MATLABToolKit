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
                    vf = interp1(Uf,Vf,Value2,'linear','extrap');
                    if Value1>vf
                        Out = 'Saturated';
                    else
                        Out = 'SubCooled';
                    end
                    
                end
                
                
            case 'h'
                
                hg = interp1(Vg,Hg,Value1,'linear','extrap');
                if Value2>hg
                    Out = 'SuperHeat';
                else
                    vf = interp1(Hf,Vf,Value2,'linear','extrap');
                    if Value1>vf
                        Out = 'Saturated';
                    else
                        Out = 'SubCooled';
                    end
                    
                end
                
            case 's'
                
                sg = interp1(Vg,Sg,Value1,'linear','extrap');
                if Value2>sg
                    Out = 'SuperHeat';
                else
                    vf = interp1(Sf,Vf,Value2,'linear','extrap');
                    if Value1>vf
                        Out = 'Saturated';
                    else
                        Out = 'SubCooled';
                    end
                    
                end
                
                
        end
        
        
        
    case 'u'
        
        switch Prop2
            
            case 'h'
                hg = interp1(Ug,Hg,Value1,'linear','extrap');
                if Value2>hg
                    Out = 'SuperHeat';
                else
                    uf = interp1(Hf,Uf,Value2,'linear','extrap');
                    if Value1>uf
                        Out = 'Saturated';
                    else
                        Out = 'SubCooled';
                    end
                end
                
        end
        
        
        
end










end