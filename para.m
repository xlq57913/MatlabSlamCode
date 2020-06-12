function [gray_img,F1,F2,dham,matchpoint,A]=para(img1,img2)
[~,~,d] = size(img1);
if(d==3)
    gray_img1=rgb2gray(img1);
% rotate as you want
% �����ת���������������Ч��
% img2=imrotate(img2,45);
    gray_img2=rgb2gray(img2);
else
    gray_img1=img1;
    gray_img2=img2;
end
% ���Ŵ�С��ͬ��ͼ��ͳһ��ʽ
[m1,n1]=size(gray_img1);
[m2,n2]=size(gray_img2);
if m1<m2
    m1=m2;
end
if n1<n2
    n1=n2;
end
% ��ȡԭͼ����ʵ��
img1_scale=imresize(img1,[m1,n1]);
% n1��ͼƬ��ȷ������ص����
gray_img1=imresize(gray_img1,[m1,n1]);
gray_img2=imresize(gray_img2,[m1,n1]);
%�ϲ�ͼ��
gray_img=[gray_img1,gray_img2];
% ��ȡ�������������
[B1,F1]=ExtractORB(gray_img1,1000);
[B2,F2]=ExtractORB(gray_img2,1000);
fprintf('After ExtractORB : %0.5f \n',toc)
% �ڶ���ͼƬ�������һ��ͼƬ�ϲ���
% % ����������n1����λ
F2(:,2)=F2(:,2)+n1;
% �����Ӻ�������
dham=hamming(B1,B2);
% ����ƥ����
matchpoint=violent_match(dham);

% A�Ĵ洢��ʽ����һ�еڶ��зֱ�Ϊ
% ��һ�š��ڶ���ͼƬ�ĺ�����
% ���������зֱ�Ϊ��һ����ͼ��
% ������
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
fprintf('After match : %0.5f \n',toc)
A=A(1:j-1,:);
A1=A;
A1(:,2)=A1(:,2)-n1;
save('fig1.mat','img1_scale');
save('match.mat','A1');