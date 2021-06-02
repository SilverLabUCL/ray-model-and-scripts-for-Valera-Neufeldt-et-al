function Error_Rd = find_Error_Rd(A,B1,B2,Phi_o1,Theta1,Theta2,dB1,dB2,...
    dPhi_o1,dTheta1,dTheta2,Rdash,n,T,dRdash)

% T1 = dRd/dRdash

t1 = Phi_o1 - B2;
t2 = asin((A-B1)/n);
t2 = t2 + Phi_o1 - B2;
t3 = cos(abs(Theta1-Theta2)) + 1;

T1 = tan(t1)*tan(t2)*t3;

% T2 = dRd/dPhi_o1

t1 = Rdash*cos(abs(Theta1-Theta2));
t2 = sec(Phi_o1-B2);
t2 = t2.^2;
t3 = -asin(sin(B1-A)/n) - B2 + Phi_o1;
t3 = tan(t3);
t4 = t1*tan(Phi_o1-B2) - T;
t5 = (sec(t3)).^2;

T2 = t1*t2*t3 + t4*t5;

% T3 = dRd/dB2

t1 = Rdash*cos(abs(Theta1-Theta2));
t2 = sec(B2-Phi_o1);
t2 = t2.^2;
t3 = asin(sin(B1-A)/n) + B2 - Phi_o1;
t3 = tan(t3);
t4 = t1*tan(B2 - Phi_o1) + T;
t5 = (sec(t3)).^2;

T3 = t1*t2*t3 + t4*t5;

% T4 = dRd/dB1

t1 = tan(Phi_o1 - B2)*t1;
t1 = T - t1;
t2 = cos(B1-A);
t3 = t5;
t4 = asin(sin(B1-A)/n);
t4 = (1-t4.^2).^0.5;
t4 = n*t4;

T4 = (t1*t2*t3)/t4;

% T5 = dRd/dTheta1 = dRd/dTheta2

t1 = -tan(Phi_o1-B2);
t2 = asin(sin(B1-A)/n) - B2 + Phi_o1;
t2 = tan(t2);
t3 = Rdash*sin(abs(Theta1-Theta2));

T5 = t1*t2*t3;

T1 = T1.^2*dRdash.^2;
T2 = T2.^2*dPhi_o1.^2;
T3 = T3.^2*dB2.^2;
T4 = T4.^2*dB1.^2;
T6 = T5.^2*dTheta1.^2;
T7 = T5.^2*dTheta2.^2;

Error_Rd = (T1 + T2 + T3 + T4 + T6 + T7).^0.5;

end







