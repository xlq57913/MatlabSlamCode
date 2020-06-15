% �洢ƥ��õ�������
% A�Ĵ洢��ʽ����һ�еڶ��зֱ�Ϊ
% ��һ�š��ڶ���ͼƬ�ĺ�����
% ���������зֱ�Ϊ��һ����ͼ��
% ������
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
end