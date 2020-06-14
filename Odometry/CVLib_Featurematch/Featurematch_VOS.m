function [m1_l,m2_l,m1_r,m2_r]=Featurematch_VOS(img1_l,img1_r,img2_l,img2_r)
img1_l=rgb2image(img1_l);
img1_r=rgb2image(img1_r);
img2_l=rgb2image(img2_l);
img2_r=rgb2image(img2_r);
% ×óÍ¼
points1_l = detectHarrisFeatures(img1_l);
points2_l = detectHarrisFeatures(img2_l);
% ÓÒÍ¼
points1_r = detectHarrisFeatures(img1_r);
points2_r = detectHarrisFeatures(img2_r);
% ÌØÕ÷µã
[features1_l,valid_points1_l] = extractFeatures(img1_l,points1_l);
[features2_l,valid_points2_l] = extractFeatures(img2_l,points2_l);
[features1_r,valid_points1_r] = extractFeatures(img1_r,points1_r);
[features2_r,valid_points2_r] = extractFeatures(img2_r,points2_r);
% ÌØÕ÷Æ¥Åä£¬ÕÒ³öÆ¥ÅäÌØÕ÷µã
% ×óÍ¼
indexPairs_l = matchFeatures(features1_l,features2_l);
matchedPoints1_l = valid_points1_l(indexPairs_l(:,1),:);
matchedPoints2_l = valid_points2_l(indexPairs_l(:,2),:);
% ÓÒÍ¼
indexPairs_r = matchFeatures(features1_r,features2_r);
matchedPoints1_r = valid_points1_r(indexPairs_r(:,1),:);
matchedPoints2_r = valid_points2_r(indexPairs_r(:,2),:);
m1_l=matchedPoints1_l;
m2_l=matchedPoints2_l;
m1_r=matchedPoints1_r;
m2_r=matchedPoints2_r;
