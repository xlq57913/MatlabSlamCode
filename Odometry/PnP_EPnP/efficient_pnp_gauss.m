function [R,T,Xc,best_solution,opt]=efficient_pnp_gauss(x3d_h,x2d_h,A)
% 高斯牛顿法非线性优化EPNP算法 
%INPUT:
%       x3d_h: 世界坐标系中的齐次坐标（N*4）
%       x2d_h: 像素坐标系中的齐次坐标（N*3)
%       A: 相机内参
%OUTPUT:
%       R: 对世界坐标系的旋转矩阵
%       T: 对世界坐标系的平移矩阵
%       Xc: 相机坐标系中的三维坐标
%       best solution: 高斯牛顿法之前最佳解的维数
%       opt: 优化过程中的参数


Xw=x3d_h(:,1:3);
U=x2d_h(:,1:2);

THRESHOLD_REPROJECTION_ERROR=20;%控制点基准度误差


%在世界坐标系中定义控制点（以三维点的质心为中心）
Cw=define_control_points();

%Compute alphas（表示3d点的控制点的线性组合）
Alph=compute_alphas(Xw,Cw);

%Compute M
M=compute_M_ver2(U,Alph,A);

%Compute kernel M
Km=kernel_noise(M,4); %in matlab we have directly the funcion km=null(M);
    


%1.-Solve assuming dim(ker(M))=1. X=[Km_end];------------------------------
dim_kerM=1;
X1=Km(:,end);
[Cc,Xc,sc]=compute_norm_sign_scaling_factor(X1,Cw,Alph,Xw);

[R,T]=getrotT(Xw,Xc);  %solve exterior orientation
err(1)=reprojection_error_usingRT(Xw,U,R,T,A);

sol(1).Xc=Xc;
sol(1).Cc=Cc;
sol(1).R=R;
sol(1).T=T;
sol(1).error=err(1);
sol(1).betas=[1];
sol(1).sc=sc;
sol(1).Kernel=X1;


%2.-Solve assuming dim(ker(M))=2------------------------------------------
Km1=Km(:,end-1);
Km2=Km(:,end);

