clear;
tic
Img1_l = imread('./figure/10.png');
Img2_l = imread('./figure/11.png');
Img1_r = imread('./figure/08.png');
Img2_r = imread('./figure/09.png');
% Featurematch_VOS:���಻ͬʱ��ͼƬ��ͬһʱ�̹�����
% Featurematch_angle������ͬʱ��ͼƬ��
% m1_l.Location:����ƥ������������꣬��һ�к����꣬�ڶ��������꣬
% 2��3��4ͬ��
%% 
% m1_l_2.Location:����ƥ������������꣬��һ�к����꣬�ڶ��������꣬
%% 
[m1_l,m2_l,m1_r,m2_r]=Featurematch_VOS(Img1_l,Img1_r,Img2_l,Img2_r);
[m1_l_2,m1_r_2]=Featurematch_angle(Img1_l,Img1_r);