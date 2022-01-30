function Out = StateDetectSafe_Archive(Prop1,Value1,Prop2,Value2,Table,critical)

%this method of state detection works based on assuming that value1 is
%either a saturated liquid or saturated vapour property value. Then it
%finds the row in the saturation tables that corresponds to if it was a
%two phase mixture - this is one row if pressure or temperature is given.
%But multiple rows if something else is given, because it is necessary to
%look at both if it were saturated liquid and saturated vapour





%lets try to generalize this a bit further
%also, this should return all the properties P, T, s, u, h, x... but ONLY
%for liquid-vapour mixture. If it isn't LV mix, then those can be assigned
%as zero

%generalize first, then assess how difficult it would be to implement. If
%it would be a lot more code / complexity, just switch to using
%propertycalculatesafe everywhere




% clc; clear; close all;
% %
% Prop1 = 's';
% Value1 = 10.3;
% %Prop1 = 'P';
% %Value1 = 5;
% 
% %Prop2 = 's';
% %Value2 = 1;
% % 
% % Prop1 = 'h';
% % Value1 = 855;
% 
% % Prop2 = 's';
% % Value2 = 3.2;
% 
% Prop2 = 'T';
% Value2 = 200;
% 
% 
% [Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2);
% 
% 
% [Table,critical] = GenTableNew();
% 

if absBoundsCheck(Prop1,Value1,Prop2,Value2,Table,critical)
    %print statement is in the function, for abs bounds and supercritical
    %fprintf("Invalid Input")
end



%this function computes the state as saturated, subcooled or superheated given prop 1,
%prop 2 as anything. This state detection works for any properties. But
%this function only assigns a value to out.h, out.s, etc. if the state is
%saturated liquid-vapour mixture. If the state is subcooled or superheated,
%then the properties u, h, s, etc must be computed in a later step by
%StateDetectUVHS()

%if pressure or temperature is given as property 2, switch so that it is
%property 1

%this section is not necessary if inputs have already been passed through
%InputSort()
% if strcmp(Prop2,'T') || strcmp(Prop2,'P')

% Exctracting Saturation Data
Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;
%Vfg = Table.Sat.vfg;
Uf = Table.Sat.uf;
Ug = Table.Sat.ug;
%Ufg = Table.Sat.ufg;
Hf = Table.Sat.hf;
Hg = Table.Sat.hg;
%Hfg = Table.Sat.hfg;
Sf = Table.Sat.sf;
Sg = Table.Sat.sg;
%Sfg = Table.Sat.sfg;



%% NEW CODE


% First Independent Property
switch Prop1

    %% P
    case 'P'
        Value1InterpArray = Press; %set this

%         % Saturation Data
%         %SatState.P = Value1;
%         SatState.P = interp1(Press,Press,Value1,'linear','extrap');
%         SatState.T = interp1(Press,Temp,Value1,'linear','extrap');
%         SatState.vf = interp1(Press,Vf,Value1,'linear','extrap');
%         SatState.vg = interp1(Press,Vg,Value1,'linear','extrap');
%         SatState.uf = interp1(Press,Uf,Value1,'linear','extrap');
%         SatState.ug = interp1(Press,Ug,Value1,'linear','extrap');
%         SatState.hf = interp1(Press,Hf,Value1,'linear','extrap');
%         SatState.hg = interp1(Press,Hg,Value1,'linear','extrap');
%         SatState.sf = interp1(Press,Sf,Value1,'linear','extrap');
%         SatState.sg = interp1(Press,Sg,Value1,'linear','extrap');
%         % Output
%         Out.P = Value1;

