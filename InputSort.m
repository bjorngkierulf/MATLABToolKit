function [Prop1New,Value1New,Prop2New,Value2New] = InputSort(Prop1,Value1,Prop2,Value2,order,debug)
    % This function takes inputs of two properties and values, and sorts
    % them into a standard order such that redundant switch statements can
    % be avoided
    % The order that inputs will be sorted into is:
    % ['P','T','v','u','h','s','x']

    if isempty(order)
        %~exist('order','var')
        order = {'P','T','v','u','h','s','x'};
    end
    
    ind1 = find(strcmp(order,Prop1));
    ind2 = find(strcmp(order,Prop2));

    %check that both input properties were matched in the list
    if isempty(ind1) || isempty(ind2)
        if debug, fprintf(["Either or both of the properties are invalid: " + Prop1 + ' ' + Prop2]); end
        
        %assign the defaults anyway
        Prop1New = Prop1;
        Value1New = Value1;
        Prop2New = Prop2;
        Value2New = Value2;
        return
    end

    %if ind 2 is less it should be prop 1, so swap them
    if ind2 < ind1
        Prop1New = Prop2;
        Value1New = Value2;
        Prop2New = Prop1;
        Value2New = Value1;

    %if ind 2 is greater then the inputs are as they should be, and no
    %rearranging is necessary
    else
        Prop1New = Prop1;
        Value1New = Value1;
        Prop2New = Prop2;
        Value2New = Value2;
    end

end %end function