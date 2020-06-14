function [m1_l,m2_l,m1_r,m2_r]=FeatureMatch(img1_l,img1_r,img2_l,img2_r)
[gray_img1_l,gray_img2_l]=grayimg(img1_l,img2_l);
[gray_img1_r,gray_img2_r]=grayimg(img1_r,img2_r);

% 提取特征点和描述子
[B1_l,F1_l]=ExtractORB(gray_img1_l,1000);
[B2_l,F2_l]=ExtractORB(gray_img2_l,1000);
[B1_r,F1_r]=ExtractORB(gray_img1_r,1000);
[B2_r,F2_r]=ExtractORB(gray_img2_r,1000);
% 第二张图片由于与第一章图片合并，
% % 横坐标右移n1个单位
% F2_l(:,2)=F2_l(:,2)+n1_l;
% F2_r(:,2)=F2_r(:,2)+n1_r;
% 描述子汉明距离
dham_l=hamming(B1_l,B2_l);
dham_r=hamming(B1_r,B2_r);
dham_1=hamming(B1_l,B1_r);
dham_2=hamming(B2_l,B2_r);
% 暴力匹配结果
matchpoint_l=violent_match(dham_l);
matchpoint_r=violent_match(dham_r);
matchpoint_1=violent_match(dham_1);
matchpoint_2=violent_match(dham_2);
% A的存储格式：第一列第二列分别为
% 第一张、第二张图片的横坐标
% 第三、四列分别为第一二张图的
% 纵坐标
A_l=save_matchpoint(matchpoint_l,F1_l,F2_l);
A_r=save_matchpoint(matchpoint_r,F1_r,F2_r);
m1_l=[A_l(:,1),A_l(:,3)];
m2_l=[A_l(:,2),A_l(:,4)];
m1_r=[A_r(:,1),A_r(:,3)];
m2_r=[A_r(:,2),A_r(:,4)];
