 function [Table,Critical] = GenTableNew()

% This Fucntion Generates A2-A6 Table of the Textbook

% Critical Point Properties

Critical.P = 220.9; % Bar
Critical.T = 374.1; % C
Critical.v = 3.155e-3;  % (m^3/Kg)
Critical.u = 2029.6;    % KJ/Kg
Critical.h = 2099.3;    % 
Critical.s = 4.4298;


%% Saturation Data

% Water Saturation Temperature Data
TDataSatNew= readmatrix('ThermoProp.xlsx','Sheet','A2');
TDataSatNew(:,[1 2]) = TDataSatNew(:,[2 1]); 

% Water Saturation Pressure Data
PDataSatNew= readmatrix('ThermoProp.xlsx','Sheet','A3');


SatData = sortrows([PDataSatNew;TDataSatNew],1);
SatData(end,:) = [];

% Table - Saturated State
Table.Sat.P = SatData(:,1);
Table.Sat.T = SatData(:,2); 
Table.Sat.vf = SatData(:,3)/1e3;
Table.Sat.vg = SatData(:,4);
Table.Sat.vfg =Table.Sat.vg - Table.Sat.vf ;
Table.Sat.uf = SatData(:,5);
Table.Sat.ug = SatData(:,6);
Table.Sat.ufg =Table.Sat.ug - Table.Sat.uf ;
Table.Sat.hf = SatData(:,7);
Table.Sat.hfg =SatData(:,8);
Table.Sat.hg = SatData(:,9);
Table.Sat.sf = SatData(:,10);
Table.Sat.sg = SatData(:,11);
Table.Sat.sfg =Table.Sat.sg - Table.Sat.sf ;



%% Superheat Data

% Water Superheat Data
SuperHearData = readmatrix('ThermoProp.xlsx','Sheet','A4');

% Table - Pressure
Table.SuperHeat.P = SuperHearData(:,1); 
Table.SuperHeat.T = SuperHearData(:,2);
Table.SuperHeat.v = SuperHearData(:,3);
Table.SuperHeat.u = SuperHearData(:,4); 
Table.SuperHeat.h = SuperHearData(:,5);
Table.SuperHeat.s = SuperHearData(:,6);



%% Subcooled Data

% Water Superheat Data
SubCooledData = readmatrix('ThermoProp.xlsx','Sheet','A5');

% Table
Table.SubCooled.P = SubCooledData(:,1); 
Table.SubCooled.T = SubCooledData(:,2);
Table.SubCooled.v = SubCooledData(:,3)/1000;
Table.SubCooled.u = SubCooledData(:,4); 
Table.SubCooled.h = SubCooledData(:,5);
Table.SubCooled.s = SubCooledData(:,6);



%% Saturated Water (Solid Vapor) Data 

% Water Saturation Temperature Data
TDataSat= readmatrix('ThermoProp.xlsx','Sheet','A6');

% Table - Temperature
Table.SatSV.T = TDataSat(:,1); 
Table.SatSV.P = TDataSat(:,2)/100;
Table.SatSV.vi = TDataSat(:,3)/1e3;
Table.SatSV.vg = TDataSat(:,4);
Table.SatSV.ui = TDataSat(:,5);
Table.SatSV.ug = TDataSat(:,7);
Table.SatSV.hi = TDataSat(:,8);
Table.SatSV.hg = TDataSat(:,10);
Table.SatSV.si = TDataSat(:,11);
Table.SatSV.sg = TDataSat(:,13);

end