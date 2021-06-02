%% Calculates the FOV predicted by the distortion model

function [xFOV,xFOV_minus,yFOV,yFOV_minus,zFOV] = nonTelecentricAOL_Distortion(OP,Scan)

Cv = Scan.Curvature;      % Curvature of the optical beam produced by the AOL
Cv = Cv + (Cv==0)*eps;

%% Eq. (1)
zFOV = -(OP.n.*OP.focal_length.^2.*Cv) ./ (Cv.*OP.RelayMag.^2.*OP.zError + OP.RelayMag.^2);

thetaX = 2*Scan.AccAngle; % Semi scan angle X
thetaY = 2*Scan.AccAngle; % Semi scan angle Y

%% Eqs. (2) and (S8)
xFOV = (OP.focal_length.*thetaX - OP.focal_length.*Cv.*OP.xError) ./ (OP.RelayMag.*Cv.*OP.zError + OP.RelayMag);
yFOV = (OP.focal_length.*thetaY - OP.focal_length.*Cv.*OP.yError) ./ (OP.RelayMag.*Cv.*OP.zError + OP.RelayMag);
xFOV_minus = (OP.focal_length.*-thetaX - OP.focal_length.*Cv.*OP.xError) ./ (OP.RelayMag.*Cv.*OP.zError + OP.RelayMag);
yFOV_minus = (OP.focal_length.*-thetaY - OP.focal_length.*Cv.*OP.yError) ./ (OP.RelayMag.*Cv.*OP.zError + OP.RelayMag);

end