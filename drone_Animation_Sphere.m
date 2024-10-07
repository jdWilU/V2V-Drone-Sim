%% Display animation function. Drone represented by Sphere

function drone_Animation_Sphere(x, y, z, roll, pitch, yaw, combinedobject)
    % This Animation code represents the drone as a small black sphere.
    
    %% Define constants
    D2R = pi/180;   % Degrees to radians
    
    %% Create the black sphere representing the drone
    [sx, sy, sz] = sphere(20);  % Create a unit sphere with 20 grid points
    
    % Scale the sphere to make it small
    sphere_radius = 0.5;  % Set a small radius for the drone sphere
    
    % Create the sphere and set its color to black
    droneSphere = surf(sphere_radius * sx, sphere_radius * sy, sphere_radius * sz, ...
        'FaceColor', 'black', 'EdgeColor', 'none', 'Parent', combinedobject);  % Black sphere representing the drone
    
    hold on;

    %% Animation - update transformations for the sphere
    for i = 1:length(x)
        % Translation to update position
        translation = makehgtform('translate', [x(i), y(i), z(i)]);
        
        % Apply orientation changes with yaw, pitch, and roll
        rotation1 = makehgtform('xrotate', roll(i) * D2R);
        rotation2 = makehgtform('yrotate', pitch(i) * D2R);
        rotation3 = makehgtform('zrotate', yaw(i) * D2R);
        
        % Apply transformations (position + orientation)
        set(combinedobject, 'matrix', translation * rotation3 * rotation2 * rotation1);
        
        % Render the scene
        drawnow;
        pause(0.02);  % Pause to simulate real-time updates
    end
end
