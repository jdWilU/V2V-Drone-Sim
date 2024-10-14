function newBezierPath = recalculatePath(currentPos, endPos, timeNormalized, k)
    % recalculatePath generates a new path using a detour control point to avoid collision.
    %
    % Inputs:
    % - currentPos: Current position of the drone [1x3]
    % - endPos: End position of the drone [1x3]
    % - timeNormalized: Normalized time vector for Bézier path calculation
    % - k: Current time step index
    %
    % Outputs:
    % - newBezierPath: New path from the current position to the endpoint [numTimeSteps x 3]

    % Generate a detour control point to avoid collision:
    % Detour control point is generated with random offsets, but you could improve this
    % logic to base the detour on actual collision direction.
    % This control point shifts the drone out of the current straight line path.
    detourControlPoint = currentPos + [rand()*5, rand()*5, rand()*2];  % Random detour offsets
    
    % Extract the time vector for remaining simulation time
    timeVector = timeNormalized(k:end);
    
    % Generate smooth Bézier curve from current position (start), detour (control point), and final destination (end)
    newBezierPath = zeros(length(timeVector), 3);
    for dim = 1:3
        newBezierPath(:, dim) = (1 - timeVector).^2 .* currentPos(dim) + ...
                                2 .* (1 - timeVector) .* timeVector .* detourControlPoint(dim) + ...
                                timeVector.^2 .* endPos(dim);
    end
end