%         switch Prop2
% 
%             case 'T'
% 
%                 Value2UpperLimit = SatState.T;
%                 Value2LowerLimit = SatState.T;
% 
% %                 % Identifying Phase State
% %                 if Value2 < SatState.T
% %                     Out.State = 'SubCooled';
% %                 elseif Value2 > SatState.T
% %                     Out.State = 'SuperHeat';
% %                 else
% %                     Out.State = 'Saturated';
% %                 end
% 
% 
%             case 'v'
% 
%                 Value2UpperLimit = SatState.vg;
%                 Value2LowerLimit = SatState.vf;
% 
% %                 % Identifying Phase State
% %                 if Value2 > SatState.vg
% %                     Out.State = 'SuperHeat';
% %                 elseif Value2 < SatState.vf
% %                     Out.State = 'SubCooled';
% %                 else
% %                     Out.State = 'Saturated';
% %                 end
% 
%             case 'u'
% 
%                 % Identifying Phase State
%                 if Value2 > SatState.ug
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.uf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'h'
%                 % Identifying Phase State
%                 if Value2 > SatState.hg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.hf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 's'
%                 % Identifying Phase State
%                 if Value2 > SatState.sg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.sf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
%         end

        %% T
    case 'T'
        Value1InterpArray = Temp;
        
        %% v
    case 'v'
        Value1InterpArrayUpper = Vg;
        Value1InterpArrayLower = Vf;


%         switch Prop2
% 
%             case 'u'
%                 ug = interp1(Vg,Ug,Value1,'linear','extrap');
%                 if Value2>ug
%                     Out.State = 'SuperHeat';
%                 else
%                     vf = interp1(Uf,Vf,Value2,'linear','extrap');
%                     if Value1>vf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
% 
%                 end
% 
% 
%             case 'h'
% 
%                 hg = interp1(Vg,Hg,Value1,'linear','extrap');
%                 if Value2>hg
%                     Out.State = 'SuperHeat';
%                 else
%                     vf = interp1(Hf,Vf,Value2,'linear','extrap');
%                     if Value1>vf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
% 
%                 end
% 
%             case 's'
% 
%                 sg = interp1(Vg,Sg,Value1,'linear','extrap');
%                 if Value2>sg
%                     Out.State = 'SuperHeat';
%                 else
%                     vf = interp1(Sf,Vf,Value2,'linear','extrap');
%                     if Value1>vf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
% 
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
% 
%         end

    case 'u'
        Value1InterpArrayUpper = Ug;
        Value1InterpArrayLower = Uf;
%         switch Prop2
% 
%             case 'h'
%                 hg = interp1(Ug,Hg,Value1,'linear','extrap');
%                 if Value2>hg
%                     Out.State = 'SuperHeat';
%                 else
%                     uf = interp1(Hf,Uf,Value2,'linear','extrap');
%                     if Value1>uf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
%                 end
% 
%             case 's'
%                 sg = interp1(Sg,Ug,Value1,'linear','extrap');
%                 if Value2>sg
%                     Out.State = 'SuperHeat';
%                 else
%                     sf = interp1(Sf,Uf,Value2,'linear','extrap');
%                     if Value1>sf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
% 
%         end

    case 'h'
        switch Prop2

            case 's'
                sg = interp1(Sg,Ug,Value1,'linear','extrap');
                if Value2>sg
                    Out.State = 'SuperHeat';
                else
                    sf = interp1(Sf,Uf,Value2,'linear','extrap');
                    if Value1>sf
                        Out.State = 'Saturated';
                    else
                        Out.State = 'SubCooled';
                    end
                end

            case 'x'
                if 0 <= Value2 && 1 >= Value2
                    %both inclusive as 0 and 1 are valid
                    Out.State = 'Saturated';
                else
                    fprintf("Invalid input, quality should be between 0 and 1")
                end

        end

    case 's'
        switch Prop2

            case 'x'
                if 0 <= Value2 && 1 >= Value2
                    %both inclusive as 0 and 1 are valid
                    Out.State = 'Saturated';
                else
                    fprintf("Invalid input, quality should be between 0 and 1")
                end

        end

    case 'x'

        if 0 <= Value1 && 1 >= Value1
            %both inclusive as 0 and 1 are valid
            Out.State = 'Saturated';
        else
            fprintf("Invalid input, quality should be between 0 and 1")
        end

end



%interp for the saturation data

