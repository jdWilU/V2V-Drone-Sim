function logTestData(logFileName, testNumber, numDrones, testStartTime, testDuration, collisions, randomPriorities, startPosArray, endPosArray)
    % Calculate the number of collisions
    numCollisions = length(collisions);

    % Convert start and end positions to strings
    startPositionsStr = mat2str(startPosArray);
    endPositionsStr = mat2str(endPosArray);

    % Prepare data to write
    data = {testNumber, numDrones, datestr(testStartTime), testDuration, numCollisions, mat2str(randomPriorities), startPositionsStr, endPositionsStr};

    % Check if the file exists
    fileExists = isfile(logFileName);

    if testNumber == 1

        % If it's the first test, write (or overwrite) the file and include the header
        fileID = fopen(logFileName, 'w');
        
        % Check if the file opened successfully
        if fileID == -1
            error('Could not open the file %s for writing. Check the file path or permissions.', filename);
        end

        header = {'Test Number', 'NumDrones', 'TestStartTime', 'TestDuration', ...
                      'NumCollisions', 'RandomPriorities', ...
                      'StartPositions', 'EndPositions'};
        fprintf(fileID, '%s,%s,%s,%s,%s,%s,%s,%s,\n', header{:});
    

    else

    % Open the file for appending
    fileID = fopen(logFileName, 'a');

        if fileID == -1
            error('Cannot open file: %s', logFileName);
        end

    end

    % Write the data
    fprintf(fileID, '%d,%d,%s,%f,%d,"%s","%s","%s"\n', data{:});

    % Close the file
    fclose(fileID);
end
