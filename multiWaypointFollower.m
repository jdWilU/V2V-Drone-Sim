classdef multiWaypointFollower < matlab.System
    % multiWaypointFollower Implements multiple waypoint follower objects
    % for simulations containing multiple UAVs
    
    % Public, tunable properties
    properties (Access = private)
        WaypointFollowers;
    end

    % Pre-computed constants or internal states
       
    properties (Nontunable)
        MaxFollowers = 100;
        
        NumUAVs = 1;

        UAVType = '';

        StartsFrom = '';

        TransitionRadiusSource = '';

        TransitionRadius = 10;

        MinimumLookaheadDistance = 0.1;

        Waypoints (10,3,5)
        
    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.reset()
        end

        function [lookaheadPoint, desiredCourse, desiredYaw, lookaheadPointFlag] = stepImpl(obj, currentPose, lookaheadDistance)
            % Implement algorithm. Calculate y as a function of input u and
            % internal states.
            lookaheadPoint = zeros(obj.NumUAVs,3);
            lookaheadPointFlag = zeros(obj.NumUAVs,1);
            desiredYaw = zeros(obj.NumUAVs,1);
            desiredCourse = zeros(obj.NumUAVs,1);

            for i = 1:obj.NumUAVs
                wp = obj.WaypointFollowers{i};
                [lookaheadPoint(i,:), desiredCourse(i), desiredYaw(i), lookaheadPointFlag(i), ~, ~] = wp(currentPose(i,:)', lookaheadDistance(i));
            end

        end

        function resetImpl(obj)
            % Initialize / reset internal properties

            obj.WaypointFollowers = coder.nullcopy(cell(1,obj.MaxFollowers));
            for i=1:obj.MaxFollowers
                obj.WaypointFollowers{i} = uavWaypointFollower;
            end

            % for i=1:obj.NumUAVs
            %     obj.WaypointFollowers{i} = uavWaypointFollower("StartFrom", obj.StartsFrom{i}, "TransitionRadius", obj.TransitionRadius(i),...
            %         "UAVType", obj.UAVType{i},"Waypoints",obj.Waypoints(:,:,i));
            % end

            for i=1:obj.NumUAVs
                obj.WaypointFollowers{i} = uavWaypointFollower("StartFrom", 'first', "TransitionRadius", 10,...
                    "UAVType", 'fixed-wing',"Waypoints",obj.Waypoints(:,:,i));
            end
        end

        function [sizeLookAheadPoint, sizeDesiredCourse, sizeDesiredYaw, sizeLookAheadFlag] = getOutputSizeImpl(obj)
            % Return size for each output port
            sizeLookAheadPoint = [obj.NumUAVs 3];
            sizeDesiredCourse = [obj.NumUAVs 1];
            sizeDesiredYaw = [obj.NumUAVs 1];
            sizeLookAheadFlag = [obj.NumUAVs 1];
        end

        function [typeLookAheadPoint, typeDesiredCourse, typeDesiredYaw, typeLookAheadFlag] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            typeLookAheadPoint = "double";
            typeDesiredCourse = "double";
            typeDesiredYaw = "double";
            typeLookAheadFlag = "double";
        end

        function [isComplexLookAheadPoint, isComplexDesiredCourse, isComplexDesiredYaw, isComplexLookAheadFlag] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            isComplexLookAheadPoint = false;
            isComplexDesiredCourse = false;
            isComplexDesiredYaw = false;
            isComplexLookAheadFlag = false;
        end

        function [isFixedLookAheadPoint, isFixedDesiredCourse, isFixedDesiredYaw, isFixedLookAheadFlag] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            isFixedLookAheadPoint = true;
            isFixedDesiredCourse = true;
            isFixedDesiredYaw = true;
            isFixedLookAheadFlag = true;
        end
    end

    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
    end
end
