%% Appropriately resize bus signals used in the Simulink model, based on the number of UAVs
dictObj = Simulink.data.dictionary.open('formationFlightSimulationData.sldd');
dataSectObj = getSection(dictObj,'Design Data');

stateObj = getEntry(dataSectObj,'MultiFixedWingStateBus');
stateBus = stateObj.getValue;

for i=1:numel(stateBus.Elements)
    stateBus.Elements(i).Dimensions = [numUAVs 1];
end

stateObj.setValue(stateBus);

controlObj = getEntry(dataSectObj,'MultiFixedWingControlBus');
controlBus = controlObj.getValue;

for i=1:numel(controlBus.Elements)
    controlBus.Elements(i).Dimensions = [numUAVs 1];
end

controlObj.setValue(controlBus);

envObj = getEntry(dataSectObj,'MultiFixedWingEnvironmentBus');
envBus = envObj.getValue;

for i=1:numel(envBus.Elements)
    envBus.Elements(i).Dimensions = [numUAVs 1];
end

envObj.setValue(envBus);

dictObj.saveChanges;

dictObj.close;

%% Define the initial state of the UAVs as a column array

initialState = zeros(numUAVs*8,1);

north = [0; 10; 20; 10; 0];
east = [-20; -10; 0; 10; 20];
height = [0; 0; 0; 0; 0];
airSpeed = [0; 0; 0; 0; 0];
headingAngle = [0; 0; 0; 0; 0];
flightPathAngle = [0; 0; 0; 0; 0];
rollAngle = [0; 0; 0; 0; 0];
rollAngleRate = [0; 0; 0; 0; 0];

for i=1:numUAVs
    initialState((i-1)*8 + 1) = north(i);
    initialState((i-1)*8 + 2) = east(i);
    initialState((i-1)*8 + 3) = height(i);
    initialState((i-1)*8 + 4) = airSpeed(i);
    initialState((i-1)*8 + 5) = headingAngle(i);
    initialState((i-1)*8 + 6) = flightPathAngle(i);
    initialState((i-1)*8 + 7) = rollAngle(i);
    initialState((i-1)*8 + 8) = rollAngleRate(i);
end

%% Define configuration Properties of the UAVs

PHeight = [3.9; 3.9; 3.9; 3.9; 3.9];
PDRoll = [3403,116.67; 3403,116.67; 3403,116.67; 3403,116.67; 3403,116.67];
PFlightPathAngle = [39; 39; 39; 39; 39];
PAirSpeed = [0.39; 0.39; 0.39; 0.39; 0.39];
FlightPathAngleLimits = [-1.5708, 1.5708; -1.5708, 1.5708; -1.5708, 1.5708; -1.5708, 1.5708; -1.5708, 1.5708];