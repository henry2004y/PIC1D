function [field] = updateBfield(field,prm)
%updateBfield Update magnetic field in one step
  
X2 = prm.X2;
nxp1 = prm.nxp1; nxp2 = prm.nxp2;

ey = field.ey; ez = field.ez;
by = field.by; bz = field.bz;

by(X2) = by(X2) + ez(  X2) - ez(X2-1);
bz(X2) = bz(X2) - ey(X2+1) + ey(X2  );

by(nxp2)= by(2);
bz(nxp2)= bz(2);
by(1)   = by(nxp1);
bz(1)   = bz(nxp1);

field.by = by;
field.bz = bz;

end
