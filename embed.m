function [ markImg, headerInfo ] = embed( I, payload )
% Secure Embedding
% Proposed Method: Embed randomly generated data into original image
% Input: image I; embedding rate _rate_ .
% Output: marked image _markImg_


[M,N] = size(I);
errOne = zeros((M-3)*(N-3) , 1);
errTwo = zeros((M-3)*(N-3) , 1);

errMapOne = zeros(M,N);
errMapTwo = zeros(M,N);
errMapMock = zeros(M,N);
markImg = double(I);

locMap = zeros(M,N);
locMapSeq = zeros((M-3)*(N-3) , 1);
k = 0;
for i = 2:(M-2)
    for j = 2:(N-2)
        if mod(i+j,2) == 0
            k = k +1;
            pre =round( mean([I(i+1,j),I(i,j+1),I(i-1,j),I(i,j-1)]) );
            pre2 = round(mean([I(i+1,j),I(i,j+1),I(i+2,j+1),I(i+1,j+2)]));
            
            e1= (I(i,j) - pre); 
            errOne(k) = e1;
            errMapOne(i,j) = e1;
            e2= (I(i+1,j+1) - pre2);
            errTwo(k) = e2;  
            errMapTwo(i+1,j+1) = e2;
            
            if e1>=0    % determine expandable location
                if I(i,j) + e1 + 1<=255 && I(i,j) + e1 -1 >=0 
                    locMap(i,j) = 1;
                    locMapSeq(k) = 1;
                end
            else
                %if I(i,j) + e1 >=0
                 if I(i,j) + e1 -1 >=0 
                    locMap(i,j) = 1;
                    locMapSeq(k) = 1;
                end
            end 
        end
    end
end


locMapSeq = locMapSeq(1:k);
errOne = errOne(1:k);
errTwo = errTwo(1:k);

% distribution parameters, most abs of errors are less than 20. 
% P should be sync between encoder and decoder.
P = zeros(10,1); 


Thres = 1.0; % restrict the range of pesudo-random generated error.

errMock= zeros((M-3)*(N-3) , 1);
MockRand = rand(M,N); % uniform random num., sync with encoder and decoder
k = 0;
for i = 2:(M-2)
    for j = 2:(N-2)
        if mod(i+j,2) == 0
            k = k +1; 
            
            
            e2= errMapTwo(i+1,j+1);
            
            RN = MockRand(i,j);
            % generate mock error based on e2 and conditional distribution
            % P(E1=e1| E2= e2)
            ehat = mockErrDet(e2, P, Thres, RN); 
            errMapMock(i,j) = ehat; % mock error map
            errMock(k) = ehat; % mock error in sequence form
        end
    end
end
errMock = errMock(1:k);

paySize = length(payload);
[Tl, Tr, ~] = detParaCap2(locMapSeq, paySize, errMock,errOne);
% disp(min(upperc,paySize/(M*N)));
dither = (-1)* double(rand(paySize,1)>=0.5);
cnt = 0;
endi = 1; endj = 1;
k = 0;
exitLoop =0;

for i = 2:(M-2) % Embed:  from top to bottom, from left to right,
    for j = 2:(N-2)
        if mod(i+j,2) == 0
            k = k +1;
            err = errMapOne(i,j);
            errM =  errMapMock(i,j);
            pre =round( mean([I(i+1,j),I(i,j+1),I(i-1,j),I(i,j-1)]) );

            if (errM < Tr) && (errM>=Tl) && (locMap(i,j) == 1)               
                cnt = cnt + 1;
                b = payload(cnt);
                E1 = 2*err + b+dither(cnt);
                
                markImg(i,j) = pre + E1;

                if cnt >= paySize
                    exitLoop = 1;
                    endi = i;
                    endj = j;
                    break;
                end     
            end
        end
    end
    if exitLoop == 1
        break;
    end
end
endLoc = [endi,endj];
capPara = [Tl, Tr];
markImg = uint8(markImg);
headerInfo = struct('locMap',locMap,'paySize', paySize, ...
    'errMapMock',errMapMock, 'dither',dither,'endLoc',endLoc,'capPara',capPara);

end

