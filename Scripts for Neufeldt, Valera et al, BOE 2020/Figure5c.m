%% Script to generate Figure 5c. F.N. 25.05.2021
%% See ThorLabs Application Notes
%% https://www.thorlabs.com/images/tabimages/Risley_Prism_Scanner_App_Note.pdf
mainFolder = initialise_script('5c');

f_mm = 8;                   % Focal length in mm
n = 4/3;                    % refractive index
RelayMag = 150/250;         % Relay magnification
f_R2 = 150;                 % Focal length of relay lens 2 (mm)
DistanceToMirror = 210;     % Experimental distance from prisms to mirror before relay lens, mm

%% Experimental mount angles of Risleys prisms 1 and 2 %%
MountAngle_1 = [38,38,38,38,38,39,42,86,86,87,87,89,91,92,116,123,126,127,127,127,128,178,178,178,180,181,181,181];
MountAngle_2 = [153,159,166,172,179,184,188,182,188,168,175,192,158,195,114,100,84,64,70,90,76,77,83,90,94,68,100,106];

for i = 1:length(MountAngle_1) % Number of data points/z-stacks
    
    MountAngle1 = MountAngle_1(i);
    MountAngle2 = MountAngle_2(i);
    
    % Prism rotation positions, Theta1 and Theta2
    % HomePosition1 = 242 deg, found experimentally
    % HomePosition2 = 178 deg, found experimentally
    % Theta1 = MountAngle1 - HomePosition1 
    % Theta2 = HomePosition2 - MountAngle2
    %%
    Theta1 = MountAngle1 - 245;
    Theta2 = 176 - MountAngle2;
    
    if Theta1 > 360
        Theta1 = Theta1-360;
    end
    
    if Theta1 < 0
        Theta1 = 360+Theta1;
    end
    
    if Theta2 > 360
        Theta2 = Theta2-360;
    end
    
    if Theta2 < 0
        Theta2 = 360+Theta2;
    end
    %%
    
    % Calculate the beam deflection caused by the prisms at the 150 f lens
    [xDeflectionMin(i) yDeflectionMin(i) xDeflection_150f(i) yDeflection_150f(i)...
        xDeflection_150f_Error(i) yDeflection_150f_Error(i) z2] = CalculateBeamDeflection(Theta1,Theta2,DistanceToMirror);
    
    % X and Y slope of the ray incident on the 150 f lens - the beam exits
    % the second prism at a height DeflectionMin in x and y (see page 9 of ThorLabs manual):
    IncomingSlopeX(i) = (xDeflection_150f(i)-xDeflectionMin(i))/z2;
    IncomingSlopeY(i) = (yDeflection_150f(i)-yDeflectionMin(i))/z2;
    
    % X slope of the ray exiting the 150 f (thin) lens:
    OutgoingSlopeX(i) = IncomingSlopeX(i) - xDeflection_150f(i)/f_R2;
    
    % The ray is then incident on the 8 f objective:
    xDeflection_BackAperture(i) = (f_R2+f_mm)*OutgoingSlopeX(i) + xDeflection_150f(i);
    
    % The resulting X skew angle in the FOV, dThetaX, due to the deflection
    % in the back aperture:
    dThetaX(i) = asin(xDeflection_BackAperture(i)./f_mm./n);
    dThetaX_error(i) = xDeflection_150f_Error(i)./f_mm./n;
    
    % Y slope of the ray exiting the 150 f (thin) lens:
    OutgoingSlopeY(i) = IncomingSlopeY(i) - yDeflection_150f(i)/f_R2;
    
    % The ray is then incident on the 8 f objective:
    yDeflection_BackAperture(i) = (f_R2+f_mm)*OutgoingSlopeY(i) + yDeflection_150f(i);
    
    % The resulting Y skew angle in the FOV, dThetaY, due to the deflection
    % in the back aperture:
    dThetaY(i) = asin(yDeflection_BackAperture(i)./f_mm./n);
    dThetaY_error(i) = yDeflection_150f_Error(i)./f_mm./n;
    
    xError(i) = xDeflection_BackAperture(i)/RelayMag;
    yError(i) = yDeflection_BackAperture(i)/RelayMag;
    xError_err(i) = xDeflection_150f_Error(i)/RelayMag;
    yError_err(i) = yDeflection_150f_Error(i)/RelayMag;
    
    
end
%%

