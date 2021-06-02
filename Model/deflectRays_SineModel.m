
function [Rays_sinX,Rays_sinY,Deflect_sinX,Deflect_sinY] = deflectRays_SineModel(OP,a,b,X,Y,T,xOffset,yOffset,time,Timings,DC,Z,Zplanes,circlePixels)

%% AOD drives where f(t) = a + bt
b_x1 = b(1);
b_x2 = b(3);
b_y1 = b(2);
b_y2 = b(4);

a_x1 = a(1);
a_x2 = a(3);
a_y1 = a(2);
a_y2 = a(4);

%% Empty ray and deflection arrays
Rays_sinX = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Position of the rays in x (X,X,Z,T)
Rays_sinY = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Position of the rays in y (X,X,Z,T)
freq_sinX = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Frequency across the AODs at the x-ray positions
freq_sinY = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Frequency across the AODs at the y-ray positions
Deflect_sinX = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;    % Deflection by AODs and lenses in x
Deflect_sinY = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;    % Deflection by AODs and lenses in y

%% X Deflection - Sine Lens Model %%
% The position and deflection of the rays in x are calculated at each z-plane as
% they are deflected by the AOL and subsequent optics.

%% Input ray positions (zPlane = 1):
Rays_sinX(:,:,1,:) = X;

%% Input beam may have a convergence/divergence of 1/(OP.f_input_x) m^-1:
Deflect_sinX(:,:,1,:) = (X + xOffset)./OP.f_input_x;

%% X-Position of rays incident on the first (x) AOD (zPlane = 2):
Rays_sinX(:,:,2,:) = Rays_sinX(:,:,1,:)+ Deflect_sinX(:,:,1,:)*(Zplanes(2)-Zplanes(1));

%% Frequency across the first (x) AOD:
freq_sinX(:,:,2,:) = OP.Fc+a_x1+b_x1.*((Timings.Time_delay_xOffset + time + DC.timing_offsets_sin(1))+squeeze(Rays_sinX(:,:,2,:))./OP.Vac);

%% Ray deflection in the x-dir produced across the first (x) AOD:
Deflect_sinX(:,:,2,:) = Deflect_sinX(:,:,1,:)+OP.mode.* freq_sinX(:,:,2,:).*OP.lambda./OP.Vac;

%% X-Position of rays incident on the third (x) AOD (zPlane = 4):
Rays_sinX(:,:,4,:) = Rays_sinX(:,:,2,:)+Deflect_sinX(:,:,2,:).*(Zplanes(4)-Zplanes(2));

%% Frequency across the third (x) AOD:
freq_sinX(:,:,4,:) = OP.Fc+a_x2+b_x2.*((time - Timings.Time_delay_fc - Timings.Time_delay_xOffset + DC.timing_offsets_sin(2))-(squeeze(Rays_sinX(:,:,4,:)))./OP.Vac);

%% Ray deflection in the x-dir produced across the third (x) AOD:
Deflect_sinX(:,:,4,:) = Deflect_sinX(:,:,2,:)-OP.mode.* freq_sinX(:,:,4,:).*OP.lambda./OP.Vac;

%% X-Position of rays incident on the first relay lens (zPlane = 6):
Rays_sinX(:,:,6,:) = Rays_sinX(:,:,4,:)+Deflect_sinX(:,:,4,:).*(Zplanes(6)-Zplanes(4));

%% Ray deflection in the x-dir produced by the first relay lens:
Deflect_sinX(:,:,6,:) = Deflect_sinX(:,:,4,:)+(Rays_sinX(:,:,6,:)).*1/OP.f_R1;

%% X-Position of rays incident on the second relay lens (zPlane = 7):
Rays_sinX(:,:,7,:) = Rays_sinX(:,:,6,:)+Deflect_sinX(:,:,6,:).*(Zplanes(7)-Zplanes(6));

%% Ray deflection in the x-dir produced by the second relay lens:
Deflect_sinX(:,:,7,:) = Deflect_sinX(:,:,6,:)+(Rays_sinX(:,:,7,:)).*1./OP.f_R2;

%% X-Position of rays incident on the iris plane of the objective (zPlane = 8):
Rays_sinX(:,:,8,:) = Rays_sinX(:,:,7,:)+Deflect_sinX(:,:,7,:).*(Zplanes(8)-Zplanes(7));

%% Ray positions at intermediate z-planes:
Rays_sinX(:,:,3,:) = (0.5*(Rays_sinX(:,:,2,:)+Rays_sinX(:,:,4,:)));
Rays_sinX(:,:,5,:) = (0.5*(Rays_sinX(:,:,4,:)+Rays_sinX(:,:,6,:)));


%% Y Deflection - Sine Lens Model %%
% The position and deflection of the rays in y are calculated at each z-plane as
% they are deflected by the AOL and subsequent optics.

%% Input ray positions (zPlane = 1):
Rays_sinY(:,:,1,:) = Y;

%% Input beam may have a convergence/divergence of 1/(OP.f_input_y) m^-1:
Deflect_sinY(:,:,1,:) = (Y + yOffset)./OP.f_input_y;

%% Y-Position of rays incident on the second (y) AOD (zPlane = 3):
Rays_sinY(:,:,3,:) = Rays_sinY(:,:,1,:)+ Deflect_sinY(:,:,1,:)*(Zplanes(3)-Zplanes(1));

%% Frequency across the second (y) AOD:
freq_sinY(:,:,3,:) = OP.Fc+a_y1+b_y1.*((Timings.Time_delay_yOffset + time + DC.timing_offsets_sin(3))+squeeze(Rays_sinY(:,:,3,:))./OP.Vac);

