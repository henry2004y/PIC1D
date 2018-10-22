function [by,bz] = bfield(by,bz, ey,ez)

  global nxp1 nxp2

  k=2:nxp1;
  by(k) = by(k) +ez(  k) -ez(k-1);
  bz(k) = bz(k) -ey(k+1) +ey(k  );

  by(nxp2)= by(2);
  bz(nxp2)= bz(2);
  by(1)   = by(nxp1);
  bz(1)   = bz(nxp1);

return
