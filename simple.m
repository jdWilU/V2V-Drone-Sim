% Number of drones
numDrones = 5;

% Simulation time
totalTime = 10; % seconds
dt = 0.1; % time step

% Environment limits
xLimits = [-10, 10];
yLimits = [-10, 10];
zLimits = [0, 10];

% Initialize drone positions and velocities
dronePos = rand(numDrones, 3) .* [xLimits(2) - xLimits(1), yLimits(2) - yLimits(1), zLimits(2) - zLimits(1)] + [xLimits(1), yLimits(1), zLimits(1)];
droneVel = rand(numDrones, 3) * 10 - 5; % Random velocities for now

% Initialize roll, pitch, and yaw for each drone
roll = zeros(numDrones, 1);
pitch = zeros(numDrones, 1);
yaw = zeros(numDrones, 1);

% Create figure and hold it for plotting all drones
figure;
hold on;
axis equal;
xlim(xLimits);
ylim(yLimits);
zlim(zLimits);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Drone Flight Simulation with Multiple Drones');

% Create transformation objects for each drone
droneTransforms = gobjects(numDrones, 1);

for i = 1:numDrones
    % Initialize hgtransform object for each drone
    droneTransforms(i) = hgtransform;
    
    % Create the drone model and associate it with hgtransform
    drone_Animation(0, 0, 0, 0, 0, 0, droneTransforms(i)); % Initial position at origin
end

% Simulation loop
for t = 0:dt:totalTime
    % Update drone positions based on velocity
    dronePos = dronePos + droneVel * dt;
    
    % Example update for roll, pitch, and yaw (random changes)
    roll = roll + randn(numDrones, 1) * dt * 10; % Random small changes
    pitch = pitch + randn(numDrones, 1) * dt * 10;
    yaw = yaw + randn(numDrones, 1) * dt * 10;
    
    % Animate each drone using the drone_Animation function
    for i = 1:numDrones
        drone_Animation(dronePos(i, 1), dronePos(i, 2), dronePos(i, 3), roll(i), pitch(i), yaw(i), droneTransforms(i));
    end
    
    % Pause to simulate real-time
    pause(dt);
end