%% Ray deflection in the y-dir produced across the second (y) AOD:
Deflect_sinY(:,:,3,:) = Deflect_sinY(:,:,1,:)+OP.mode.* freq_sinY(:,:,3,:).*OP.lambda./OP.Vac;

%% Y-Position of rays incident on the fourth (y) AOD (zPlane = 5):
Rays_sinY(:,:,5,:) = Rays_sinY(:,:,3,:)+Deflect_sinY(:,:,3,:).*(Zplanes(5)-Zplanes(3));

%% Frequency across the fourth (y) AOD:
freq_sinY(:,:,5,:) = OP.Fc+a_y2+b_y2.*((time - Timings.Time_delay_fc - Timings.Time_delay_yOffset + DC.timing_offsets_sin(4))-(squeeze(Rays_sinY(:,:,5,:)))./OP.Vac);

%% Ray deflection in the y-dir produced across the fourth (y) AOD:
Deflect_sinY(:,:,5,:) = Deflect_sinY(:,:,3,:)-OP.mode.* freq_sinY(:,:,5,:).*OP.lambda./OP.Vac;

%% Y-Position of rays incident on the first relay lens (zPlane = 6):
Rays_sinY(:,:,6,:) = Rays_sinY(:,:,5,:)+Deflect_sinY(:,:,5,:).*(Zplanes(6)-Zplanes(5));

%% Ray deflection in the y-dir produced by the first relay lens:
Deflect_sinY(:,:,6,:) = Deflect_sinY(:,:,5,:)+(Rays_sinY(:,:,6,:)).*1/OP.f_R1;

%% Y-Position of rays incident on the second relay lens (zPlane = 7):
Rays_sinY(:,:,7,:) = Rays_sinY(:,:,6,:)+Deflect_sinY(:,:,6,:).*(Zplanes(7)-Zplanes(6));

%% Ray deflection in the y-dir produced by the second relay lens:
Deflect_sinY(:,:,7,:) = Deflect_sinY(:,:,6,:)+(Rays_sinY(:,:,7,:)).*1./OP.f_R2;

%% Y-Position of rays incident on the iris plane of the objective (zPlane = 8)
Rays_sinY(:,:,8,:) = Rays_sinY(:,:,7,:)+Deflect_sinY(:,:,7,:).*(Zplanes(8)-Zplanes(7));

%% Ray positions at intermediate z-planes:
Rays_sinY(:,:,2,:) = (0.5*(Rays_sinY(:,:,1,:)+Rays_sinY(:,:,3,:)));
Rays_sinY(:,:,4,:) = (0.5*(Rays_sinY(:,:,3,:)+Rays_sinY(:,:,5,:)));


%% Sine Lens Objective - X & Y Deflection with Spherical Coordinates

xX = Rays_sinX(:,:,8,:); % X-Position of the rays in the iris plane
yY = Rays_sinY(:,:,8,:); % Y-Position of the rays in the iris plane

r = abs(xX+1i*yY);                          % Radial distance
theta = angle(xX+1i*yY);                    % Polar angle
phi = asin(r/OP.focal_length_effective);    % Azimuth angle

%% Find the x ray positions in the natural focal plane (zPlane = 11)
% Then back and forward propagate the deflection to find the positions in
% zPlanes 9 and 13, the objective plane and the plane 2f from the
% objective, respectively:
Rays_sinX(:,:,11,:) = -Deflect_sinX(:,:,7,:)*OP.focal_length;
Rays_sinX(:,:,9,:) = Rays_sinX(:,:,11,:) +((Zplanes(9)-Z.Z_normalised_zero).*tan(phi).*cos(theta));
Rays_sinX(:,:,13,:) = Rays_sinX(:,:,11,:) +((Zplanes(13)-Z.Z_normalised_zero).*tan(phi).*cos(theta));

%% Find the y ray positions in the natural focal plane (zPlane = 11)
% Then back and forward propagate the deflection to find the positions in
% zPlanes 9 and 13, the objective plane and the plane 2f from the
% objective, respectively:
Rays_sinY(:,:,11,:) = -Deflect_sinY(:,:,7,:)*OP.focal_length;
Rays_sinY(:,:,9,:) = Rays_sinY(:,:,11,:) +((Zplanes(9)-Z.Z_normalised_zero).*tan(phi).*sin(theta));
Rays_sinY(:,:,13,:) = Rays_sinY(:,:,11,:) +((Zplanes(13)-Z.Z_normalised_zero).*tan(phi).*sin(theta));

%% Ray positions at intermediate z-planes:
Rays_sinX(:,:,10,:) = (0.5*(Rays_sinX(:,:,9,:)+Rays_sinX(:,:,11,:)));
Rays_sinX(:,:,12,:) = (0.5*(Rays_sinX(:,:,11,:)+Rays_sinX(:,:,13,:)));
Rays_sinY(:,:,10,:) = (0.5*(Rays_sinY(:,:,9,:)+Rays_sinY(:,:,11,:)));
Rays_sinY(:,:,12,:) = (0.5*(Rays_sinY(:,:,11,:)+Rays_sinY(:,:,13,:)));

%% X and Y Deflection in the objective plane (zPlane = 11) - needed for
%% Fourier Model
Deflect_sinX(:,:,11,:) = (Rays_sinX(:,:,12,:)-Rays_sinX(:,:,10,:))/OP.focal_length_effective;
Deflect_sinY(:,:,11,:) = (Rays_sinY(:,:,12,:)-Rays_sinY(:,:,10,:))/OP.focal_length_effective;

end