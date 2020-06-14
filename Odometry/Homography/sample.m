clear all
clc

% m1 = [1;1];
% m2 = [2,2];
% m3 = [3,3];
% m4 = [4,4];
% m5 = [5,5];
% m6 = [6,6];
% 
% n1 = [2,8];
% n2 = [3,7];
% n3 = [4,6];
% n4 = 

% n*4 矩阵 [x1;y1;x2;y2]

load('match.mat')
load('fig1.mat')
A1 = A1';
p1 = [A1(1,:);A1(3,:);ones(1,length(A1))];%第一张图齐次化像素坐标
p2 = [A1(2,:);A1(4,:);ones(1,length(A1))];

% x1 = [1,2,3,4,5,6,7,8];
% y1 = [1,2,3,4,5,6,7,8];
% x2 = [2,3,4,5,6,7,8,9];
% y2 = [8,7,6,5,4,3,2,1];

H = homography2d(p1,p2) ;
figure(1)
imagesc(gray_img1);


[m,n] = size(gray_img1);
gray_img2 =zeros(m,n);
for i = 1:m
    for j = 1:n
        X=H*[i;j;1];
        u2 = fix(X(1,1));
        v2 = fix(X(2,1));
        if u2<=m && u2>0 && v2<=n && v2>0
            gray_img2(u2,v2) = gray_img1(i,j);
        end
    end
end
figure(2)
imagesc(gray_img2);

