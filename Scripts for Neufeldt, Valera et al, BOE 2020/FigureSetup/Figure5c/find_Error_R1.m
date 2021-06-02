function Error_R1 = find_Error_R1(z,dz,Phi_o1,dPhi_o1)

t1 = (dz/z).^2;
t2 = dPhi_o1*(sec(Phi_o1).^2);
t2 = (t2/tan(Phi_o1)).^2;

Error_R1 = (t1 + t2).^0.5;

end