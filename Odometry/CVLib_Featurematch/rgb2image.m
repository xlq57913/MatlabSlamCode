% ͼ����
% m��3����ת��Ϊ�Ҷ�ͼ�����򷵻�ԭͼ
function img=rgb2image(Img1)
[~,~,d1] = size(Img1);
if(d1==3)
    img = rgb2gray(Img1);
else
    img = Img1;
end