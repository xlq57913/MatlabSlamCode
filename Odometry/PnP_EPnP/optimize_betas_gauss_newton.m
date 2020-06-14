function [Xc_opt,R_opt,T_opt,err_opt,iter]=optimize_betas_gauss_newton(Km,Cw,Beta0,Alph,Xw,U,A)

% 高斯牛顿法优化
%       Km: kernel向量
%       Cw: 控制点在世界坐标系中的位置
%       Beta0: beta初始值



n=size(Beta0,2);

[Beta_opt,err,iter]=gauss_newton(Km,Cw,Beta0);

%从Beta和Kernel中提取控制点摄像机坐标
X=zeros(12,1);
for i=1:n
   X=X+Beta_opt(i)*Km(:,i); 
end

Cc=zeros(4,3);
for i=1:4
    Cc(i,:)=X(3*i-2:3*i);
end


%检查行列式符号（保持控制点的方向）
s_Cw=sign_determinant(Cw);
s_Cc=sign_determinant(Cc);
Cc=Cc*(s_Cw/s_Cc);

%计算误差
Xc_opt=Alph*Cc; 
[R_opt,T_opt]=getrotT(Xw,Xc_opt); 

[err_opt,Urep_opt]=reprojection_error_usingRT(Xw,U,R_opt,T_opt,A);
end






