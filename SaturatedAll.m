function SatState = SaturatedAll(Prop1,Value1,Prop2,Value2,Table,debug)
    % THIS FUNCTION RELIES ON THE INPUTS BEING IN A CERTAIN ORDER. given by
    % inputSort

% Extracting Saturation Data
Temp = Table.Sat.T;
Press = Table.Sat.P;
Vf = Table.Sat.vf;
Vg = Table.Sat.vg;
Uf = Table.Sat.uf;
Ug = Table.Sat.ug;
Hf = Table.Sat.hf;
Hg = Table.Sat.hg;
Sf = Table.Sat.sf;
Sg = Table.Sat.sg;


%inputSort gives P before T
if strcmp(Prop1,'P') && strcmp(Prop2,'T') %really this first thing just shouldn't be the case
    
    if debug
    fprintf("P and T were entered when the fluid is saturated, " + ...
        "check that this is correct as these properties are " + ...
        "insufficient to determine the quality x")
    end
    %find the temperature that it would be if it were saturated
    %Tsat = interp1(Press,Temp,Value1,'linear','extrap');

    %examine the difference between that and the actual input temp
    %if abs(Tsat - Value2) < saturateDetectPTTolerance
    %    %fuck, quality is still indeterminate
    %    x = 0; %default to sat liquid?
    %else
        %fprintf("P, T values supposed to be saturated but aren't")
        x = 0; %default to sat liquid?
    %end

elseif strcmp(Prop1,'P') || (strcmp(Prop1,'T') || strcmp(Prop2,'T'))
    %pressure can only be Prop1, temperature could be either
    
    switch Prop1
        case 'P'
            value1InterpArray = Press;
        case 'T'
            value1InterpArray = Temp;
        otherwise
            %the case where T is prop2 is already caught by the P&T above,
            %because if P was not prop1 then T would be first, ie prop1
            %value1InterpArray = Temp;
    end
    
    switch Prop2
        case 'v'
            satGArray = Vg;
            satFArray = Vf;
        case 'u'
            satGArray = Ug;
            satFArray = Uf;
        case 'h'
            satGArray = Hg;
            satFArray = Hf;
        case 's'
            satGArray = Sg;
            satFArray = Sf;
        %case 'x'
        %shouldn't be the case

    end
    
    satF = interp1(value1InterpArray,satFArray,Value1,'linear','extrap');
    satG = interp1(value1InterpArray,satGArray,Value1,'linear','extrap');

    x = (Value2 - satF) / (satG - satF);

else %neither prop1 nor prop2 is pressure or temperature. UVHS TIME!

%pseudocode:

switch Prop1
        case 'v'
            satGArray = Vg;
            satFArray = Vf;
        case 'u'
            satGArray = Ug;
            satFArray = Uf;
        case 'h'
            satGArray = Hg;
            satFArray = Hf;
        case 's'
            satGArray = Sg;
            satFArray = Sf;
        %case 'x'
        %shouldn't be the case

end

%check which inds of something f, something g are valid, ie for which inds
%is Value1 < satGArray, and Value1 > satFArray (saturated should be between
%them)
validBinary = zeros(numel(satFArray),1); %= ((Value1>satFArray)&&(Value1<satGArray))

for i = 1:numel(satFArray)
    validBinary(i) = (Value1>satFArray(i))&&(Value1<satGArray(i));
end
validInds = find(validBinary);

%find what quality the mixture would be based on the first property
%x(i) = Value1 - something f / something g - something f
xArray = (Value1 - satFArray(validInds)) ./ (satGArray(validInds) - satFArray(validInds));

%now prop2 switch
switch Prop2
        case 'v'
            satGArray2 = Vg;
            satFArray2 = Vf;
        case 'u'
            satGArray2 = Ug;
            satFArray2 = Uf;
        case 'h'
            satGArray2 = Hg;
            satFArray2 = Hf;
        case 's'
            satGArray2 = Sg;
            satFArray2 = Sf;
end

%lets check real quick that things are valid and bounded
if (numel(validInds) < 1) || max(xArray) > 1 || min(xArray) < 0
    if debug
    fprintf("Something is out of bounds while calculating quality - state may not be saturated")
    end
end


%find what the second value would be based on the quality
%v2(i) = something2 f + x(i) * (something2 g - something2 f)
value2Array = satFArray2(validInds) + xArray .* (satGArray2(validInds) - satFArray2(validInds));

x = interp1(value2Array,xArray,Value2,'linear','extrap');

end %end overarching flow control if else

%function output
SatState.x = x;

end