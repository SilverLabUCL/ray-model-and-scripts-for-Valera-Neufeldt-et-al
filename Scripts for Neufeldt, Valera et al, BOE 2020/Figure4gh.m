%% Script to generate Figure 4gh. F.N. 25.05.2021
mainFolder = initialise_script('4gh');

%% Find the true z-remote-focus by finding the max. intensity z-plane
figTitle = {'Figure 4g','Figure 4h'};
zFocus = zeros(2,3);    % Empty matrix for focal positions
mean_Iz = zeros(1,61);  % Empty matrix for mean intensity values
numPlanes = 61;         % Number of z-planes in the C-z-stack, from experiment
centrePlane = 31;       % z = 0 plane
i_mag_DC = 0;           % Loop iteration

for mag_DC = [1 18.5]  % Experimental magnification distortion correction factor
    
    figure()
    i_mag_DC = i_mag_DC+1;
    i_z = 0;
    
    for zCentre = [0 -200 200]
        
        i_z = i_z+1;
        z_um = (zCentre-centrePlane+1):1:(zCentre+centrePlane-1); % Z-Stage position
        z_um = z_um -0.5;                                         % Experimentally determined z-offset
        
        %% Import and process C-z-Stack
        % Limits to crop only central FOV
        crop_min = 128;
        crop_max = 384;
        
        % Import first image
        stack = imread(['xScan_centred on ',num2str(zCentre),' w mag ',num2str(mag_DC),'_aa0_0046025_dt5e-08.tif']);
        % Crop stack and analyse green channel (2)
        stack = stack(crop_min:crop_max,crop_min:crop_max,2);
        
        % Import remaining z-slices, crop and keep only green channel (2)
        for i = 2:numPlanes
            temp = imread(['xScan_centred on ',num2str(zCentre),' w mag ',num2str(mag_DC),'_aa0_0046025_dt5e-08.tif'], i);
            temp = temp(crop_min:crop_max,crop_min:crop_max,2);
            stack = cat(3,stack,temp);
        end
        
        % Subtract background
        min_Iz = min(min(stack(:,:,centrePlane)))+min(min(stack(:,:,1)))+20;
        stack = stack - min_Iz;
        
        % Mean intensity at each z-plane:
        for i = 1:numPlanes
            mean_Iz(i) = mean(mean(stack(:,:,i)));
        end
        
        max_mean_Iz = max(mean_Iz); % Mean intensity at z = 0
        
        %% Plot the normalised mean intensity vs. z-stage position
        colour = {'LightSkyBlue','DarkOrange', 'MediumVioletRed'};
        figure(gcf)
        hold on
        plot(z_um, mean_Iz./max_mean_Iz,'Color',rgb(colour(i_z)),'LineWidth',1) % Plot normalised mean intensity
        hold on
        xlim([-250,250])
        xlabel('Z-Stage Focus (\mum)')
        ylabel('Normalised Mean Intensity (arb. units)')
        title(figTitle(i_mag_DC))
        set(gca, 'FontName', 'times','FontSize',16)
        set(gcf, 'Renderer', 'Painters');
        
        %% Find focal plane
        max_Iz = find(mean_Iz == max(mean_Iz));
        zFocus(i_mag_DC,i_z) = z_um(max_Iz); % Focus given by z-plane with the max. normalised intensity
        plot([zFocus(i_mag_DC,i_z),zFocus(i_mag_DC,i_z)],[0,1],'--k')
        
    end
    
end

disp('Z-Stage Focal Positions at [-200, 200] \mum :')
disp('Before:')
zFocus(1,2:3)
disp('After:')
zFocus(2,2:3)

cd(mainFolder)