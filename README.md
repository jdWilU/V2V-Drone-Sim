# Multi-UAV V2V Collision Mitigation

## Overview
Simple simulation software developed in MATLAB for measuring collision between kinematically modelled UAS platforms. The simulation is to act as a means of evaluating V2V communication and collision mitigation strategies for the completion of EGH400-1. 

![readmeImage](https://github.com/user-attachments/assets/5ab73f6f-7fef-452f-a3d0-8f9d1b06a090) ![dronePlot](https://github.com/user-attachments/assets/aed78d05-0ce3-4544-a7ba-9b2c4c85793e)


## Functionality
#### Initial Conditions
Initial conditions regarding simulation settings are outlined within the main `drone_model.m` file and allow the functionality to alter the following:

```MATLAB
numDrones = 4; % Number of drones to exist within the simulation
collisionRadius = 3;  % Set the distance at which a collision is considered to have occured. (m)
testNumber = 1;   % No for current test being run. Relevant for tracking collision logs
logFileName = 'flight_log.csv';  % CSV file location to store collision logs
t = 0:0.03:10;  % Time and simulation parameters
```

#### Flight Pathing & Motion Parameters
Start and end potions are randomly generated within the pre configured bounds of the simulation plot, along with the single control point.

When run, the simulation generates smooth Bézier curves as flight paths for each drone utilising this control point. 

```MATLAB
generateBezierPath = @(startP, controlP, endP, time) ...
    (1 - time).^2 * startP + 2 * (1 - time) .* time * controlP + time.^2 * endP;
```

This Bézier curve  generates the drone's 3D flight path data, which is stored in the dronePos array.


#### Collision Detection
Collisions are detected by repeatedly computing the euclidean distance between each drone, comparing differences in positional data. When this euclidean distance is less than the specified collisionRadius, a collision is recorded. Relevant information includes time, 

This functionality has been implemented by the `checkAndLogCollisions` function. 

```MATLAB
%% Function to check if collision has occured between drones
function [collisions, collisionPoints] = checkAndLogCollisions(dronePos, numDrones, collisionRadius, k, t, collisions, collisionPoints)
    % Check pairwise distances and log collisions
    for i = 1:numDrones
        for j = i+1:numDrones
            distance = sqrt(sum((dronePos(i, k, :) - dronePos(j, k, :)).^2));  % Euclidean distance
            if distance < collisionRadius
                % Record the collision details
                collisions{end+1} = struct('time', t(k), 'drone1', i, 'drone2', j, 'position', dronePos(i, k, :));
                collisionPoints = [collisionPoints; dronePos(i, k, :)];  % Save collision point
            end
        end
    end
end
```
Once the simulation is complete, collision details (test number, number of drones, collision radius, drones involved, time of collision) is written to the CSV file "flight_log.csv"

## Limitations
It should be noted that the current implementation of this simulation does not capture complex forces regarding the drones dynamics. 

That being simulating drone forces, control inputs, and responses

#### References
Animation Code for the quadcopter is developed and provided by Jitendra Singh  where the 'HGtransform' function is used to animate the trajectory of quadcopter.
Code has been sourced from: https://au.mathworks.com/matlabcentral/fileexchange/97192-quadcopter-model-matlab-code-for-animation (30 March 2024)
