
function plot_FOV(OP,X_FOV,Y_FOV,X_FOV_minus,Y_FOV_minus,zFOV)
figure(gcf); hold on;

%% Extent of the FOV
xSum = X_FOV - X_FOV_minus;
ySum = Y_FOV - Y_FOV_minus;
xCentre = 0.5*(X_FOV + X_FOV_minus);
yCentre = 0.5*(Y_FOV + Y_FOV_minus);

xFOV = transpose([-0.5*xSum; 0.5*xSum] + xCentre);
yFOV = transpose([-0.5*ySum; 0.5*ySum] + yCentre);

%% Plot pink shaded FOV and z = 0 plane
plot_Planes(OP,xFOV,yFOV,zFOV)

end