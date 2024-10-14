function inAvoidanceRadius = checkAvoidanceRadius(dronePos, k, droneIndex1, droneIndex2, collisionHorizontal, collisionVertical)
    % checkAvoidanceRadius checks if two drones are within the avoidance radius.
    %
    % Inputs:
    % - dronePos: Current positions of all drones [numDrones x numTimeSteps x 3]
    % - k: Current time step index
    % - droneIndex1: Index of the first drone
    % - droneIndex2: Index of the second drone
    % - collisionHorizontal: Horizontal avoidance distance threshold
    % - collisionVertical: Vertical avoidance distance threshold
    %
    % Outputs:
    % - inAvoidanceRadius: Boolean indicating if the two drones are within the avoidance radius.

    % Calculate horizontal and vertical distances between drones
    horizontalDistance = abs(dronePos(droneIndex1, k, 1) - dronePos(droneIndex2, k, 1));  % X-axis distance
    verticalDistance = abs(dronePos(droneIndex1, k, 3) - dronePos(droneIndex2, k, 3));    % Z-axis distance

    % Check if drones are within the avoidance radius
    inAvoidanceRadius = (horizontalDistance <= collisionHorizontal) && (verticalDistance <= collisionVertical);
end
