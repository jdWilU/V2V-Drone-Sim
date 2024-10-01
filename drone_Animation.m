function animation = drone_Animation(x, y, z, roll, pitch, yaw)
    % This Animation code is for QuadCopter. Written by Jitendra Singh 
    
    %% Define design parameters (scaled by 4)
    D2R = pi/180;
    R2D = 180/pi;
    b   = 2.4;   % (4x) the length of total square cover by whole body of quadcopter in meters
    a   = b/3;   % the length of small square base of quadcopter
    H   = 0.24;  % (4x) height of drone in Z direction (24cm)
    H_m = H + H/2; % (4x) height of motor in z direction (30 cm)
    r_p = b/4;   % (4x) radius of propeller

    %% Conversions
    ro = 45*D2R;  % angle by which to rotate the base of quadcopter
    Ri = [cos(ro) -sin(ro) 0;
          sin(ro) cos(ro)  0;
           0       0       1];  % rotation matrix to rotate the coordinates of base 
    base_co = [-a/2  a/2 a/2 -a/2;
               -a/2 -a/2 a/2 a/2;
                 0    0   0   0];
    base = Ri * base_co;  % rotate base coordinates by 45 degrees

    to = linspace(0, 2*pi);
    xp = r_p * cos(to);
    yp = r_p * sin(to);
    zp = zeros(1, length(to));

    %% Define Figure plot
    fig1 = figure('pos', [0 50 800 600]);
    hg   = gca;
    view(68, 53);
    grid on;
    axis equal;
    
    % Expanded plot limits to accommodate larger drone and sphere
    xlim([-10, 10]);  % 4x the previous range
    ylim([-10, 10]);  % 4x the previous range
    zlim([0, 20]);  % 4x the previous range
    
    title('(JITENDRA) Scaled Drone Animation with Proximity Sphere')
    xlabel('X[m]');
    ylabel('Y[m]');
    zlabel('Z[m]');
    hold(gca, 'on');

    %% Design Different parts (scaled)
    % Design the base square
    drone(1) = patch([base(1, :)], [base(2, :)], [base(3, :)], 'r');
    drone(2) = patch([base(1, :)], [base(2, :)], [base(3, :) + H], 'r');
    alpha(drone(1:2), 0.7);
    
    % Design 2 perpendicular legs of quadcopter
    [xcylinder, ycylinder, zcylinder] = cylinder([H/2 H/2]);
    drone(3) = surface(b*zcylinder - b/2, ycylinder, xcylinder + H/2, 'facecolor', 'b');
    drone(4) = surface(ycylinder, b*zcylinder - b/2, xcylinder + H/2, 'facecolor', 'b');
    alpha(drone(3:4), 0.6);
    
    % Design 4 cylindrical motors
    drone(5) = surface(xcylinder + b/2, ycylinder, H_m*zcylinder + H/2, 'facecolor', 'r');
    drone(6) = surface(xcylinder - b/2, ycylinder, H_m*zcylinder + H/2, 'facecolor', 'r');
    drone(7) = surface(xcylinder, ycylinder + b/2, H_m*zcylinder + H/2, 'facecolor', 'r');
    drone(8) = surface(xcylinder, ycylinder - b/2, H_m*zcylinder + H/2, 'facecolor', 'r');
    alpha(drone(5:8), 0.7);
    
    % Design 4 propellers
    drone(9)  = patch(xp + b/2, yp, zp + (H_m + H/2), 'c', 'LineWidth', 0.5);
    drone(10) = patch(xp - b/2, yp, zp + (H_m + H/2), 'c', 'LineWidth', 0.5);
    drone(11) = patch(xp, yp + b/2, zp + (H_m + H/2), 'p', 'LineWidth', 0.5);
    drone(12) = patch(xp, yp - b/2, zp + (H_m + H/2), 'p', 'LineWidth', 0.5);
    alpha(drone(9:12), 0.3);

    %% Create a light blue sphere around the drone
    [sx, sy, sz] = sphere(20);  % Create a unit sphere
    sphere_radius = 4;  % Radius of 4 meters
    sphereSurface = surf(sphere_radius * sx, sphere_radius * sy, sphere_radius * sz, ...
        'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.2);  % Light blue and transparent
    hold on;

    %% Create a group object and parent surface
    combinedobject = hgtransform('parent', hg);
    set(drone, 'parent', combinedobject);
    set(sphereSurface, 'parent', combinedobject);  % Attach the sphere to follow the drone's movement

    %% Animation
    for i = 1:length(x)
        ba = plot3(x(1:i), y(1:i), z(1:i), 'b:', 'LineWidth', 1.5);
        
        translation = makehgtform('translate', [x(i), y(i), z(i)]);
        rotation1 = makehgtform('xrotate', (pi/180) * (roll(i)));
        rotation2 = makehgtform('yrotate', (pi/180) * (pitch(i)));
        rotation3 = makehgtform('zrotate', (pi/180) * yaw(i));
        
        set(combinedobject, 'matrix', translation * rotation3 * rotation2 * rotation1);
        drawnow;
        pause(0.02);
    end
end
