function rebuild  = rebuild(img_l,img_r,m,n)
% Author：Zhonghao Zhang
% rebuild:拼接两张图片，两张图片往往有重合部分，根据角度进行拼接
% 首先进行m,n试验操作：将左图分割为m:n，而右图分割为n:m，讲左
% 、右图分割下来的左、右部分进行拼接
% function rebuild  = rebuild(img_l,img_r,m,n)
%%
 
% rgbimg_l=rgb2image(img_l);
% rgbimg_r=rgb2image(img_r);
rgbimg_l=img_l;
rgbimg_r=img_r;

% doubleimg_l = im2double(rgbimg_l);
% doubleimg_r = im2double(rgbimg_r);
doubleimg_l=rgbimg_l;
doubleimg_r=rgbimg_r;
%获取图像的大小
[M_l, N_l, C_l] = size(doubleimg_l); 
[~, N_r, ~] = size(doubleimg_r); 
%% 尺寸 
n_length_l = fix(N_l*m/(m+n)); 
n_length_r = fix(N_r*n/(m+n)); 
%每张小图的宽
% m_width_l  = N_l;
% m_width_r  = N_r;

%% 

rebuild= zeros(M_l,n_length_l+N_r-n_length_r, C_l); %生成与原图大小的全黑图,用于图像重建

%生成小图
senfig_l = doubleimg_l( :,1 : n_length_l, :); 
senfig_r = doubleimg_r( :,n_length_r+1:end, :); 
%重建原图
rebuild(:,1:n_length_l, :) = senfig_l; 
rebuild(:,n_length_l+1:end, :) = senfig_r; 





% figure(2);imshow(rebuild); title('重建原图')%显示原图
