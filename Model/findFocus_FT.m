function [xFocus, yFocus, zFocus] = findFocus_FT(FT,OP,Scan,Z,approx_zFocus,TanX, TanY ,SineX, SineY, dX, dY)

% z_ref = focal plane of the Sine lens model by the least squares "focus finder".

% X path length difference between Sine model rays and the central ray =
% X_Intersect * sin(theta), where X_Intersect is the distance between where
% the central ray and nth ray intersect the z_ref axis and theta is the
% angle the nth ray makes with respect to the central ray. (Similarly for
% the y-direction)

warning off
T = Scan.timePoints*Scan.resolution*Scan.DwellTime;
xFocus = zeros(1,length(T));
yFocus = xFocus;
zFocus = xFocus;

for t = 1:length(T)
    
    %% Create a circular gaussian beam mask
    imageSizeX = size(SineX,1);
    imageSizeY = size(SineY,1);
    [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    
    centre = round(imageSizeX/2);
    radius = (imageSizeX-1)/2;
    circlePixels = (rowsInImage - centre).^2 ...
        + (columnsInImage - centre).^2 <= radius.^2;
    circlePixels = double(circlePixels);
    pixels = circlePixels == 0;
    circlePixels(pixels) = 0;
    
    s = 3.75e-03;
    e_squaredWidth = OP.RelayMag*sqrt(2)*2.35*s./sqrt(log(2));
    x = linspace(-0.5*OP.Aperture,0.5*OP.Aperture,imageSizeX);
    y = linspace(-0.5*OP.Aperture,0.5*OP.Aperture,imageSizeY);
    [x,y] = meshgrid(x,y);
    x = x - SineX(centre,centre,8,t);
    y = y - SineY(centre,centre,8,t);
    gauss =  (1/(2*pi()*s^2))*exp(-(x.^2 + y.^2)/(2*s^2));
    gauss = gauss/(max(max(gauss)));
    gauss = gauss.*circlePixels;
    gaussPixels = gauss;
    clear x y row col xoffsetTemp yoffsetTemp
    
    %% Find the dKx and dKy wavevector increment size
    dx = SineX(:,:,8,t);                        % dx/dz of the sine model rays
    dx = mean(diff(nonzeros(dx(centre,:))));
    dy = SineY(:,:,8,t);                        % dy/dz of the sine model rays
    dy = mean(diff(nonzeros((dy(:,centre)))));
    
    dKx = dx/(OP.focal_length_effective*OP.lambda);
    dKy = dy/(OP.focal_length_effective*OP.lambda);
    xFOV = 1/dKx;   % Spatial x limits of the FT
    yFOV = 1/dKy;   % Spatial y limits of the FT
    
    % Use an equally sized sample size in z
    dz = (abs(xFOV/FT.N)+abs(yFOV/FT.N))/2;
    
    % zPlanes of the PSF
    if approx_zFocus(t)>=0
        zPlanes = (approx_zFocus(t)-30*OP.lambda): 10*dz : (approx_zFocus(t)+30*OP.lambda);
    else
        zPlanes = (approx_zFocus(t)+30*OP.lambda): -10*dz : (approx_zFocus(t)-30*OP.lambda);
    end
    
    %% Find intersection of central ideal thin lens (reference) ray with the zPlanes
    % P0 and P1 are the start and end points of the reference rays
    P0 = [TanX(centre,centre,10,t),TanY(centre,centre,10,t),Z.Zplanes(10)-Z.Z_normalised_zero];
    P1 = [TanX(centre,centre,12,t),TanY(centre,centre,12,t),Z.Zplanes(12)-Z.Z_normalised_zero];
    
    % Empty arrays
    xIntersectCentre = zeros(1,length(zPlanes));
    yIntersectCentre = zeros(1,length(zPlanes));
    RayX = zeros((2*OP.numRays+1)^2,length(zPlanes));
    RayY = RayX;
    CentreRayX = xIntersectCentre;
    CentreRayY = CentreRayX;
    PhaseError = zeros(2*OP.numRays+1,2*OP.numRays+1,length(zPlanes));
    PSF = zeros(FT.N,FT.N,length(zPlanes));
    
    % Find the intersection pts of the reference rays with the zPlanes:
    for iz = 1:length(zPlanes)
        
        z_ref = zPlanes(iz);
        n = [0,0,1];        % normal to the xy plane at z = z_ref
        V0 = [0,0,z_ref];   % point in the plane z = z_ref
        [Intersect,~] = plane_line_intersect(n,V0,P0,P1);
        xIntersectCentre(iz) = Intersect(1);
        yIntersectCentre(iz) = Intersect(2);
        
    end
    
    %% Find the path length difference between the reference rays and the sine model rays
    for iz = 1:length(zPlanes)
        
        z_ref = zPlanes(iz);
        n = [0,0,1];        % normal to the xy plane at z = z_ref
        V0 = [0,0,z_ref];   % point in the plane z = z_ref
        i_ray = 1;
        
        % Empty arrays
        PT1 = zeros(2*OP.numRays+1,2*OP.numRays+1,3);
        PT2 = PT1;
        PD = zeros(2*OP.numRays+1,2*OP.numRays+1);
        
        for i = 1:size(SineX,1)
            for ii = 1:size(SineY,1)
                
                % Point in the plane perpendicular to the ray
                V_ref = [xIntersectCentre(iz), yIntersectCentre(iz), z_ref];
                % Normal to the plane perpendicular to ray
                n_ref = [-dX(i,ii), -dY(i,ii), 1];
                
                % Start and end point of the sine model ray
                P0 = [SineX(i,ii,10,t), SineY(i,ii,10,t), Z.Zplanes(10)-Z.Z_normalised_zero];
                P1 = [SineX(i,ii,12,t), SineY(i,ii,12,t), Z.Zplanes(12)-Z.Z_normalised_zero];
                
                % Intersection of the sine model ray and perpendicular plane
                [Intersect,~] = plane_line_intersect(n_ref,V_ref,P0,P1);
                x = Intersect(1);
                y = Intersect(2);
                PT2(i,ii,:) = [x, y, Intersect(3)];
                
                % Intersection of the sine model ray and z = z_ref plane
                [Intersect,~] = plane_line_intersect(n,V0,P0,P1);
                x0 = Intersect(1);
                y0 = Intersect(2);
                PT1(i,ii,:) = [x0,y0,z_ref];
                
                % Path length difference = distance between intersection
                % points (PT1 and PT2)
                PD(i,ii) = sqrt((PT2(i,ii,1)-PT1(i,ii,1))^2 + (PT2(i,ii,2)-PT1(i,ii,2))^2 + (PT2(i,ii,3)-PT1(i,ii,3))^2);
                
                if PT1(i,ii,3) > PT2(i,ii,3)
                    PD(i,ii) = -PD(i,ii);
                end
                
                % Record ray positions for plotting
                if i ~= centre && ii ~= centre
                    if Intersect(1) == 0
                        Intersect(1) = nan;
                    end
                    if Intersect(2) == 0
                        Intersect(2) = nan;
                    end
                end
                
                RayX(i_ray,iz) = Intersect(1);
                RayY(i_ray,iz) = Intersect(2);
                
                if i == centre && ii == centre
                    CentreRayX(iz) = Intersect(1);
                    CentreRayY(iz) = Intersect(2);
                end
                
                i_ray = i_ray + 1;
            end
        end
        
        
        PhaseErr = OP.n*2*pi*PD./OP.lambda; % Phase Error
        PhaseError(:,:,iz) = PhaseErr;
        
        Amp = 1*gaussPixels;                % Amplitude of the gaussian beam
        f = Amp.*exp(1i*PhaseErr);          % Wavefunction in the iris plane
        
        w = hann(size(f,1)).*hann(size(f,1))';
        f = f.*w;
        
        F = fftshift(fft2(f, FT.N,FT.N));   % FT of the wavefunction in the iris plane
        I = F.*conj(F);                     % Intensity at the z_ref plane
        if FT.TwoPhoton
            I = I.^2;                       % 2-photon intensity
        end
        
        PSF(:,:,iz) = I;
        
    end
    
    
    MaxZ = max(max(max(PSF)));                          % Find max. intensity of the PSF
    [xx,yy,zz] = ind2sub(size(PSF), find(PSF == MaxZ)); % Indices of the max. intensity point
    
    % x limits of the Fourier transform
    X = linspace(xFOV/2, -xFOV/2, size(PSF,1));
    X = X + xIntersectCentre(zz);
    % y limits of the Fourier transform
    Y = linspace(yFOV/2, -yFOV/2, size(PSF,1));
    Y = Y + yIntersectCentre(zz);
    
    % x,y,z coordinates of the max. intensity point
    xFocus(t) = X(yy);
    yFocus(t) = Y(xx);
    zFocus(t) = zPlanes(zz);
end
end




