%% Script to generate Figure S8a. F.N. 25.05.2021
mainFolder = initialise_script('S8');

[OP,Scan,DC,Z] = setup_FigS8;

% Plot rays through relay with 250 f and 150 f lens
[~,RaysX,RaysY] = find_FocalPts(OP,Z,Scan,DC);
plot_OpticalPath(OP,Z,RaysX,RaysY)
title('Figure S8(a)')

% Plot rays through relay with 375 f and 150 f lens
OP.f_R1 = 375e-3;
[~,RaysX,RaysY] = find_FocalPts(OP,Z,Scan,DC);
plot_OpticalPath(OP,Z,RaysX,RaysY)
title('Figure S8(b)')

% Plot rays through relay with 188 f and 150 f lens
OP.f_R1 = 188e-3;
[~,RaysX,RaysY] = find_FocalPts(OP,Z,Scan,DC);
plot_OpticalPath(OP,Z,RaysX,RaysY)
title('Figure S8(c)')

%%
cd(mainFolder)

