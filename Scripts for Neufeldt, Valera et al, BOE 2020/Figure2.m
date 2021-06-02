%% Script to generate Figure 2, original script by Paul Kirkby, modified to
%% match format of distortion equations given in paper. F.N. 25.05.2021
%%

% Optical parameters given in B. F. Grewe, F. F. Voigt, M. van \mu€™t Hoff, and F. Helmchen, \mu€œFast two-layer two-photon imaging of neuronal cell
% populations using an electrically tunable lens,\mu€? Biomed. Opt. Express 2(7), 2035\mu€“2046 (2011)
initialise_script();

n       = 4/3;              % Refractive index (water)
f       = 4e-3;             % Focal length of the 40x olympus objective in water
x       = [-144 144];       % x FOV limits
thetaX  = x.*1e-6./f;       % Beam semi-scan angle in x

% Find xError from the parameters given in Helmchen and Grewe
beamRadius = 4e-3;          % Radius of input beam at remote focusing aperture
rhoX = 0.1;                 % Radial offset in x direction of central ray of input beam
xError = beamRadius*rhoX;   % Misalignment of the remote focus unit (RFU) in x

% Find zError from the parameters given in Grewe and Helmchen
Zd = f*n+0.8e-3;            % Position of plane conjugate to the output of the RFU
D = f*n/(Zd-f*n);           % Magnification distortion factor
zError = f*D;               % Misalignment of the RFU in z

% Find the wavefront curvature (Cv) range used, given the z range
z_max = 375e-6;          % From paper
z_min = -108e-6;         % From paper
Cv_max = -z_max./(z_max.*zError + n*f.^2);
Cv_min = -z_min./(z_min.*zError + n*f.^2);
Cv =(linspace(Cv_max,Cv_min,10))';  % Wavefront curvature imparted by the RFU

% Calculate xz FOV given by distortion model equations
z_new = -f.^2.*Cv.*n./(Cv.*zError + 1);             % Eq. (1) main paper
x = (f.*thetaX - f.*Cv.*xError)./(Cv.*zError + 1);  % Eq. (2) main paper

figure(); hold on
title('Figure 2')

%% Plot Fig. 2a
subplot(2,2,1)
plot(x*1e6,z_new*1e6,'r','LineWidth',1.5)
xlim([-250 250])
ylim ([-130 400])
axis equal
hold on
plot([-144 144],[0 0],'k','LineWidth',1.5) % z = 0
ylabel('Distance from natural plane (\mum)')
set(gca,'xtick',[])
set(gcf, 'Renderer', 'Painters');
set(gca, 'FontName', 'times','FontSize',12)

%% Plot Fig. 2b
subplot(2,2,2)
plot(x*1e6,z_new*1e6,'r','LineWidth',1.5)
xlim([-250 250])
ylim ([-130 400])
axis equal
hold on
xlabel('Distance from center (\mum)')
ylabel('Distance from natural plane (\mum)')
set(gcf, 'Renderer', 'Painters');
set(gca, 'FontName', 'times','FontSize',12)
% Plot z-planes
parfor iz = 1:size(z_new,1)
    plot([x(iz,1)*1e6 x(iz,2)*1e6], [z_new(iz)*1e6 z_new(iz)*1e6], 'k', 'LineWidth',1.5)
end

% Find inverse of the distorted FOV and the precompensated FOV
z_new = (linspace(z_max,z_min,10))';                % z-range
Cv_corr = -z_new./(z_new.*zError + n*f.^2);         % Eq. (4) main paper
z_corr_inv = -f.^2.*Cv_corr.*n./(Cv_corr.*0 + 1);   % z-range of the inverse field
z_corr = -f.^2.*Cv_corr.*n./(Cv_corr.*zError + 1);  % z-range using precompensated curvature range, Eq. (1)

x_new = [-144 144]*1e-06;   % x-limits
thetaX_corr = Cv_corr.*xError + x_new.*(Cv_corr.*zError+1)./f;          % Eq. (5) main paper
x_corr_inv = (f.*thetaX_corr - f.*Cv_corr.*0)./(Cv_corr.*0 + 1);        % x-range of the inverse field
x_corr = (f.*thetaX_corr - f.*Cv_corr.*xError)./(Cv_corr.*zError + 1);  % x-range using precompensated semi-scan angle

%% Plot inverse of distortion, Fig. 2c
subplot(2,2,3)
plot(x_corr_inv*1e6,z_corr_inv*1e6,'r','LineWidth',1.5)
xlim([-250 250])
ylim ([-130 400])
axis equal
hold on
xlabel('Distance from center (\mum)')
ylabel('Distance from natural plane (\mum)')
set(gcf, 'Renderer', 'Painters');
set(gca, 'FontName', 'times','FontSize',12)
% Plot z-planes
parfor iz = 1:size(z_new,1)
    plot([x_corr_inv(iz,1)*1e6 x_corr_inv(iz,2)*1e6], [z_corr_inv(iz)*1e6 z_corr_inv(iz)*1e6], 'k', 'LineWidth',1.5);hold on;
end

%% Plot precompensated FOV, Fig. 2d
subplot(2,2,4)
plot(x_corr*1e6,z_corr*1e6,'r','LineWidth',1.5)
xlim([-250 250])
ylim ([-130 400])
axis equal
hold on
xlabel('Distance from center (\mum)')
ylabel('Distance from natural plane (\mum)')
set(gcf, 'Renderer', 'Painters');
set(gca, 'FontName', 'times','FontSize',12)
% Plot z-planes
for iz = 1:size(z_new,1)
    plot([x_corr(iz,1)*1e6 x_corr(iz,2)*1e6], [z_corr(iz)*1e6 z_corr(iz)*1e6], 'k', 'LineWidth',1.5);hold on;
end
%%
