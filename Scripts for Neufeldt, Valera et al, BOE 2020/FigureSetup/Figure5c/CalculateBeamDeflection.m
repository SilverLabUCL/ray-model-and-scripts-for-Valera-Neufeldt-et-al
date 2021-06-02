
%% This function calculates the beam deflection caused by the Risley prisms and is based on the equations %%
%% found in the ThorLabs Application Notes. An estimate of the experimental error is also found by usual  %%
%% differential error propagation. Where simply a numerical error is stated, the calculations were done   %%
%% on paper for the sake of keeping the script easily readable.                                           %%
%%

function [xDeflectionRd, yDeflectionRd, xDeflection, yDeflection, xDeflectionError, yDeflectionError, z2] = ...
    CalculateBeamDeflection(theta1,theta2,DistanceToMirror)

n_glass = 1.517;                                    % Refractive index of the prism glass
WedgeAngle = deg2rad(3.8833);                       % Prism wedge angle (radians)
PrismDiameter = 25.4;                               % Prism diameter (mm)
MaxT = 4.72;                                        % Maximum thickness of the wedged prism
CentreT = MaxT - 0.5*PrismDiameter*tan(WedgeAngle); % Thickness at the centre of the prism
S = 13.4;                                           % Distance between the flat faces of the two prisms (mm)
D = 40;                                             % Value found experimentally, used in calculating the tilt of prism 1 - see notes pg 17
dTheta = 0.5*atan(2/49);                            % The angle between the defined and actual home position of the prisms.
                                                    % Value found experimentally, see notes pages 12 and 16                        
Error_dTheta = deg2rad(0.005);                      % On-paper calculation of the error in dTheta

Beta1 = atan(D/780.6)-WedgeAngle;                   % Prism 1 tilt angle - see notes page 17 
Error_Beta1 = deg2rad(0.0025);                      % On-paper calculation of the error in Beta1
Beta2 = atan(6.5/(376.9-CentreT));                  % Prism 2 tilt angle - see notes page 16
Error_Beta2 = deg2rad(0.0027);                      % On-paper calculation of the error in Beta2

% The equations for Phi_i1, Phi_i2, Phi_o1, Phi_o2, Phi_p1 and Phi_p2
% may all be found on page 13 of the notes
Phi_i1 = WedgeAngle - Beta1;        % Angle of incidence - prism 1
Error_Phi_i1 = Error_Beta1;         % The error associated with the manufacturer's value
                                    % for the wedge angle is assumed to be negligible

% Exit angle - prism 1
Phi_o1 = sin(Phi_i1)/n_glass;
Phi_o1 = asin(Phi_o1);
Phi_o1 = n_glass*sin(WedgeAngle - Phi_o1);
Phi_o1 = asin(Phi_o1) - Beta1;
Error_Phi_o1 = find_Error_Phi_o1(WedgeAngle,Beta1,Error_Beta1,n_glass);

% Angle of propagation within prism 1
Phi_p1 = sin(Phi_i1)/n_glass;
Phi_p1 = asin(Phi_p1);
Error_Phi_p1 = find_Error_Phi_p1(Phi_i1,Error_Phi_i1,n_glass);

Phi_i2 = Beta2 - Phi_o1;            % Angle of incidence - prism 2
Error_Phi_i2 = (Error_Phi_o1.^2 + Error_Beta2.^2)^0.5;

Phi_o2 = sin(Phi_i2)/n_glass;
Phi_o2 = asin(Phi_o2);
Phi_o2 = n_glass*sin(WedgeAngle - Phi_o2);
Phi_o2 = asin(Phi_o2) - WedgeAngle + Beta1;

Error_Phi_o2 = find_Error_Phi_o2(Phi_o1,Error_Phi_o1,Error_Beta1,Beta2,Error_Beta2,WedgeAngle,n_glass);

% Angle of propagation within prism 2
Phi_p2 = sin(Phi_i2)/n_glass;
Phi_p2 = asin(Phi_p2);
Error_Phi_p2 = find_Error_Phi_p1(Phi_i2,Error_Phi_i2,n_glass);

% dTheta is added only to the angle of prism 2 - see equ. 24
% Adding a 1.5/2 degree experimental error in setting the mount position.
theta1 = deg2rad(theta1);
Error_Theta1 = Error_dTheta + deg2rad(0.75);
theta2 = deg2rad(theta2)-dTheta;
Error_Theta2 = Error_dTheta + deg2rad(0.75);

