%
%
%
function [ajx, ajy, ajz] = current(ajx,ajy,ajz, vx,vy,vz, x, jtime)

  global prm
  global nxp1 nxp2
  global X1 X2 X3
  global q

  ajx = zeros(nxp2,1);
  ajy = zeros(nxp2,1);
  ajz = zeros(nxp2,1);
  
  %--
  n2=0;
  for k=1:prm.ns
    n1  = n2;
    n2  = n2 + prm.np(k);
    qh = q(k)*0.5;

    for m = (n1+1):n2
      ih = floor( x(m) + 1.5 );
      s2 = (x(m) + 1.5 - ih)*q(k);
      s1 = q(k) - s2;
      ih1= ih+1;

      ajy(ih)  = ajy(ih)  + vy(m)*s1;
      ajy(ih1) = ajy(ih1) + vy(m)*s2;

      ajz(ih)  = ajz(ih)  + vz(m)*s1;
      ajz(ih1) = ajz(ih1) + vz(m)*s2;

      %-- charge conservation method --
      if prm.iex
        qhs = qh * sign(vx(m));
        avx = abs(vx(m));

        x1 = x(m) + 2.0 -avx;
        x2 = x(m) + 2.0 +avx;
        i1 = floor(x1);
        i2 = floor(x2);

        ajx(i1) = ajx(i1) + (i2 - x1)*qhs;
        ajx(i2) = ajx(i2) + (x2 - i2)*qhs;
      end
    end
  end

  %-- boundary --
  ajx(nxp1) = ajx(1) + ajx(nxp1);
  ajx(2)    = ajx(2) + ajx(nxp2);

  ajy(nxp1) = ajy(1) + ajy(nxp1);
  ajy(2)    = ajy(2) + ajy(nxp2);
  ajy(1)    = ajy(nxp1);

  ajz(nxp1) = ajz(1) + ajz(nxp1);
  ajz(2)    = ajz(2) + ajz(nxp2);

  %--
  i=nxp1:-1:2;
  ajy(i) = (ajy(i) + ajy(i-1))*0.5;

  %-- external current source ----
  if prm.ajamp
    ajz(prm.nx/2+1) = ajz(prm.nx/2+1)+prm.ajamp*sin(prm.wj*jtime);
  else
  %--cancellation of uniform Jx,Jy,Jz components---
  ajxu = sum(ajx(2:nxp1))/prm.nx;    
  ajyu = sum(ajy(2:nxp1))/prm.nx; 
  ajzu = sum(ajz(2:nxp1))/prm.nx; 
  ajx(2:nxp1) = ajx(2:nxp1) -ajxu;
  ajy(2:nxp1) = ajy(2:nxp1) -ajyu;
  ajz(2:nxp1) = ajz(2:nxp1) -ajzu;
  end
  
  
  
return
