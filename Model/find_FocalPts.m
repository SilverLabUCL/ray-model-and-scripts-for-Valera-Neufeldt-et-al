% This function returns the focal positions of the optical beam during a
% raster scan, for the thin lens model.

function [FocalPts_RayModel_um,RayX,RayY] = find_FocalPts(OP,Z,Scan,DC)

%% Empty array - focal points(T,scanRow,Z)
FocalPts_RayModel_um = zeros(length(Scan.timePoints),3,length(Scan.sampledXY_um),length(Scan.Curvature));

for i_z = 1:length(Scan.Curvature)
    
    Cv = Scan.Curvature(i_z);   % Curvature of the optical beam produced by the AOL
    Cv = Cv + (Cv==0)*eps;
    
    z_aol = 1./Cv; % Distance to the focus produced by the AOL in the absence of subsequent optics.
    
    for row = 1:length(Scan.sampledXY_um)  % Row here is the coordinate in the non-scan dimension
        % (analogy - we maintain the focus at a constant 'row'
        % while scanning along a 'column')
        
        %% Set up start and stop scan coordinates in AOL and objective space:
        [start_aol,stop_aol,start_obj,stop_obj] = scanCoordinates(Scan,OP,z_aol,row);
        
        %% Correct non-linear z and magnification distortion
        if DC.zCorrection
            %% Correction for the distortion produced by a finite CorrZ
            % (non-linear z-spacing and z-dependent lateral magnification).
            % Corrects the start_aol and stop_aol coordinates
            start_aol = distortion_correction(OP,Scan,DC,start_aol);
            stop_aol = distortion_correction(OP,Scan,DC,stop_aol);
            
        end
        
        %% Calculate drives
        [a,b] = calculateDrives(OP,Scan,start_aol,stop_aol);
        
        %% AOL Timing Offsets
        T = Scan.timePoints*Scan.resolution*Scan.DwellTime;             % Scan time
        Zplanes = [Z.Ioz Z.Zaod Z.z_relay Z.Imz];                       % Concatenated list of the Z coordinates of all the Z planes
        
        d3 = Zplanes(3)-Zplanes(5);                                     % Distance between AOD3 and AOD4
        Spatial_offset_fc = -d3.*(OP.mode.*OP.Fc.*OP.lambda./OP.Vac);   % Offset caused by centre frequency
        Timings.Time_delay_fc = -Spatial_offset_fc./OP.Vac;             % Time delay due to centre frequency offset
        
        xOffset = Spatial_offset_fc + OP.xError;        % Spatial offset due to the centre freq. offset and xError
        yOffset = Spatial_offset_fc + OP.yError;        % Spatial offset due to the centre freq. offset and yError
        Timings.Time_delay_xOffset = xOffset/OP.Vac;    % Timing offset due to xOffset
        Timings.Time_delay_yOffset = yOffset/OP.Vac;    % Timing offset due to yOffset
        
        %% Main ray model
        % Set up the input ray array = a square array of size numRays*numRays
        % spread across the 15 mm AOL aperture
        % Input rays are offset so that the undiffracted beam is focused at (x,y,z) = (0,0,0)
        x = (-OP.numRays:OP.numRays)./OP.numRays.*OP.Aperture/2 - xOffset;
        y = (-OP.numRays:OP.numRays)./OP.numRays.*OP.Aperture/2 - yOffset;
        [X,Y,time] = meshgrid(x,y,T);
        
        %% Apply a circular mask to the beam
        [X,Y,circlePixels] = circularBeam(X,Y);
        
        %% Find the ray positions given by the ray model
        [RaysX,RaysY] = deflectRays_TanModel(OP,a,b,X,Y,T,xOffset,yOffset,time,Timings,DC,Zplanes,circlePixels);
        
        %% Find Focal Points
        % The focus is found by finding the least squares intersection
        % point of the rays between z-planes 10 and 12, a distance +- 0.5 f
        % from the natural focal plane
        
        RayX = reshape(RaysX,(2*OP.numRays+1)^2,size(Zplanes,2),size(T,2));
        RayY = reshape(RaysY,(2*OP.numRays+1)^2,size(Zplanes,2),size(T,2));
        StartPts_RayModel = zeros((2*OP.numRays+1)^2,3);
        EndPts_RayModel = zeros((2*OP.numRays+1)^2,3);
        IntersectionPts_ray_um = zeros(length(Scan.timePoints),3);
        
        for nn = 1:size(T,2)
            
            clear StartPts_RayModel EndPts_RayModel
            
            StartPts_RayModel(:,1) = RayX(:,10,nn);
            StartPts_RayModel(:,2) = RayY(:,10,nn);
            StartPts_RayModel(:,3) = Zplanes(10);
            
            EndPts_RayModel(:,1) = RayX(:,12,nn);
            EndPts_RayModel(:,2) = RayY(:,12,nn);
            EndPts_RayModel(:,3) = Zplanes(12);
            
            %% Exclude values = 0, from the circular mask
            A = find(EndPts_RayModel(:,1) == 0);
            StartPts_RayModel(A,:) = [];
            EndPts_RayModel(A,:) = [];
            
            %% Intersection point found by least squares calculation
            IntersectionPts_ray_um(nn,:) = lineIntersect3D(StartPts_RayModel*1e06,EndPts_RayModel*1e06);
            
        end
        
        FocalPts_RayModel_um(:,:,row,i_z) = IntersectionPts_ray_um;
        FocalPts_RayModel_um(:,3,row,i_z) = FocalPts_RayModel_um(:,3,row,i_z)-Z.Z_normalised_zero*1e6;
        
    end
end
end