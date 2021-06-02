function find_FOV(OP,Z,Scan,DC,figTitle)

%% Find foci at edges of the FOV
[FocalPts_Ray_um,~,~] = find_FocalPts(OP,Z,Scan,DC);

%% Plot foci
figure(); hold on
title(figTitle)
Foci = permute(FocalPts_Ray_um*1e-3, [1,3,4,2]);
Foci = reshape(Foci, [], 3);
scatter3(Foci(:,1),Foci(:,2),Foci(:,3),80,'*','MarkerEdgeColor',rgb('Red'),'LineWidth',0.8);

%% Find and plot extent of the undistorted FOV to verify the distortion
%% precompensation applied to the ray model. Temporarily set
%% (xError,yError,zError) = (0,0,0) and reset later for ray model.
if DC.zCorrection || DC.zCorrection
    xError = OP.xError;
    yError = OP.yError;
    zError = OP.zError;
    OP.xError = 0;
    OP.yError = 0;
    OP.zError = eps;
end

%% Find extent of the FOV predicted by distortion model
[xFOV,yFOV,xFOV_minus,yFOV_minus,zFOV] = nonTelecentricAOL_Distortion(OP,Scan);

%% Plot extent of the FOV
plot_FOV(OP,xFOV*1e3,xFOV_minus*1e3,yFOV*1e3,yFOV_minus*1e3,zFOV*1e3)

%% Reset (xError,yError,zError) values
if DC.zCorrection || DC.zCorrection
    OP.xError = xError;
    OP.yError = yError;
    OP.zError = zError;
end

%% Find central foci for z-range
Scan.timePoints = 0;
Scan.Curvature = linspace(-1,1,21);
Scan.sampledXY_um = Scan.timePoints*OP.FOV_um;  % Sampled coordinates of the FOV
[FocalPts_Ray_um, ~, ~] = find_FocalPts(OP,Z,Scan,DC);

%% Plot foci
figure(gcf); hold on
Foci = permute(FocalPts_Ray_um*1e-3, [1,3,4,2]);
Foci = reshape(Foci, [], 3);
scatter3(Foci(:,1),Foci(:,2),Foci(:,3),80,'*','MarkerEdgeColor',rgb('Black'),'LineWidth',0.8);
xlim([-0.25 0.25])
ylim([-0.25 0.25])
zlim([-0.4 0.4])
xlabel('X (mm)')
ylabel('Y (mm)')
zlabel('Z (mm)')
pbaspect([1 1 2])
set(gca, 'FontName', 'times','FontSize',16)
view([35,10])

%% Plot rays for wavefront curvature = 0
Scan.Curvature = eps;
[~,RaysX,RaysY] = find_FocalPts(OP,Z,Scan,DC);
plot3(RaysX(:,9:13)*1e3,RaysY(:,9:13)*1e3,(Z.Zplanes(9:13)-Z.Z_normalised_zero)*1e3,'Color',[0 0.4470 0.7410],'LineWidth',0.8);
end


