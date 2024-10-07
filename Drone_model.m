% Multiple Drone Simulation with Realistic Flight Paths

close all
clear all
clc

%% Number of Drones
numDrones = 4;
collisionRadius = 3;  % Collision radius of 2 meters
collisions = {};  % To store collision data
testNumber = 1;   % Example test number
logFileName = 'flight_log.csv';  % CSV file to store collision logs


% Time and simulation parameters
t = 0:0.03:10;  % simulation time for 10 seconds

% Store drones' positions, yaw, roll, pitch
dronePos = zeros(numDrones, length(t), 3);  % Store [x, y, z] for each drone

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
        dronePos(i, :, j) = generateBezierPath(startPos(j), controlPoint(j), endPos(j), timeNormalized);
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
    [collisions, collisionPoints] = checkAndLogCollisions(dronePos, numDrones, collisionRadius, k, t, collisions, collisionPoints);
end

%% After the simulation, log collision data to a CSV file
header = {'Test Number', 'Number of Vehicles', 'Collision Radius', 'Drone1', 'Drone2', 'Collision Time'};
fileID = fopen(logFileName, 'w');
fprintf(fileID, '%s,%s,%s,%s,%s,%s\n', header{:});
for c = 1:length(collisions)
    fprintf(fileID, '%d,%d,%f,%d,%d,%f\n', testNumber, numDrones, collisionRadius, ...
            collisions{c}.drone1, collisions{c}.drone2, collisions{c}.time);
end
fclose(fileID);


%% Plot flight path information (3D and 2D)
figure;  % Open a new figure for the plots

% First subplot: 3D view
subplot(1, 2, 1);  % 1 row, 2 columns, 1st plot
hold on;
grid on;
axis equal;
xlim([-20, 20]);
ylim([-20, 20]);
zlim([0, 40]);
xlabel('X[m]');
ylabel('Y[m]');
zlabel('Z[m]');
title('3D Flight Paths and Collisions');
view(3);

% Plot each drone's full path in 3D
for i = 1:numDrones
    plot3(dronePos(i, :, 1), dronePos(i, :, 2), dronePos(i, :, 3), 'LineWidth', 1.5);
end

% Highlight the start and end points
plot3(startPosArray(:, 1), startPosArray(:, 2), startPosArray(:, 3), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g', 'DisplayName', 'Start Points');  % Green circles for start points
plot3(endPosArray(:, 1), endPosArray(:, 2), endPosArray(:, 3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'End Points');  % Red circles for end points

% Highlight the collision points (only if there are any)
if ~isempty(collisionPoints)
    plot3(collisionPoints(:, 1), collisionPoints(:, 2), collisionPoints(:, 3), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Collisions');
end

legend('show');  % Show the legend

% Second subplot: Top-down 2D view (ignoring the z-axis)
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd plot
hold on;
grid on;
axis equal;
xlim([-20, 20]);
ylim([-20, 20]);
xlabel('X[m]');
ylabel('Y[m]');
title('Top-Down 2D Flight Paths and Collisions');

% Plot each drone's full path in 2D (top-down view, ignoring z)
for i = 1:numDrones
    plot(dronePos(i, :, 1), dronePos(i, :, 2), 'LineWidth', 1.5);
end

% Highlight the start and end points in the 2D plot
plot(startPosArray(:, 1), startPosArray(:, 2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g', 'DisplayName', 'Start Points');  % Green circles for start points
plot(endPosArray(:, 1), endPosArray(:, 2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'End Points');  % Red circles for end points

% Highlight the collision points in the 2D plot (only if there are any)
if ~isempty(collisionPoints)
    plot(collisionPoints(:, 1), collisionPoints(:, 2), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Collisions');
end

legend('show');  % Show the legend

hold off

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

% Plot trajectories for each drone (precompute future paths)
for i = 1:numDrones
    plot3(dronePos(i, :, 1), dronePos(i, :, 2), dronePos(i, :, 3), 'g--', 'LineWidth', 1.5);  % Dashed green line for the future trajectory
end

% Initialize the drones in the environment
for i = 1:numDrones
    droneTransforms(i) = hgtransform;
    % Call the drone animation function to initialize each drone's plot
    drone_Animation(0, 0, 0, 0, 0, 0, droneTransforms(i));  % Initialize at origin
end

% Simulation loop
for k = 1:length(t)
    for i = 1:numDrones
        % Update drone positions and orientations
        x = dronePos(i, k, 1);
        y = dronePos(i, k, 2);
        z = dronePos(i, k, 3);
        
        % Update drone animation with the current position and orientation
        drone_Animation([x], [y], [z], ...
                        roll(i, k), pitch(i, k), yaw(i, k), droneTransforms(i));
    end
    pause(0.01);  % Simulate real-time updates
end

