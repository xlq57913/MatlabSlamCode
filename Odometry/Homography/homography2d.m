% HOMOGRAPHY2D - computes 2D homography 
% 
% usage:   H = homography2d(x1, x2) 
%          H = homography2d(x) 
% 
% description: 
%          x1  - 3xN(至少六个点） 向量[u1,u2,....;v1,v2,....;1,1,1....] 图一
%          x2  - 3xN（至少六个点） 向量[u1',u2',....;v1',v2',....;1,1,1....] 图二
%          
%           x  - x必须具有形式x = [x1; x2] 
% Returns: 
%          H - 3x3 homography矩阵，满足x2 = H*x1 
% Method：
%         use DLT method
function H = homography2d(varargin) 
     
    [x1, x2] = checkargs(varargin(:)); 
 
    % 每组点规范化，使原点位于质心，且与原点的平均距离为sqrt（2）
    [x1, T1] = normalise2dpts(x1); 
    [x2, T2] = normalise2dpts(x2); 
     
    %请注意，如果一个点位于无穷远处，则可能无法将其正规化，因此下面不假定缩放参数w=1。
    Npts = length(x1); 
    A = zeros(3*Npts,9); 
     
    O = [0 0 0]; 
    for n = 1:Npts 
	X = x1(:,n)'; 
	x = x2(1,n); y = x2(2,n); w = x2(3,n); 
	A(3*n-2,:) = [  O  -w*X  y*X]; 
	A(3*n-1,:) = [ w*X   O  -x*X]; 
	A(3*n  ,:) = [-y*X  x*X   O ]; 
    end 
     
    [U,D,V] = svd(A,0); % Ax = 0 使用suv分解得到，此时最小奇异值对应的特征向量即为最小二乘解
     
    % 规范化后的homography矩阵 
    H = reshape(V(:,9),3,3)'; 
     
    % 去规范化 
    H = T2\H*T1; 
     
end
