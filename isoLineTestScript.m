clc; clear; close all;
%% iso line test script
[Table,Critical] = GenTableNew();

%P = 5; %bar
%T = 140; %C

%Out = IsoLine('P',P,Table,Critical,0,1)

v = [40];%[0.001, 0.0015, 0.002, 0.0025, 0.003, 0.0035, 0.004];%, 0.005, 0.006, 0.007, 0.01, 0.1, 0.5]; %m3/kg

for i = 1:length(v)
    Outv(i) = IsoLine('P',v(i),Table,Critical,0,0)
    %Outv(i) = ConstVolLine(v(i),Table,Critical);
end

s = [1];%[1,2,3,3.5,4,4.4,4.5,5,6]; %kJ/kg*K
%Outs = [];
for i = 1:length(s)
    %Outs(i) = IsentropicLine(s(i),Table,Critical);
    Outs(i) = IsoLine('s',s(i),Table,Critical,0,0);
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

%plot isolines
for i = 1:length(v)
    plot(Outv(i).v,Outv(i).T)
end

for i = 1:length(s)
    plot(Outs(i).v,Outs(i).T)
end

%% T-S plot
figure(2)
hold on
xlabel("s - kJ/kg*K")
ylabel("T (C)")

%plot saturation curve
plot(Table.Sat.sf,Table.Sat.T)
plot(Table.Sat.sg,Table.Sat.T)

% %plot isolines
for i = 1:length(v)
plot(Outv(i).s,Outv(i).T)
end

for i = 1:length(s)
plot(Outs(i).s,Outs(i).T)
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

% %plot isolines
for i = 1:length(v)
    plot(Outv(i).v,Outv(i).P)
end

for i = 1:length(s)
    plot(Outs(i).v,Outs(i).P)
end