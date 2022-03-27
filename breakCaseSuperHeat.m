function SuperState = breakCaseSuperHeat(PVec,NewTable,PInput,Prop1,Value1,Table,xInput)
%NewTable.P should only have one element
    %actually it could have many values. Is taking the maximum justified? I
    %think so at least for superheated, probably not for subcooled
    firstIsoBarInd = find(PVec==max(NewTable.P)); %index of the lower isobar
    firstIsoBarValue = PVec(firstIsoBarInd)
    %NewTable.P should only have the element where the pressure was not out
    %of bounds

    switch Prop1
        case 'T'
            %secondIsoBarInd = firstIsoBarInd + 1; %always true?
            secondIsoBarInd = firstIsoBarInd + 1; %always true?

        case 'v'
            %really what we need to do is swap them as well
            secondIsoBarInd = firstIsoBarInd;
            %secondIsoBarValue = firstIsoBarValue;
            
            %unused? no it is
            firstIsoBarInd = firstIsoBarInd - 1
            %firstIsoBarInd = firstIsoBarInd + 1;

            firstIsoBarValue = PVec(firstIsoBarInd) %resets this
            %secondIsoBarInd = firstIsoBarInd - 1; %always true?

            

        otherwise
            fprintf("must be T or v")
    end
    secondIsoBarValue = PVec(secondIsoBarInd);

    %the isotherm is based on the first temperature (saturation?) of the second isobar
    %indices in table data for the second isobar pressure
    Ind1 = find(Table.SuperHeat.P == secondIsoBarValue);
    secondIsoBarTemps = Table.SuperHeat.T(Ind1);
    secondIsoBarVols = Table.SuperHeat.v(Ind1);


    isoTherm = secondIsoBarTemps(1) % is it always the first (lowest) temperature here?

    Ind2 = find(Table.SuperHeat.P == firstIsoBarValue);
    firstIsoBarTemps = Table.SuperHeat.T(Ind2);
    firstIsoBarVols = Table.SuperHeat.v(Ind2);

    %we now have temperature and specific volume arrays for the first and
    %second isobars

    %now we calcuate the specific volume at each of the points on the
    %isobar
    secondIsoBarVol = secondIsoBarVols(1); %should just be the first?

    firstIsoBarVol = interp1(firstIsoBarTemps,firstIsoBarVols,isoTherm,'linear','extrap');
    %where along the first isobar does it intersect with the isotherm
    %created by the second isobar

    %next we can calculate the specific volume at the isotherm temperature, for
    %an arbitrary pressure between the two isobars


    qVIsotherm = interp1([firstIsoBarValue,secondIsoBarValue],[firstIsoBarVol,secondIsoBarVol],PInput,'linear','extrap')

    %next we can interpolate for saturation data to get the saturation
    %properties for the isobar corresponding to the input pressure
    %we need to find saturation based on pressure and not based on
    %temperature, even if we are given temperature. Because we are
    %explicitly looking at the variation along an isobar of the input
    %pressure, using the other variables to find the position along said
    %isobar
    qTSat = interp1(Table.Sat.P,Table.Sat.T,PInput,'linear','extrap')
    qVSat = interp1(Table.Sat.P,Table.Sat.vg,PInput,'linear','extrap')

    if strcmp(Prop1,'T')
            
            %now we interpolate between the saturation for the queried isobar, and
            %the values on that isobar at the isotherm temperature. This should be
            %locally linear
            qV = interp1([qTSat,isoTherm],[qVSat,qVIsotherm],xInput,'linear','extrap');

            %then getting all the other properties u, v, h, s is trivial

            SuperState.T = Value1;
            SuperState.P = PInput;
            SuperState.v = qV;
            SuperState.u = 0;
            SuperState.h = 0;
            SuperState.s = 0;

        elseif strcmp(Prop1,'v')
            

            qT = interp1([qVSat,qVIsotherm],[qTSat,isoTherm],xInput,'linear','extrap'); %double check on this but I think it just flips

            %then getting all the other properties u, v, h, s is trivial

            SuperState.T = qT;
            SuperState.P = PInput;
            SuperState.v = Value1;
            SuperState.u = 0;
            SuperState.h = 0;
            SuperState.s = 0;


        else
            fprintf("s, h, u, properties not supported for this type of interpolation")
            %also fuck
        end


    end


