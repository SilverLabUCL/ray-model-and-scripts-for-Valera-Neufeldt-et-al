function Error_R2 = find_Error_R2(z,Theta1,Theta2,Phi_o2,dz,dTheta1,dTheta2,dPhi_o2)

% T1 = dR2/dPhi_o2

t1 = cos(abs(Theta1-Theta2))+1;
t2 = sec(2*Phi_o2);
t2 = t2.^2;
t3 = cos(abs(Theta1-Theta2));
t4 = sec(Phi_o2);
t4 = t4.^2;

T1 = z*(t1*t2 - t3*t4);


% T2 = dR2/dz

t1 = tan(Phi_o2);
t2 = tan(2*Phi_o2);
t3 = cos(abs(Theta1-Theta2))+1;

T2 = 0.5*(t2 - 2*t1*t3) + t1;


% T3 = dR2/dTheta1 = dR2/dTheta2

t1 = sin(abs(Theta1-Theta2));
t2 = tan(2*Phi_o2);
t3 = tan(Phi_o2);

T3 = -0.5*z*t1*(t2-2*t3);

T1 = T1.^2*dPhi_o2.^2;
T2 = T2.^2*dz.^2;
T4 = T3.^2*dTheta1.^2;
T5 = T3.^2*dTheta2.^2;

Error_R2 = (T1 + T2 + T4 + T5).^0.5;

end
