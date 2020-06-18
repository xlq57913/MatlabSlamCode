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
addpath('KalmanFilter');

%% number of dataset
datanum = 1;

%% 加载相机参数
if(datanum==1)
    load('camera.mat');
else
    load('camera_1L.mat')
    load('camera_1R.mat')
end
load('timestamps.mat');

% global landmarks;
landmarks = containers.Map;

% number of image to read
framenum = 50;

Odometry = zeros(3,framenum+1);
trajectory = zeros(3,framenum+1);

for picnum=1:framenum      %读取数据，逐帧处理
%% feature matching
    [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPicture(picnum,datanum);
    [m1_l,m2_l,m1_r,m2_r]=FeatureMatch(Image1_l,Image1_r,Image2_l,Image2_r);
    [num,~]=size(m1_l);
    Point1_L = m1_l;
    Point1_R = m1_r;
    Point2_L = m2_l;
    Point2_R = m2_r;

%% calculate 3D coordinate
    Point3ddepth_1 = triangulate(Point1_L, Point1_R, P_L',P_R')*1000;     
    Point3ddepth_2 = triangulate(Point2_L, Point2_R, P_L',P_R')*1000;

    % remove bad points
    Err = abs(Point3ddepth_1-Point3ddepth_2);
    avgDis1 = sum(Err)/num * 2;
    
    discrad = 0;
    for i = 1:num
        if(i==num-discrad)
            break;
        end
        if(Err(i,1)>avgDis1(1) || Err(i,2)>avgDis1(2) || Err(i,3)>avgDis1(3))
            Point3ddepth_1(i-discrad,:) = [];
            Point3ddepth_2(i-discrad,:) = [];
            Point1_L(i-discrad,:) = [];
            Point1_R(i-discrad,:) = [];
            Point2_L(i-discrad,:) = [];
            Point2_R(i-discrad,:) = [];
            discrad = discrad+1;
        end
    end
    
    num = num-discrad

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
    % [R1,t1,Point2_3D_epnp,~] = efficient_pnp(Point1_3D_hom, Point2_2D_hom,P_L(1:3,1:3));
    [R0,t0]=ICP(Point3ddepth_1,Point2_3D_epnp);
    Rt(picnum).R=R0;
    Rt(picnum).t=t0;
    if norm(Rt(picnum).t)>=2000
        Rt(picnum).t=Rt(picnum).t/norm(Rt(picnum).t)*1300;
    end

    %% update Odometry
    [Odometry(:,picnum+1),trajectory(:,picnum+1)] = updateOdometry(Rt,Odometry,trajectory,picnum);
    % Odometry(:,picnum+1) = Rt.R*Odometry(:,picnum)+Rt.t;

    %% get 3D coordinate of feature points
    GlobalPoint = (Point3ddepth_1+Point3ddepth_2)/2;
    GlobalPoint(:,1:2) = transpose((GlobalPoint(:,1:2)') + Odometry([1,3],picnum+1));

    %% update landmarks
    lmk = makeLandMark(GlobalPoint,landmarks);
    if(~isempty(lmk))
        vP = lmk(3:4,:) - lmk(1:2,:);
        [~,n] = size(vP);

        % ugly wey
        if(n~=1)
            offset = sum(vP')'/n
        else
            offset = vP
        end
        % if(norm(offset)>norm(Odometry([1,3],picnum+1)-Odometry([1,3],picnum))*0.3)
        %     offset = offset / norm(offset) * norm(Odometry([1,3],picnum+1)-Odometry([1,3],picnum))*0.3;
        % end
        Odometry([1,3],picnum+1) = Odometry([1,3],picnum+1) + offset;

        %elegant way
        % [xV,q,r] = EFK2(vP,Odometry,picnum);
    end
    
    

    fprintf('%d has finished.\n',picnum);  
end


% trajectory
% for i=1:(length(Rt))
%     if norm(Rt(i).t)>=2000
%         Rt(i).t=Rt(i).t/norm(Rt(i).t)*1300;
%     end
% end

% [Odometry,Z]=trajectory(Rt);     %计算轨迹
mileage=zeros(1,length(Rt));
for i=1:(length(Odometry)-1)
    mileage(:,i)=norm(Odometry(:,i)-Odometry(:,i+1));
end

Odometry(2,:)=[];                %去除y轴数据
%Z(2,:)=[];

Mapkeys = keys(landmarks);
m = length(Mapkeys);
landmarkPoints = zeros(2,m);
landmarkNum = 0;
for i = 1:m
    key = cell2mat(Mapkeys(i));
    landmark = landmarks(key);
    if(landmark.count>3)
        landmarkNum = landmarkNum+1;
        landmarkPoints(:,landmarkNum) = landmark.point(1:2)';
    end
end
landmarkPoints = landmarkPoints(:,1:landmarkNum);

%% show GPS_trajectory
if(datanum == 1)
    load('t_true.mat');
    P_true = [Odometry(2,:);Odometry(1,:)];
    L_true = [landmarkPoints(2,:);landmarkPoints(1,:)];
    T_true = [trajectory(3,:);trajectory(1,:)];
elseif(datanum == 2)
    load('t1_true.mat');
    load('R1_correct.mat')
    P_true = R1_correct*[Odometry(2,:);Odometry(1,:)];
    L_true = R1_correct*[landmarkPoints(2,:);landmarkPoints(1,:)];
else
    load('t2_true.mat');
    load('R2_correct.mat')
    P_true = R2_correct*[Odometry(2,:);Odometry(1,:)];
    L_true = R2_correct*[landmarkPoints(2,:);landmarkPoints(1,:)];
end


%% 画图
hold on;
plot(P_true(2,:),P_true(1,:),'o-')
plot(T_true(2,:),T_true(1,:),'b--')
plot(L_true(2,:),L_true(1,:),'x')
% plot(Z(1,:),Z(2,:),'o-');
% h1=plot(Ptrajectory(1,:),Ptrajectory(2,:));
% plot(Z(1,:),Z(2,:),'bo');
% for i=1:length(Z)
%     plot([Ptrajectory(1,i) Z(1,i)],[Ptrajectory(2,i) Z(2,i)],'r');      %绘制相机姿态
% end
% hold off;
title('trajectory');
xlabel('x(mm)');
ylabel('z(mm)');
total_m=sum(mileage)                %显示里程
hold on;



h2=plot(t_true(2,:),t_true(1,:),'r','linewidth',2);
hold off;
legend('视觉里程计恢复图像','地标','GPS数据')