%% Set up coordinates of the sampled FOV

function Scan = SetUp_xyFOV(Scan,OP)
if strcmp(Scan.ScanDirection,'x')       % X Scan
    X_um = 0;
    Y_um = Scan.timePoints*OP.FOV_um;
    Scan.sampledXY = Y_um;
elseif strcmp(Scan.ScanDirection,'y')   % Y Scan
    Y_um = 0;
    X_um = Scan.timePoints*OP.FOV_um;
    ScansampledXY = X_um;
end
end
