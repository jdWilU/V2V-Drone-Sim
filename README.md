# Multi-UAV V2V Collision Mitigation

## Overview
Simple simulation software developed in MATLAB for modelling collision between kinematically modelled UAS platforms. The simulation is to act as a means of evaluating V2V communication and collision mitigation strategies for the completion of EGH400-1. 

## Functionality
##### Initial Conditions
Initial conditions regarding simulation settings are outlined within the Drone_model.m file and allow the functionality to alter the following:

```MATLAB
numDrones = 4; % Number of drones to exist within the simulation
collisionRadius = 3;  % Set the distance at which a collision is considered to have occured. (m)
testNumber = 1;   % No for current test being run. Relevant for tracking collision logs
logFileName = 'flight_log.csv';  % CSV file location to store collision logs
t = 0:0.03:10;  % Time and simulation parameters
```

##### Flight Pathing
When run, the simulation generates smooth Bézier curves as flight paths for each drone. These curves have been kept relatively simple, using only one control point. 

```MATLAB
generateBezierPath = @(startP, controlP, endP, time) ...
    (1 - time).^2 * startP + 2 * (1 - time) .* time * controlP + time.^2 * endP;
```



## Limitations
It should be noted that the current implementation of this simulation does not capture complex forces regarding the drones dynamics. 

That being simulating drone forces, control inputs, and responses

#### References
Animation Code for the quadcopter is developed and provided by Jitendra Singh  where the 'HGtransform' function is used to animate the trajectory of quadcopter.
Code has been sourced from: https://au.mathworks.com/matlabcentral/fileexchange/97192-quadcopter-model-matlab-code-for-animation (30 March 2024)