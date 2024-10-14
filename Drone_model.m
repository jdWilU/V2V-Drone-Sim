% Multiple Drone Simulation with Realistic Flight Paths

close all
clear all
clc

%% Preamble parameter settings
numDrones = 4; % Number of drones in simulation

% NMAC Proxy Separation Guidelines (Andrew Weinert)
% Typical separation dictates 500ft separation horizontal, 100ft vertical
collisionVertical = 1; % Collision height (factor of 1)
collisionHorizontal = 5; % Collision horizontal (factor of 5)
collisions = {};  % To store collision data

testNumber = 1;   % Example test number
logFileName = 'flight_log.csv';  % CSV file to store collision logs

% Time and simulation parameters
t = 0:1:120;  % simulation time for 60 seconds

testStartTime = datetime("now");  % Capture the current time
testDuration = max(t);  % The total time the simulation ran for

%Priority setting of drones
% Create an array of priority values
priorityValues = 1:numDrones;

% Randomly shuffle the priority values
randomPriorities = priorityValues(randperm(numDrones));

% Initial velocities and acceleration (randomized for each drone)
velocity = rand(numDrones, 3) * 2 - 1;  % Initial velocity for each drone (random direction)
acceleration = rand(numDrones, 3) * 0.1 - 0.05;  % Small acceleration for each drone

% Time step for kinematic updates
deltaT = 0.25;  % .1 second time step


%% Positional Setting
% Store drones' positions, yaw, roll, pitch
dronePos = zeros(numDrones, length(t), 3);  % Store [x, y, z] for each drone

%Store orignal bezier curve paths for plotting/comparison
bezierPos = zeros(numDrones, length(t), 3);


startPosArray = zeros(numDrones, 3);  % Store start positions for plotting
endPosArray = zeros(numDrones, 3);    % Store end positions for plotting
collisionPoints = [];  % To store collision points

yaw = zeros(numDrones, length(t));
roll = zeros(numDrones, length(t));
pitch = zeros(numDrones, length(t));

% Function to generate smooth Bézier curve for the flight path
generateBezierPath = @(startP, controlP, endP, time) ...
    (1 - time).^2 * startP + 2 * (1 - time) .* time * controlP + time.^2 * endP;