% function SuperState = breakCaseSuperHeat(PVec,NewTable,PInput,Prop1,Value1,Prop2,Value2,Table,xInput)
% %NewTable.P should only have one element
%     %actually it could have many values. Is taking the maximum justified? I
%     %think so at least for superheated, probably not for subcooled
%     firstIsoBarInd = find(PVec==max(NewTable.P)); %index of the lower isobar
%     firstIsoBarValue = PVec(firstIsoBarInd)
%     %NewTable.P should only have the element where the pressure was not out
%     %of bounds
% 
%     switch Prop1
%         case 'T'
%             secondIsoBarInd = firstIsoBarInd + 1; %always true?
% 
%         case 'v'
%             %really what we need to do is swap them as well
%             secondIsoBarInd = firstIsoBarInd;
%             %secondIsoBarValue = firstIsoBarValue;
%             
%             %unused? no it is
%             firstIsoBarInd = firstIsoBarInd - 1
%             firstIsoBarValue = PVec(firstIsoBarInd) %resets this
%             %secondIsoBarInd = firstIsoBarInd - 1; %always true?
% 
%         otherwise
%             fprintf("must be T or v")
%     end
%     secondIsoBarValue = PVec(secondIsoBarInd)
% 
%     %the isotherm is based on the first temperature (saturation?) of the second isobar
%     %indices in table data for the second isobar pressure
%     Ind1 = find(Table.SuperHeat.P == secondIsoBarValue);
%     secondIsoBarTemps = Table.SuperHeat.T(Ind1);
%     secondIsoBarVols = Table.SuperHeat.v(Ind1);
% 
% 
%     isoTherm = secondIsoBarTemps(1) % is it always the first (lowest) temperature here?
% 
%     Ind2 = find(Table.SuperHeat.P == firstIsoBarValue);
%     firstIsoBarTemps = Table.SuperHeat.T(Ind2);
%     firstIsoBarVols = Table.SuperHeat.v(Ind2)
% 
%     %we now have temperature and specific volume arrays for the first and
%     %second isobars
% 
%     %now we calcuate the specific volume at each of the points on the
%     %isobar
%     secondIsoBarVol = secondIsoBarVols(1) %should just be the first?
% 
%     firstIsoBarVol = interp1(firstIsoBarTemps,firstIsoBarVols,isoTherm,'linear','extrap')
%     %where along the first isobar does it intersect with the isotherm
%     %created by the second isobar
% 
%     %next we can calculate the specific volume at the isotherm temperature, for
%     %an arbitrary pressure between the two isobars
% 
% 
%     qVIsotherm = interp1([firstIsoBarValue,secondIsoBarValue],[firstIsoBarVol,secondIsoBarVol],PInput,'linear','extrap')
% 
%     %next we can interpolate for saturation data to get the saturation
%     %properties for the isobar corresponding to the input pressure
%     %we need to find saturation based on pressure and not based on
%     %temperature, even if we are given temperature. Because we are
%     %explicitly looking at the variation along an isobar of the input
%     %pressure, using the other variables to find the position along said
%     %isobar
%     qTSat = interp1(Table.Sat.P,Table.Sat.T,PInput,'linear','extrap')
%     qVSat = interp1(Table.Sat.P,Table.Sat.vg,PInput,'linear','extrap')
% 
%     if strcmp(Prop1,'T')
%             
%             %now we interpolate between the saturation for the queried isobar, and
%             %the values on that isobar at the isotherm temperature. This should be
%             %locally linear
%             qV = interp1([qTSat,isoTherm],[qVSat,qVIsotherm],xInput,'linear','extrap');
% 
%             %then getting all the other properties u, v, h, s is trivial
% 
%             SuperState.T = Value1;
%             SuperState.P = PInput;
%             SuperState.v = qV;
%             SuperState.u = 0;
%             SuperState.h = 0;
%             SuperState.s = 0;
% 
%         elseif strcmp(Prop1,'v')
%             
% 
%             qT = interp1([qVSat,qVIsotherm],[qTSat,isoTherm],xInput,'linear','extrap'); %double check on this but I think it just flips
% 
%             %then getting all the other properties u, v, h, s is trivial
% 
%             SuperState.T = qT;
%             SuperState.P = PInput;
%             SuperState.v = Value1;
%             SuperState.u = 0;
%             SuperState.h = 0;
%             SuperState.s = 0;
% 
% 
%         end
% 
% 
%     end