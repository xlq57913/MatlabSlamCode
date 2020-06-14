% 图像处理
% m×3矩阵转换为灰度图，否则返回原图
function img=rgb2image(Img1)
[~,~,d1] = size(Img1);
if(d1==3)
    img = rgb2gray(Img1);
else
    img = Img1;
end