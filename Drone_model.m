% JITENDRA SINGH
% India 
% this code written for making the animation of Quadcoptor model, all units
% are in meters, in this code of example we are using 'HGtransform'
% function for animate the trajectory of quadcopter
% {Thanks to MATLAB}
close all
clear all
clc
 
 %% 1. define the motion coordinates 
 % roll , pitch and yaw input in degree 
 
% Modify the frequency for a faster or slower rotation
frq = 0.5;  % Adjust frequency to control yaw rate
frq_rp = 4 * frq;  % Roll and pitch frequency

% Define the motion coordinates
% Adjust trajectory and motion coordinates
t = 0:0.03:10;   % simulation time for 10 seconds
z = t;           % Adjusted z motion
y = 4 * sin(2 * pi * frq * t);   % Increased radius for larger trajectory
x = 4 * cos(2 * pi * frq * t);   % Increased radius for larger tra

% Adjust the yaw, roll, and pitch
yaw = (2 * pi * frq * t) * (180 / pi);  % Full rotation during simulation
roll = 5 * sin(2 * pi * frq_rp * t);    % Increased roll angle
pitch = 5 * cos(2 * pi * frq_rp * t);   % Increased pitch angle


 %% 6. animate by using the function makehgtform
 % Function for ANimation of QuadCopter
  drone_Animation(x,y,z,roll,pitch,yaw)
 
 
 %% step5: Save the movie
%myWriter = VideoWriter('drone_animation', 'Motion JPEG AVI');
% myWriter = VideoWriter('drone_animation1', 'MPEG-4');
% myWriter.Quality = 100;
% myWritter.FrameRate = 120;
% 
% % Open the VideoWriter object, write the movie, and class the file
% open(myWriter);
% writeVideo(myWriter, movieVector);
% close(myWriter); 