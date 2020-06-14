% HOMOGRAPHY2D - computes 2D homography 
% 
% usage:   H = homography2d(x1, x2) 
%          H = homography2d(x) 
% 
% description: 
%          x1  - 3xN(���������㣩 ����[u1,u2,....;v1,v2,....;1,1,1....] ͼһ
%          x2  - 3xN�����������㣩 ����[u1',u2',....;v1',v2',....;1,1,1....] ͼ��
%          
%           x  - x���������ʽx = [x1; x2] 
% Returns: 
%          H - 3x3 homography��������x2 = H*x1 
% Method��
%         use DLT method
function H = homography2d(varargin) 
     
    [x1, x2] = checkargs(varargin(:)); 
 
    % ÿ���淶����ʹԭ��λ�����ģ�����ԭ���ƽ������Ϊsqrt��2��
    [x1, T1] = normalise2dpts(x1); 
    [x2, T2] = normalise2dpts(x2); 
     
    %��ע�⣬���һ����λ������Զ����������޷��������滯��������治�ٶ����Ų���w=1��
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
     
    [U,D,V] = svd(A,0); % Ax = 0 ʹ��suv�ֽ�õ�����ʱ��С����ֵ��Ӧ������������Ϊ��С���˽�
     
    % �淶�����homography���� 
    H = reshape(V(:,9),3,3)'; 
     
    % ȥ�淶�� 
    H = T2\H*T1; 
     
end
