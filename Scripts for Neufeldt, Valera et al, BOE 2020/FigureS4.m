%% Script to generate Figure S4. F.N. 25.05.2021

% Set up
mainFolder = initialise_script('S4');
[OP,Scan,DC,Z] = setup_FigS4;

% Plot FOV with skew distortion
figTitle = 'Figure S4';
find_FOV(OP,Z,Scan,DC,figTitle)

cd(mainFolder)