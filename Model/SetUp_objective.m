%% Calculate the field of view, objective focal length, objective numerical
%% aperture and half angle for the Leica 25x objective.

function OP = SetUp_objective(OP,Scan)
OP.ObjMag = 25;                 % Objective magnification
OP.xyScaling = 26666;           % Objective xy scaling factor
OP.zScaling = 63051;            % Objective z scaling factor
OP.TubeLensDistance = 200e-3;   % Leica objective designed for 200 mm tube lens
OP.n = 4/3;                     % Refractive index of imaging medium (water)


OP.FOV_um = 2*OP.xyScaling*Scan.AccAngle;                       % Objective FOV in microns
OP.focal_length = OP.TubeLensDistance/OP.ObjMag;                % Focal length of lens
OP.focal_length_effective = OP.n*OP.TubeLensDistance/OP.ObjMag; % Focal length of lens in water
OP.NA = OP.Aperture*OP.RelayMag/(2*OP.focal_length);            % Effective NA of the underfilled objective
OP.theta_half = asin(OP.NA/OP.n);                               % Half angle of objective in rad
end