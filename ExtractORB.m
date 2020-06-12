function[B,Ps] = ExtractORB(P,n)
%ExtractORB - extract ORB describers from gray image P, n is  is expected number of describers
%
% Syntax: [B,Ps] = ExtractORB(P,n)
%
% Long description 
    %% 计算构筑金字塔所需的层数
    [h,w] = size(P);
    % 金字塔的最小层的尺寸为256*256
    s = fix(log(min(h,w)/256)/log(1.2));
    nums = ones(1,s);
    for i = 2:s
        nums(i) =  1/(1.44^(i-1));
    end
    % 计算每一层需要的特征点数
    nums = fix(n/sum(nums)*nums);
    nums(1) = n - sum(nums(2:end));
    Ps = zeros(n,2);
    B = zeros(n,256);
    lastl = 0;
    %% 对每层图片生成Fast角点和Brief描述子
    for j = 1:s
        if(j~=1)
            rP = imresize(P,1/(1.2^(j-1)));
        else
            rP = P;
        end
        % 提取Fast角点
        Fs = GetFAST(rP,nums(j));
        l = length(Fs(:,1));
        if(l==1 && norm(Fs)==0)
            continue;
        end
        % 提取Brief描述子
        rP = Gaussian(rP,3,1.6);
        for i = 1: l
            % 获取用于描述的点对
            D = GetDescriber(Fs(i,3));
            for a = 1:256
                if(rP(Fs(i,1)+D(1,a),Fs(i,2)+D(2,a))>rP(Fs(i,1)+D(3,a),Fs(i,2)+D(4,a)))
                    B(i+lastl,a) = 1;
                end
            end
        end
        % 将不同尺寸的图片的特征点放缩到原尺寸上
        Ps(lastl+1:lastl+l,:) = Fs(:,1:2)*1.2^(j-1);
        lastl = lastl+l;
    end
    Ps = Ps(1:lastl,:);
    B = B(1:lastl,:);
end