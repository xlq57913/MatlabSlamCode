% violent match
% find min within hamming matrix
% 第i行表示的是
% 第二张图片中与第一张图片第i个特征点
% % hamming距离最近的那个点的序号
% 组成n*1矩阵
% 如果最近汉明距离超过了阈值t
% 则该组数据舍弃（取为-1）
function k=violent_match(d)
[n,~]=size(d);
t=min(d);
t=min(t);
k=zeros(n,1);
for i=1:n
    [dist,b]=min(d(i,:));
    if dist<2.3*t
        k(i)=b;
    else
        k(i)=-1;
    end
end
