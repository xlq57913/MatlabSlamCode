function F = GetFAST(P,N)
% GetFAST - 对灰度图片P提取Fast角点，预期数量为N
%
% Syntax: F = GetFAST(P,N)
%
% 对给定的图片以此�?测Fast特征点，并利用Harris响应筛�?�得到的特征�?
% 对每个特征点计算方向后根据Harris响应的结果对得到的特征点排序
% 输出结果F为一个l*3的矩�?(l<=N)
% 第一列为Harris响应得到的结果，第二、三列为得到的特征点的坐�?

    alp = 0.04;
    [h,w] = size(P);
    F = zeros(1,4);
    % 梯度算子
    Sx = [1 0 -1; 2 0 -2; 1 0 -1];
    Sy = [1 2 1; 0 0 0; -1 -2 -1];
    Hx = [1 0 -1];
    Hy = [1 0 -1]';
    % 提取图片的梯�?
    % Ix = conv2(Sx,P);
    % Ix = Ix(2:h+1,2:w+1);
    Ix = conv2(Hx,P);
    Ix = Ix(:,2:w+1);

    % Iy = conv2(Sy,P);
    % Iy = Iy(2:h+1,2:w+1);
    Iy = conv2(Hy,P);
    Iy = Iy(2:h+1,:);

    Ixx = Gaussian(Ix.*Ix,3,2);
    Iyy = Gaussian(Iy.*Iy,3,2);
    Ixy = Gaussian(Ix.*Iy,3,2);
    count = 0;
    for i = 16:h-15
        for j = 16:w-15
            T = P(i,j)*0.2;
            ls = [P(i,j+3),P(i+1,j+3),P(i+2,j+2),P(i+3,j+1),P(i+3,j),P(i+3,j-1),P(i+2,j-2),P(i+1,j-3),P(i,j-3),P(i-1,j-3),P(i-2,j-2),P(i-3,j-1),P(i-3,j),P(i-3,j+1),P(i-2,j+2),P(i-1,j+3)];
            % �?测Fast角点
            if(CheckFAST(ls-P(i,j),T))
                %% 计算Harris响应
                A = sum(Ixx(i-1:i+1,j-1:j+1),'all');
                B = sum(Iyy(i-1:i+1,j-1:j+1),'all');
                C = sum(Ixy(i-1:i+1,j-1:j+1),'all');
                R = A*B-C^2 - alp*(A+B)^2;
                % 响应结果为负数就不记�?
                if(R<=0)
                    continue;
                end
                count = count+1;
                F(count,1) = R;
                F(count,2:3)=[i,j];
                %% 计算特征点的灰度质心
                n=15;
                Patch = P(i-n:i+n,j-n:j+n);
                Px = Patch;
                Py = Patch;
                Px(n+1,:) = Px(n+1,:)*0;
                Py(:,n+1) = Py(:,n+1)*0;
                for a = 1:n
                    Px(a,:) = Px(a,:)*(-n-1+a);
                    Px(a+n+1,:) = Px(a+n+1,:)*(a);
                    Py(:,a) = Py(:,a)*(-n-1+a);
                    Py(:,a+n+1) = Py(:,a+n+1)*(a);
                end
                cx = sum(Px,'all')/sum(Patch,'all');
                cy = sum(Py,'all')/sum(Patch,'all');
                % 计算特征点的方向
                F(count,4) = atan2(cy,cx);
            end
        end
    end
    % 按照Harris响应的�?�排�?
    F = sortrows(F,1,'descend');
    if(count>N)
        F = F(1:N,2:4);
    else
        F = F(:,2:4);
    end
    F = sortrows(F,[1,2],'descend');
end