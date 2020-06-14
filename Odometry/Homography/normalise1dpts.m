% NORMALISE1DPTS - normalises 1D homogeneous points 
% 
% Function translates and normalises a set of 1D homogeneous points  
% so that their centroid is at the origin and their mean distance from  
% the origin is 1.   
% 
% Usage:   [newpts, T] = normalise1dpts(pts) 
% 
% Argument: 
%   pts -  2xN array of 2D homogeneous coordinates 
% 
% Returns: 
%   newpts -  2xN array of transformed 1D homogeneous coordinates 
%   T      -  The 2x2 transformation matrix, newpts = T*pts 
%            
% Note that if one of the points is at infinity no normalisation 
% is possible.  In this case a warning is printed and pts is 
% returned as newpts and T is the identity matrix. 
 
function [newpts, T] = normalise1dpts(pts) 
 
     if ~all(pts(2,:)) 
       warning('Attempt to normalise a point at infinity') 
       newpts = pts; 
       T = eye(2); 
       return; 
     end 
 
     % Ensure homogeneous coords have scale of 1 
     pts(1,:) = pts(1,:)./pts(2,:); 
 
     c = mean(pts(1,:)')';      % Centroid. 
     newp = pts(1,:)-c;         % Shift origin to centroid. 
 
     meandist = mean(abs(newp)); 
     scale = 1/meandist; 
 
     T = [scale    -scale*c 
            0         1      ]; 
 
     newpts = T*pts; 
end