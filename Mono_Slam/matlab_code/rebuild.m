function rebuild  = rebuild(img_l,img_r,m,n)
% Author��Zhonghao Zhang
% rebuild:ƴ������ͼƬ������ͼƬ�������غϲ��֣����ݽǶȽ���ƴ��
% ���Ƚ���m,n�������������ͼ�ָ�Ϊm:n������ͼ�ָ�Ϊn:m������
% ����ͼ�ָ����������Ҳ��ֽ���ƴ��
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
%��ȡͼ��Ĵ�С
[M_l, N_l, C_l] = size(doubleimg_l); 
[~, N_r, ~] = size(doubleimg_r); 
%% �ߴ� 
n_length_l = fix(N_l*m/(m+n)); 
n_length_r = fix(N_r*n/(m+n)); 
%ÿ��Сͼ�Ŀ�
% m_width_l  = N_l;
% m_width_r  = N_r;

%% 

rebuild= zeros(M_l,n_length_l+N_r-n_length_r, C_l); %������ԭͼ��С��ȫ��ͼ,����ͼ���ؽ�

%����Сͼ
senfig_l = doubleimg_l( :,1 : n_length_l, :); 
senfig_r = doubleimg_r( :,n_length_r+1:end, :); 
%�ؽ�ԭͼ
rebuild(:,1:n_length_l, :) = senfig_l; 
rebuild(:,n_length_l+1:end, :) = senfig_r; 





% figure(2);imshow(rebuild); title('�ؽ�ԭͼ')%��ʾԭͼ
