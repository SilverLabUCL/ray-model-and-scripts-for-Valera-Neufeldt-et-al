
function mainFolder = initialise_script(Fig_id)
    % clear all; 
    
    %% Make sure all scripts are in the path, and return current path
    mainFolder = RayModelPath;
    addpath(genpath(mainFolder))

    set(groot,'defaultfigureposition',[0 0 750 600]); % Increase default size of figures

    cd(mainFolder);
end