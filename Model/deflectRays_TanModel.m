function [RaysX,RaysY] = deflectRays_TanModel(OP,a,b,X,Y,T,xOffset,yOffset,time,Timings,DC,Zplanes,circlePixels)

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
RaysX = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Position of the rays in x (X,X,Z,T)
RaysY = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Position of the rays in y (X,X,Z,T)
freqX = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Frequency across the AODs at the x-ray positions
freqY = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;       % Frequency across the AODs at the y-ray positions
DeflectX = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;    % Deflection by AODs and lenses in x
DeflectY = zeros(2*OP.numRays+1,2*OP.numRays+1,size(Zplanes,2),size(T,2)).*circlePixels;    % Deflection by AODs and lenses in y

%% X Deflection - Thin Lens Model %%
% The position and deflection of the rays in x are calculated at each z-plane as
% they are deflected by the AOL and subsequent optics.

%% Input ray positions (zPlane = 1):
RaysX(:,:,1,:) = X;

%% Input beam may have a convergence/divergence of 1/(OP.f_input_x) m^-1:
DeflectX(:,:,1,:) = (X + xOffset)./OP.f_input_x;

%% X-Position of rays incident on the first (x) AOD (zPlane = 2):
RaysX(:,:,2,:) = RaysX(:,:,1,:)+ DeflectX(:,:,1,:)*(Zplanes(2)-Zplanes(1));

%% Frequency across the first (x) AOD:
freqX(:,:,2,:) = OP.Fc+a_x1+b_x1.*((Timings.Time_delay_xOffset + time + DC.timing_offsets(1))+squeeze(RaysX(:,:,2,:))./OP.Vac);

%% Ray deflection in the x-dir produced across the first (x) AOD:
DeflectX(:,:,2,:) = DeflectX(:,:,1,:)+OP.mode.* freqX(:,:,2,:).*OP.lambda./OP.Vac;

%% X-Position of rays incident on the third (x) AOD (zPlane = 4):
RaysX(:,:,4,:) = RaysX(:,:,2,:)+DeflectX(:,:,2,:).*(Zplanes(4)-Zplanes(2));

%% Frequency across the third (x) AOD:
freqX(:,:,4,:) = OP.Fc+a_x2+b_x2.*((-Timings.Time_delay_fc + time - Timings.Time_delay_xOffset + DC.timing_offsets(2))-(squeeze(RaysX(:,:,4,:)))./OP.Vac);

%% Ray deflection in the x-dir produced across the third (x) AOD:
DeflectX(:,:,4,:) = DeflectX(:,:,2,:)-OP.mode.* freqX(:,:,4,:).*OP.lambda./OP.Vac;

%% X-Position of rays incident on the first relay lens (zPlane = 6):
RaysX(:,:,6,:) = RaysX(:,:,4,:)+DeflectX(:,:,4,:).*(Zplanes(6)-Zplanes(4));

%% Ray deflection in the x-dir produced by the first relay lens:
DeflectX(:,:,6,:) = DeflectX(:,:,4,:)+(RaysX(:,:,6,:)).*1/OP.f_R1;

%% X-Position of rays incident on the second relay lens (zPlane = 7):
RaysX(:,:,7,:) = RaysX(:,:,6,:)+DeflectX(:,:,6,:).*(Zplanes(7)-Zplanes(6));

%% Ray deflection in the x-dir produced by the second relay lens:
DeflectX(:,:,7,:) = DeflectX(:,:,6,:)+(RaysX(:,:,7,:)).*1/OP.f_R2;

%% X-Position of rays incident on the iris plane of the objective (zPlane = 8):
RaysX(:,:,8,:) = RaysX(:,:,7,:)+DeflectX(:,:,7,:).*(Zplanes(8)-Zplanes(7));

%% X-Position of rays incident on the plane of the objective (zPlane = 9):
RaysX(:,:,9,:) = RaysX(:,:,7,:)+DeflectX(:,:,7,:).*(Zplanes(9)-Zplanes(7));

%% Ray deflection in the x-dir produced by the thin lens objective in water:
DeflectX(:,:,9,:) = DeflectX(:,:,7,:)+(RaysX(:,:,9,:)).*1/(OP.focal_length);
DeflectX(:,:,9,:) = DeflectX(:,:,9,:)/OP.n;

%% Ray positions in x at a distance 1f (zPlane = 11) and 2f (zPlane = 13) from the objective:
RaysX(:,:,11,:) = RaysX(:,:,9,:)+DeflectX(:,:,9,:).*(Zplanes(11)-Zplanes(9));
RaysX(:,:,13,:) = RaysX(:,:,9,:)+DeflectX(:,:,9,:).*(Zplanes(13)-Zplanes(9));

%% Ray positions at intermediate z-planes:
RaysX(:,:,3,:) = 0.5*(RaysX(:,:,2,:)+RaysX(:,:,4,:));
RaysX(:,:,5,:) = 0.5*(RaysX(:,:,4,:)+RaysX(:,:,6,:));

