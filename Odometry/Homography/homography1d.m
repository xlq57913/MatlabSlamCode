% HOMOGRAPHY1D - computes 1D homography 
% 
% Usage:   H = homography1d(x1, x2) 
% 
% Arguments: 
%          x1  - 2xN set of homogeneous points 
%          x2  - 2xN set of homogeneous points such that x1<->x2 
% Returns: 
%          H - the 2x2 homography such that x2 = H*x1 
% 
% This code is modelled after the normalised direct linear transformation 
% algorithm for the 2D homography given by Hartley and Zisserman p92. 
% 
 
% Peter Kovesi 
% School of Computer Science & Software Engineering 
% The University of Western Australia 
% pk @ csse uwa edu au 
% http://www.csse.uwa.edu.au/~pk 
% 
% May 2003 
 
function H = homography1d(x1, x2) 
 
  % check matrix sizes 
  if ~all(size(x1) == size(x2)) 
    error('x1 and x2 must have same dimensions'); 
  end 
   
  % Attempt to normalise each set of points so that the origin  
  % is at centroid and mean distance from origin is 1. 
  [x1, T1] = normalise1dpts(x1); 
  [x2, T2] = normalise1dpts(x2); 
 
  % Note that it may have not been possible to normalise 
  % the points if one was at infinity so the following does not 
  % assume that scale parameter w = 1. 
 
  Npts = length(x1); 
  A = zeros(2*Npts,4); 
 
  for n = 1:Npts 
    X = x1(:,n)'; 
    x = x2(1,n);  w = x2(2,n); 
    A(n,:) = [-w*X x*X]; 
  end 
 
  [U,D,V] = svd(A); 
 
  % Extract homography 
  H = reshape(V(:,4),2,2)'; 
 
  % Denormalise 
  H = T2\H*T1; 
 
  % Report error in fitting homography... 
 
