function Error_Phi_p1 = find_Error_Phi_p1(Phi_i1,dPhi_i1,n)

t1 = cos(Phi_i1);
t2 = sin(Phi_i1);
t3 = (t2/n).^2;
t4 = (1-t3).^0.5;

Error_Phi_p1 = t1/(n*t4);
Error_Phi_p1 = dPhi_i1*Error_Phi_p1;

end
