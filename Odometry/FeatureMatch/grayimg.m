function [gray_img1,gray_img2,n]=grayimg(img1,img2)
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
% ��ȡ����ͼƬ��С
    [m1,n1]=size(gray_img1);
    [m2,n2]=size(gray_img2);
    m1 = max(m1,m2);
    n1 = max(n1,n2);
    gray_img1=imresize(gray_img1,[m1,n1]);  
    gray_img2=imresize(gray_img2,[m1,n1]);
    n=n1;
end