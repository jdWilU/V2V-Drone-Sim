function logCollisionData(filename, testNumber, numDrones, collisionRadius, collisions)
    % logData logs the collision data to a CSV file.
    % 
    % Inputs:
    %   - filename: Name of the file to save the log (e.g., 'flight_log.csv')
    %   - testNumber: The current test number
    %   - numDrones: Number of drones involved in the test
    %   - collisionRadius: The defined collision detection radius
    %   - collisions: A cell array of collision data, where each cell contains a struct with
    %                 fields 'drone1', 'drone2', and 'time'

    if testNumber == 1
        fileID = fopen(filename, "w");

        % Check if the file opened successfully
        if fileID == -1
            error('Could not open the file %s for writing. Check the file path or permissions.', filename);
        end
        
        % Write the header for the CSV file
        header = {'Test Number', 'Number of Vehicles', 'Collision Radius', 'Drone1', 'Drone2', 'Collision Time'};
        fprintf(fileID, '%s,%s,%s,%s,%s,%s\n', header{:});
    else
        % If it's not the first test, append to the existing file
        fileID = fopen(filename, 'a');
        
        % Check if the file opened successfully
        if fileID == -1
            error('Could not open the file %s for appending. Check the file path or permissions.', filename);
        end
    end

    % Write each collision to the file
    for c = 1:length(collisions)
        fprintf(fileID, '%d,%d,%f,%d,%d,%f\n', testNumber, numDrones, collisionRadius, ...
                collisions{c}.drone1, collisions{c}.drone2, collisions{c}.time);
    end
    
    % Close the file
    fclose(fileID);
end
