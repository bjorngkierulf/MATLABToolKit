function ProcOut = ProcIsoLine(Prop1,Value1,v1,v2,Table,Critical,debug)
%relies on specific volume and specific entropy relationship being
%monotonic
%For an isovolumetric process, input P1, P2 as the limits in place of v1, v2

%we need the contingency if for an isovolumetric line
if strcmp(Prop1,'v')
    %oh no they input an isovolume and two volume bounds
    %no wait, the volume bounds are now pressure bounds

    %get all variables at first and last specific volume
    first = PropertyCalculate(Prop1,Value1,'P',v1,Table);
    last = PropertyCalculate(Prop1,Value1,'P',v2,Table);
    %why is the main functionality of the code not already bundled into a
    %function??

else
    %get all variables at first and last specific volume
    first = PropertyCalculate(Prop1,Value1,'v',v1,Table);
    last = PropertyCalculate(Prop1,Value1,'v',v2,Table);
    %why is the main functionality of the code not already bundled into a
    %function??

end


%switch based on the property given, then call the normal isoline
% function for that property
switch Prop1

    case 'P'
        %constant pressure line
        out = IsoBarLineNew(Value1,Table);

        %get first and last points
        %first = StateDetect('P',Value1,'v',v1);
        %generalize


    case 'T'
        %constant temperature line
        out = IsoThermLine(Value1,Table);

    case 'v'
        %constant volume line
        out = ConstVolLine(Value1,Table,Critical);
        %In this case v1, v2 are N/A, because it is a constant volume line
        %so we will assume the user has passed us P1, P2 instead

    case 'u'
        %constant internal energy line
        fprintf("iso line not yet implemented")

    case 'h'
        %constant enthalpy line
        fprintf("iso line not yet implemented")

    case 's'
        %constant entropy line
        out = IsentropicLine(Value1,Table,Critical);

end


if strcmp(Prop1,'v')
    %break case when the user inputs v for a isovolumetric process
    %we assume they also input P1, P2 as the limits in place of v1, v2
    %valid indices
    %find(out.P>v1);
    %find(out.P<v2);
    insideInd = [1:length(out.P)];
    outsideInd = [find(out.P<v1), find(out.P>v2)];
    %again P1 and P2 in place of v1 and v2
    insideInd(outsideInd) = [];%empty
    %insideInd = insideInd(insideInd>0)

else
    %normal operation:

    %valid indices
    %find(out.v>v1);
    %find(out.v<v2);
    insideInd = [1:length(out.v)];
    outsideInd = [find(out.v<v1), find(out.v>v2)];
    insideInd(outsideInd) = [];%empty
    %insideInd = insideInd(insideInd>0)


end


%then extract only the values of the other variables for those indices
newOut.P = [first.P, out.P(insideInd), last.P];
newOut.T = [first.T, out.T(insideInd), last.T];
newOut.v = [first.v, out.v(insideInd), last.v];
newOut.s = [first.s, out.s(insideInd), last.s];


%add back in the two end points, maybe this needs to happen within the
%switch statment...


ProcOut = newOut;

end %end function