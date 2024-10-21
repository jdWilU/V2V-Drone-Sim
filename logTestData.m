function logTestData(logFileName, testNumber, numDrones, testStartTime, testDuration, collisions, randomPriorities)
    % logTestData logs important information about each test to a CSV file.
    %
    % Parameters:
    %   logFileName      - The name of the CSV file to store test data.
    %   testNumber       - The current test number.
    %   numDrones        - The number of drones used in the simulation.
    %   testStartTime    - The datetime when the test started.
    %   testDuration     - The duration of the test in seconds.
    %   collisions       - A cell array containing collision data.
    %   randomPriorities - An array of the randomly assigned priorities for each drone.
    %
    % The function appends a new line to the specified CSV file with the collected data.

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
