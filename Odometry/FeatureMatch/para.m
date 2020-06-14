function [gray_img,F1,F2,dham,matchpoint,A,t1,t2]=para(img1,img2)
[gray_img1,gray_img2,n1]=grayimg(img1,img2);
% 读取原图，做实验
[m2,n2]=size(img1);
img1_scale=imresize(img1,[m2,n2]);
% n1：图片宽度方向像素点个数
% 提取特征点和描述子
tic
[B1,F1]=ExtractORB(gray_img1,1000);
[B2,F2]=ExtractORB(gray_img2,1000);
t1=toc;
gray_img = [gray_img1,gray_img2];
% 第二张图片由于与第一章图片合并，
% % 横坐标右移n1个单位
F2(:,2)=F2(:,2)+n1(1);
% 描述子汉明距离
dham=hamming(B1,B2);
% 暴力匹配结果
matchpoint=violent_match(dham);
t2=toc;
% A的存储格式：第一列第二列分别为
% 第一张、第二张图片的横坐标
% 第三、四列分别为第一二张图的
% 纵坐标
A=save_matchpoint(matchpoint,F1,F2);
A1=A;
A1(:,2)=A1(:,2)-n1(1);
save('fig1.mat','img1_scale');
save('match.mat','A1');