
function [dPhi_o1] = find_Error_Phi_o1(A,B,dB,n)

% A = WedgeAngle
% B = Beta1
% n = n_glass

t1 = sin(B-A)/n;
t2 = asin(t1)+A;

t3 = cos(B-A)*cos(t2);
t4 = (1-t1.^2).^0.5;
t5 = (1 - n.^2*(sin(t2)).^2).^0.5;

dPhi_o1 = (t3/(t4*t5) - 1)*dB;

end


