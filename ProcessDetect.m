function Process = ProcessDetect(StartingState, FinalState, Tolerance)

%debug
%data = [{label}    {state}    {pressure}    {temperature}    {specific volume}    {spec internal energy}    {spec enthalpy}    {spec entropy}    {quality}]
%testData1  = [{'a'}    {'SuperHeat'}    {[0.500]}    {[70.1]}    {[27.15]}    {[2.4732e+03]}    {[2.6314e+03]}    {[8.5517]} {'N/A'}];
%testData2  = [{'b'}    {'SuperHeat'}    {[0.0500]}    {[70]}    {[27.1121]}    {[2.4732e+03]}    {[2.6314e+03]}    {[8.5517]} {'N/A'}];

%StartingState = testData1;
%FinalState = testData2;


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
end %end if

end %end for


%now we decide what to do with duplicates
%isProcess
%sum(isProcess)
if sum(isProcess) > 1
    %figure it out
    %fuck it just do it in order
    %ProcessInd = find(isProcess==1,1) %find the first only
    Process = Processes(find(isProcess==1,1));

elseif sum(isProcess) < 1
    fprintf("no process detected");
    Process = 'Unknown';
    %hard coded, as the above Processes array needs to correspond to a way
    %to find the iso line for that process

    %return %empty, no process detected
else
    %easy money
    %for now this is the same as above
    Process = Processes(find(isProcess==1,1));
end


end %end function