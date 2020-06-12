function G = Gaussian(P,ksize,sig)
%Gaussian - Gaussian Filter
%
% Syntax: G = Gaussian(P,ksize,sig)
%
% P     : origin photo
% ksize : using ksize*ksize Gaussian Kernel
% sig   : sigma of Gaussian Filter 

%% Generate Gaussian Template
    if(mod(ksize,2)==0)
        ksize = kszie + 1;
    end
    K = zeros(ksize);
    center = (ksize+1)/2;
    for i = 1 : center % simplify through symmetry
        for j = 1 : center
            if(i==center && j==center) 
                K(i,j)=1;
            elseif i==center
                K(i,j)=exp(-j^2/(2*sig^2));
                K(i,j+center) = K(i,j);
            elseif j==center
                K(i,j)=exp(-i^2/(2*sig^2));
                K(i+center,j) = K(i,j);
            else
                K(i,j)=exp(-(i^2+j^2)/(2*sig^2));
                K(i+center,j)=K(i,j);
                K(i,j+center)=K(i,j);
                K(i+center,j+center)=K(i,j);
            end    
        end
    end
    
    K = K/sum(K,'all'); % Normalized
    
    %% doing filter
    [h,w] = size(P);

    G = conv2(P,K);
    G = G(center:h+center-1,center:w+center-1);
end