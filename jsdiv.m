function dist=jsdiv(P,Q)

    if size(P,2)~=size(Q,2)
        error('the number of columns in P and Q should be the same');
    end

    if sum(~isfinite(P(:))) + sum(~isfinite(Q(:)))
       error('the inputs contain non-finite values!') 
    end

    dist = zeros(size(P));

    %# create an index of the "good" data points
    goodIdx = P>0 & Q>0; %# bin counts <0 are not good, either

    d1 = sum(P(goodIdx) .* log(P(goodIdx) ./Q(goodIdx)));
    d2 = sum(Q(goodIdx) .* log(Q(goodIdx) ./P(goodIdx)));

    %# overwrite d only where we have actual data
    %# the rest remains zero
    % dist(goodIdx) = d1 + d2;
    dist = (d1 + d2)/2;
end