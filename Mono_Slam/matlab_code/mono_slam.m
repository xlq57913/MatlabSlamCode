%-----------------------------------------------------------------------
% 1-point RANSAC EKF SLAM from a monocular sequence
%-----------------------------------------------------------------------

% Copyright (C) 2010 Javier Civera and J. M. M. Montiel
% Universidad de Zaragoza, Zaragoza, Spain.

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation. Read http://www.gnu.org/copyleft/gpl.html for details

% If you use this code for academic work, please reference:
%   Javier Civera, Oscar G. Grasa, Andrew J. Davison, J. M. M. Montiel,
%   1-Point RANSAC for EKF Filtering: Application to Real-Time Structure from Motion and Visual Odometry,
%   to appear in Journal of Field Robotics, October 2010.

%-----------------------------------------------------------------------
% Authors:  Javier Civera -- jcivera@unizar.es 
%           J. M. M. Montiel -- josemari@unizar.es

% Robotics, Perception and Real Time Group
% Aragón Institute of Engineering Research (I3A)
% Universidad de Zaragoza, 50018, Zaragoza, Spain
% Date   :  May 2010
%-----------------------------------------------------------------------

clear variables; close all; clc;
rand('state',0); % rand('state',sum(100*clock));

%-----------------------------------------------------------------------
% Sequence, camera and filter tuning parameters, variable initialization
%-----------------------------------------------------------------------

% Sequence path and initial image
sequencePath_r = '../sequences/RightCamera/data/000000';
sequencePath_l = '../sequences/LeftCamera/data/000000';
initIm = 0;
lastIm = 100;

im_r = takeImage( sequencePath_l,sequencePath_r, initIm );
% [colums,rows]=size(im_r);

% Camera calibration
cam = initialize_cam;

% Set plot windows
set_plots;

% Initialize state vector and covariance
[x_k_k, p_k_k] = initialize_x_and_p;

% Initialize EKF filter
sigma_a = 0.007; % standar deviation for linear acceleration noise
sigma_alpha = 0.007; % standar deviation for angular acceleration noise
sigma_image_noise = 1.0; % standar deviation for measurement noise
% filter_l = ekf_filter( x_k_k, p_k_k, sigma_a, sigma_alpha, sigma_image_noise, 'constant_velocity' );
filter_r = ekf_filter( x_k_k, p_k_k, sigma_a, sigma_alpha, sigma_image_noise, 'constant_velocity' );

% variables initialization
% features_info_l = [];
features_info_r = [];
trajectory = zeros( 7, lastIm - initIm );
% other
min_number_of_features_in_image = 25;
generate_random_6D_sphere;
measurements = []; predicted_measurements = [];

%---------------------------------------------------------------
% Main loop
%---------------------------------------------------------------
% im_l = takeImage( sequencePath_l, initIm );




for step=initIm+1:lastIm
    
    % Map management (adding and deleting features; and converting inverse depth to Euclidean)
%     [ filter_l, features_info_l ] = map_management( filter_l, features_info_l, cam, im_l, min_number_of_features_in_image, step );
    [ filter_r, features_info_r ] = map_management( filter_r, features_info_r, cam, im_r, min_number_of_features_in_image, step );

    % EKF prediction (state and measurement prediction)
%     [ filter_l, features_info_l ] = ekf_prediction( filter_l, features_info_l );
    [ filter_r, features_info_r ] = ekf_prediction( filter_r, features_info_r );
    
    % Grab image
%     im_l = takeImage( sequencePath_l, step );
    im_r = takeImage( sequencePath_l,sequencePath_r, step );
    
    % Search for individually compatible matches
%     features_info_l = search_IC_matches( filter_l, features_info_l, cam, im_r );
    features_info_r = search_IC_matches( filter_r, features_info_r, cam, im_r );
    
    % 1-Point RANSAC hypothesis and selection of low-innovation inliers
%     features_info_l = ransac_hypotheses( filter_l, features_info_l, cam ); 
    features_info_r = ransac_hypotheses( filter_r, features_info_r, cam );
    
    % Partial update using low-innovation inliers
%     filter_l = ekf_update_li_inliers( filter_l, features_info_l );
    filter_r = ekf_update_li_inliers( filter_r, features_info_r );
    
    % "Rescue" high-innovation inliers
%     features_info_l = rescue_hi_inliers( filter_l, features_info_l, cam );
    features_info_r = rescue_hi_inliers( filter_r, features_info_r, cam );
    
    % Partial update using high-innovation inliers
%     filter_l = ekf_update_hi_inliers( filter_l, features_info_l );
    filter_r = ekf_update_hi_inliers( filter_r, features_info_r );

    % Plots,
    plots; display( step );
    
    % Save images
    % saveas( figure_all, sprintf( '%s/image%04d.fig', directory_storage_name, step ), 'fig' );

end

% Mount a video from saved Matlab figures
% fig2avi;