%% Function to check if collision has occurred between drones
function [collisions, collisionPoints] = checkAndLogCollisions(dronePos, numDrones, collisionHorizontal, collisionVertical, k, t, collisions, collisionPoints)
    % Check pairwise distances and log collisions
    for i = 1:numDrones
        for j = i+1:numDrones
            % Calculate horizontal and vertical distances separately
            horizontalDistance = sqrt((dronePos(i, k, 1) - dronePos(j, k, 1))^2 + (dronePos(i, k, 2) - dronePos(j, k, 2))^2);  % X and Y axes
            verticalDistance = abs(dronePos(i, k, 3) - dronePos(j, k, 3));  % Z axis (altitude)
            
            % Check if both horizontal and vertical distances are within thresholds
            if horizontalDistance < collisionHorizontal && verticalDistance < collisionVertical
                % Record the collision details
                collisions{end+1} = struct('time', t(k), 'drone1', i, 'drone2', j, 'position', dronePos(i, k, :));
                
                % Save the collision point
                collisionPoints = [collisionPoints; dronePos(i, k, :)];
            end
        end
    end
end
