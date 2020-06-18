function [m1_l,m2_l,m1_r,m2_r]=FeatureMatch(img1_l,img1_r,img2_l,img2_r)
[~,~,d] = size(img1_l);
if(d==3)
    gray_img1_l=rgb2gray(img1_l);
    gray_img1_r=rgb2gray(img1_r);
    gray_img2_l=rgb2gray(img2_l);
    gray_img2_r=rgb2gray(img2_r);
else
    gray_img1_l=img1_l;
    gray_img1_r=img1_r;
    gray_img2_l=img2_l;
    gray_img2_r=img2_r;
end
% [gray_img1_l,gray_img2_l]=grayimg(img1_l,img2_l);
% [gray_img1_r,gray_img2_r]=grayimg(img1_r,img2_r);

% 提取特征点和描述子
[B1_l,F1_l]=ExtractORB(gray_img1_l,1250);
[B2_l,F2_l]=ExtractORB(gray_img2_l,1250);
[B1_r,F1_r]=ExtractORB(gray_img1_r,1250);
[B2_r,F2_r]=ExtractORB(gray_img2_r,1250);

% 描述子汉明距离
dham_l=hamming(B1_l,B2_l);
dham_r=hamming(B1_r,B2_r);
dham_1=hamming(B1_l,B1_r);
% dham_2=hamming(B2_l,B2_r);

% 暴力匹配结果
% [matchpoint_l,matchpoint_1]=violent_matchFor3(dham_l,dham_1);
matchpoints = violent_matchFor4(dham_l,dham_1,dham_r);
% [matchpoint_l,matchpoint_1,matchpoint_r,match_d]=violent_matchFor4(dham_l,dham_1,dham_r);
for i = 1:3
    [~,ia,~] = unique(matchpoints(:,i));
    matchpoints = matchpoints(ia,:);
end

% [matchpoint_r]=getMatchPoint(matchpoint_1,dham_r);
% matchpoint_r=violent_match(dham_r);
% matchpoint_1=violent_match(dham_1);
% matchpoint_2=violent_match(dham_2);

% A_l=save_matchpoint(matchpoint_l,F1_l,F2_l);
% A_r=save_matchpoint(matchpoint_r,F1_r,F2_r);
% m1_l=[A_l(:,1),A_l(:,3)];
% m2_l=[A_l(:,2),A_l(:,4)];
% m1_r=[A_r(:,1),A_r(:,3)];
% m2_r=[A_r(:,2),A_r(:,4)];



[n,~] = size(matchpoints);
A=zeros(n,9);
j=0;
for i=1:n
    if(matchpoints(i,1)==-1)
        continue;
    end
    j=j+1;
    origin = matchpoints(i,5);
    A(j,:)=[F1_l(origin,2),F1_l(origin,1),F2_l(matchpoints(i,1),2),F2_l(matchpoints(i,1),1),F1_r(matchpoints(i,2),2),F1_r(matchpoints(i,2),1),F2_r(matchpoints(i,3),2),F2_r(matchpoints(i,3),1),matchpoints(i,4)];
end

A = A(1:j,:);

Err = [abs(A(:,1)-A(:,3))+abs(A(:,2)-A(:,4)) abs(A(:,1)-A(:,5))+abs(A(:,2)-A(:,6)) abs(A(:,1)-A(:,7))+abs(A(:,2)-A(:,8))];
avgDis1 = sum(Err)/j * 1.3;

discrad = 0;
for i = 1:j
    if(i==j-discrad)
        break;
    end
    if(Err(i,1)>avgDis1(1) || Err(i,2)>avgDis1(2) || Err(i,3)>avgDis1(3))
        A(i-discrad,:) = [];
        discrad = discrad+1;
    end
end

j = j-discrad;

if(j>60)
    A = sortrows(A,9);
    A = A(1:60,:);
end

m1_l=A(:,1:2);
m2_l=A(:,3:4);
m1_r=A(:,5:6);
m2_r=A(:,7:8);

