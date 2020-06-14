function Alph=compute_alphas(Xw,Cw)
n=size(Xw,1);
C=[Cw';ones(1,4)];
X=[Xw';ones(1,n)];
Alph_=inv(C)*X;
Alph=Alph_';
end
