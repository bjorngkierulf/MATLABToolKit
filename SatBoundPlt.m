function Out = SatBoundPlt()

[Table,~]  = GenTableNew();

v = [Table.Sat.vf;Table.Sat.vg];
P = [Table.Sat.P;Table.Sat.P];
T = [Table.Sat.T;Table.Sat.T];

Out = sortrows([v,T,P],1);
% plot3(Out(:,1),Out(:,2),Out(:,3),'-k')
figure(1)
plot(Out(:,1),Out(:,3))
set(gca,'XScale','log')

end