clc
clear
close all

[Table,Critical] = GenTableNew();

% Out = StateDetect('P',1,'T',99.63,Table)
% Out = XSaturated(0.4,'T',50,Table)
% Out = XSaturated(0.4,'P',0.1235,Table)
% Out = XSaturated(0.4,'v',4.8134,Table)

% Out =  SubcooledR('v',0.00102,'T',80,Table)

v = [Table.Sat.vf;Table.Sat.vg];
P = [Table.Sat.P;Table.Sat.P];
T = [Table.Sat.T;Table.Sat.T];

StateMain = StateDetect('P',150,'T',90,Table);
State = SubCooled(100,'T',250,Table);

Out = sortrows([v,T,P],1);
% plot3(Out(:,1),Out(:,2),Out(:,3),'-k')
subplot(2,1,1)
% plot(Out(:,1),Out(:,3))
plot(Table.Sat.vf,Table.Sat.P,'-b',Table.Sat.vg,Table.Sat.P,'-b')
hold on 
plot(State.v,State.P,'Ok','MarkerFaceColor','k')
text(State.v,State.P,['  State ' num2str(1)])


set(gca,'XScale','log')
xlabel('V')
ylabel('P')

subplot(2,1,2)
plot(Table.Sat.vf,Table.Sat.T,'-b',Table.Sat.vg,Table.Sat.T,'-b')
hold on
plot(State.v,State.T,'O','MarkerFaceColor','k')
text(State.v,State.T,['  State ' num2str(1)])
set(gca,'XScale','log')
xlabel('V')
ylabel('T')

% grid on
% xlabel('V')
% ylabel('T')
% zlabel('P')