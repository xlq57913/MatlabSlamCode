function U = PyUp(P,ksize,sig)
%PyUp - Description
%
% Syntax: U = PyUp(P)
%
% Long description
    G = Gaussian(P,ksize,sig);
    [h,w]=size(G);
    U = zeros(1);
    for i = 1:2:h
        for j = 1:2:w
            U((i+1)/2,(j+1)/2)=G(i,j);
        end
    end
    U = uint8(U);
end