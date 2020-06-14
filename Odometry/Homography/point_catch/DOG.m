function [D1,D2,D3,D4,D5] = DOG(P,ksize,sig)
%DOG - Description
%
% Syntax: [D1,D2,D3,D4,D5] = DOG(P,ksize,sig)
%
% Long description
    k = 2^(1/3);
    G1 = uint8(Gaussian(P,ksize,k^(0)*sig));
    G2 = uint8(Gaussian(P,ksize,k^(1)*sig));
    G3 = uint8(Gaussian(P,ksize,k^(2)*sig));
    G4 = uint8(Gaussian(P,ksize,k^(3)*sig));
    G5 = uint8(Gaussian(P,ksize,k^(4)*sig));
    G6 = uint8(Gaussian(P,ksize,k^(5)*sig));

    D1 = (G2-G1).*P;
    D2 = (G3-G2).*P;
    D3 = (G4-G3).*P;
    D4 = (G5-G4).*P;
    D5 = (G6-G5).*P;
    
end