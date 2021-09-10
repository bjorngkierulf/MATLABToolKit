clc
clear
close all

format long 
[Table,Critical] = GenTableNew();


Value = 40;

A = XSaturated(0.4,'P',Value,Table);
B = XSaturated(0,'s',A.s,Table);
C = SubCooled(B.P,'s',A.s,Table);

Out = ProcIsentropicLine(A.s,A.T,C.T,Table);

plot(Table.Sat.sf,Table.Sat.T,'-b',Table.Sat.sg,Table.Sat.T,'-b');
hold on 
plot(Out.s,Out.T,'-r')

% set(gca,'XScale','log')