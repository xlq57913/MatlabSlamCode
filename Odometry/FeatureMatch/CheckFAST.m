function r = CheckFAST(Is,T)
%CheckFAST - 检测给定的点对是否是Fast角点
%
% Syntax: r = CheckFAST(Is,T)
%
% Is为按顺序选定的环形区域内的点的灰度与中心点灰度的差值
% T为判断大小所用的阈值
% 当环形区域上的16个点中有12个点的灰度值大于阈值或小于负阈值，认为这个点满足Fast特征点的要求
    bigger = 0;
    smaller = 0;
    %% 检测 1，5，9，13方向的点
    for i = 1 : 4 : 13
        if(Is(i)>T)
            bigger = bigger+1;
        elseif (Is(i)<-T)
            smaller = smaller+1;
        end
    end
    % 如果四个点中有三个较大或三个较小，则通过
    if(bigger<3 && smaller<3)
        r = false;
        return;
    end
    %% 检测其余点
    for i = 2 : 16
        if(mod(i,4)==1)
            continue;
        end
        if(Is(i)>T)
            bigger = bigger+1;
        elseif (Is(i)<-T)
            smaller = smaller+1;
        end
    end
    % 如果有12个点满足较大或较小，认为该点满足Fast特征点的要求
    if(bigger>=12||smaller>=12)
        r=true;
    else
        r=false;
    end
end