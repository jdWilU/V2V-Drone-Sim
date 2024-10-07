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
