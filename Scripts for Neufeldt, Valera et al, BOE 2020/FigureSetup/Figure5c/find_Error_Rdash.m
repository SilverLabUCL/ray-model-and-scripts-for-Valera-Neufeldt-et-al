function Error_Rdash = find_Error_Rdash(B1,dB1,A,n,T,S,Phi_o1,dPhi_o1)


t1 = cos(B1-A);
t2 = sin(B1-A)/n;
t3 = asin(t2) - B1 + A;
t4 = (1 - t2.^2).^0.5;
t5 = t1/(n*t4);

T1 = T*(t5 - 1)*(sec(t3)).^2; % T1 = dRdash/dBeta1

T2 = S*(sec(Phi_o1)).^2; % T2 = dRdash/dPhi_o1

Error_Rdash = (T1.^2*dB1.^2) + (T2.^2*dPhi_o1.^2);
Error_Rdash = Error_Rdash.^0.5;

end

