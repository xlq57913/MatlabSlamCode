close all;
clear;
clc;
%% 添加路径
addpath(genpath('PnP_EPnP'));
addpath(genpath('CVLib_Featurematch'));
addpath('FeatureMatch')
addpath('featureMatching');

%% load data mat
load('camera.mat');     %读取相机参数
%% parameter setLeft='LeftCamera';
Right='RightCamera';    %数据集储存点
Left='LeftCamera';
%% loop
for picnum=1:140      %读取数据，逐帧处理
%% feature matching
    [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPic(picnum,Left,Right);
    [m1_l,m2_l,m1_r,m2_r]=Featurematch_1(Image1_l, Image2_l, Image1_r, Image2_r);
    Point1_L=((m1_l.Location));
    Point1_R=((m1_r.Location));
    Point2_L=((m2_l.Location));
    Point2_R=((m2_r.Location));
    fprintf('%d has finished.\n',picnum);
%% calculate 3D coordinate
    Point3ddepth_1 = triangulate(Point1_L, Point1_R, P_L',P_R')*1000;     
    Point3ddepth_2 = triangulate(Point2_L, Point2_R, P_L',P_R')*1000;


 %% 齐次化
    Point1_3D_hom = [Point3ddepth_1,ones(length(Point3ddepth_1),1)];
    Point2_2D_hom = [Point2_L,ones(length(Point2_L),1)];
    
%% pnp问题 -EPnP算法-已Gauss_Newton非线性优化
  [R1,t1,Point2_3D_epnp,~] = efficient_pnp_gauss(Point1_3D_hom, Point2_2D_hom,P_L(1:3,1:3));
  [R0,t0]=ICP(Point3ddepth_1,Point2_3D_epnp);
%     [R0,t0,~,~] = efficient_pnp_gauss(Point1_3D_hom, Point2_2D_hom,P_L(1:3,1:3));
    Rt(picnum).R=R0;
    Rt(picnum).t=t0;
end


%% trajectory
for i=1:(length(Rt))
    if norm(Rt(i).t)>=2000
        Rt(i).t=Rt(i).t/norm(Rt(i).t)*1300;
    end
end


[Ptrajectory,Z]=trajectory(Rt);     %计算轨迹
mileage=zeros(1,length(Rt));

for i=1:(length(Ptrajectory)-1)
    mileage(:,i)=norm(Ptrajectory(:,i)-Ptrajectory(:,i+1));
end



Ptrajectory(2,:)=[];                %去除y轴数据
Z(2,:)=[];

%% 画图
hold on;
plot(Ptrajectory(1,:),Ptrajectory(2,:),'o')
hold off;
title('trajectory');
xlabel('x(mm)');
ylabel('z(mm)');
total_m=sum(mileage)                %显示里程
hold on;

%% show GPS_trajectory
load('t_true.mat');
h2=plot(t_true(2,:),t_true(1,:),'r','linewidth',2);
hold off;
legend('视觉里程计恢复图像','GPS数据');