% Calculation for Tdash and associated error - see pages 8 and 9
% Tdash is used to find the z-distance travelled by the ray
% through prism 2 (depends on the difference in theta1 & theta2).
Rdash = S*tan(Phi_o1) + CentreT*tan(Phi_i1 - Phi_p1);
Error_Rdash = find_Error_Rdash(Beta1,Error_Beta1,WedgeAngle,n_glass,CentreT,S,Phi_o1,Error_Phi_o1);
Tdash = Rdash*tan(Phi_i2)*cos(abs(theta1-theta2));
Error_Tdash = ((Error_Rdash/Rdash)^2 + (Error_Phi_i2/Phi_i2)^2 + (1/cos(abs(theta1-theta2)))^2)^0.5;
Error_Tdash = abs(Error_Tdash) * Tdash;

z1 = DistanceToMirror + S + 150;                % Distance between prism 1 and the 150 f lens
Error_z1 = 5;                                   % Estimate of the error in z1
z2 = DistanceToMirror + 150 - CentreT - Tdash;  % Distance between prism 2 and the 150 f lens
Error_z2 = 5;                                   % Estimate of the error in z2

% Calculation for Rd and associated error - see page 13
% Rd is the minimum beam deflection caused by the prisms.
Rd = Rdash + (CentreT + Tdash)*tan(Phi_i2 - Phi_p2);
Error_Rd = find_Error_Rd(WedgeAngle,Beta1,Beta2,Phi_o1,theta1,theta2,Error_Beta1,Error_Beta2,...
    Error_Phi_o1,Error_Theta1,Error_Theta2,Rdash,n_glass,CentreT,Error_Rdash);

% Equations for the beam deflection caused by each prism on pages 13 and 27
R1 = z1*tan(Phi_o1); % Beam deflection caused by prism 1
Error_R1 = find_Error_R1(z1,Error_z1,Phi_o1,Error_Phi_o1);
R2 = z2*tan(Phi_o2) + ((0.5*(cos(abs(theta1-theta2))+1))*(z2*tan(2*Phi_o2)-2*z2*tan(Phi_o2)));
Error_R2 = find_Error_R2(z2,theta1,theta2,Phi_o2,Error_z2,Error_Theta1,Error_Theta2,Error_Phi_o2);

yDeflectionRd = Rd*sin(theta1);             % Minimum x-deflection at a distance of 150 mm
xDeflectionRd = Rd*cos(theta1);             % Minimum y-deflection at a distance of 150 mm

xDeflection = (Rd+R1)*cos(theta1) + R2*cos(theta2); % Total x-deflection at 150 mm
yDeflection = (Rd+R1)*sin(theta1) + R2*sin(theta2); % Total y-deflection at 150 mm

% Error propagation to find the error in the X and Y deflection at 150 mm:
Error_sinTheta1 = cos(theta1)*Error_Theta1;
Error_sinTheta2 = cos(theta2)*Error_Theta2;
Error_cosTheta1 = sin(theta1)*Error_Theta1;
Error_cosTheta2 = sin(theta2)*Error_Theta2;

dy1 = R1*sin(theta1)*(((Error_R1/R1)^2 + (Error_sinTheta1/sin(theta1))^2)^0.5);
dy2 = R2*sin(theta2)*(((Error_R2/R2)^2 + (Error_sinTheta2/sin(theta2))^2)^0.5);
dy3 = Rd*sin(theta1)*(((Error_Rd/Rd)^2 + (Error_sinTheta1/sin(theta1))^2)^0.5);

yDeflectionError = sqrt((dy1^2 + dy2^2 + dy3^2));

dx1 = R1*cos(theta1)*(((Error_R1/R1)^2 + (Error_cosTheta1/cos(theta1))^2)^0.5);
dx2 = R2*cos(theta2)*(((Error_R2/R2)^2 + (Error_cosTheta2/cos(theta2))^2)^0.5);
dx3 = Rd*cos(theta1)*(((Error_Rd/Rd)^2 + (Error_cosTheta1/cos(theta1))^2)^0.5);

xDeflectionError = sqrt((dx1^2 + dx2^2 + dx3^2));

end

