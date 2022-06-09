clc; clear; close all;
format short
%% Read in test cases:
% this script will run functions though multiple baseline calculations in
% order to verify their outputs
testCaseTable = readtable('TestCaseMatrix.xlsx');
%units are not specified here, but they are the defaults - pressure in bar,
%temperature in celsius, and specific volume in m^3/kg

%now we have variables P, T, and v. We'd like to recombine these such that
%we take each two of these and calculate the third
%initialize
%N = length(testCaseTable.P);
%override
N = 7;

%the last column is to store the value we calculate
testCaseMatrix = zeros(N,4);

testCaseMatrix(1:N,1:4) = [testCaseTable.P(1:N),testCaseTable.T(1:N),testCaseTable.v(1:N),testCaseTable.s(1:N)]; %P + T -> v
%testCaseMatrix(N+1:2*N,1:3) = [testCaseTable.T,testCaseTable.v,testCaseTable.P]; %T + v -> P
%testCaseMatrix(2*N+1:3*N,1:3) = [testCaseTable.v,testCaseTable.P,testCaseTable.T]; %v + P -> T

%first column will be the calculated number, second column will be the
%difference from the table value
forV = zeros(N,2);
forT = zeros(N,2);
forP = zeros(N,2);
forS = zeros(N,2);

M = 5; %methods count
calc = zeros(N*M,6);
phaseMatch = zeros(N,M);



%% next, state detection and property calculation for different fluids
%out = PropertyCalculateSafe(['P',2,'T',200,Table,Critical]

%unique fluids in the test cases
[fluids,~] = unique(testCaseTable.Fluid(1:N));

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
    fprintf("\nTest point %d",i)
    fprintf("\nTrue pressure %f",testCaseMatrix(i,1))
    fprintf("\nTrue temperature %f",testCaseMatrix(i,2))
    fprintf("\nTrue specific volume %f",testCaseMatrix(i,3))
    fprintf("\nTrue specific entropy %f",testCaseMatrix(i,4))

    outV = PropertyCalculateSafe('P',testCaseMatrix(i,1),'T',testCaseMatrix(i,2),Table,Critical);
    forV(i,1) = outV{4}
    forV(i,2) = abs(testCaseMatrix(i,3) - forV(i,1))/testCaseMatrix(i,3)
    phaseMatch(i,1) = strcmp(testCaseTable.Phase(i),outV{1})
    calc((M*(i-1)+1),1:6) = [testCaseMatrix(i,1),testCaseMatrix(i,2),outV{4},outV{7},outV{5},outV{6}]

    outT = PropertyCalculateSafe('P',testCaseMatrix(i,1),'v',testCaseMatrix(i,3),Table,Critical);
    forT(i,1) = outT{3};
    forT(i,2) = abs(testCaseMatrix(i,2) - forT(i,1))/testCaseMatrix(i,2)
    phaseMatch(i,2) = strcmp(testCaseTable.Phase(i),outT{1})
    calc((M*(i-1)+2),1:6) = [testCaseMatrix(i,1),outT{3},testCaseMatrix(i,3),outT{7},outT{5},outT{6}]

    outP = PropertyCalculateSafe('T',testCaseMatrix(i,2),'v',testCaseMatrix(i,3),Table,Critical);
    forP(i,1) = outP{2};
    forP(i,2) = abs(testCaseMatrix(i,1) - forP(i,1))/testCaseMatrix(i,1)
    phaseMatch(i,3) = strcmp(testCaseTable.Phase(i),outP{1})
    calc((M*(i-1)+3),1:6) = [outP{2},testCaseMatrix(i,2),testCaseMatrix(i,3),outP{7},outP{5},outP{6}]

    outTS = PropertyCalculateSafe('T',testCaseMatrix(i,2),'s',testCaseMatrix(i,4),Table,Critical);
%     forS(i,1) = outS{7};
%     forS(i,2) = abs(testCaseMatrix(i,4) - forS(i,1))/testCaseMatrix(i,4)
    phaseMatch(i,4) = strcmp(testCaseTable.Phase(i),outTS{1})
    calc((M*(i-1)+4),1:6) = [outTS{2},testCaseMatrix(i,2),outTS{4},testCaseMatrix(i,4),outTS{5},outTS{6}]
    
    outPS = PropertyCalculateSafe('P',testCaseMatrix(i,1),'s',testCaseMatrix(i,4),Table,Critical);
%     forS(i,1) = outS{7};
%     forS(i,2) = abs(testCaseMatrix(i,4) - forS(i,1))/testCaseMatrix(i,4)
    phaseMatch(i,5) = strcmp(testCaseTable.Phase(i),outPS{1})
    calc((M*(i-1)+5),1:6) = [testCaseMatrix(i,1),outPS{3},outPS{4},testCaseMatrix(i,4),outPS{5},outPS{6}]

end

end

%% T-V plot
figure(1)
hold on
xlabel("v - m3/kg")
ylabel("T (C)")
set(gca,'XScale','log')

%plot saturation curve
plot(Table.Sat.vf,Table.Sat.T)
plot(Table.Sat.vg,Table.Sat.T)

for i = 1:N %plot test matrix points - data from IAPWS-97 (Industrial Formulation)
    plot(testCaseMatrix(i,3),testCaseMatrix(i,2),'.','MarkerSize',5,'Color','r')
end

for i = 1:M*N %plot calculated test points, using different methods
    plot(calc(i,3),calc(i,2),'.','MarkerSize',5,'Color','b')
end

%% T-S plot
figure(2)
hold on
xlabel("s - kJ/kg*K")
ylabel("T (C)")

%plot saturation curve
plot(Table.Sat.sf,Table.Sat.T)
plot(Table.Sat.sg,Table.Sat.T)

for i = 1:N %plot test matrix points - data from IAPWS-97 (Industrial Formulation)
    plot(testCaseMatrix(i,4),testCaseMatrix(i,2),'.','MarkerSize',5,'Color','r')
end

for i = 1:M*N %plot calculated test points, using different methods
    plot(calc(i,4),calc(i,2),'.','MarkerSize',5,'Color','b')
end

%% P-V plot
figure(3)
hold on
xlabel("v - m3/kg")
ylabel("P (bar)")
set(gca,'XScale','log')

%plot saturation curve
plot(Table.Sat.vf,Table.Sat.P)
plot(Table.Sat.vg,Table.Sat.P)

for i = 1:N %plot test matrix points - data from IAPWS-97 (Industrial Formulation)
    plot(testCaseMatrix(i,3),testCaseMatrix(i,1),'.','MarkerSize',5,'Color','r')
end

for i = 1:M*N %plot calculated test points, using different methods
    plot(calc(i,3),calc(i,1),'.','MarkerSize',5,'Color','b')
end