%value1 is of the same unit / property as value1interparray. for instance
%the array will be 2bar, 4bar, 6bar, and the value will be 3.5bar

if strcmp(Prop1,'P') || strcmp(Prop1,'T')

% Saturation Data
SatState.P = interp1(Value1InterpArray,Press,Value1,'linear','extrap');
SatState.TUpper = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
SatState.TLower = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
SatState.vf = interp1(Value1InterpArray,Vf,Value1,'linear','extrap');
SatState.vg = interp1(Value1InterpArray,Vg,Value1,'linear','extrap');
SatState.uf = interp1(Value1InterpArray,Uf,Value1,'linear','extrap');
SatState.ug = interp1(Value1InterpArray,Ug,Value1,'linear','extrap');
SatState.hf = interp1(Value1InterpArray,Hf,Value1,'linear','extrap');
SatState.hg = interp1(Value1InterpArray,Hg,Value1,'linear','extrap');
SatState.sf = interp1(Value1InterpArray,Sf,Value1,'linear','extrap');
SatState.sg = interp1(Value1InterpArray,Sg,Value1,'linear','extrap');

else

    % Saturation Data
    %test, P, T need different treatment

    absLowerLimit = 0;
    absUpperLimit = 10^7; %idk large number, bad practice probably


        if Value1 > min(Value1InterpArrayLower) && Value1 < max(Value1InterpArrayLower)
        SatState.TLower = interp1(Value1InterpArrayLower,Temp,Value1,'linear','extrap');
        SatState.vf = interp1(Value1InterpArrayLower,Vf,Value1,'linear','extrap');
        SatState.uf = interp1(Value1InterpArrayLower,Uf,Value1,'linear','extrap');
        SatState.hf = interp1(Value1InterpArrayLower,Hf,Value1,'linear','extrap');
        SatState.sf = interp1(Value1InterpArrayLower,Sf,Value1,'linear','extrap');
    else
        SatState.TLower = absLowerLimit;
        SatState.vf = absLowerLimit;
        SatState.uf = absLowerLimit;
        SatState.hf = absLowerLimit;
        SatState.sf = absLowerLimit;
    end



    if Value1 > min(Value1InterpArrayUpper) && Value1 < max(Value1InterpArrayUpper)
        SatState.TUpper = interp1(Value1InterpArrayUpper,Temp,Value1,'linear','extrap');
        SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
        SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
        SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
        SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');



%?????????maybe
    elseif Value1 > min(Value1InterpArrayLower) && Value1 < max(Value1InterpArrayLower)
        SatState.TUpper = interp1(Value1InterpArrayUpper,Temp,Value1,'linear','extrap');
        SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
        SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
        SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
        SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');

    else
        SatState.TUpper = absUpperLimit;
        SatState.vg = absUpperLimit;
        SatState.ug = absUpperLimit;
        SatState.hg = absUpperLimit;
        SatState.sg = absUpperLimit;

    end




%     if Value1 > min(Value1InterpArrayLower) && Value1 < max(Value1InterpArrayLower)
%         SatState.TLower = interp1(Value1InterpArrayLower,Temp,Value1,'linear','extrap');
%         SatState.vf = interp1(Value1InterpArrayLower,Vf,Value1,'linear','extrap');
%         SatState.uf = interp1(Value1InterpArrayLower,Uf,Value1,'linear','extrap');
%         SatState.hf = interp1(Value1InterpArrayLower,Hf,Value1,'linear','extrap');
%         SatState.sf = interp1(Value1InterpArrayLower,Sf,Value1,'linear','extrap');
%     else
%         SatState.TLower = absLowerLimit;
%         SatState.vf = absLowerLimit;
%         SatState.uf = absLowerLimit;
%         SatState.hf = absLowerLimit;
%         SatState.sf = absLowerLimit;
%     end
% 
% 
% 
%     if Value1 > min(Value1InterpArrayUpper) && Value1 < max(Value1InterpArrayUpper)
%         SatState.TUpper = interp1(Value1InterpArrayUpper,Temp,Value1,'linear','extrap');
%         SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
%         SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
%         SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
%         SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');
% 
%     else
%         SatState.TUpper = absUpperLimit;
%         SatState.vg = absUpperLimit;
%         SatState.ug = absUpperLimit;
%         SatState.hg = absUpperLimit;
%         SatState.sg = absUpperLimit;
% 
%     end



    %SatState

    %SATSTATE . T???????


