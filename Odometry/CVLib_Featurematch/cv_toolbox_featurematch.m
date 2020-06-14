clear;
tic
Img1_l = imread('./figure/10.png');
Img2_l = imread('./figure/11.png');
Img1_r = imread('./figure/08.png');
Img2_r = imread('./figure/09.png');
% Featurematch_VOS:两侧不同时刻图片，同一时刻共四张
% Featurematch_angle：两侧同时刻图片；
% m1_l.Location:所求匹配特征点的坐标，第一列横坐标，第二列纵坐标，
% 2、3、4同理
%% 
% m1_l_2.Location:所求匹配特征点的坐标，第一列横坐标，第二列纵坐标，
%% 
[m1_l,m2_l,m1_r,m2_r]=Featurematch_VOS(Img1_l,Img1_r,Img2_l,Img2_r);
[m1_l_2,m1_r_2]=Featurematch_angle(Img1_l,Img1_r);