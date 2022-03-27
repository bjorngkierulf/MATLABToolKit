function SuperState = SuperHeatAll(Prop1,Value1,Prop2,Value2,Table,nonrobust)

%MAKE IT A SCRIPT
%clc; clear; close all;


%reorder inputs, so that pressure is never the first input
customOrder = {'T','v','u','h','s','x','P'};
% 
% %Prop1
% %Prop2
% 
% 
% Prop1 = 'v';
% Value1 = .8123;
% Prop2 = 'T';
% Value2 = 140;
% % Prop1 = 'P';
% % Value1 = 2;
% 
% 
% [Table,~] = GenTableNew();

%% first section
[Prop1,Value1,Prop2,Value2] = InputSort(Prop1,Value1,Prop2,Value2,customOrder);
%InputSort(Prop1,Value1,Prop2,Value2,order)
%fprintf("NOW HERE")

%this allows the interpolation code to be further generalized

%initialize
PVec = unique(Table.SuperHeat.P);
NewTable.P = PVec;
NewTable.T = zeros(size(PVec));
NewTable.v = zeros(size(PVec));
NewTable.u = zeros(size(PVec));
NewTable.h = zeros(size(PVec));
NewTable.s = zeros(size(PVec));

switch Prop1

    case 'T'
        Value1InterpArray = Table.SuperHeat.T;

    case 'v'
        Value1InterpArray = Table.SuperHeat.v;

    case 'u'
        Value1InterpArray = Table.SuperHeat.u;

    case 'h'
        Value1InterpArray = Table.SuperHeat.h;

    case 's'
        Value1InterpArray = Table.SuperHeat.s;

end

%general code:
for i = 1:numel(PVec)
    %find applicable rows indices in the superheated tables
    Ind1 = find(Table.SuperHeat.P == PVec(i));
    a = Value1InterpArray(Ind1);

    %min(a)
    %max(a)

    if Value1 > max(a) || Value1 < min(a)
        if nonrobust

            %min(a)
            %max(a)

            NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind1),Value1,'linear','extrap');
            NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind1),Value1,'linear','extrap');
            NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind1),Value1,'linear','extrap');
            NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind1),Value1,'linear','extrap');
            NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind1),Value1,'linear','extrap');
            fprintf("\nOut of bounds, data kept")
        else
            %Value1
            %min(a)
            %max(a)

            fprintf("\nLocally out of bounds, data discarded")
            NewTable.P(i) = 0;
        end

    else
        NewTable.T(i) = interp1(a,Table.SuperHeat.T(Ind1),Value1,'linear','extrap');
        NewTable.v(i) = interp1(a,Table.SuperHeat.v(Ind1),Value1,'linear','extrap');
        NewTable.h(i) = interp1(a,Table.SuperHeat.h(Ind1),Value1,'linear','extrap');
        NewTable.s(i) = interp1(a,Table.SuperHeat.s(Ind1),Value1,'linear','extrap');
        NewTable.u(i) = interp1(a,Table.SuperHeat.u(Ind1),Value1,'linear','extrap');
    end

end

%remove zeroes
NewTable.T = NewTable.T(NewTable.P~=0);
NewTable.v = NewTable.v(NewTable.P~=0);
NewTable.h = NewTable.h(NewTable.P~=0);
NewTable.s = NewTable.s(NewTable.P~=0);
NewTable.u = NewTable.u(NewTable.P~=0);
NewTable.P = NewTable.P(NewTable.P~=0);


switch Prop2

    case 'T'
        Value2InterpArray = NewTable.T;

    case 'v'
        Value2InterpArray = NewTable.v;

    case 'u'
        Value2InterpArray = NewTable.u;

    case 'h'
        Value2InterpArray = NewTable.h;

    case 's'
        Value2InterpArray = NewTable.s;

    case 'P'
        Value2InterpArray = NewTable.P;
    otherwise
        fprintf("Unrecognized property")

end



