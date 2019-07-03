function [ recI, payload ] = recover( markImg, headerInfo )
% Secure Recovery
% Proposed method: recover the original image with the payload
% Input: marked image markImg, header information headerInfo
% Output: recovered image and embedded payload
markImg = double(markImg);
[M,N] = size(markImg);

dither = headerInfo.dither;     locMap = headerInfo.locMap;
errMapMock = headerInfo.errMapMock;
paySize = headerInfo.paySize;
endLoc= headerInfo.endLoc;
endi = endLoc(1); endj = endLoc(2); 
capPara = headerInfo.capPara;
Tl = capPara(1); Tr = capPara(2);

reDither = dither(end:-1:1);
cnt1 = 0;
exitLoop = 0;
recI = markImg;
recData = zeros(M*N/2,1);
for i = endi :-1:2
    % Recovery: from right to left, from bottom to top
    if i == endi
        jj = endj;
    else
        jj = (N-2);
    end
    
    for j = jj :-1:2
        if mod(i+j,2) == 0
            errM =  errMapMock(i,j);
            pre =round( mean([markImg(i+1,j),markImg(i,j+1),markImg(i-1,j),markImg(i,j-1)]) );
            errw = markImg(i,j) - pre;
            if (errM) < Tr && (errM)>=Tl && locMap(i,j) == 1
                cnt1 = cnt1 + 1;
                errw = errw - reDither(cnt1);
                b = mod(errw,2);
                recData(cnt1) = b;
                err = (errw - b)/2;
                recI(i,j) = pre + err;
                if cnt1 >= paySize
                    exitLoop = 1;
                    break;
                end
            end
        end
    end
    if exitLoop == 1
        break;
    end
end
recData = recData(1:cnt1);
payload = recData(end:-1:1);
recI = uint8(recI);
end

