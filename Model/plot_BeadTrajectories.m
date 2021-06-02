%% Plot the tracked bead trajectories
function [Error,STD,STE] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot)
cd(Exp.dataLocation);
Tracks = xml2struct(Exp.fileName);

%% Info about this C-z-stack:
numberBeads = length(Tracks.Tracks.particle);           % number of tracked beads
zCentre = round(Exp.numberPlanes/2);                    % z = 0 plane
FOV_microns = 2*OP.xyScaling*Scan.AccAngle;             % Field of view
NumberPixelsPerMicron = Scan.resolution/FOV_microns;    % Ratio to convert between pixels and microns
zRange = (Exp.numberPlanes-1)*Exp.StepSize_microns;     % Z remote range
Z = linspace(zRange/2,-zRange/2,Exp.numberPlanes);      % Z planes


%% Load the xy coordinates of the tracked bead trajectories
bead = 0;
for n = 1:numberBeads
    
    %% Check that only trajectories spanning the full length of z are kept,
    %% sometimes TrackMate makes errors and includes data on shorter
    %% trajectories
    if strcmp(Tracks.Tracks.particle{1,n}.Attributes.nSpots,num2str(Exp.numberPlanes))
        bead = bead+1;
        for zPlane = 1:Exp.numberPlanes
            xyBeadPosition(1,bead,zPlane) = abs(str2num(Tracks.Tracks.particle{1,n}.detection{1,zPlane}.Attributes.x)-512);
            xyBeadPosition(2,bead,zPlane) = str2num(Tracks.Tracks.particle{1,n}.detection{1,zPlane}.Attributes.y);
        end
    end
    
end

%% Convert xy bead positions to microns
X = squeeze(xyBeadPosition(1,:,:)/NumberPixelsPerMicron);
X = X - FOV_microns/2;
xyBeadPosition(1,:,:) = X;
Y = squeeze(xyBeadPosition(2,:,:)/NumberPixelsPerMicron);
Y = Y - FOV_microns/2;
xyBeadPosition(2,:,:) = Y;

%% Reshape matrices for plotting
X2 = reshape(X,[1,bead*length(Z)]);
Y2 = reshape(Y,[1,bead*length(Z)]);
Z2 = repmat(Z,[bead,1]);
Z2 = reshape(Z2,[1,bead*length(Z)]);

%% Plot trajectories
figure(gcf)
if strcmp(Scan.ScanDirection,'x') && to_plot
    
    hold on
    scatter3(Y2,X2,Z2,50,'.','MarkerEdgeColor',colour)
    hold on
    scatter3(Y(:,1),X(:,1),repmat(Z(1),[bead,1]),100,'+','MarkerEdgeColor',rgb('DarkOrange'),'LineWidth',1.5)
    hold on
    scatter3(Y(:,zCentre),X(:,zCentre),repmat(Z(zCentre),[bead,1]),100,'x','MarkerEdgeColor',rgb('Gray'),'LineWidth',1.5)
    
elseif strcmp(Scan.ScanDirection,'y') && to_plot
    hold on
    scatter3(X2,-Y2,Z2,50,'.','MarkerEdgeColor',colour)
    hold on
    scatter3(X(:,1),-Y(:,1),repmat(Z(1),[bead,1]),100,'+','MarkerEdgeColor',rgb('DarkOrange'),'LineWidth',1.5)
    hold on
    scatter3(X(:,zCentre),-Y(:,zCentre),repmat(Z(zCentre),[bead,1]),100,'x','MarkerEdgeColor',rgb('Gray'),'LineWidth',1.5)
    
end

%% Find the positional error for the trajectories in the outer regions of the FOV
% Find trajectories with coordinates outside the min and max limits
min_um = -OP.FOV_um/4;
max_um = OP.FOV_um/4;
[~, xMin, ~] = find(xyBeadPosition(1,:,zCentre) < min_um);
[~, yMin, ~] = find(xyBeadPosition(2,:,zCentre) < min_um);
[~, xMax, ~] = find(xyBeadPosition(1,:,zCentre) > max_um);
[~, yMax, ~] = find(xyBeadPosition(2,:,zCentre) > max_um);
EdgeTrajectories = unique([xMin,yMin,xMax,yMax]);

%% Include only trajectories with coordinates outside the min and max limits
xyBeadPosition = xyBeadPosition(:,EdgeTrajectories,:);

%% Empty arrays
xError = 2*zeros(size(EdgeTrajectories));
yError = 2*zeros(size(EdgeTrajectories));

ii = 1;

%% Find the absolute x and y error wrt the position at z = 0
for i = 1:length(EdgeTrajectories)
    
    xError(ii) = abs(xyBeadPosition(1,i,1)-xyBeadPosition(1,i,zCentre));
    yError(ii) = abs(xyBeadPosition(2,i,1)-xyBeadPosition(2,i,zCentre));
    ii = ii+1;
    
    xError(ii) = abs(xyBeadPosition(1,i,end)-xyBeadPosition(1,i,zCentre));
    yError(ii) = abs(xyBeadPosition(2,i,end)-xyBeadPosition(2,i,zCentre));
    ii = ii+1;
    
end

%% Absolute mean error, standard deviation and standard error
Error = (xError.^2 + yError.^2).^0.5;
STD = std(Error);
STE = STD/(length(Error).^0.5);
Error = mean(Error);

end