clc
clear
close all

x = linspace(0,pi,40);
y = sin(x);

figure(1)
plot(x,y)
hold on 
plot(x(10),y(10),'Ok')
text(x(10),y(10),['  State ' num2str(1)])

plot(x(20),y(20),'Ok')
text(x(20),y(20),['  State ' num2str(2)])

plot(x(30),y(30),'Ok','MarkerFaceColor','k')
text(x(30),y(30),['  State ' num2str(3)])
grid on