% 
%     if Value1 > min(Value1InterpArrayUpper) && Value1 < max(Value1InterpArrayUpper)
%         SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
%         SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
%         SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
%         SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');
%     elseif Value1 > min(Value1InterpArrayLower) && Value1 < max(Value1InterpArrayLower)
%         SatState.vg = interp1(Value1InterpArrayLower,Vg,Value1,'linear','extrap');
%         SatState.ug = interp1(Value1InterpArrayLower,Ug,Value1,'linear','extrap');
%         SatState.hg = interp1(Value1InterpArrayLower,Hg,Value1,'linear','extrap');
%         SatState.sg = interp1(Value1InterpArrayLower,Sg,Value1,'linear','extrap');



end

% %SatState.P = interp1(Value1InterpArray,Press,Value1,'linear','extrap');
% %SatState.T = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
% SatState.vf = interp1(Value1InterpArrayLower,Vf,Value1,'linear','extrap');
% SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
% SatState.uf = interp1(Value1InterpArrayLower,Uf,Value1,'linear','extrap');
% SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
% SatState.hf = interp1(Value1InterpArrayLower,Hf,Value1,'linear','extrap');
% SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
% SatState.sf = interp1(Value1InterpArrayLower,Sf,Value1,'linear','extrap');
% SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');







%now do a prop2 switch
%P is not included as P will never be prop2
%and in fact is problematic if its prop 2 as well...

switch Prop2

    case 'T'
        Value2UpperLimit = SatState.TUpper;
        Value2LowerLimit = SatState.TLower;

    case 'v'
        Value2UpperLimit = SatState.vg;
        Value2LowerLimit = SatState.vf;

    case 'u'
        Value2UpperLimit = SatState.ug;
        Value2LowerLimit = SatState.uf;

    case 'h'
        Value2UpperLimit = SatState.hg;
        Value2LowerLimit = SatState.hf;

    case 's'
        Value2UpperLimit = SatState.sg;
        Value2LowerLimit = SatState.sf;

    case 'x'
        Value2UpperLimit = 1;
        Value2LowerLimit = 0;

        %SPECIAL TREATMENT?
        if 0 <= Value2 && 1 >= Value2
            %both inclusive as 0 and 1 are valid
            Out.State = 'Saturated';
        else
            fprintf("Invalid input, quality should be between 0 and 1")
        end

end




%then identifying the state is easy
% Identifying Phase State
if Value2 < Value2LowerLimit
    Out.State = 'SubCooled';
elseif Value2 > Value2UpperLimit
    Out.State = 'SuperHeat';
else
    Out.State = 'Saturated';
end



%if saturated (LV mix), compute quality and properties
if strcmp(Out.State,'Saturated')
    %compute quality using upper and lower limits, which are the same property as
    %value2
    Out.x = (Value2 - Value2LowerLimit) / (Value2UpperLimit - Value2LowerLimit)
    %x = v (input) - vf      /       (vg - vf)
    
    %assuming liquid vapour mixture, this is simple
    Out.v = SatState.vf + Out.x * (SatState.vg - SatState.vf);
    Out.u = SatState.uf + Out.x * (SatState.ug - SatState.uf);
    Out.h = SatState.hf + Out.x * (SatState.hg - SatState.hf);
    Out.s = SatState.sf + Out.x * (SatState.sg - SatState.sf);

    %if the state is saturated then TUpper = TLower
    Out.T = SatState.TUpper

    if strcmp(Prop1,'P') || strcmp(Prop1,'T')
        %in this case SatState.P was already calculated earlier
        Out.P = SatState.P;
    else
        Out.P = interp1(Value1InterpArrayUpper,Press,Value1,'linear','extrap');
    end



    %hold on maybe this tupper tlower business is unnecessary because these
    %two will never happen at the same time: T is second property and
    %neither P nor T is first property

    %SatState.TLower
