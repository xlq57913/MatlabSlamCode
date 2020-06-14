clear;
tic;
% 阈值t=38,汉明距离，暴力匹配
% 阈值t的调整在para.m的第30行
img1=imread('./figure/004.jpg');
img2=imread('./figure/005.jpg');
%img2 = imrotate(img2,180);
[gray_img,F1,F2,dham,matchpoint,A]=para(img1,img2);
colormap gray;
imagesc(gray_img);
hold on;
[m,~]=size(A);
for i=1:m
    x1=[A(i,1),A(i,2)];
    x2=[A(i,3),...
        A(i,4)];
    plot(x1,x2);
    hold on;
end
timeusing=toc;