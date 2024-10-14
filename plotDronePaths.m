% plotDronePaths.m
function plotDronePaths(dronePos, bezierPos, startPosArray, endPosArray, collisionPoints, numDrones)
    % Function to plot both Bézier paths and kinematic paths for multiple drones
    % Inputs:
    % - dronePos: The kinematically updated positions of the drones
    % - bezierPos: The original Bézier paths for the drones
    % - startPosArray: Start positions of the drones
    % - endPosArray: End positions of the drones
    % - collisionPoints: Points where collisions occurred
    % - numDrones: Number of drones in the simulation
    
    %% Plot the paths of all drones after the simulation in one figure with three subplots
    figure;  % Open a new figure for the plots

    % First subplot: 3D view
    subplot(1, 3, 1);  % 1 row, 3 columns, 1st plot
    hold on;
    grid on;
    axis equal;
    xlim([-20, 20]);
    ylim([-20, 20]);
    zlim([0, 40]);
    xlabel('X[m]');
    ylabel('Y[m]');
    zlabel('Z[m]');
    title('3D Flight Paths (Bézier and Kinematic)');
    view(3);

       % Plot Bézier paths in dashed lines
    for i = 1:numDrones
        plot3(bezierPos(i, 1), bezierPos(i, 2), bezierPos(i, 3), 'k--', 'LineWidth', 1.5);  % Bézier path in dashed black lines
    end

    % Plot both the original Bézier paths and the kinematic paths
    for i = 1:numDrones
        
        % Actual kinematic path in solid line
        h = plot3(dronePos(i, :, 1), dronePos(i, :, 2), dronePos(i, :, 3), 'LineWidth', 1.5);
        
        % Get the color of the current line for consistent plotting
        lineColor = get(h, 'Color');
        
        % Plot start and end points with the same color as the drone's path
        plot3(startPosArray(i, 1), startPosArray(i, 2), startPosArray(i, 3), 'o', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'Start Points');
        plot3(endPosArray(i, 1), endPosArray(i, 2), endPosArray(i, 3), 's', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'End Points');
    end

    % Highlight the collision points (if any)
    if ~isempty(collisionPoints)
        plot3(collisionPoints(:, 1), collisionPoints(:, 2), collisionPoints(:, 3), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Collisions');
    end

    legend('show');  % Show the legend

    %% Second subplot: Top-down 2D view (x-y plane)
    subplot(1, 3, 2);  % 1 row, 3 columns, 2nd plot
    hold on;
    grid on;
    axis equal;
    xlim([-20, 20]);
    ylim([-20, 20]);
    xlabel('X[m]');
    ylabel('Y[m]');
    title('Top-Down 2D Flight Paths (X-Y)');

    % Plot Bézier paths in dashed lines
    for i = 1:numDrones
        plot(bezierPos(i, :, 1), bezierPos(i, :, 2), 'k--', 'LineWidth', 1.5);  % Bézier path in dashed black lines
    end

    % Plot actual paths in solid lines
    for i = 1:numDrones
        h = plot(dronePos(i, :, 1), dronePos(i, :, 2), 'LineWidth', 1.5);
        lineColor = get(h, 'Color');
        
        % Plot start and end points with the same color as the path
        plot(startPosArray(i, 1), startPosArray(i, 2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'Start Points');
        plot(endPosArray(i, 1), endPosArray(i, 2), 's', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'End Points');
    end

    % Highlight the collision points in the y-z plot (if any)
    if ~isempty(collisionPoints)
        plot(collisionPoints(:, 1), collisionPoints(:, 2), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Collisions');
    end


    legend('show');

    %% Third subplot: Side view 2D plot (Y-Z plane)
    subplot(1, 3, 3);  % 1 row, 3 columns, 3rd plot
    hold on;
    grid on;
    axis equal;

    xlabel('Y[m]');
    ylabel('Z[m]');

    title('Side View 2D Flight Paths (Y-Z)');

    % Plot Bézier paths in dashed lines
    for i = 1:numDrones
        plot(bezierPos(i, :, 2), bezierPos(i, :, 3), 'k--', 'LineWidth', 1.5);  % Bézier path in dashed black lines
    end

    % Plot actual paths in solid lines
    for i = 1:numDrones
        h = plot(dronePos(i, :, 2), dronePos(i, :, 3), 'LineWidth', 1.5);
        lineColor = get(h, 'Color');
        
        % Plot start and end points with the same color as the path
        plot(startPosArray(i, 2), startPosArray(i, 3), 'o', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'Start Points');
        plot(endPosArray(i, 2), endPosArray(i, 3), 's', 'MarkerSize', 8, 'MarkerFaceColor', lineColor, 'MarkerEdgeColor', lineColor, 'DisplayName', 'End Points');
    end

    % Highlight the collision points in the y-z plot (if any)
    if ~isempty(collisionPoints)
        plot(collisionPoints(:, 2), collisionPoints(:, 3), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Collisions');
    end

    axis([-20, 20, 0, 40]);  % Set Y-axis from -20 to 20, and Z-axis from 0 to 40

    legend('show');  % Show the legend
end
