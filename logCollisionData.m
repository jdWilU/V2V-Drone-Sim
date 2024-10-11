function logCollisionData(filename, testNumber, numDrones, collisionHorizontal, collisionVertical, collisions, testStartTime, testDuration)
    % logCollisionData logs the collision data to a CSV file, appending data for subsequent tests.
    %
    % Inputs:
    %   - filename: Name of the file to save the log (e.g., 'flight_log.csv')
    %   - testNumber: The current test number
    %   - numDrones: Number of drones involved in the test
    %   - collisionHorizontal: Horizontal collision detection radius
    %   - collisionVertical: Vertical collision detection radius
    %   - collisions: A cell array of collision data, where each cell contains a struct with
    %                 fields 'drone1', 'drone2', and 'time'
    %   - testStartTime: Start time of the test (string)
    %   - testDuration: Total test duration in seconds

    % Determine the file mode based on the test number
    if testNumber == 1
        % If it's the first test, write (or overwrite) the file and include the header
        fileID = fopen(filename, 'w');
        
        % Check if the file opened successfully
        if fileID == -1
            error('Could not open the file %s for writing. Check the file path or permissions.', filename);
        end
        
        % Write the header for the CSV file
        header = {'Test Number', 'Test Start Time', 'Test Duration', 'Number of Vehicles', ...
                  'Horizontal Collision Distance', 'Vertical Collision Distance', ...
                  'Drone1', 'Drone2', 'Collision Time'};
        fprintf(fileID, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n', header{:});
        
    else
        % If it's not the first test, append to the existing file
        fileID = fopen(filename, 'a');
        
        % Check if the file opened successfully
        if fileID == -1
            error('Could not open the file %s for appending. Check the file path or permissions.', filename);
        end
    end

    % Write each collision to the file (test-level and drone-level collision details in each row)
    for c = 1:length(collisions)
        fprintf(fileID, '%d,%s,%f,%d,%f,%f,%d,%d,%f\n', testNumber, testStartTime, testDuration, numDrones, ...
                collisionHorizontal, collisionVertical, collisions{c}.drone1, collisions{c}.drone2, collisions{c}.time);
    end
    
    % Close the file
    fclose(fileID);
end
