%% Script to generate Figure S5. F.N. 25.05.2021

% Set up
mainFolder = initialise_script('S5');
[OP,Scan,DC,Z] = setup_FigS5;

% Plot FOV with magnification distortion
figTitle = 'Figure S5';
find_FOV(OP,Z,Scan,DC,figTitle)

cd(mainFolder)