# MATLABToolKit
Repository for the educational thermodynamic MATLAB ToolKit

File locations:
A brief manual is ThermoToolkitManual.docx/.pdf
The main app is realApp.mlapp, and it should open in MatLab's app designer
The installable version of the toolkit is Compiled/ThermoToolkit.mlappinstall
Old code is in the Archive/ folder
The source data, taken from the Thermodynamics textbook is in the ThermoProp.xlsx spreadsheet. If you are messing with it, make a copy
The top-level functions handle the bulk of what the app does, but work independent of the app. For example, you could use GenTableNew() to generate variables for the table data and PropertyCalculateSafe() to calculate state and properties using two input properties. You could use IsoLine() to generate the data for a line of a constant property, then plot it. All these functions work in scripts