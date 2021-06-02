
%% Script to generate Figure 3d. F.N. 25.05.2021
mainFolder = initialise_script('3d');
[OP,Scan,DC,Z,Exp] = setup_Fig3d(mainFolder);

%% Sample the modelled raster scan at the bead positions
[FocalPts_Ray_um,RaysX,RaysY] = find_FocalPts_BeadCoordinates(OP,Z,Scan,DC,Exp);

%% Plot the modelled (red) and experimental (black) trajectories
figure(); hold on
colour = rgb('Red');
transparency = 0.5;
plot_RasterScan(OP,Scan,FocalPts_Ray_um,colour,[],transparency)
colour = rgb('Black');
to_plot = true;
[~,~,~] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);

%% Sample the modelled raster scan in a grid pattern
Scan.timePoints = linspace(-0.35,0.35,6);
Scan.sampledXY_um = Scan.timePoints*OP.FOV_um;
[FocalPts_Ray_um,~,~]...
    = find_FocalPts(OP,Z,Scan,DC);

%% Plot the modelled trajectories (pink) in a grid pattern
colour = rgb('Pink');
figTitle = 'Figure 3(d)';
transparency = 1;
plot_RasterScan(OP,Scan,FocalPts_Ray_um,colour,figTitle,transparency)
xlim([-130,130])
ylim([-130,130])

%%
cd(mainFolder)
