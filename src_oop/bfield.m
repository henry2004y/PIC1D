function [field] = bfield(field,prm)
% Update magnetic field in one step
  
X2 = prm.X2;
f = field; % reference to Field obj

f.by(X2) = f.by(X2) + f.ez(  X2) - f.ez(X2-1);
f.bz(X2) = f.bz(X2) - f.ey(X2+1) + f.ey(X2  );

f.by(prm.nxp2)= f.by(2);
f.bz(prm.nxp2)= f.bz(2);
f.by(1)   = f.by(prm.nxp1);
f.bz(1)   = f.bz(prm.nxp1);

end
