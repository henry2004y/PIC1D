function [field] = efield(field,prm)
% Update the electric field in one step


nxp1 = prm.nxp1; nxp2 = prm.nxp2;
tcs = prm.tcs;
X1 = prm.X1; X2 = prm.X2; X3 = prm.X3;

f = field; % reference to class obj

if prm.iex == 0
   f.ex(:) = 0;
else
   f.ex(X2) = f.ex(X2) - 2*f.ajx(X2);
   f.ex(1) = f.ex(nxp1);
   f.ex(nxp2) = f.ex(2);
end

f.ey(X2) = f.ey(X2) - tcs*(f.bz(X2) - f.bz(X1)) - 2*f.ajy(X2);
f.ez(X2) = f.ez(X2) + tcs*(f.by(X3) - f.by(X2)) - 2*f.ajz(X2);

f.ey(1) = f.ey(nxp1);
f.ez(1) = f.ez(nxp1);
f.ey(nxp2) = f.ey(2);
f.ez(nxp2) = f.ez(2);

end