%debug - a and b should always have the same length
%our break case occurs when the NewTable.xx each only have one element
%a = NewTable.T
%b = NewTable.v

%test point for R134a is .8 bar, -30 C

%we need a better way to detect for using this, because this only works on
%the lowest temperature range in the superheated table

%this works for input P, T
%what if the inputs are P, v or T, v (both necessary for iso-lines
%a = NewTable.P

switch Prop2
    case 'T'
        limitArray = NewTable.T;
        breakcase = sum(limitArray > Value2) < 1
    case 'P'
        limitArray = NewTable.P;
        breakcase = sum(limitArray > Value2) < 1
    case 'v'
        limitArray = NewTable.v;
        breakcase = sum(limitArray < Value2) < 1
    case 's'
        limitArray = NewTable.s;
        breakcase = 0;%sum(limitArray > Value1) < 1
    case 'u'
        limitArray = NewTable.u;
        breakcase = 0;%sum(limitArray > Value1) < 1
    case 'h'
        limitArray = NewTable.h;
        breakcase = 0;%sum(limitArray > Value1) < 1
end

%breakcase = 0; %for now, just turn it off

if 0
    %format long
    %maybe helps eliminate precision issues? maybe not?

    %if NewTable.T (valid T values) has no values above the input
    %temperature, then use the other method. Otherwise we would be
    %extrapolating from lower temperatures to the input temperature

%if numel(NewTable.T) < 2 %do the alternate method
    %this method should ideally work for any inputs P, T, v, s. Don't
    %bother with h, u, x (superheated)


    %alrighty now we break it up based on what we're given
    if strcmp(Prop2,'P') %P is sorted to be prop2 here
        PInput = Value2;
        xInput = Value1;

        SuperState = breakCaseSuperHeat(PVec,NewTable,PInput,Prop1,Value1,Prop2,Value2,Table,xInput)

        pause
        
        %% old - now in the func
% 
% 
%         %NewTable.P should only have one element
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
% 
%         if strcmp(Prop1,'T')
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
%             %already written
% %             %% written
% % 
% %     %NewTable.P should only have one element
% %     %actually it could have many values. Is taking the maximum justified? I
% %     %think so at least for superheated, probably not for subcooled
% %     firstIsoBarInd = find(PVec==max(NewTable.P)); %index of the lower isobar
% %     firstIsoBarValue = PVec(firstIsoBarInd)
% %     %NewTable.P should only have the element where the pressure was not out
% %     %of bounds
% % 
% %     secondIsoBarInd = firstIsoBarInd + 1; %always true?
% %     secondIsoBarValue = PVec(secondIsoBarInd)
% % 
% %     %the isotherm is based on the first temperature (saturation?) of the second isobar
% %     %indices in table data for the second isobar pressure
% %     Ind1 = find(Table.SuperHeat.P == secondIsoBarValue);
% %     secondIsoBarTemps = Table.SuperHeat.T(Ind1);
% %     secondIsoBarVols = Table.SuperHeat.v(Ind1);
% % 
% % 
% %     isoTherm = secondIsoBarTemps(1) % is it always the first (lowest) temperature here?
% % 
% %     Ind2 = find(Table.SuperHeat.P == firstIsoBarValue);
% %     firstIsoBarTemps = Table.SuperHeat.T(Ind2);
% %     firstIsoBarVols = Table.SuperHeat.v(Ind2)
% % 
% %     %we now have temperature and specific volume arrays for the first and
% %     %second isobars
% % 
% %     %now we calcuate the specific volume at each of the points on the
% %     %isobar
% %     secondIsoBarVol = secondIsoBarVols(1) %should just be the first?
% % 
% %     firstIsoBarVol = interp1(firstIsoBarTemps,firstIsoBarVols,isoTherm,'linear','extrap')
% %     %where along the first isobar does it intersect with the isotherm
% %     %created by the second isobar
% % 
% %     %next we can calculate the specific volume at the isotherm temperature, for
% %     %an arbitrary pressure between the two isobars
% % 
% %     %assuming given temp, press
% %     if strcmp(Prop2,'P')
% %         PInput = Value2; %I think because sorting - is this robust?
% % 
% %         TInput = Value1; %not robust, will need to be made better
% % 
% %     else
% %         fprintf("This type of interpolation is not currently supported when neither property is pressure")
% %     end
% % 
% %     qVIsotherm = interp1([firstIsoBarValue,secondIsoBarValue],[firstIsoBarVol,secondIsoBarVol],PInput,'linear','extrap')
% % 
% % 
% %     %next we can interpolate for saturation data to get the saturation
% %     %properties for the isobar corresponding to the input pressure
% %     %we need to find saturation based on pressure and not based on
% %     %temperature, even if we are given temperature. Because we are
% %     %explicitly looking at the variation along an isobar of the input
% %     %pressure, using the other variables to find the position along said
% %     %isobar
% %     qTSat = interp1(Table.Sat.P,Table.Sat.T,PInput,'linear','extrap')
% %     qVSat = interp1(Table.Sat.P,Table.Sat.vg,PInput,'linear','extrap')
% % 
% %     %now we interpolate between the saturation for the queried isobar, and
% %     %the values on that isobar at the isotherm temperature. This should be
% %     %locally linear
% % 
% %     qV = interp1([qTSat,isoTherm],[qVSat,qVIsotherm],TInput,'linear','extrap');
% % 
% %     %then getting all the other properties u, v, h, s is trivial
% % 
% %     SuperState.T = TInput;
% %     SuperState.P = PInput;
% %     SuperState.v = qV;
% %     SuperState.u = 0;
% %     SuperState.h = 0;
% %     SuperState.s = 0;
% % 
% % 
%         else
%             fprintf("s, h, u, properties not supported for this type of interpolation")
%             %also fuck
%         end
% 



%true mysteries await
    elseif strcmp(Prop1,'T')
        if strcmp(Prop2,'v') %because of sorting this should be the only case
            xInput = Value1; %temp
            new = 1;
            if new
                    
    lowerIsoBarInd = find(PVec==max(NewTable.P)); %index of the lower isobar
    lowerIsoBarValue = PVec(lowerIsoBarInd)

    upperIsoBarInd = lowerIsoBarInd - 1;
    upperIsoBarValue = PVec(upperIsoBarInd)

    %now make an array with 5 pressures between the upper and lower
    %isobars. Then follow the same procedure as before with that pressure
    %and the input specific volume. This will create a range of values
    %corresponding to a range of temperatures. Then we interpolate among
    %those temperatures (or temp / v swapped)

    n = 100;

    pressArr = linspace(lowerIsoBarValue,upperIsoBarValue,n)
    vArr = zeros(size(pressArr));
    tArr = zeros(size(pressArr));

    vArr2 = zeros(size(pressArr));
    tArr2 = zeros(size(pressArr));

    for i = 1:length(pressArr)
        PInput = pressArr(i);
        supS = breakCaseSuperHeat(PVec,NewTable,PInput,Prop1,Value1,Table,xInput);
    
        tArr(i) = supS.T;
        vArr(i) = supS.v;

    end
    
    pressMaybe = interp1(pressArr,vArr,Value2)

    if 1 %for whatever reason using the other method is infinitely better 
        % and yields a linear v vs P for constant T, whereas this one gives 
        % a very nonlinear (and even non-monotonic) T vs P for constant v

    for i = 1:length(pressArr) %use v instead of T
        PInput = pressArr(i);
        Prop1Switch = Prop2;
        Value1Switch = Value2;
        xInput = Value2;
        supS = breakCaseSuperHeat(PVec,NewTable,PInput,Prop1Switch,Value1Switch,Table,xInput);
    
        tArr2(i) = supS.T;
        vArr2(i) = supS.v;

    end
    
    pressMaybe2 = interp1(pressArr,tArr2,Value1)


    end

    figure(1)
    tiledlayout(1,2)
    nexttile(1)
    plot(pressArr,vArr)
    nexttile(2)
    plot(pressArr,tArr2)


    figure(2)
    hold on
    plot(vArr,tArr) %constant T
    plot(vArr2,tArr2) %constant v

    plot(Value2,Value1,'*','MarkerSize',10) %query point

    legend("Constant T","Constant v","query point")
    xlabel("v")
    ylabel("T")



    pause
    

















                %new, worse method
            else
                %% bad

            %first we copy from above as it's already done
            %actually it could have many values. Is taking the maximum justified? I
    %think so at least for superheated, probably not for subcooled
    firstIsoBarInd = find(PVec==max(NewTable.P)); %index of the lower isobar
    firstIsoBarValue = PVec(firstIsoBarInd)
    %NewTable.P should only have the element where the pressure was not out
    %of bounds

    secondIsoBarInd = firstIsoBarInd + 1; %always true? maybe?
    secondIsoBarValue = PVec(secondIsoBarInd)

    %the isotherm is based on the first temperature (saturation?) of the second isobar
    %indices in table data for the second isobar pressure
    Ind1 = find(Table.SuperHeat.P == secondIsoBarValue);
    secondIsoBarTemps = Table.SuperHeat.T(Ind1);
    secondIsoBarVols = Table.SuperHeat.v(Ind1);


    isoTherm = secondIsoBarTemps(1) % is it always the first (lowest) temperature here?

    Ind2 = find(Table.SuperHeat.P == firstIsoBarValue);
    firstIsoBarTemps = Table.SuperHeat.T(Ind2);
    firstIsoBarVols = Table.SuperHeat.v(Ind2)

    %we now have temperature and specific volume arrays for the first and
    %second isobars

    %now we calcuate the specific volume at each of the points on the
    %isobar
    secondIsoBarVol = secondIsoBarVols(1) %should just be the first?

    firstIsoBarVol = interp1(firstIsoBarTemps,firstIsoBarVols,isoTherm,'linear','extrap')
    
    




            %this is going to be nasty, lets define variables as I have
            %them in the math
            %known inputs
            qT = Value1
            qv = Value2


            %first isobar (second IsoBar)
                %saturation
                asv = secondIsoBarVols(1)
                asT = secondIsoBarTemps(1)
                asP = secondIsoBarValue
    
                %next data point in table
                a1v = secondIsoBarVols(2)
                a1T = secondIsoBarTemps(2)
                %a1P = asP


            %second isobar (first IsoBar)
                %saturation
                bsv = firstIsoBarVols(1)
                bsT = firstIsoBarTemps(1)
                bsP = firstIsoBarValue
    
                %next data point in table
                b1v = firstIsoBarVols(3) %because of the data and its intervals. This is nonrobust
                b1T = firstIsoBarTemps(3)
                %b1P = bsP

                %value on the isotherm
                bxv = firstIsoBarVol %better this way as asT is not guaranteed to be in the range of bsT and b1T
                %bxv = ((asT - bsT) / (b1T - bsT)) * (b1v-bsv) + bsv
                bxT = asT %isotherm
                %bxP = bsP = b1P %b isobar
                
            %the one known of the unknown
                c1T = asT; %isotherm

            %now define algebra variables
                d = qv;
                e = asv;
                f = (bxv-asv)/(bsv-asv)
                h = asT
                i = qT - asT
                j = (bsT-asT)/(bsv-asv)
                k = c1T - asT %=0


            %now we can define variables for polynomial equation
            a = j*f
            b = -d*j -k -e*j -i*f -j*e*f +j*h -e*j*f +i +e*j
            c = d*(k+e*j) -i*(-e*f+h) +e*j*(-e*f+h)

            %define polynomial tuple
            p = [a, b, c]

            %calculate roots
            out = roots(p) %this is the correct input format and syntax


    %choose one of the roots
    csv = out(2)


    %calculate the other variables based on that
    c1v = ((csv-asv)/(bsv-asv))*(bxv-asv) + asv
    csT = ((csv-asv)/(bsv-asv))*(bsT-asT) + asT

    %instead set them to the true value
    csv = 0.1614 %specific volume of saturated vapor at 1.2 bar
    csT = -22.36

    %c1v = ((csv-asv)/(bsv-asv))*(bxv-asv) + asv
    c1v = ((csT-asT)/(bsT-asT))*(bxv-asv) + asv
    csv = ((csT-asT)/(bsT-asT))*(bsv-asv) + asv

% now we check that it satisfies the equations

fprintf("\nthese three should be equal\n") %and of course they are because we just calculated them using those equations
(csv-asv)/(bsv-asv)
(c1v-asv)/(bxv-asv)
(csT-asT)/(bsT-asT)

fprintf("\nand these two should be equal\n") %these two are defff the issue.. not sure how though?
(qv-csv)/(c1v-csv)
(qT-csT)/(c1T-csT)

fprintf("\nupstream, these two should be equal\n") %these two are defff the issue.. not sure how though?
(d-csv) / ((csv-e)*f + h-csv)
(i - (csv-e)*j)/(k-(csv-e)*j)

fprintf("\nmore things that should be equal\n") %these two are defff the issue.. not sure how though?
(qv-csv) / ((csv-asv)*(bxv-asv)/(bsv-asv) + asT-csv)
(qT - csT - asT) / (c1T - csT  - asT)
(qT - (csv-asv)*(bsT-asT)/(bsv-asv) - asT) / (c1T-(csv-asv)*(bsT-asT)/(bsv-asv) - asT)

fprintf("\nThis should equal 1\n") %This should equal 1
(bsP-asP)/(bsP-asP)


%they're clearly not, so let's do some graphing
close all
figure(1)
plot([asv,csv,bsv],[asT,csT,bsT])
hold on
plot([asv,a1v],[asT,a1T])
plot([bsv,bxv,b1v],[bsT,bxT,b1T])
plot([csv,c1v],[csT,c1T])
plot(qv,qT,'*')

legend("Saturation curve","a isobar","b isobar","c isobar","query point")
xlabel("v")
ylabel("T")




            
            end %end if new
            
            %oh bad oh bad oh bad bad bad
        else
            fprintf("This type of interpolation is not currently supported for the combination of input properties")
        end

    else
        fprintf("still not supported")
    end


end

%if 1 %this is the default

%     if length(NewTable.P) < 2
%         %first order assumption, set it to the values
%         SuperState.T = NewTable.T;
%         SuperState.P = NewTable.P;
%         SuperState.v = NewTable.v;
%         SuperState.u = NewTable.u;
%         SuperState.h = NewTable.h;
%         SuperState.s = NewTable.s;
% 
%     else

    %Value2InterpArray

%prop2 general code for real

if Value2 > max(Value2InterpArray) || Value2 < min(Value2InterpArray)
    fprintf("Second property out of range: %f",Value2)
end


if breakcase %does this break for u, h, v, s cases?
    if ~nonrobust %guarantees that we don't cause recursion
        Prop1
        Value1
        Prop2
        Value2
        NewTable
        fprintf("break case")

        SuperState = SuperHeatAll(Prop1,Value1,Prop2,Value2,Table,1);%nonrobust
    end
else


SuperState.T = interp1(Value2InterpArray,NewTable.T,Value2,'linear','extrap');
SuperState.P = interp1(Value2InterpArray,NewTable.P,Value2,'linear','extrap');
SuperState.v = interp1(Value2InterpArray,NewTable.v,Value2,'linear','extrap');
SuperState.u = interp1(Value2InterpArray,NewTable.u,Value2,'linear','extrap');
SuperState.h = interp1(Value2InterpArray,NewTable.h,Value2,'linear','extrap');
SuperState.s = interp1(Value2InterpArray,NewTable.s,Value2,'linear','extrap');

%This can be generalized because there isn't an issue with passing
%something an interpolation where the output array is all the same. Ie if
%pressure is value2, both Value2InterpArray and NewTable.P are equal. Thus
%by asking for interpolation at value2 you get value2 back

end


end