% Motion parameters for each drone
for i = 1:numDrones
    % Generate random start and end positions
    startPos = [-20 + 40 * rand(), -20 + 40 * rand(), 5 + 30 * rand()];  % Start position in x, y from -20 to 20
    endPos = [-20 + 40 * rand(), -20 + 40 * rand(), 5 + 30 * rand()];    % End position in x, y from -20 to 20

    % Store start and end positions for later plotting
    startPosArray(i, :) = startPos;
    endPosArray(i, :) = endPos;
    
    % Generate a control point for a smooth trajectory
    controlPoint = [-20 + 40 * rand(), -20 + 40 * rand(), 15 * rand() + 10];  % Control point in x, y from -20 to 20


    % Generate smooth path using Bézier curve
    timeNormalized = linspace(0, 1, length(t));
    for j = 1:3
        bezierPos(i, :, j) = generateBezierPath(startPos(j), controlPoint(j), endPos(j), timeNormalized);  % Bézier path (Original Path)
        dronePos(i, :, j) = generateBezierPath(startPos(j), controlPoint(j), endPos(j), timeNormalized); % Drone Path (Taken Path
    end
    
    % Compute yaw angle (heading) based on consecutive x and y positions
    dx = diff(dronePos(i, :, 1));  % Change in x
    dy = diff(dronePos(i, :, 2));  % Change in y
    yaw(i, 1:end-1) = atan2(dy, dx) * (180 / pi);  % Compute yaw in degrees
    yaw(i, end) = yaw(i, end-1);  % To avoid index size mismatch, repeat last yaw
    
    % Adjust the roll and pitch for a more realistic orientation
    roll(i, :) = 5 * sin(2 * pi * 0.5 * t);  % Simulate some roll angle changes
    pitch(i, :) = 5 * cos(2 * pi * 0.5 * t); % Simulate some pitch angle changes
end





%% Simulation loop with collision detection
for k = 1:length(t)
    % Check for collisions at each time step
    [collisions, collisionPoints] = checkAndLogCollisions(dronePos, numDrones, collisionHorizontal, collisionVertical, k, t, collisions, collisionPoints);
end

%% Initialize the drones in the environment
figure;
hold on;
axis equal;
xlim([-20, 20]);
ylim([-20, 20]);
zlim([0, 40]);
xlabel('X[m]');
ylabel('Y[m]');
zlabel('Z[m]');
title('Multiple Drone Simulation with Realistic Flight Paths');
view(3);
grid on;

% Create transformation objects for each drone
droneTransforms = gobjects(numDrones, 1);


for i = 1:numDrones
    % Plot start and end points with the same color as the drone's path
    % Get the color of the current line for consistent plotting

    % Plot trajectories for each drone (precompute future paths)
    h = plot3(dronePos(i, :, 1), dronePos(i, :, 2), dronePos(i, :, 3), "--", 'LineWidth', 1.5);  % Dashed line for the future trajectory

    lineColor = get(h, 'Color');

    plot3(startPosArray(i, 1), startPosArray(i, 2), startPosArray(i, 3), 'o', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'Start Points');
    plot3(endPosArray(i, 1), endPosArray(i, 2), endPosArray(i, 3), 's', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'End Points');
end


% Initialize the drones in the environment
for i = 1:numDrones
    droneTransforms(i) = hgtransform;
    % Call the drone animation function to initialize each drone's plot
    drone_Animation(0, 0, 0, 0, 0, 0, droneTransforms(i));  % Initialize at origin
end

for k = 1:length(t)-1  % Adjust loop to avoid index overflow
    for i = 1:numDrones
        for j = i+1:numDrones
            % Check if drones i and j are within the avoidance radius
            inAvoidance = checkAvoidanceRadius(dronePos, k, i, j, 6, 2);

            if inAvoidance
                % Determine which drone has lower priority and should alter its path
                if randomPriorities(i) > randomPriorities(j)
                    % Drone i has lower priority, so it should alter its path
                    currentPos = squeeze(dronePos(i, k, :));  % Current position of drone i
                    endPos = endPosArray(i, :);  % End position of drone i
                    
                    % Recalculate the new Bézier path for drone i
                    newBezierPath = recalculatePath(currentPos, endPos, timeNormalized, k);

                    % Update the drone's path from time step k+1 onwards
                    numRemainingSteps = length(t) - k;
                    newBezierPath = newBezierPath(1:numRemainingSteps, :);
                    dronePos(i, k+1:end, :) = newBezierPath;

                elseif randomPriorities(j) > randomPriorities(i)
                    % Drone j has lower priority, so it should alter its path
                    currentPos = squeeze(dronePos(j, k, :));  % Current position of drone j
                    endPos = endPosArray(j, :);  % End position of drone j
                    
                    % Recalculate the new Bézier path for drone j
                    newBezierPath = recalculatePath(currentPos, endPos, timeNormalized, k);

                    % Update the drone's path from time step k+1 onwards
                    numRemainingSteps = length(t) - k;
                    newBezierPath = newBezierPath(1:numRemainingSteps, :);
                    dronePos(j, k+1:end, :) = newBezierPath;
                end
            end
        end
    end

    % Continue with regular position update for each drone
    for i = 1:numDrones
        % Get the desired position from the Bézier path at the next time step
        desiredPos = squeeze(dronePos(i, k+1, :));  % Bézier position at the next time step
        
        % Calculate the direction to the next point on the Bézier path
        currentPos = squeeze(dronePos(i, k, :));  % Current position
        direction = desiredPos - currentPos;  % Direction to the next Bézier point
        
        % Normalize the direction and set a constant speed toward the target
        if norm(direction) ~= 0  % Ensure we don't divide by zero
            direction = direction / norm(direction);  % Normalize the direction
        end
        
        speed = 2;  % You can adjust this speed factor
        
        % Update position by moving towards the next Bézier point
        newPos = currentPos + direction * speed * deltaT;

        % Store the updated position for the next step
        dronePos(i, k+1, :) = newPos;

        % Compute yaw angle based on the direction of movement
        dx = newPos(1) - currentPos(1);  % Change in x
        dy = newPos(2) - currentPos(2);  % Change in y
        yaw(i, k) = atan2(dy, dx) * (180 / pi);  % Compute yaw in degrees

        % Update drone animation with the current position and orientation
        drone_Animation(newPos(1), newPos(2), newPos(3), ...
                        roll(i, k), pitch(i, k), yaw(i, k), droneTransforms(i));
    end

    pause(0.01);  % Simulate real-time updates
end


%% After the simulation, plot the paths
plotDronePaths(dronePos, bezierPos, startPosArray, endPosArray, collisionPoints, numDrones, randomPriorities);



%% After the simulation, log data to different CSV files

%Collect all flight data


%Collect Collision Data
logCollisionData('flight_log.csv', testNumber, numDrones, collisionHorizontal, collisionVertical, collisions, testStartTime, testDuration);
