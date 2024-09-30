# README: Multi-UAV Formation Flight Simulation

## Overview

This project simulates the flight dynamics and control of multiple UAVs (Unmanned Aerial Vehicles) flying in formation using MATLAB and Simulink. The simulation is based on a system of multiple fixed-wing UAVs, allowing for coordinated flight patterns, control system dynamics, and interaction between UAVs. The project also implements multi-UAV guidance and control, waypoint following, and derivative modeling.

### Main Components:
1. **`formationFlightSimulation.slx`**: The Simulink model that implements the dynamics and control of multiple UAVs in formation.
2. **`formationFlightSimulationData.sldd`**: A data dictionary containing predefined parameters and data used by the simulation model.
3. **`exampleHelperMultiUAVSetupScript.m`**: A helper script to configure and initialize the simulation, including resizing bus signals for multiple UAVs and defining initial states and control properties.
4. **`multiFixedwingDerivative.m`**: A class definition that handles the UAV dynamics and derivatives calculation, including state, control, and environment interactions for multiple fixed-wing UAVs.
5. **`multiWaypointFollower.m`**: A class definition that manages the waypoint following behavior for multiple UAVs, allowing for dynamic path following and flight guidance.
6. **`SimulatingMultipleUAVsInSimulinkUsingSystemObjectBlocksExample.mlx`**: An example Live Script demonstrating how to simulate and visualize multiple UAVs using System Objects in Simulink.

## Purpose

The purpose of this simulation is to model and test the dynamics of multiple UAVs flying in formation, including control of each UAV's position, speed, altitude, and orientation. Additionally, it provides implementations for UAV derivative calculations and waypoint following behavior. The simulation can be extended to explore the effects of control strategies, environmental disturbances, and UAV-to-UAV interaction.

## Setup and Usage Instructions

### Prerequisites:
- MATLAB (version compatible with the provided files)
- Simulink
- **Aerospace Blockset** (for flight dynamics modeling)
- **Simulink 3D Animation** (optional, for visualization)

### Step-by-Step Instructions:

1. **Open the Simulink Model**:
   - Open the `formationFlightSimulation.slx` Simulink model in MATLAB.
   - Ensure the `formationFlightSimulationData.sldd` data dictionary is correctly linked to the model. This dictionary contains essential parameters like control properties, UAV state definitions, and environment data.

2. **Configure the Simulation**:
   - Before running the model, configure the number of UAVs by modifying the `numUAVs` variable. This can be done in the `exampleHelperMultiUAVSetupScript.m` script.
   - The script adjusts the bus signal dimensions for UAV state, control, and environment to match the number of UAVs specified.

3. **Run the Initialization Script**:
   - Run `exampleHelperMultiUAVSetupScript.m` to initialize the state and control parameters of the UAVs. This script sets up the initial positions, speeds, and flight parameters for each UAV in the formation.
   - Example command in MATLAB:
     ```matlab
     exampleHelperMultiUAVSetupScript;
     ```

4. **Run the Simulation**:
   - Once the configuration is complete, run the Simulink model (`formationFlightSimulation.slx`) by clicking the **Run** button or using the following MATLAB command:
     ```matlab
     sim('formationFlightSimulation');
     ```
   - The model will simulate the formation flight, updating the states of each UAV and showing their interactions.

5. **Visualize the UAVs**:
   - You can visualize the flight paths and dynamics of the UAVs by integrating with the **Simulink 3D Animation** toolbox.
   - Alternatively, you can use the `SimulatingMultipleUAVsInSimulinkUsingSystemObjectBlocksExample.mlx` Live Script for visualization and more complex simulations.

### Key Components:

#### `multiFixedwingDerivative.m`
This file implements the flight dynamics derivative calculations for multiple fixed-wing UAVs. The class calculates the UAV's derivative as a function of input state, control, and environmental variables (like wind and gravity). It supports the configuration of various UAV parameters, such as roll angle, airspeed, and flight path angle. 

##### Key Properties:
- **GuidanceModels**: Stores guidance models for each UAV.
- **NumUAVs**: The number of UAVs in the simulation.
- **Configuration Parameters**: Includes settings for roll angle, height, flight path angle, airspeed, and angle limits.

##### Key Methods:
- **setupImpl**: Initializes the UAV models.
- **stepImpl**: Calculates the derivative for each UAV.
- **resetImpl**: Resets the internal states of the UAV models.

#### `multiWaypointFollower.m`
This file implements a waypoint following algorithm for multiple UAVs. Each UAV has its own waypoint follower, which calculates the next lookahead point, desired course, and yaw based on the current position and lookahead distance.

##### Key Properties:
- **WaypointFollowers**: Stores waypoint followers for each UAV.
- **Waypoints**: Specifies the waypoints for each UAV to follow.
- **TransitionRadius**: Defines the radius for transitioning between waypoints.

##### Key Methods:
- **setupImpl**: Initializes the waypoint followers.
- **stepImpl**: Computes the lookahead point, desired course, and yaw for each UAV.
- **resetImpl**: Resets the waypoint followers to their initial state.

### Key Customizable Parameters:

- **Initial UAV States**: The initial positions, speeds, and orientations of the UAVs are set in the `exampleHelperMultiUAVSetupScript.m` script. These can be modified to test different scenarios.
- **UAV Control Properties**: Parameters such as roll angle limits, flight path angle, and airspeed are defined in the same script and can be adjusted for each UAV.
- **Number of UAVs**: The number of UAVs in the simulation can be set by changing the `numUAVs` variable in the script.

## Troubleshooting

- **Version Compatibility**: If the data dictionary `formationFlightSimulationData.sldd` was created in a newer MATLAB version, you may encounter compatibility issues. To resolve this, export the data dictionary to a version compatible with your MATLAB release:
  ```matlab
  Simulink.data.dictionary.exportToVersion('formationFlightSimulationData.sldd', 'olderVersionFile.sldd', 'R2022b');
