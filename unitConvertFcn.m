function newVal = unitConvertFcn(oldVal,oldUnits,newUnits)
%unitConvert converts units between a specified old and new unit

%supported units are
%pressure: ['kPa','bar','Pa,'MPa','psi','psf']
%temperature: ['C','K','R','F']
%specific volume: ['m3_kg','L_kg']
%energy: [J,kJ]
%specific energy: ['kJ_kg','J_kg','Btu_lb']
%specific entropy: ['kJ_kgK','J_kgK','Btu_lbR']

%Define conversion factors and names for each type of unit

%Pressure
press = {'kPa','bar','Pa','MPa','psi','psf'};
psiToKpa = 6.89476;
psfToKpa = psiToKpa / 12^2; %=0.0479;
pressConversion = [1, 100, 0.001, 1000, psiToKpa, psfToKpa];
pressOldIndex = strcmp(press,oldUnits)

%Specific volume
vol = {'m3_kg','L_kg'};
volConversion = [1, 0.001];
volOldIndex = strcmp(vol,oldUnits)

%Temperature
temp = {'C','K','R','F'};
tempConversionScale = [1, 1, 5/9, 5/9];
tempConversionOffset = [0, -273.15, -491.67, -32];
tempOldIndex = strcmp(temp,oldUnits)

%Energy
energy = {'kJ','J'};
energyConversion = [1,0.001];
energyOldIndex = strcmp(energy,oldUnits)

%Specific energy
specEnergy = {'kJ_kg','J_kg','Btu_lb'};
kJ_kgToBtu_lb =  2.3260; %1/0.429923;
specEnergyConversion = [1, 0.001, kJ_kgToBtu_lb];
specEnergyOldIndex = strcmp(specEnergy,oldUnits)

%specific entropy: 
specEntropy = {'kJ_kgK','J_kgK','Btu_lbR'};
kJ_kgKToBtu_lbR =  4.1868; %kJ_kgToBtu_lb * 5/9; %=0.2388459
specEntropyConversion = [1, 0.001, kJ_kgKToBtu_lbR];
specEntropyOldIndex = strcmp(specEntropy,oldUnits)


if sum(pressOldIndex) + sum(volOldIndex) + sum(tempOldIndex) ...
        + sum(energyOldIndex) + sum(specEnergyOldIndex) ...
        + sum(specEntropyOldIndex) > 1
    fprintf("Units match double?") %this should never happen
end

if sum(pressOldIndex) > 0
    %standard unit is kPa   
    conversionArray = pressConversion;
    oldIndex = pressOldIndex;
    newIndex = strcmp(press,newUnits);
    conversionOffset = zeros(size(press));    
    
elseif sum(volOldIndex) > 0
    %standard unit is m3/kg
    conversionArray = volConversion;
    oldIndex = volOldIndex;
    newIndex = strcmp(vol,newUnits);
    conversionOffset = zeros(size(vol));

elseif sum(tempOldIndex) > 0
    %standard unit is C
    conversionArray = tempConversionScale;
    oldIndex = tempOldIndex;
    newIndex = strcmp(temp,newUnits);
    conversionOffset = tempConversionOffset;

elseif sum(energyOldIndex) > 0
    %standard unit is kJ
    conversionArray = energyConversion;
    oldIndex = energyOldIndex;
    newIndex = strcmp(energy,newUnits);
    conversionOffset = zeros(size(energy));
    
elseif sum(specEnergyOldIndex) > 0
    %standard unit is kJ/kg
    conversionArray = specEnergyConversion;
    oldIndex = specEnergyOldIndex;
    newIndex = strcmp(specEnergy,newUnits);
    conversionOffset = zeros(size(specEnergy));
    
elseif sum(specEntropyOldIndex) > 0
    %standard unit is kJ/kgK
    conversionArray = specEntropyConversion;
    oldIndex = specEntropyOldIndex;
    newIndex = strcmp(specEntropy,newUnits);
    conversionOffset = zeros(size(specEntropy));    
    
else
    %this means that none of the units matched
    fprintf(strcat("First (old) units are unrecognized: ", oldUnits))
    
end
    
if newIndex == 0
    %this means that they entered the first unit correctly, but the second
    %one didn't match
    fprintf(strcat("Second (new) Units are unrecognized or do not match: ", newUnits))
end


%final value conversion, first to an intermediary unit, then to the desired
%output unit
valIntermediary = (oldVal + conversionOffset(oldIndex)) .* conversionArray(oldIndex)
newVal = (valIntermediary ./ conversionArray(newIndex)) - conversionOffset(newIndex)
%dot syntax allows this to work for arrays of values
    

%K = C + 273
%F = C * 9/5 + 32
%C = (F - 32 ) * 5/9
%R = F + 459.67
%R - 459.67 = C * 9/5 + 32
%C = (R - 459.67 - 32 ) * 5/9

end