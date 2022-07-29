function Process = ProcessDetect(StartingState, FinalState, Tolerance,debug)
% debug test data
%data = [{label}    {state}    {pressure}    {temperature}    {specific volume}    {spec internal energy}    {spec enthalpy}    {spec entropy}    {quality}]
%testData1  = [{'a'}    {'SuperHeat'}    {[0.500]}    {[70.1]}    {[27.15]}    {[2.4732e+03]}    {[2.6314e+03]}    {[8.5517]} {'N/A'}];
%testData2  = [{'b'}    {'SuperHeat'}    {[0.0500]}    {[70]}    {[27.1121]}    {[2.4732e+03]}    {[2.6314e+03]}    {[8.5517]} {'N/A'}];

Processes = {'Isobaric','Isothermal','Constant Volume','Isentropic'};%,'Polytropic']
isProcess = zeros(numel(Processes),1);

%convenience
%e.g. the second process, 'isothermal', maps to the fourth variable in the
%input data cell aray
ProcessToVariableIndex = [4, 5, 6, 9];

%if else, check each independently
%first isobar
for i = 1:length(Processes)

    varInd = ProcessToVariableIndex(i);
    
if 2*abs(StartingState{varInd} - FinalState{varInd}) / (StartingState{varInd} + FinalState{varInd}) < Tolerance
    isProcess(i) = 1;
    %it is in fact that process
    %I think this detect algorithm depends on all values being positive
end

end

%now we decide what to do with duplicates
if sum(isProcess) > 1
    if debug
        fprintf("Multiple processes detected, keeping first one")
    end
    % go in order
    Process = Processes(find(isProcess==1,1));

elseif sum(isProcess) < 1
    if debug
        fprintf("no process detected");
    end
    Process = 'Unknown';
    %hard coded, as the above Processes array needs to correspond to a way
    %to find the iso line for that process

else
    % exactly one matching process
    Process = Processes(find(isProcess==1,1));
end

end