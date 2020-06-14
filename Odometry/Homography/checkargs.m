%-------------------------------------------------------------------------- 
% Function to check argument values and set defaults 
 
function [x1, x2] = checkargs(arg) 
     
    if length(arg) == 2 
	x1 = arg{1}; 
	x2 = arg{2}; 
	if ~all(size(x1)==size(x2)) 
	    error('x1 and x2 must have the same size'); 
	elseif size(x1,1) ~= 3 
	    error('x1 and x2 must be 3xN'); 
	end 
	 
    elseif length(arg) == 1 
	if size(arg{1},1) ~= 6 
	    error('Single argument x must be 6xN'); 
	else 
	    x1 = arg{1}(1:3,:); 
	    x2 = arg{1}(4:6,:); 
	end 
    else 
	error('Wrong number of arguments supplied'); 
    end 
    