function R = correctR(c,d)
%ac - 2*1;d-2*1; R*c=d
[TH1,~] = cart2pol(c(1),c(2));
[TH2,~] = cart2pol(d(1),d(2));
theta = TH2-TH1;
% a = c/norm(c);
% b =d/norm(d);
% theta = acos (a'*b /(norm(a)*norm(b)));
R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
end
% clear 
% clc
% c = [230;1200];
% d = [6;1170];
% R = correctR1(c,d)