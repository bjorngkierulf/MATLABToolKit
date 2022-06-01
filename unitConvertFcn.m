function newVal = unitConvertFcn(oldVal,oldUnits,newUnits)
%unitConvert converts units between a specified old and new unit

%temperature specific - check if they entered 'C' for celsius instead of
%degrees symbol C
if strcmp(oldUnits,'C')
    oldUnits = [char(0176),'C'];
elseif strcmp(oldUnits,'F')
    oldUnits = [char(0176),'F'];
elseif strcmp(oldUnits,'R')
    oldUnits = [char(0176),'R'];
end

if strcmp(newUnits,'C')
    newUnits = [char(0176),'C'];
elseif strcmp(newUnits,'F')
    newUnits = [char(0176),'F'];
elseif strcmp(newUnits,'R')
    newUnits = [char(0176),'R'];
end


%supported units are
%pressure: ['kPa','bar','Pa,'MPa','psi','psf']
%temperature: ['^oC','K','^oR','^oF']
%specific volume: ['m^3/kg','L/kg']
%energy: [J,kJ]
%specific energy: ['kJ/kg','J/kg','Btu/lb']
%specific entropy: ['kJ/kgK','J/kgK','Btu/lbR']

%Define conversion factors and names for each type of unit

%Pressure
press = {'bar','kPa','Pa','MPa','psi','psf'};
psiToKpa = 6.89476;
psfToKpa = psiToKpa / 12^2; %=0.0479;
pressConversion = [1, .01, 0.00001, 10, psiToKpa/100, psfToKpa/100];
pressOldIndex = strcmp(press,oldUnits);
pressNewIndex = strcmp(press,newUnits);

%Specific volume
vol = {'m^3/kg','L/kg'};
volConversion = [1, 0.001];
volOldIndex = strcmp(vol,oldUnits);
volNewIndex = strcmp(vol,newUnits);

%Temperature
temp = {[char(0176),'C'],'K',[char(0176),'R'],[char(0176),'F']};
tempConversionScale = [1, 1, 5/9, 5/9];
tempConversionOffset = [0, -273.15, -491.67, -32];
tempOldIndex = strcmp(temp,oldUnits);
tempNewIndex = strcmp(temp,newUnits);

%Energy
energy = {'kJ','J'};
energyConversion = [1,0.001];
energyOldIndex = strcmp(energy,oldUnits);
energyNewIndex = strcmp(energy,newUnits);

%Specific energy
specEnergy = {'kJ/kg','J/kg','Btu/lb'};
kJ_kgToBtu_lb =  2.3260; %1/0.429923;
specEnergyConversion = [1, 0.001, kJ_kgToBtu_lb];
specEnergyOldIndex = strcmp(specEnergy,oldUnits);
specEnergyNewIndex = strcmp(specEnergy,newUnits);

%specific entropy:
specEntropy = {'kJ/kgK','J/kgK',['Btu/lb',char(0176),'R']};
kJ_kgKToBtu_lbR =  4.1868; %kJ_kgToBtu_lb * 5/9; %=0.2388459
specEntropyConversion = [1, 0.001, kJ_kgKToBtu_lbR];
specEntropyOldIndex = strcmp(specEntropy,oldUnits);
specEntropyNewIndex = strcmp(specEntropy,newUnits);

if sum(pressOldIndex) + sum(volOldIndex) + sum(tempOldIndex) ...
        + sum(energyOldIndex) + sum(specEnergyOldIndex) ...
        + sum(specEntropyOldIndex) > 1
    fprintf("Old units match double?") %this should never happen
    newVal = oldVal;
    return
end

if sum(pressNewIndex) + sum(volNewIndex) + sum(tempNewIndex) ...
        + sum(energyNewIndex) + sum(specEnergyNewIndex) ...
        + sum(specEntropyNewIndex) > 1
    fprintf("New units match double?") %this should never happen
    newVal = oldVal;
    return
end

%initialize, so we can guarantee they exist later
%and can also check if they are still this initial value
oldIndex = 0;
newIndex = 0;
%check if the first (old) of each index is greater than zero
if sum(pressOldIndex) > 0 || sum(pressNewIndex) > 0
    %standard unit is kPa
    %this flow control make sure that we don't assign nonsense values to
    %old and new indices
    if sum(pressOldIndex) > 0 && sum(pressNewIndex) > 0
        oldIndex = find(pressOldIndex);
        newIndex = find(pressNewIndex);

    elseif sum(pressOldIndex) > 0
        oldIndex = find(pressOldIndex);
    else %sum(pressNewIndex) > 0
        newIndex = find(pressNewIndex);

    end

    conversionArray = pressConversion;
    conversionOffset = zeros(size(press));

elseif sum(volOldIndex) > 0
    %standard unit is m3/kg
    if sum(volOldIndex) > 0 && sum(volNewIndex) > 0
        oldIndex = find(volOldIndex);
        newIndex = find(volNewIndex);

    elseif sum(volOldIndex) > 0
        oldIndex = find(volOldIndex);
    else %sum(pressNewIndex) > 0
        newIndex = find(volNewIndex);

    end

    conversionArray = volConversion;
    conversionOffset = zeros(size(vol));

elseif sum(tempOldIndex) > 0 || sum(tempNewIndex) > 0
    %standard unit is C
    if sum(tempOldIndex) > 0 && sum(tempNewIndex) > 0
        oldIndex = find(tempOldIndex);
        newIndex = find(tempNewIndex);

    elseif sum(tempOldIndex) > 0
        oldIndex = find(tempOldIndex);
    else %sum(pressNewIndex) > 0
        newIndex = find(tempNewIndex);

    end
    
    conversionArray = tempConversionScale;
    conversionOffset = tempConversionOffset;

elseif sum(energyOldIndex) > 0 || sum(energyNewIndex) > 0
    %standard unit is kJ
    if sum(energyOldIndex) > 0 && sum(energyNewIndex) > 0
        oldIndex = find(energyOldIndex);
        newIndex = find(energyNewIndex);

    elseif sum(energyOldIndex) > 0 
        oldIndex = find(energyOldIndex);
    else %sum(pressNewIndex) > 0
        newIndex = find(energyNewIndex);

    end
    
    conversionArray = energyConversion;
    conversionOffset = zeros(size(energy));

elseif sum(specEnergyOldIndex) > 0 || sum(specEnergyNewIndex) > 0
    %standard unit is kJ/kg
    if sum(specEnergyOldIndex) > 0 && sum(specEnergyNewIndex) > 0
        oldIndex = find(specEnergyOldIndex);
        newIndex = find(specEnergyNewIndex);

    elseif sum(specEnergyOldIndex) > 0 
        oldIndex = find(specEnergyOldIndex);
    else %sum(pressNewIndex) > 0
        newIndex = find(specEnergyNewIndex);

    end
    
    conversionArray = specEnergyConversion;
    conversionOffset = zeros(size(specEnergy));

elseif sum(specEntropyOldIndex) > 0 || sum(specEntropyNewIndex) > 0
    %standard unit is kJ/kgK
    if sum(specEntropyOldIndex) > 0 && sum(specEntropyNewIndex) > 0
        oldIndex = find(specEntropyOldIndex);
        newIndex = find(specEntropyNewIndex);

    elseif sum(specEntropyOldIndex) > 0 
        oldIndex = find(specEntropyOldIndex);
    else %sum(pressNewIndex) > 0
        newIndex = find(specEntropyNewIndex);

    end
    
    conversionArray = specEntropyConversion;
    conversionOffset = zeros(size(specEntropy));

end

% 
% %check if the second (new) of each index is greater than zero
% if sum(pressNewIndex) > 0
%     %standard unit is bar
%     if exist('conversionArray','var')
%         %vector equals checks all in the vector, all collapses into a bool
%         if all(conversionArray == pressConversion)
%             %nominal
%         else
%         %bad. It matched a different unit above
%         fprintf("Old and new units recognized but incompatible")
%         newVal = oldVal;
%         return
%         end
%     else
%         %nominal - first one did not match so it is probably default
%         conversionArray = pressConversion;
%         conversionOffset = zeros(size(press));
% 
%     end
% 
%     newIndex = pressNewIndex;
% 
% elseif sum(volNewIndex) > 0
%     %standard unit is m3/kg
%     if all(conversionArray == volConversion) %vector equals checks all in the vector, all collapses into a bool
%         %nominal
%     elseif exist('conversionArray','var')
%         %bad. It matched a different unit above
%         fprintf("Old and new units recognized but incompatible")
%         newVal = oldVal;
%         return
%     else
%         %nominal - first one did not match so it is probably default
%         conversionArray = volConversion;
%         conversionOffset = zeros(size(vol));
% 
%     end
%     
%     newIndex = volNewIndex;
% 
% elseif sum(tempNewIndex) > 0
%     %standard unit is C
%     if all(conversionArray == tempConversionScale) %vector equals checks all in the vector, all collapses into a bool
%         %nominal
%     elseif exist('conversionArray','var')
%         %bad. It matched a different unit above
%         fprintf("Old and new units recognized but incompatible")
%         newVal = oldVal;
%         return
%     else
%         %nominal - first one did not match so it is probably default
%         conversionArray = tempConversionScale;
%         conversionOffset = tempConversionOffset;
% 
%     end
% 
%     newIndex = tempNewIndex;
% 
% elseif sum(energyNewIndex) > 0
%     %standard unit is kJ
%     if all(conversionArray == energyConversion) %vector equals checks all in the vector, all collapses into a bool
%         %nominal
%     elseif exist('conversionArray','var')
%         %bad. It matched a different unit above
%         fprintf("Old and new units recognized but incompatible")
%         newVal = oldVal;
%         return
%     else
%         %nominal - first one did not match so it is probably default
%         conversionArray = energyConversion;
%         conversionOffset = zeros(size(energy));
% 
%     end
% 
%     newIndex = energyNewIndex;
% 
% elseif sum(specEnergyNewIndex) > 0
%     %standard unit is kJ/kg
%     if all(conversionArray == specEnergyConversion) %vector equals checks all in the vector, all collapses into a bool
%         %nominal
%     elseif exist('conversionArray','var')
%         %bad. It matched a different unit above
%         fprintf("Old and new units recognized but incompatible")
%         newVal = oldVal;
%         return
%     else
%         %nominal - first one did not match so it is probably default
%         conversionArray = specEnergyConversion;
%         conversionOffset = zeros(size(specEnergy));
% 
%     end
% 
%     newIndex = specEnergyNewIndex;
% 
% 
% elseif sum(specEntropyNewIndex) > 0
%     %standard unit is kJ/kgK
%     if all(conversionArray == specEntropyConversion) %vector equals checks all in the vector, all collapses into a bool
%         %nominal
%     elseif exist('conversionArray','var')
%         %bad. It matched a different unit above
%         fprintf("Old and new units recognized but incompatible")
%         newVal = oldVal;
%         return
%     else
%         %nominal - first one did not match so it is probably default
%         conversionArray = specEntropyConversion;
%         conversionOffset = zeros(size(specEntropy));
% 
%     end
% 
%     newIndex = specEntropyNewIndex;
% 
% end
% 



%now we may or may not have changed either or both of the new / old indices
%to values based on matching
%change from logical to number indexing, but be careful that we don't end
%up with [] for nonmatching

oldIndex = oldIndex
newIndex = newIndex

if oldIndex ~= 0 && newIndex ~= 0 %both have matched, this is easy
    %convert units using standard method
    %no action necessary
elseif oldIndex ~= 0 %oldIndex matched, new did not - is the new default?
    if strcmp(newUnits,'default')
        %new units are default. Set new ind to 1 and convert
        %oldIndex, matched
        newIndex = 1;
    else
        %it matched the first units but didn't match the second, and the
        %second wasn't default. This means the second input was invalid
        %return original value
        fprintf("Second units did not match first units")
        newVal = oldVal;
        return
    end

elseif newIndex ~= 0 %newIndex matched, old did not - is the old default?
    if strcmp(oldUnits,'default')
        %old units are default. Set old ind to 1 and convert
        oldIndex = 1;
        %newIndex, matched
    else
        %it matched the second units but didn't match the first, and the
        %first wasn't default. This means the first input was invalid
        %return original value
        fprintf("First units did not match second units")
        newVal = oldVal;
        return
    end

elseif strcmp(oldUnits,'default') && strcmp(newUnits,'default') %both old and new units are default. Return the original
    %convert 1 to 1
    %return original
    newVal = oldVal;
    return

else %break case. Neither input units (old or new) matched with any of the known units
    % One input unit may be default but not both of them
    % This means something has gone very wrong
    % return original
    newVal = oldVal;
    fprintf("Neither input unit matched, and both units are not default")
    return;

end

%if it gets to this point without preemptively returning oldVal as newVal,
%it means that at least something has matched, and both oldIndex and
%newIndex should have valid values

%final value conversion, first to an intermediary unit, then to the desired
%output unit
valIntermediary = (oldVal + conversionOffset(oldIndex)) .* conversionArray(oldIndex);
newVal = (valIntermediary ./ conversionArray(newIndex)) - conversionOffset(newIndex);
%dot syntax allows this to work for arrays of values

%K = C + 273
%F = C * 9/5 + 32
%C = (F - 32 ) * 5/9
%R = F + 459.67
%R - 459.67 = C * 9/5 + 32
%C = (R - 459.67 - 32 ) * 5/9

end