%% Find the experimental FOV skew angle from the tracked bead trajectories %%
AccAngle = 5;                                   % 5 mRad acceptance angle
xScaling = 26212;                               % Experimental xy scaling factor
sizeImage = 512;                                % Image size in pixels
FOV_microns = 2*xScaling*AccAngle*1e-3;         % Field of view in microns
NumberPixelsPerMicron = sizeImage/FOV_microns;  % Ratio of the number of pixels per micron


%% Find the experimental skew angle before distortion precompensation
cd([mainFolder,path_for_figures,'/Figure5c/Data/Before/'])
particle = 1;   % Initialise count of tracked beads (one per stack - only the central bead)

for i = 1:length(MountAngle_1)
    
    M1 = MountAngle_1(i);
    M2 = MountAngle_2(i);
    
    % Xml file name - bead trajectory data from ImageJ TrackMate stored in a xml file 
    FileName = ['xScan_Before_M1_',num2str(M1),'_M2_',num2str(M2),'.xml'];
    Tracks = xml2struct(FileName);                              % Bead trajectory information for this C-z-stack
    numberParticles = length(Tracks.Tracks.particle);           % Number of tracked beads in this C-z-stack (always 1 in this analysis)
                                                               
    numberPlanes = length(Tracks.Tracks.particle.detection);    % Number of z-planes in the trajectory
                                                                % (this can vary since image quality decreases for larger beam deflection
    StepSize_microns = 5;                                       % 5 micron step size of the C-z-stack
    zRange = (numberPlanes-1)*StepSize_microns;
    zRange = zRange/2;
    Z = linspace(zRange,-zRange,numberPlanes);                  % Z-range in microns
    
    ComplexPosition = 0;                                        % X and Y position of the tracked bead as x + iy
    
    for n = 1:numberParticles
        
        for plane = 1:numberPlanes
            
            xPlane = str2double(Tracks.Tracks.particle.detection{1,plane}.Attributes.x);
            xPlane = xPlane/NumberPixelsPerMicron; % X position of the bead in microns
            
            yPlane = str2double(Tracks.Tracks.particle.detection{1,plane}.Attributes.y);
            yPlane = yPlane/NumberPixelsPerMicron; % Y position of the bead in microns
            
            ComplexPosition(plane) = xPlane + j*yPlane;
            
            % After recording the bead position for all planes in this
            % stack, calculate the slope of this trajectory:
            if plane == numberPlanes
                
                % Linear fit of the bead trajectories
                pX = polyfit(transpose(Z),real(ComplexPosition(:)),1);
                pY = polyfit(transpose(Z),imag(ComplexPosition(:)),1);
                
                % The first fit coefficient gives the slope:
                xSlope(particle) = pX(1);
                ySlope(particle) = pY(1);
                
                particle = particle +1;
                
            end 
        end
    end
end

for i = 1:length(MountAngle_1)
    
    % Experimental X skew angle
    SkewAngleX_Before(i) = atan(xSlope(i));
    SkewAngleX_Before(i) = rad2deg(SkewAngleX_Before(i));
    
    % Experimental Y skew angle
    SkewAngleY_Before(i) = atan(ySlope(i));
    SkewAngleY_Before(i) = rad2deg(SkewAngleY_Before(i));
    
end

%% Find the experimental skew angle after distortion precompensation
cd([mainFolder,path_for_figures,'/Figure5c/Data/After/'])
particle = 1;   % Initialise count of tracked beads (one per stack - only the central bead)

for i = 1:length(MountAngle_1)
    
    % The true prism angles, recorded in 'RisleyPrismData.mat'
    M1 = MountAngle_1(i);
    M2 = MountAngle_2(i);
    
    % Xml file name - bead trajectory data from ImageJ TrackMate stored in a xml file 
    FileName = ['xScan_After_M1_',num2str(M1),'_M2_',num2str(M2),'.xml'];
    Tracks = xml2struct(FileName);                              % Bead trajectory information for this C-z-stack
    numberParticles = length(Tracks.Tracks.particle);           % Number of tracked beads in this C-z-stack (always 1 in this analysis)
                                                               
    numberPlanes = length(Tracks.Tracks.particle.detection);    % Number of z-planes in the trajectory
                                                                % (this can vary since image quality decreases for larger beam deflection
    StepSize_microns = 5;                                       % 5 micron step size of the C-z-stack
    zRange = (numberPlanes-1)*StepSize_microns;
    zRange = zRange/2;
    Z = linspace(zRange,-zRange,numberPlanes);                  % Z-range in microns
    
    ComplexPosition = 0;                                        % X and Y position of the tracked bead as x + iy
    
    for n = 1:numberParticles
        
        for plane = 1:numberPlanes
            
            xPlane = str2double(Tracks.Tracks.particle.detection{1,plane}.Attributes.x);
            xPlane = xPlane/NumberPixelsPerMicron; % X position of the bead in microns
            
            yPlane = str2double(Tracks.Tracks.particle.detection{1,plane}.Attributes.y);
            yPlane = yPlane/NumberPixelsPerMicron; % Y position of the bead in microns
            
            ComplexPosition(plane) = xPlane + j*yPlane;
            
            % After recording the bead position for all planes in this
            % stack, calculate the slope of this trajectory:
            if plane == numberPlanes
                
                % Linear fits of the bead trajectories
                pX = polyfit(transpose(Z),real(ComplexPosition(:)),1);
                pY = polyfit(transpose(Z),imag(ComplexPosition(:)),1);
                
                % The first fit coefficient gives the slope:
                xSlope(particle) = pX(1);
                ySlope(particle) = pY(1);
                
                particle = particle +1;
                
            end 
        end
    end
end

for i = 1:length(MountAngle_1)
    
    % Experimental X skew angle
    SkewAngleX_After(i) = atan(xSlope(i));
    SkewAngleX_After(i) = rad2deg(SkewAngleX_After(i));
    
    % Experimental Y skew angle
    SkewAngleY_After(i) = atan(ySlope(i));
    SkewAngleY_After(i) = rad2deg(SkewAngleY_After(i));
    
end

%% Plot the x-skew angle before and after distortion precompensation
figure()
scatter(xError(15:28),SkewAngleX_Before(15:28),50,'o','r','filled')
hold on
scatter(xError(15:28),SkewAngleX_After(15:28),50,'o','k','filled')
hold on
scatter(xError(15:28),rad2deg(dThetaX(15:28)),50,'o','k','LineWidth',1)
hold on
plot([-7,7],[0,0],'--k','LineWidth',1)
hold on
errorbar(xError(15:28),SkewAngleX_Before(15:28),rad2deg(dThetaX_error(15:28)),rad2deg(dThetaX_error(15:28)), 'LineStyle','none','Color','r','LineWidth',1);
errorbar(xError(15:28),SkewAngleX_After(15:28),rad2deg(dThetaX_error(15:28)),rad2deg(dThetaX_error(15:28)), 'LineStyle','none','Color','k','LineWidth',1);
title('X-Skew angle before and after distortion precompensation')
xlabel('X_E_R_R_O_R (mm)')
ylabel('X-Skew angle in the FOV (deg)')
set(gca, 'FontName', 'times','FontSize',14)
set(gcf, 'Renderer', 'Painters');
xlim([-7,7])
ylim([-25,25])

%% Plot the y-skew angle before and after distortion precompensation
figure()
scatter(yError(1:14),SkewAngleY_Before(1:14),50,'o','r','filled')
hold on
scatter(yError(1:14),SkewAngleY_After(1:14),50,'o','k','filled')
hold on
scatter(yError(1:14),rad2deg(dThetaY(1:14)),50,'o','k','LineWidth',1)
hold on
plot([-7,7],[0,0],'--k','LineWidth',1)
hold on
errorbar(yError(1:14),SkewAngleY_Before(1:14),rad2deg(dThetaY_error(1:14)),rad2deg(dThetaY_error(1:14)), 'LineStyle','none','Color','r','LineWidth',1);
errorbar(yError(1:14),SkewAngleY_After(1:14),rad2deg(dThetaY_error(1:14)),rad2deg(dThetaY_error(1:14)), 'LineStyle','none','Color','k','LineWidth',1);
xlabel('Y_E_R_R_O_R (mm)')
ylabel('Y-Skew angle in the FOV (deg)')
set(gca, 'FontName', 'times','FontSize',14)
set(gcf, 'Renderer', 'Painters');
xlim([-7,7])
ylim([-25,25])
title('Figure 5(c)');
hold on;ps = polyshape([-5.6 -5.6 -6.4 -6.4],[25 -25 -25 25]);ps = plot(ps);
ps.FaceColor = [0.4,0.4,1]; ps.FaceAlpha = 0.5; ps.EdgeColor = 'none';
legend({'Data - Uncorrected','Data - Corrected','Theoretical'},'Location','NW','Box','off');
%%
rmpath(genpath([mainFolder,path_for_figures,'Figure5c/']))
cd(mainFolder)