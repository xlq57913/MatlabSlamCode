function [x1,x2] =m2D_3D(m1,m2) 
%input     m1  - 2xN or 3xN set of homogeneous points.  If the data is 
%                2xN it is assumed the homogeneous scale factor is 1. 
%          m2  - 2xN or 3xN set of homogeneous points such that x1<->x2. 
%function  x1  - 3xN set of homogeneous points.   
%          x2  - 3xN set of homogeneous points such that x1<->x2.       
 
[rows,npts] = size(m1); 
    if rows~=2 && rows~=3 
        error('x1 and x2 must have 2 or 3 rows'); 
    end 
     
    if rows == 2    % Pad data with homogeneous scale factor of 1 
        x1 = [m1; ones(1,npts)]; 
        x2 = [m2; ones(1,npts)];         
    end