%     Out.P = SatState.PUpper
%     SatState.PLower



    %assign T, P assuming they weren't given
    %inds1 = Value1InterpArrayUpper
    %Out.T = Temp(inds1)


end



% 
% 
% if strcmp(Prop1,'P') || strcmp(Prop1,'T')
% 
% 
% 
% 
% else
% 
%     % Saturation Data
%     %test, P, T need different treatment
%     
% 
% 
% %SatState.P = interp1(Value1InterpArray,Press,Value1,'linear','extrap');
% %SatState.T = interp1(Value1InterpArray,Temp,Value1,'linear','extrap');
% SatState.vf = interp1(Value1InterpArrayLower,Vf,Value1,'linear','extrap');
% SatState.vg = interp1(Value1InterpArrayUpper,Vg,Value1,'linear','extrap');
% SatState.uf = interp1(Value1InterpArrayLower,Uf,Value1,'linear','extrap');
% SatState.ug = interp1(Value1InterpArrayUpper,Ug,Value1,'linear','extrap');
% SatState.hf = interp1(Value1InterpArrayLower,Hf,Value1,'linear','extrap');
% SatState.hg = interp1(Value1InterpArrayUpper,Hg,Value1,'linear','extrap');
% SatState.sf = interp1(Value1InterpArrayLower,Sf,Value1,'linear','extrap');
% SatState.sg = interp1(Value1InterpArrayUpper,Sg,Value1,'linear','extrap');
% 
% 
% 
% end

%BUT HOW ARE THEY COMPUTED EARLIER


%assumes they've been computed earlier
%Set some outputs
%Out.P = SatState.P;
%Out.T = SatState.T;
%Out.v = SatState.v  interp between vf, vg











%% OLD CODE

