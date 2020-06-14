clear;
clc

%% make date
clc
clear

fprintf('---------------------------PNP test---------------------------\n\n')

A = rand(3, 3);
t = [-200;-50;200];
[R, ~] = qr(A);
K= [721.5377,0,609.5593;0,721.5377,172.8540;0,0,1.0000];
K_hom =[721.5377,0,609.5593,0;0,721.5377,172.8540,0;0,0,1.0000,0];

npoints = 6;
X = rand(3, npoints);
X(4, :) = ones(1, npoints);
P = [R,t;zeros(1,3),1];
x = K_hom* P * X;
for i = 1:npoints
    x(:, i) = x(:, i) ./ x(3, i);
end

[R1,t1,X0,~] = efficient_pnp(X', x',K)
