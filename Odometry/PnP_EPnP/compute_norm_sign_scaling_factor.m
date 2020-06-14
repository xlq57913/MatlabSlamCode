function [Cc,Xc,sc]=compute_norm_sign_scaling_factor(X1,Cw,Alph,Xw)

n=size(Xw,1);

Cc_=zeros(4,3);
for i=1:4
    Cc_(i,:)=X1(3*i-2:3*i);
end

%摄像机坐标系中参考点的位置
Xc_=Alph*Cc_;

%用世界坐标计算距离质心
centr_w=mean(Xw);
centroid_w=repmat(centr_w,[n,1]);
tmp1=Xw-centroid_w;
dist_w=sqrt(sum(tmp1.^2,2));

%用摄像机坐标计算距离质心
centr_c=mean(Xc_);
centroid_c=repmat(centr_c,[n,1]);
tmp2=Xc_-centroid_c;
dist_c=sqrt(sum(tmp2.^2,2));
 
%比例因子的最小二乘解
sc=1/(inv(dist_c'*dist_c)*dist_c'*dist_w);

%控制点的标度位置
Cc=Cc_/sc;

%参考点的重新缩放
Xc=Alph*Cc;

%必要时更换符号在摄像机坐标系中不可能为z负
neg_z=find(Xc(:,3)<0);
if size(neg_z,1)>=1
    sc=-sc;
    Xc=Xc*(-1);
end
end




        
        
