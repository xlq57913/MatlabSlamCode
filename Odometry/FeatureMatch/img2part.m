function senfig  = img2part(img,n)
% SENFIG: divide an image into n×n subimages;
% m_length: length of each subimage
% m_width:  width  of each subimage
%% 
%将图像读取为double类型
% img =imread('0000000009.png');
%  trial
%%
 
rgbimg=rgb2image(img);
doubleimg = im2double(rgbimg); 
%获取图像的大小
[M, N, C] = size(doubleimg); 
%% 尺寸 
%每张小图的长
% n=5;
m_length = M/n; 
%每张小图的宽
m_width  = N/n;
senfig   = {};
%% 
%计数
count = 1; 

rebulid = zeros(M, N, C); %生成与原图大小的全黑图,用于图像重建

% figure(1);

for i = 1:n

    for j = 1:n

        senfig{count} = doubleimg((i-1)*m_length+1 : i*m_length, (j-1)*m_width+1 : j*m_width, :); %生成小图

%         imwrite(senfig{count}, strcat('第',num2str(count), '幅图','.jpg')); %保存每张小图

%         subplot(n,n,count),imshow(senfig{count}),title(['第',num2str(count),'幅图']) %将小图显示在一张图中



        rebuild((i-1)*m_length+1:i*m_length, (j-1)*m_width+1:j*m_width, :) = senfig{count}; %重建原图
        count = count + 1; %计数加一

    end

end

% figure(2);imshow(rebuild); title('重建原图')%显示原图