% 
% % First Independent Property
% switch Prop1
% 
%     %% P
%     case 'P'
% 
% 
%         % Saturation Data
%         %SatState.P = Value1;
%         SatState.P = interp1(Press,Press,Value1,'linear','extrap');
%         SatState.T = interp1(Press,Temp,Value1,'linear','extrap');
%         SatState.vf = interp1(Press,Vf,Value1,'linear','extrap');
%         SatState.vg = interp1(Press,Vg,Value1,'linear','extrap');
%         SatState.uf = interp1(Press,Uf,Value1,'linear','extrap');
%         SatState.ug = interp1(Press,Ug,Value1,'linear','extrap');
%         SatState.hf = interp1(Press,Hf,Value1,'linear','extrap');
%         SatState.hg = interp1(Press,Hg,Value1,'linear','extrap');
%         SatState.sf = interp1(Press,Sf,Value1,'linear','extrap');
%         SatState.sg = interp1(Press,Sg,Value1,'linear','extrap');
%         % Output
%         Out.P = Value1;
% 
%         switch Prop2
% 
%             case 'T'
% 
%                 % Identifying Phase State
%                 if Value2 < SatState.T
%                     Out.State = 'SubCooled';
%                 elseif Value2 > SatState.T
%                     Out.State = 'SuperHeat';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'v'
% 
%                 % Identifying Phase State
%                 if Value2 > SatState.vg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.vf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'u'
% 
%                 % Identifying Phase State
%                 if Value2 > SatState.ug
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.uf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'h'
%                 % Identifying Phase State
%                 if Value2 > SatState.hg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.hf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 's'
%                 % Identifying Phase State
%                 if Value2 > SatState.sg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.sf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
%         end
% 
%         %% T
%     case 'T'
% 
%         SatState.T = Value1;
% 
%         SatState.P = interp1(Temp,Press,Value1,'linear','extrap');
%         SatState.vf = interp1(Temp,Vf,Value1,'linear','extrap');
%         SatState.vg = interp1(Temp,Vg,Value1,'linear','extrap');
%         SatState.uf = interp1(Temp,Uf,Value1,'linear','extrap');
%         SatState.ug = interp1(Temp,Ug,Value1,'linear','extrap');
%         SatState.hf = interp1(Temp,Hf,Value1,'linear','extrap');
%         SatState.hg = interp1(Temp,Hg,Value1,'linear','extrap');
%         SatState.sf = interp1(Temp,Sf,Value1,'linear','extrap');
%         SatState.sg = interp1(Temp,Sg,Value1,'linear','extrap');
%         % Output
%         Out.T = Value1;
% 
%         switch Prop2
% 
%             case 'v'
% 
%                 % Identifying Phase State
%                 if Value2 > SatState.vg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.vf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'u'
% 
%                 % Identifying Phase State
%                 if Value2 > SatState.ug
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.uf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'h'
%                 % Identifying Phase State
%                 if Value2 > SatState.hg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.hf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 's'
%                 % Identifying Phase State
%                 if Value2 > SatState.sg
%                     Out.State = 'SuperHeat';
%                 elseif Value2 < SatState.sf
%                     Out.State = 'SubCooled';
%                 else
%                     Out.State = 'Saturated';
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
%         end
% 
%         %% v
%     case 'v'
%         switch Prop2
% 
%             case 'u'
%                 ug = interp1(Vg,Ug,Value1,'linear','extrap');
%                 if Value2>ug
%                     Out.State = 'SuperHeat';
%                 else
%                     vf = interp1(Uf,Vf,Value2,'linear','extrap');
%                     if Value1>vf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
% 
%                 end
% 
% 
%             case 'h'
% 
%                 hg = interp1(Vg,Hg,Value1,'linear','extrap');
%                 if Value2>hg
%                     Out.State = 'SuperHeat';
%                 else
%                     vf = interp1(Hf,Vf,Value2,'linear','extrap');
%                     if Value1>vf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
% 
%                 end
% 
%             case 's'
% 
%                 sg = interp1(Vg,Sg,Value1,'linear','extrap');
%                 if Value2>sg
%                     Out.State = 'SuperHeat';
%                 else
%                     vf = interp1(Sf,Vf,Value2,'linear','extrap');
%                     if Value1>vf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
% 
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
% 
%         end
% 
%     case 'u'
%         switch Prop2
% 
%             case 'h'
%                 hg = interp1(Ug,Hg,Value1,'linear','extrap');
%                 if Value2>hg
%                     Out.State = 'SuperHeat';
%                 else
%                     uf = interp1(Hf,Uf,Value2,'linear','extrap');
%                     if Value1>uf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
%                 end
% 
%             case 's'
%                 sg = interp1(Sg,Ug,Value1,'linear','extrap');
%                 if Value2>sg
%                     Out.State = 'SuperHeat';
%                 else
%                     sf = interp1(Sf,Uf,Value2,'linear','extrap');
%                     if Value1>sf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
% 
%         end
% 
%     case 'h'
%         switch Prop2
% 
%             case 's'
%                 sg = interp1(Sg,Ug,Value1,'linear','extrap');
%                 if Value2>sg
%                     Out.State = 'SuperHeat';
%                 else
%                     sf = interp1(Sf,Uf,Value2,'linear','extrap');
%                     if Value1>sf
%                         Out.State = 'Saturated';
%                     else
%                         Out.State = 'SubCooled';
%                     end
%                 end
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
%         end
% 
%     case 's'
%         switch Prop2
% 
%             case 'x'
%                 if 0 <= Value2 && 1 >= Value2
%                     %both inclusive as 0 and 1 are valid
%                     Out.State = 'Saturated';
%                 else
%                     fprintf("Invalid input, quality should be between 0 and 1")
%                 end
% 
%         end
% 
%     case 'x'
%         if 0 <= Value1 && 1 >= Value1
%             %both inclusive as 0 and 1 are valid
%             Out.State = 'Saturated';
%         else
%             fprintf("Invalid input, quality should be between 0 and 1")
%         end
% 
% end



%Out.State

end %end func