function [OP,Scan,DC,Z] = setup_FigS5

%% Optical Path (OP) and AOL Parameters
OP.pdr = 0;                      % Pair deflection ratio = 0 or 1
OP.AODspacing = 50e-03;          % inter-AOD spacing
OP.mode = -1;                    % AOD diffraction order
OP.Fc = 39e6;                    % AOD central frequency
OP.Aperture = 15e-3;             % AOL aperture size
OP.lambda = 0.92e-6;             % Wavelength
OP.Vac = 613;                    % Acoustic velocity m/s
OP.RelayMag = 120/200;           % Relay magnification
OP.f_R1 = 250e-3;                % Focal length of relay lens 1
OP.f_R2 = 150e-3;                % Focal length of relay lens 2
OP.f_input_x = inf;              % x-AOL input beam curvature = 1/f_input_x (for non-linear distortion)
OP.f_input_y = inf;              % y-AOL input beam curvature = 1/f_input_y (for non-linear distortion)
OP.zOffset = 0;                  % z offset if input beam is not planar
OP.numRays = 2;                  % Number of rays across AOL aperture = 2*numRays^2

%% Scan Parameters
Scan.AccAngle = 5e-3;            % Acceptance angle in rad, single element or array
Scan.ScanDirection = 'x';        % 'x' or 'y' scan direction
Scan.DwellTime = 100e-9;         % Dwell time in s, single element or array
Scan.resolution = 512;           % Image pixel resolution
Scan.timePoints = [-0.5,0.5];    % Time points at which to sample the modelled raster scan
Scan.Curvature = [-1,1];         % Wavefront curvature in m^-1

%% Distortion/Correction Parameters
DC.zCorrection = false;         % Correct for non-linear z-spacing and magnification distortion
DC.xyCorrection = false;        % Correct for skew distortion
DC.MagCorrectionFactor = 1;     % Magnification distortion correction factor
xCorr = 0; yCorr = 0; xCorr_sine = 0; yCorr_sine = 0;   % Skew distortion correction factors
DC = SetUp_xyDistortionCorrection(DC,xCorr,yCorr,xCorr_sine,yCorr_sine);

% Set the lateral axial misalignment of the AOL
OP.xError = 0e-3;
OP.yError = 0e-3;
OP.zError = 100e-3;         OP.zError = OP.zError + (OP.zError==0)*eps;

%% Set Up Optical Path
OP = SetUp_objective(OP,Scan);                  % Objective parameters
Scan.sampledXY_um = Scan.timePoints*OP.FOV_um;  % Sampled coordinates of the FOV
Z = SetUp_opticalPath(OP);                      % Coordinates of z-planes

end
