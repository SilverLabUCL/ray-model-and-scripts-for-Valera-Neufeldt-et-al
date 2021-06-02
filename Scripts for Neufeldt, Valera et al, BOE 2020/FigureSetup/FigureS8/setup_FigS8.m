function [OP,Scan,DC,Z] = setup_FigS8

%% Optical Path (OP) and AOL Parameters
OP.pdr = 0;                      % Pair deflection ratio = 0 or 1
OP.AODspacing = 50e-03;           % inter-AOD spacing
OP.mode = -1;                    % AOD diffraction order
OP.Fc = 39e6;                    % AOD central frequency
OP.Aperture = 15e-3;             % AOL aperture size
OP.lambda = 0.92e-6;             % Wavelength
OP.Vac = 613;                    % Acoustic velocity m/s
OP.RelayMag = 120/200;           % Relay magnification
OP.f_R1 = 250e-3;                % Focal length of relay lens 1
OP.f_R2 = 150e-3;                % Focal length of relay lens 2
OP.f_input_x = inf;             % x-AOL input beam curvature (non-linear distortion)
OP.f_input_y = inf;             % y-AOL input beam curvature (non-linear distortion)
OP.zOffset = 0;
OP.numRays = 3;                % Number of rays across AOL aperture = 2*numRays^2

%% Scan Parameters
Scan.AccAngle = 5e-3;                           % Acceptance angle in rad, single element or array
Scan.ScanDirection = 'x';                       % 'x' or 'y' scan direction
Scan.DwellTime = 100e-9;                        % Dwell time in s, single element or array
Scan.resolution = 512;                          % Image pixel resolution
Scan.timePoints = 0;        % Time points at which to sample the modelled raster scan
Scan.Curvature = 0;                           % Wavefront curvature in m^-1

%% Distortion/Correction Parameters
DC.zCorrection = false;
DC.xyCorrection = false;
DC.MagCorrectionFactor = 0;      % Magnification distortion correction factor
xCorr = 0; yCorr = 0; xCorr_sine = 0; yCorr_sine = 0;
DC = SetUp_xyDistortionCorrection(DC,xCorr,yCorr,xCorr_sine,yCorr_sine);

% Set the lateral axial misalignment of the AOL
OP.xError = 0;
OP.yError = 0;
OP.zError = 0;         OP.zError = OP.zError + (OP.zError==0)*eps;

%% Set Up Optical Path
OP = SetUp_objective(OP,Scan);
Scan.sampledXY_um = Scan.timePoints*OP.FOV_um;  % Sampled coordinates of the FOV
Z = SetUp_opticalPath(OP);

end
