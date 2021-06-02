%% Distortion precompensation implemented on the AOL microscope
function [new_start_aol] = distortion_correction(OP,Scan,DC,start_aol)

%% Normalised coordinates in aol space
start_aol_norm(1) = start_aol(1)/(2*Scan.AccAngle*start_aol(3));
start_aol_norm(2) = start_aol(2)/(2*Scan.AccAngle*start_aol(3));
start_aol_norm(3) = OP.Aperture/(4*Scan.AccAngle*start_aol(3));

%% Calculate the distance from the lens to the AOL
f = 1000e-3;                                         % Focal length of the lens
Zi = f + DC.MagCorrectionFactor * Scan.AccAngle - 0; % Distance from the lens to the AOL

%% Correct for Z non-linear scaling
new_start_aol = start_aol_norm;
new_start_aol(3) = -(f * (start_aol_norm(3) - f) ./ start_aol_norm(3)  - (Zi)) .^-1;

%% Correct for Z-dependant X-Y magnification
% Pre-distortion calculation
Zd = (1./f - 1./ (Zi)).^-1;
M = (Zd - f + start_aol_norm(3)) ./ (Zd - f);
new_start_aol(1:2) = start_aol_norm(1:2) ./ M;

new_start_aol(3) = OP.Aperture/(4*Scan.AccAngle*new_start_aol(3));
new_start_aol(1) = 2*Scan.AccAngle*new_start_aol(3)*new_start_aol(1);
new_start_aol(2) = 2*Scan.AccAngle*new_start_aol(3)*new_start_aol(2);

end