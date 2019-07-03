function [ Tl, Tr, upperc ] = detParaCap2( locMapSeq, paySize, errMock, errOne)


Ti = 0;
idxt = (abs(errMock)>=Ti);
upperc = sum(locMapSeq(idxt)); % upper capacity

Tl =0; Tr = 1;
idxt = ((errMock)>=Tl & errMock<Tr);
capacity = sum(locMapSeq(idxt)); % capacity
if capacity >= paySize
    return;
end
if upperc < paySize
    temp = errMock(logical(locMapSeq));
    Tl = min(temp(:));
    Tr = max(temp(:));
%     disp([Tl,Tr]);
    return;
end

dir = -1; % -1 and 1 is left and right direction respectively
while capacity < paySize
    if dir == -1
        Tl = Tl - 1;
        dir = 1;
    else
        Tr = Tr +1;
        dir = -1;
    end
    idx = ((errMock)>=Tl & abs(errMock)<Tr);
    capacity = sum(locMapSeq(idx));
end


end

