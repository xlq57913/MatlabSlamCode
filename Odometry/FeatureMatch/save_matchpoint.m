% 存储匹配好的特征点
% A的存储格式：第一列第二列分别为
% 第一张、第二张图片的横坐标
% 第三、四列分别为第一二张图的
% 纵坐标
%% 
function A=save_matchpoint(matchpoint,F1,F2)
A=zeros(length(matchpoint),4);
j=1;
for i=1:length(matchpoint)
    if(matchpoint(i)==-1)
        continue;
    end
    A(j,1:2)=[F1(i,2),F2(matchpoint(i),2)];
    A(j,3:4)=[F1(i,1),...
        F2(matchpoint(i),1)];
    j=j+1;
end
A=A(1:j-1,:);