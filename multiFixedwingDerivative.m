classdef multiFixedwingDerivative < matlab.System
    % multiFixedwingDerivative Implements multiple fixedwing objects
    % for simulations containing multiple UAVs
    
    % Public, tunable properties
    properties (Access = private)
        GuidanceModels

    end

    % Pre-computed constants or internal states
    properties (Nontunable)
        MaxGuidanceModels = 100;
        
        NumUAVs = 1;
       
        Configuration_PDRoll = [3403,116.67];
        Configuration_PHeight = 3.9;
        Configuration_PFlightPathAngle = 39;
        Configuration_PAirSpeed = 0.39;
        Configuration_FlightPathAngleLimits = [-1.5708, 1.5708];

    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.reset()
        end

        function deriv = stepImpl(obj,state, control, env)
            % Implement algorithm. Calculate derivative as a function of input state, control and environment and
            % internal states.

            deriv = zeros(obj.NumUAVs*8, 1);
            for i=1:obj.NumUAVs
                controlInst.Height = control.Height(i);
                controlInst.RollAngle = control.RollAngle(i);
                controlInst.AirSpeed = control.AirSpeed(i);

                envInst.WindNorth = env.WindNorth(i);
                envInst.WindEast = env.WindEast(i);
                envInst.WindDown = env.WindDown(i);
                envInst.Gravity = env.Gravity(i);

                deriv((i-1)*8 + (1:8)) = derivative(obj.GuidanceModels{i}, state((i-1)*8 + (1:8)), controlInst, envInst);
            end

        end

        function resetImpl(obj)
            % Initialize / reset internal properties
            
            obj.GuidanceModels = coder.nullcopy(cell(1,obj.MaxGuidanceModels));
            
            for i=1:obj.MaxGuidanceModels
                obj.GuidanceModels{i} = fixedwing;
            end
            for i = 1:obj.NumUAVs
                config = obj.GuidanceModels{i}.Configuration;
                config.PDRoll = obj.Configuration_PDRoll(i,:);
                config.PHeight = obj.Configuration_PHeight(i);
                config.PFlightPathAngle = obj.Configuration_PFlightPathAngle(i);
                config.PAirSpeed = obj.Configuration_PAirSpeed(i);
                config.FlightPathAngleLimits = obj.Configuration_FlightPathAngleLimits(i,:);
                obj.GuidanceModels{i}.Configuration = config;
            end
        end
    
    end

    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
    end
end
