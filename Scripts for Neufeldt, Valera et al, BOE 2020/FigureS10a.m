%% Script to generate Figure S10a. F.N. 25.05.2021
mainFolder = initialise_script('S10a');

[OP,Scan,DC,Z,Exp] = setup_FigS10a(mainFolder);

%% Model the specified raster scan - non-linear distortion
[FocalPts_Ray_um,~,~] = find_FocalPts(OP,Z,Scan,DC);

%% Plot the modelled (black) trajectories
figure()
colour = rgb('Black');
transparency = 1;
figTitle = 'Figure S10(a)';
plot_RasterScan(OP,Scan,FocalPts_Ray_um,colour,figTitle,transparency)

%% Plot the experimental (red) trajectories
colour = rgb('Red');
to_plot = true;
[~,~,~] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);
Exp.fileName = 'FigS10a_yScan_aa0_005_dt2e-07_2_Tracks.xml';
[~,~,~] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);
xlim([-145,145])
ylim([-145,145])
set (gca,'Xdir','reverse')
set (gca,'Ydir','reverse')

%%
cd(mainFolder)