function [gray_img,F1,F2,dham,matchpoint,A]=para(img1,img2)
[~,~,d] = size(img1);
if(d==3)
    gray_img1=rgb2gray(img1);
% rotate as you want
% 这个旋转操作纯粹是想检验效果
% img2=imrotate(img2,45);
    gray_img2=rgb2gray(img2);
else
    gray_img1=img1;
    gray_img2=img2;
end
% 两张大小不同的图像统一格式
[m1,n1]=size(gray_img1);
[m2,n2]=size(gray_img2);
if m1<m2
    m1=m2;
end
if n1<n2
    n1=n2;
end
% 读取原图，做实验
img1_scale=imresize(img1,[m1,n1]);
% n1：图片宽度方向像素点个数
gray_img1=imresize(gray_img1,[m1,n1]);
gray_img2=imresize(gray_img2,[m1,n1]);
%合并图像
gray_img=[gray_img1,gray_img2];
% 提取特征点和描述子
[B1,F1]=ExtractORB(gray_img1,1000);
[B2,F2]=ExtractORB(gray_img2,1000);
fprintf('After ExtractORB : %0.5f \n',toc)
% 第二张图片由于与第一章图片合并，
% % 横坐标右移n1个单位
F2(:,2)=F2(:,2)+n1;
% 描述子汉明距离
dham=hamming(B1,B2);
% 暴力匹配结果
matchpoint=violent_match(dham);

% A的存储格式：第一列第二列分别为
% 第一张、第二张图片的横坐标
% 第三、四列分别为第一二张图的
% 纵坐标
A=zeros(length(matchpoint),4);
j=1;
for i=1:length(matchpoint)
    if(matchpoint(i)==-1)
        continue;
    end
    A(j,1:2)=[F1(i,2),F2(matchpoint(i),2)];
    A(j,3:4)=[F1(i,1),...
        F2(matchpoint(i),1)];
    j=j+1;
end
fprintf('After match : %0.5f \n',toc)
A=A(1:j-1,:);
A1=A;
A1(:,2)=A1(:,2)-n1;
save('fig1.mat','img1_scale');
save('match.mat','A1');