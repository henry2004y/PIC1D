function [field] = updateEfield(field,prm)
%updateEfield Update the electric field in one step
%
%INPUTS:
% field: field info
% prm  : simulation parameters
%
%OUTPUTS:
% field: field info

nxp1 = prm.nxp1; nxp2 = prm.nxp2;
tcs = prm.tcs; iex = prm.iex;
X1 = prm.X1; X2 = prm.X2; X3 = prm.X3;

ex = field.ex; ey = field.ey; ez = field.ez;
by = field.by; bz = field.bz;
ajx = field.ajx; ajy = field.ajy; ajz = field.ajz;

if iex == 0
   ex(:) = 0;
else
   ex(X2) = ex(X2) - 2*ajx(X2);
   ex(1) = ex(nxp1);
   ex(nxp2) = ex(2);
end

ey(X2) = ey(X2) - tcs*(bz(X2) - bz(X1)) - 2*ajy(X2);
ez(X2) = ez(X2) + tcs*(by(X3) - by(X2)) - 2*ajz(X2);

ey(1) = ey(nxp1);
ez(1) = ez(nxp1);
ey(nxp2) = ey(2);
ez(nxp2) = ez(2);

field.ex = ex; field.ey = ey; field.ez = ez;

end
