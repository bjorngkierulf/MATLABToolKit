function newVal = unitConvertFcn(oldVal,oldUnits,newUnits)
%unitConvert converts units between a specified old and new unit

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
    fprintf("Units match double?") %this should never happen
end

%
% if strcmp(newUnits,'default')   
%     %convert to the default units and be done with it
    
    
if sum(pressOldIndex) > 0 || sum(pressNewIndex) > 0
    %standard unit is kPa   
    conversionArray = pressConversion;
    oldIndex = pressOldIndex;
    %newIndex = strcmp(press,newUnits);
    newIndex = pressNewIndex;
    conversionOffset = zeros(size(press));
    
elseif sum(volOldIndex) > 0 || sum(volNewIndex) > 0
    %standard unit is m3/kg
    conversionArray = volConversion;
    oldIndex = volOldIndex;
    %newIndex = strcmp(vol,newUnits);
    newIndex = volNewIndex;
    conversionOffset = zeros(size(vol));

elseif sum(tempOldIndex) > 0 || sum(tempNewIndex) > 0
    %standard unit is C
    conversionArray = tempConversionScale;
    oldIndex = tempOldIndex;
    %newIndex = strcmp(temp,newUnits);
    newIndex = tempNewIndex;
    conversionOffset = tempConversionOffset;

elseif sum(energyOldIndex) > 0 || sum(energyNewIndex) > 0
    %standard unit is kJ
    conversionArray = energyConversion;
    oldIndex = energyOldIndex;
    %newIndex = strcmp(energy,newUnits);
    newIndex = energyNewIndex;
    conversionOffset = zeros(size(energy));
    
elseif sum(specEnergyOldIndex) > 0 || sum(specEnergyNewIndex) > 0
    %standard unit is kJ/kg
    conversionArray = specEnergyConversion;
    oldIndex = specEnergyOldIndex;
    %newIndex = strcmp(specEnergy,newUnits);
    newIndex = specEnergyNewIndex;
    conversionOffset = zeros(size(specEnergy));
    
elseif sum(specEntropyOldIndex) > 0 || sum(specEntropyNewIndex) > 0
    %standard unit is kJ/kgK
    conversionArray = specEntropyConversion;
    oldIndex = specEntropyOldIndex;
    %newIndex = strcmp(specEntropy,newUnits);
    newIndex = specEntropyNewIndex;
    conversionOffset = zeros(size(specEntropy));    
    
elseif strcmp(oldUnits,'default')
%     oldIndex = 1;
%     
%     newIndex = [pressNewIndex, volNewIndex, tempNewIndex, energyNewIndex, specEnergyNewIndex, specEntropyNewIndex]
%     
%     newIndex = strcmp(specEntropy,newUnits);
% 
%     
    %conversionArray = specEntropyConversion;
    conversionArray = 1;
    conversionOffset = 0;
    %this should only be for default to default, so just return the
    %unchanged input

    fprintf("Default specified, error in assigning unit type");
    newIndex = 1;
    
    
else
    conversionArray = 1;
    conversionOffset = 0;
    %this means that none of the units matched
    fprintf(strcat("First (old) units are unrecognized: ", oldUnits))
    newIndex = 0;
    
end

%debugging
% strcmp(newUnits,'default');
% newIndex == 0;


if strcmp(oldUnits,'default')
    oldIndex = 1;
    %again hard coding default units in first index
end


%newIndex


if all(newIndex == 0) && strcmp(newUnits,'default')
    %so nothing matched, other than default
    %newVal = oldVal;
    newIndex = 1;
    %oldIndex = 1; %was a typo
    %return
    %this hard codes the first index in the unit list as the default
    
elseif all(newIndex == 0)
    %this means that they entered the first unit correctly, but the second
    %one didn't match
    oldIndex = 1; %just return the entered value
    fprintf(strcat("Second (new) Units are unrecognized or do not match: ", newUnits))
    %newVal = oldVal;
    %return
end


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