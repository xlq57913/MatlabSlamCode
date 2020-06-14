close all
clear;
clc
%% 添加路径
addpath(genpath('EPnP'));
addpath(genpath('PnP_EPnP'));
addpath(genpath('code_epnp'));
addpath(genpath('CVLib_Featurematch'));
addpath('FeatureMatch')
addpath('featureMatching');

%% 加载相机参数
load('camera.mat'); 

Right='RightCamera';    %数据集储存点
Left='LeftCamera';



for picnum=1:20      %读取数据，逐帧处理
%% feature matching
    [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPicture(picnum);
    [m1_l,m2_l,m1_r,m2_r]=FeatureMatch(Image1_l,Image1_r,Image2_l,Image2_r);
    num_1 = min(length(m1_l),length(m1_r))
    num_2 = min(length(m2_l),length(m2_r))
    Point1_L = m1_l(1:num_1,:);
    Point1_R = m1_r(1:num_1,:);
    Point2_L = m2_l(1:num_2,:);
    Point2_R = m2_r(1:num_2,:);
    % [m1_l,m2_l,m1_r,m2_r]=Featurematch_1(Image1_l, Image2_l, Image1_r, Image2_r);
    % Point1_LT=((m1_l.Location));
    % Point1_RT=((m1_r.Location));
    % Point2_LT=((m2_l.Location));
    % Point2_RT=((m2_r.Location));
%     Point1_L=((Point1_L.Location));
%     Point1_R=((Point1_R.Location));
%     Point2_L=((Point2_L.Location));
%     Point2_R=((Point2_R.Location));
    fprintf('%d has finished.\n',picnum);  
    if(num_1==0 || num_2==0)
        continue;
    end
 %% calculate 3D coordinate
    Point3ddepth_1 = triangulate(Point1_L, Point1_R, P_L',P_R')*1000;     
    Point3ddepth_2 = triangulate(Point2_L, Point2_R, P_L',P_R')*1000;
%  %% data selection
%     length=length(Point1_L);
%     Point1_L(fix(length/3)*3+1:end,:)=[];
%     Point1_R(fix(length/3)*3+1:end,:)=[];
%     Point2_L(fix(length/3)*3+1:end,:)=[];
%     Point2_R(fix(length/3)*3+1:end,:)=[];
%     Point3ddepth_1(fix(length/3)*3+1:end,:)=[];
%     Point3ddepth_2(fix(length/3)*3+1:end,:)=[];
%     clear length;

% %% P3P 2D-3D
%     [Point3dP3P_2,Point3ddepth_1]=P3P(Point2_L,Point3ddepth_1,P_L);
% %% ICP 3D--Rt
%     [R0,t0]=ICP(Point3ddepth_1,Point3dP3P_2);
%     Rt(picnum).R=R0;
%     Rt(picnum).t=t0;

%% 齐次化
    Point1_3D_hom = [Point3ddepth_1,ones(length(Point3ddepth_1),1)];
    Point2_2D_hom = [Point2_L,ones(length(Point2_L),1)];
%% pnp问题 -EPnP算法
    [R1,t1,Point2_3D_epnp,~] = efficient_pnp_gauss(Point1_3D_hom, Point2_2D_hom,P_L(1:3,1:3));
    [R0,t0]=ICP(Point3ddepth_1,Point2_3D_epnp);
    Rt(picnum).R=R0;
    Rt(picnum).t=t0;
end


% trajectory
% for i=1:(length(Rt))
%     if norm(Rt(i).t)>=2000
%         Rt(i).t=Rt(i).t/norm(Rt(i).t)*1300;
%     end
% end

[Ptrajectory,Z]=trajectory(Rt);     %计算轨迹
mileage=zeros(1,length(Rt));
for i=1:(length(Ptrajectory)-1)
    mileage(:,i)=norm(Ptrajectory(:,i)-Ptrajectory(:,i+1));
end

%% 画图
hold on;
plot(Ptrajectory(1,:),Ptrajectory(2,:),'o-')
% plot(Z(1,:),Z(2,:),'o-');
% h1=plot(Ptrajectory(1,:),Ptrajectory(2,:));
% plot(Z(1,:),Z(2,:),'bo');
% for i=1:length(Z)
%     plot([Ptrajectory(1,i) Z(1,i)],[Ptrajectory(2,i) Z(2,i)],'r');      %绘制相机姿态
% end
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