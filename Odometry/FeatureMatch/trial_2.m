clear;
tic;
% ��ֵt=38,�������룬����ƥ��
% ��ֵt�ĵ�����para.m�ĵ�30��
img1=imread('../LeftCamera/data/0000000000.png');
img2=imread('../LeftCamera/data/0000000001.png');
%img2 = imrotate(img2,180);
[gray_img,F1,F2,dham,matchpoint,A,t1,t2]=para(img1,img2);
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