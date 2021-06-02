%% Calculate the stop and start scan coordinates in AOL space
function [start_aol,stop_aol,start_obj,stop_obj] = scanCoordinates(Scan,OP,z_aol,row)
z_obj = OP.focal_length_effective^2./(OP.RelayMag^2*OP.n*z_aol);

if strcmp(Scan.ScanDirection,'x')
    
    y_obj = Scan.sampledXY_um(row)*1e-06;
    y_start_obj = y_obj + (y_obj==0)*eps;
    y_stop_obj = y_obj + (y_obj==0)*eps;
    
    x_start_obj = -OP.FOV_um.*1e-06./2;
    x_stop_obj = OP.FOV_um.*1e-06./2;
    
    
elseif strcmp(Scan.ScanDirection,'y')
    
    x_obj = Scan.sampledXY_um(row)*1e-06;
    x_start_obj = x_obj + (x_obj==0)*eps;
    x_stop_obj = x_obj + (x_obj==0)*eps;
    
    y_start_obj = -OP.FOV_um.*1e-06./2;
    y_stop_obj = OP.FOV_um.*1e-06./2;
    
end

% Equations from Geoffrey Evan's thesis page 60
% https://discovery.ucl.ac.uk/id/eprint/1521116/1/Evans_ThesisCorrected.pdf

% Define the x and y AOL focus at the beginning and end of the scan
x_start_aol = -(OP.RelayMag*z_aol*OP.n*x_start_obj)/(OP.focal_length_effective);
x_stop_aol = -(OP.RelayMag*z_aol*OP.n*x_stop_obj)/(OP.focal_length_effective);
y_start_aol = -(OP.RelayMag*z_aol*OP.n*y_start_obj)/(OP.focal_length_effective);
y_stop_aol = -(OP.RelayMag*z_aol*OP.n*y_stop_obj)/(OP.focal_length_effective);

start_obj = [x_start_obj,y_start_obj,z_obj];
stop_obj = [x_stop_obj,y_stop_obj,z_obj];
start_aol = [x_start_aol,y_start_aol,z_aol];
stop_aol = [x_stop_aol,y_stop_aol,z_aol];
end