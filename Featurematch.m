function [m1_l,m2_l,m1_r,m2_r]=Featurematch(img1_l,img1_r,img2_l,img2_r)
[gray_img_l,n1_l]=grayimg(img1_l,img2_l);
[gray_img_r,n1_r]=grayimg(img1_r,img2_r);

% ��ȡ�������������
[B1_l,F1_l]=ExtractORB(gray_img_l(:,1:n1_l),1000);
[B2_l,F2_l]=ExtractORB(gray_img_l(:,n1_l+1:end),1000);
[B1_r,F1_r]=ExtractORB(gray_img_r(:,1:n1_r),1000);
[B2_r,F2_r]=ExtractORB(gray_img_r(:,n1_r+1:end),1000);
% �ڶ���ͼƬ�������һ��ͼƬ�ϲ���
% % ����������n1����λ
F2_l(:,2)=F2_l(:,2)+n1_l;
F2_r(:,2)=F2_r(:,2)+n1_r;
% �����Ӻ�������
dham_l=hamming(B1_l,B2_l);
dham_r=hamming(B1_r,B2_r);
% ����ƥ����
matchpoint_l=violent_match(dham_l);
matchpoint_r=violent_match(dham_r);
% A�Ĵ洢��ʽ����һ�еڶ��зֱ�Ϊ
% ��һ�š��ڶ���ͼƬ�ĺ�����
% ���������зֱ�Ϊ��һ����ͼ��
% ������
A_l=save_matchpoint(matchpoint_l,F1_l,F2_l);
A_r=save_matchpoint(matchpoint_r,F1_r,F2_r);
m1_l=[A_l(:,1),A_l(:,3)];
m2_l=[A_l(:,2)-n1_l,A_l(:,4)];
m1_r=[A_r(:,1),A_r(:,3)];
m2_r=[A_r(:,2)-n1_r,A_r(:,4)];
