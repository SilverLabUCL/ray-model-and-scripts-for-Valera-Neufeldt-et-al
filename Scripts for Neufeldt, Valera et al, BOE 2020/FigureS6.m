%% Script to generate Figure S6. F.N. 25.05.2021

% Set up
mainFolder = initialise_script('S6');
[OP,Scan,DC,Z] = setup_FigS6;

% Plot precompensated FOV
figTitle = 'Figure S6';
find_FOV(OP,Z,Scan,DC,figTitle)

cd(mainFolder)