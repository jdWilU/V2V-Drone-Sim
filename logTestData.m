function logTestData(logFileName, testNumber, numDrones, testStartTime, testDuration, collisions, randomPriorities, startPosArray, endPosArray)
    % Additional parameters: startPosArray, endPosArray

    % ... (existing code)

    % Convert start and end positions to strings
    startPositionsStr = mat2str(startPosArray);
    endPositionsStr = mat2str(endPosArray);

    % Update data and header
    data = {testNumber, numDrones, datestr(testStartTime), testDuration, numCollisions, mat2str(randomPriorities), startPositionsStr, endPositionsStr};
    % Update header accordingly
    if ~fileExists
        fprintf(fid, 'TestNumber,NumDrones,TestStartTime,TestDuration,NumCollisions,RandomPriorities,StartPositions,EndPositions\n');
    end

    % Update fprintf format string
    fprintf(fid, '%d,%d,%s,%f,%d,"%s","%s","%s"\n', data{:});

    % Collect important information about the test and write to a CSV file

    % Calculate the number of collisions
    numCollisions = length(collisions);

    % Prepare data to write
    data = {testNumber, numDrones, datestr(testStartTime), testDuration, numCollisions, mat2str(randomPriorities)};

    % Check if the file exists
    fileExists = isfile(logFileName);

    % Open the file for appending
    fid = fopen(logFileName, 'a');

    if fid == -1
        error('Cannot open file: %s', logFileName);
    end

    % If the file doesn't exist, write the header
    if ~fileExists
        fprintf(fid, 'TestNumber,NumDrones,TestStartTime,TestDuration,NumCollisions,RandomPriorities\n');
    end

    % Write the data
    fprintf(fid, '%d,%d,%s,%f,%d,"%s"\n', data{:});

    % Close the file
    fclose(fid);
end
