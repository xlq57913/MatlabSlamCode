% violent match
% find min within hamming matrix
% ��i�б�ʾ����
% �ڶ���ͼƬ�����һ��ͼƬ��i��������
% % hamming����������Ǹ�������
% ���n*1����
% �������������볬������ֵt
% ���������������ȡΪ-1��
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
