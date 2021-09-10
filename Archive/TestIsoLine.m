clc
clear
close all

[Table,~] = GenTableNew();

Out = StateDetectUVHS('v',0.0257,'u',2.4488e3,Table)