%control points distance constraint
D=compute_constraint_distance_2param_6eq_3unk(Km1,Km2);
dsq=define_distances_btw_control_points();
betas_=inv(D'*D)*D'*dsq;
beta1=sqrt(abs(betas_(1)));
beta2=sqrt(abs(betas_(3)))*sign(betas_(2))*sign(betas_(1));
X2=beta1*Km1+beta2*Km2;

[Cc,Xc,sc]=compute_norm_sign_scaling_factor(X2,Cw,Alph,Xw);

[R,T]=getrotT(Xw,Xc);  %solve exterior orientation
err(2)=reprojection_error_usingRT(Xw,U,R,T,A);

sol(2).Xc=Xc;
sol(2).Cc=Cc;
sol(2).R=R;
sol(2).T=T;
sol(2).error=err(2);
sol(2).betas=[beta1,beta2];
sol(2).sc=sc;
sol(2).Kernel=[Km1,Km2];



%3.-Solve assuming dim(ker(M))=3------------------------------------------
if min(err)>THRESHOLD_REPROJECTION_ERROR 

    Km1=Km(:,end-2);
    Km2=Km(:,end-1);
    Km3=Km(:,end);

    %控制点距离约束
    D=compute_constraint_distance_3param_6eq_6unk(Km1,Km2,Km3);
    dsq=define_distances_btw_control_points();
    betas_=inv(D)*dsq;
    beta1=sqrt(abs(betas_(1)));
    beta2=sqrt(abs(betas_(4)))*sign(betas_(2))*sign(betas_(1));
    beta3=sqrt(abs(betas_(6)))*sign(betas_(3))*sign(betas_(1));

    X3=beta1*Km1+beta2*Km2+beta3*Km3;

    [Cc,Xc,sc]=compute_norm_sign_scaling_factor(X3,Cw,Alph,Xw);
  
    [R,T]=getrotT(Xw,Xc);  %solve exterior orientation
    err(3)=reprojection_error_usingRT(Xw,U,R,T,A);

    sol(3).Xc=Xc;
    sol(3).Cc=Cc;
    sol(3).R=R;
    sol(3).T=T;
    sol(3).error=err(3);
    sol(3).betas=[beta1,beta2,beta3];
    sol(3).sc=sc;
    sol(3).Kernel=[Km1,Km2,Km3];

end



%4.-Solve assuming dim(ker(M))=4------------------------------------------
if min(err)>THRESHOLD_REPROJECTION_ERROR %just compute if we do not have good solution in the previus cases
    Km1=Km(:,end-3);
    Km2=Km(:,end-2);
    Km3=Km(:,end-1);
    Km4=Km(:,end);


    D=compute_constraint_distance_orthog_4param_9eq_10unk(Km1,Km2,Km3,Km4);
    dsq=define_distances_btw_control_points();
    lastcolumn=[-dsq',0,0,0]';
    D_=[D,lastcolumn];
    Kd=null(D_);

    P=compute_permutation_constraint4(Kd);
    lambdas_=kernel_noise(P,1);
    lambda(1)=sqrt(abs(lambdas_(1)));
    lambda(2)=sqrt(abs(lambdas_(6)))*sign(lambdas_(2))*sign(lambdas_(1));
    lambda(3)=sqrt(abs(lambdas_(10)))*sign(lambdas_(3))*sign(lambdas_(1));
    lambda(4)=sqrt(abs(lambdas_(13)))*sign(lambdas_(4))*sign(lambdas_(1));
    lambda(5)=sqrt(abs(lambdas_(15)))*sign(lambdas_(5))*sign(lambdas_(1));

    betass_=lambda(1)*Kd(:,1)+lambda(2)*Kd(:,2)+lambda(3)*Kd(:,3)+lambda(4)*Kd(:,4)+lambda(5)*Kd(:,5);
    beta1=sqrt(abs(betass_(1)));
    beta2=sqrt(abs(betass_(5)))*sign(betass_(2));
    beta3=sqrt(abs(betass_(8)))*sign(betass_(3));
    beta4=sqrt(abs(betass_(10)))*sign(betass_(4));
    X4=beta1*Km1+beta2*Km2+beta3*Km3+beta4*Km4;

    [Cc,Xc,sc]=compute_norm_sign_scaling_factor(X4,Cw,Alph,Xw);
    
    [R,T]=getrotT(Xw,Xc);  %solve exterior orientation
    err(4)=reprojection_error_usingRT(Xw,U,R,T,A);

    sol(4).Xc=Xc;
    sol(4).Cc=Cc;
    sol(4).R=R;
    sol(4).T=T;
    sol(4).error=err(4);
    sol(4).betas=[beta1,beta2,beta3,beta4];
    sol(4).sc=sc;
    sol(4).Kernel=[Km1,Km2,Km3,Km4];
end


%5.-Gauss Newton Optimization------------------------------------------------------ 
[min_err,best_solution]=min(err);
Xc=sol(best_solution).Xc;
R=sol(best_solution).R;
T=sol(best_solution).T;
Betas=sol(best_solution).betas;
sc=sol(best_solution).sc;
Kernel=sol(best_solution).Kernel;
 
if best_solution==1
    Betas=[0,0,0,Betas];
elseif best_solution==2
    Betas=[0,0,Betas];
elseif best_solution==3
    Betas=[0,Betas];
end

Km1=Km(:,end-3);
Km2=Km(:,end-2);
Km3=Km(:,end-1);
Km4=Km(:,end);
Kernel=[Km1,Km2,Km3,Km4];


%迭代beta优化解
Beta0=Betas/sc;
[Xc_opt,R_opt,T_opt,err_opt,iter]=optimize_betas_gauss_newton(Kernel,Cw,Beta0,Alph,Xw,U,A);

%如果Gauss Newton改进了结果
if err_opt<min_err    
    R=R_opt;
    T=T_opt;
    Xc=Xc_opt;
end

opt.Beta0=Beta0;
opt.Kernel=Kernel;
opt.iter=iter;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R, T]=getrotT(wpts,cpts)

% Solve the exterior orientation problem
%假设摄像机和世界坐标给出。
%wpts=任意参考坐标系中的三维点
%cpts=相机参考帧中的三维点

  
n=size(wpts,1);
M=zeros(3);

ccent=mean(cpts);
wcent=mean(wpts);

for i=1:3
  cpts(:,i)=cpts(:,i)-ccent(i)*ones(n,1);
  wpts(:,i)=wpts(:,i)-wcent(i)*ones(n,1);
end
for i=1:n
   M=M+cpts(i,:)'*wpts(i,:);
end
[U S V]=svd(M);
R=U*V';
if det(R)<0
  R=-R;
end
T=ccent'-R*wcent';
% 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [err,Urep]=reprojection_error_usingRT(Xw,U,R,T,A)
%计算投影误差

n=size(Xw,1);

P=A*[R,T];
Xw_h=[Xw,ones(n,1)];
Urep_=(P*Xw_h')';


Urep=zeros(n,2);
Urep(:,1)=Urep_(:,1)./Urep_(:,3);
Urep(:,2)=Urep_(:,2)./Urep_(:,3);


%投影误差
err_=sqrt((U(:,1)-Urep(:,1)).^2+(U(:,2)-Urep(:,2)).^2);
err=sum(err_)/n;
end