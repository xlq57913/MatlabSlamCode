function [img,n]=grayimg(img1,img2)
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
% n1��ͼƬ��ȷ������ص����
gray_img1=imresize(gray_img1,[m1,n1]);
gray_img2=imresize(gray_img2,[m1,n1]);
%�ϲ�ͼ��
img=[gray_img1,gray_img2];