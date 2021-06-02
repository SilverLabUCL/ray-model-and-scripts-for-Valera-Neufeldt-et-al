function [Error_Phi_o2] = find_Error_Phi_o2(Phi_o1,dPhi_o1,dB1,B2,dB2,A,n)

% B1 = Beta1
% B2 = Beta2
% A = WedgeAngle

t1 = sin(B2 - Phi_o1)/n;
t2 = asin(t1) - A;
t3 = (n*sin(t2)).^2;

t4 = cos(B2 - Phi_o1)*cos(t2);
t5 = (1 - t1.^2).^0.5;
t6 = (1 - t3).^0.5;

T1 = t4/(t5*t6); % T1 = dPhi_o2/dBeta2

t1 = sin(Phi_o1-B2)/n;
t2 = asin(t1) + A;
t3 = (n*sin(t2)).^2;

t4 = cos(Phi_o1-B2)*cos(t2);
t5 = (1 - t1.^2).^0.5;
t6 = (1 - t3).^0.5;

T2 = t4/(t5*t6); % T1 = dPhi_o2/dPhi_o1

Error_Phi_o2 = (T2.^2*dPhi_o1.^2) + (T1.^2*dB2.^2) + dB1.^2;
Error_Phi_o2 = Error_Phi_o2.^0.5;

end