%% Focal position will later be found between zPlanes 10 and 12
RaysX(:,:,10,:) = 0.5*(RaysX(:,:,9,:)+RaysX(:,:,11,:));
RaysX(:,:,12,:) = 0.5*(RaysX(:,:,11,:)+RaysX(:,:,13,:));

%% Y Deflection - Thin Lens Model %%
% The position and deflection of the rays in y are calculated at each z-plane as
% they are deflected by the AOL and subsequent optics.

%% Input ray positions (zPlane = 1):
RaysY(:,:,1,:) = Y;

%% Input beam may have a convergence/divergence of 1/(OP.f_input_y) m^-1:
DeflectY(:,:,1,:) = (Y + yOffset)./OP.f_input_y;

%% Y-Position of rays incident on the second (y) AOD (zPlane = 3):
RaysY(:,:,3,:) = RaysY(:,:,1,:)+ DeflectY(:,:,1,:)*(Zplanes(3)-Zplanes(1));

%% Frequency across the second (y) AOD:
freqY(:,:,3,:) = OP.Fc+a_y1+b_y1.*((Timings.Time_delay_yOffset + time + DC.timing_offsets(3))+squeeze(RaysY(:,:,3,:))./OP.Vac);

%% Ray deflection in the y-dir produced across the second (y) AOD:
DeflectY(:,:,3,:) = DeflectY(:,:,1,:)+OP.mode.* freqY(:,:,3,:).*OP.lambda./OP.Vac;

%% Y-Position of rays incident on the fourth (y) AOD (zPlane = 5):
RaysY(:,:,5,:) = RaysY(:,:,3,:)+DeflectY(:,:,3,:).*(Zplanes(5)-Zplanes(3));

%% Frequency across the fourth (y) AOD:
freqY(:,:,5,:) = OP.Fc+a_y2+b_y2.*((-Timings.Time_delay_fc + time - Timings.Time_delay_yOffset + DC.timing_offsets(4))-(squeeze(RaysY(:,:,5,:)))./OP.Vac);

%% Ray deflection in the y-dir produced across the fourth (y) AOD:
DeflectY(:,:,5,:) = DeflectY(:,:,3,:)-OP.mode.* freqY(:,:,5,:).*OP.lambda./OP.Vac;

%% Y-Position of rays incident on the first relay lens (zPlane = 6):
RaysY(:,:,6,:) = RaysY(:,:,5,:)+DeflectY(:,:,5,:).*(Zplanes(6)-Zplanes(5));

%% Ray deflection in the y-dir produced by the first relay lens:
DeflectY(:,:,6,:) = DeflectY(:,:,5,:)+(RaysY(:,:,6,:)).*1/OP.f_R1;

%% Y-Position of rays incident on the second relay lens (zPlane = 7):
RaysY(:,:,7,:) = RaysY(:,:,6,:)+DeflectY(:,:,6,:).*(Zplanes(7)-Zplanes(6));

%% Ray deflection in the y-dir produced by the second relay lens:
DeflectY(:,:,7,:) = DeflectY(:,:,6,:)+(RaysY(:,:,7,:)).*1/OP.f_R2;

%% Y-Position of rays incident on the iris plane of the objective (zPlane = 8):
RaysY(:,:,8,:) = RaysY(:,:,7,:)+DeflectY(:,:,7,:).*(Zplanes(8)-Zplanes(7));

%% Y-Position of rays incident on the plane of the objective (zPlane = 9):
RaysY(:,:,9,:) = RaysY(:,:,7,:)+DeflectY(:,:,7,:).*(Zplanes(9)-Zplanes(7));

%% Ray deflection in the y-dir produced by the thin lens objective in water:
DeflectY(:,:,9,:) = DeflectY(:,:,7,:)+(RaysY(:,:,9,:)).*1/(OP.focal_length);
DeflectY(:,:,9,:) = DeflectY(:,:,9,:)/OP.n;

%% Ray positions in y at a distance 1f (zPlane = 11) and 2f (zPlane = 13) from the objective:
RaysY(:,:,11,:) = RaysY(:,:,9,:)+DeflectY(:,:,9,:).*(Zplanes(11)-Zplanes(9));
RaysY(:,:,13,:) = RaysY(:,:,9,:)+DeflectY(:,:,9,:).*(Zplanes(13)-Zplanes(9));

%% Ray positions at intermediate z-planes:
RaysY(:,:,2,:) = 0.5*(RaysY(:,:,1,:)+RaysY(:,:,3,:));
RaysY(:,:,4,:) = 0.5*(RaysY(:,:,3,:)+RaysY(:,:,5,:));

%% Focal position will later be found between zPlanes 10 and 12
RaysY(:,:,10,:) = 0.5*(RaysY(:,:,9,:)+RaysY(:,:,11,:));
RaysY(:,:,12,:) = 0.5*(RaysY(:,:,11,:)+RaysY(:,:,13,:));

end