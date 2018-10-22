%
%
%
function [ex,ey,ez] = efield(ex,ey,ez, by,bz, ajx,ajy,ajz)

  global prm

  global nxp1 nxp2
  global X1 X2 X3
  global tcs
  
  if prm.iex == 0
    ex(:) = 0;
  else
    ex(X2) = ex(X2)-2.0*ajx(X2);
    ex(1) = ex(nxp1);
    ex(nxp2) = ex(2);       
  end

  ey(X2) = ey(X2) -tcs*(bz(X2)-bz(X1)) -2.0*ajy(X2);
  ez(X2) = ez(X2) +tcs*(by(X3)-by(X2)) -2.0*ajz(X2);

  ey(1) = ey(nxp1);
  ez(1) = ez(nxp1);
  ey(nxp2) = ey(2);
  ez(nxp2) = ez(2);

return
