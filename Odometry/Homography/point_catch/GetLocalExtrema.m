function Ps = GetLocalExtrema(P,ksize,sig)
%GetLocalExtrema - Description
%
% Syntax: Ps = GetLocalExtrema(P,ksize,sig)
%
% Long description
    [D1,D2,D3,D4,D5] = DOG(P,ksize,sig);
    [h,w]=size(P);
    Ps = [];
    count=0;
    tmp = uint8(zeros(3));
    tmp(2,2)=1;
    for i = 2:h-1
        for j = 2:w-1
            if(D2(i,j)>max([D1(i-1:i+1,j-1:j+1),D2(i-1:i+1,j-1:j+1)-tmp,D3(i-1:i+1,j-1:j+1)],[],'all')|| D3(i,j)>max([D2(i-1:i+1,j-1:j+1),D3(i-1:i+1,j-1:j+1)-tmp,D4(i-1:i+1,j-1:j+1)],[],'all') || D4(i,j)>max([D3(i-1:i+1,j-1:j+1),D4(i-1:i+1,j-1:j+1)-tmp,D5(i-1:i+1,j-1:j+1)],[],'all'))
                count = count+1;
                Ps(count,1)=i;
                Ps(count,2)=j;
            elseif (D2(i,j)<min([D1(i-1:i+1,j-1:j+1),D2(i-1:i+1,j-1:j+1)+tmp,D3(i-1:i+1,j-1:j+1)],[],'all') || D3(i,j)<min([D2(i-1:i+1,j-1:j+1),D3(i-1:i+1,j-1:j+1)+tmp,D4(i-1:i+1,j-1:j+1)],[],'all') ||D4(i,j)<min([D3(i-1:i+1,j-1:j+1),D4(i-1:i+1,j-1:j+1)+tmp,D5(i-1:i+1,j-1:j+1)],[],'all'))
                count = count+1;
                Ps(count,1)=i;
                Ps(count,2)=j;
            end
        end
    end
end