clc; clear; close all;
%% Read in test cases:
% this script will run functions though multiple baseline calculations in
% order to verify their outputs
testCaseTable = readtable('TestCaseMatrix.xlsx');
%units are not specified here, but they are the defaults - pressure in bar,
%temperature in celsius, and specific volume in m^3/kg

%now we have variables P, T, and v. We'd like to recombine these such that
%we take each two of these and calculate the third
%initialize
N = length(testCaseTable.P);
%the last column is to store the value we calculate
testCaseMatrix = zeros(N,4);

testCaseMatrix(1:N,1:3) = [testCaseTable.P,testCaseTable.T,testCaseTable.v]; %P + T -> v
%testCaseMatrix(N+1:2*N,1:3) = [testCaseTable.T,testCaseTable.v,testCaseTable.P]; %T + v -> P
%testCaseMatrix(2*N+1:3*N,1:3) = [testCaseTable.v,testCaseTable.P,testCaseTable.T]; %v + P -> T

%first column will be the calculated number, second column will be the
%difference from the table value
forV = zeros(N,2);
forT = zeros(N,2);
forP = zeros(N,2);


%% next, state detection and property calculation for different fluids
%out = PropertyCalculateSafe(['P',2,'T',200,Table,Critical]

%unique fluids in the test cases
[fluids,~] = unique(testCaseTable.Fluid);

for j = 1:length(fluids)
    if strcmp(fluids(j),'Water')
        %water data
        [Table,Critical] = GenTableNew();

    elseif strcmp(fluids(j),'R134a')
        %R134a data
        [Table,Critical] = GenTableR134a();

    else
        fprintf("Unsupported fluid type in input data")
    end
    

for i = 1:length(testCaseMatrix)
    outV = PropertyCalculateSafe('P',testCaseMatrix(i,1),'T',testCaseMatrix(i,2),Table,Critical);
    forV(i,1) = outV{4}
    forV(i,2) = abs(testCaseMatrix(i,3) - forV(i,1))/testCaseMatrix(i,3)
    phaseMatch = strcmp(testCaseTable.Phase(i),outV{1})

    outT = PropertyCalculateSafe('P',testCaseMatrix(i,1),'v',testCaseMatrix(i,3),Table,Critical);
    forT(i,1) = outT{3};
    forT(i,2) = abs(testCaseMatrix(i,2) - forT(i,1))/testCaseMatrix(i,2)
    phaseMatch = strcmp(testCaseTable.Phase(i),outT{1})

    outP = PropertyCalculateSafe('T',testCaseMatrix(i,2),'v',testCaseMatrix(i,3),Table,Critical);
    forP(i,1) = outP{2};
    forP(i,2) = abs(testCaseMatrix(i,1) - forP(i,1))/testCaseMatrix(i,1)
    phaseMatch = strcmp(testCaseTable.Phase(i),outP{1})

end

end
% 
% 
% %% first, unit conversion
% oldVals = [1];
% oldUnits = {'bar','kPa','Pa','MPa','psi','psf'};
% %press = {'bar','kPa','Pa','MPa','psi','psf'};
% 
% %Specific volume
% vol = {'m^3/kg','L/kg'};
% 
% %Temperature
% temp = {[char(0176),'C'],'K',[char(0176),'R'],[char(0176),'F']};
% 
% %Energy
% energy = {'kJ','J'};
% 
% %Specific energy
% specEnergy = {'kJ/kg','J/kg','Btu/lb'};
% 
% %specific entropy: 
% specEntropy = {'kJ/kgK','J/kgK',['Btu/lb',char(0176),'R']};
% 
% 
% %unitConvertFcn()
% %there must be a better way to do this
