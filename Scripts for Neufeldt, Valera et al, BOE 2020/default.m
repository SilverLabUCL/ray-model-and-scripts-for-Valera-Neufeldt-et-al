%% Script to model a remote focus volumentric scan by the Fourier and/or ray model

%% Set up optical parameters
mainFolder = RayModelPath;
cd(mainFolder)

% Change parameters in setup_default to change the optical/scan parameters
% Set FT.FT_Model to true to use Fourier model (increased computational
% time)
[OP,Scan,DC,Z,FT] = setup_default;

%% Sample the modelled raster scan
[FocalPts_RayModel_um,FocalPts_FTModel_um,RayX,RayY] = find_FocalPts_FT(OP,Z,Scan,DC,FT);

%% Plot the scan modelled by the ray model
colour = rgb('Red');
figTitle = 'Modelled raster scan - Fourier Model Focus';
transparency = 1;
figure()
plot_RasterScan(OP,Scan,FocalPts_FTModel_um,colour,figTitle,transparency)

%% Plot the scan modelled by the Fourier model
colour = rgb('Red');
figTitle = 'Modelled raster scan - Least Squares Focus';
transparency = 1;
figure()
plot_RasterScan(OP,Scan,FocalPts_RayModel_um,colour,figTitle,transparency)

%%
