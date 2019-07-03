function [ ehat ] = mockErrDet( e2, P, T,RN )
    idx = abs(e2) + 1;
    if abs(e2) >=9
        idx = 10;
    end

    p = P(idx);

    X = (1-T)/2 + T*RN;
    a = (1-p)/(1+p);
    
    if X > (1-a)/2 && X < (1+a)/2
        ehat = 0;
    elseif X >= (1+a)/2
        i = 1;
        sum = (1+a)/2 + a*p^i;
        while X > sum
            i = i +1;
            sum = sum + a*p^i;
        end
        ehat = i;
    else
        i = -1;
        sum = (1-a)/2 - a*p^abs(i);
        while X < sum
            i = i -1;
            sum = sum - a*p^abs(i);
        end
        ehat = i;
    end
    ehat = min(max(-255,ehat),255);
end

