%% Script to generate Figure S7b. F.N. 25.05.2021
mainFolder = initialise_script('S7b');

[OP,Scan,DC,Z,Exp] = setup_FigS7b(mainFolder);

%% Sample the modelled raster scan at the bead positions
[FocalPts_Ray_um,RaysX,RaysY] = find_FocalPts_BeadCoordinates(OP,Z,Scan,DC,Exp);

%% Plot the modelled (red) and experimental (black) trajectories
figure(); hold on
axis equal
colour = rgb('Red');
transparency = 0.5;
plot_RasterScan(OP,Scan,FocalPts_Ray_um,colour,[],transparency)
colour = rgb('Black');
to_plot = true;
[~,~,~] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);

%% Sample the modelled raster scan in a grid pattern
Scan.timePoints = linspace(-0.45,0.45,6);
Scan.sampledXY_um = Scan.timePoints*OP.FOV_um;
[FocalPts_Ray_um,~,~] = find_FocalPts(OP,Z,Scan,DC);

%% Plot the modelled trajectories (pink) in a grid pattern
colour = rgb('Pink');
figTitle = 'Figure S7(b)';
transparency = 1;
plot_RasterScan(OP,Scan,FocalPts_Ray_um,colour,figTitle,transparency)
xlim([-150,150])
ylim([-150,150])

%%
cd(mainFolder)

