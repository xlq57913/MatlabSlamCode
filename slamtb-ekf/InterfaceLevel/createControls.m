function Con = createControls(Robot)

% CREATECONTROLS  Create controls structure Con.
%   Con = CREATECONTROLS(ROBOT) generates a control structure Con. This
%   structure depends on the robot's motion model, which contains the
%   fields:
%       .u      nominal value of control
%       .uStd   Standard deviation of control noise
%       .U      Covariances matrix
%
%   The resulting structure needs to be updated during execution time with
%   data from one of these origins:
%       1. read from odometry sensors
%       2. generated by a control software
%       3. generated by the simulator.
%
%   See also CREATEROBOTS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Robot.motion

    case {'constVel'}

        Con.u    = [Robot.dv;deg2rad(Robot.dwDegrees)];
        Con.uStd = [Robot.dvStd;deg2rad(Robot.dwStd)];
        Con.U    = diag(Con.uStd.^2);

    case {'odometry'}

        Con.u    = [Robot.dx;deg2rad(Robot.daDegrees)];
        Con.uStd = [Robot.dxStd;deg2rad(Robot.daStd)];
        Con.U    = diag(Con.uStd.^2);

    otherwise
        error('Unknown motion model %s from robot %d.',Robot.motion,Robot.id);
end



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

