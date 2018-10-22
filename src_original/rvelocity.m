function [vx,vy,vz] = rvelocity(vx,vy,vz, ex,ey,ez, by,bz, x)

  global prm

  global bx0 by0
  global cs

  global nxp1 nxp2
  global X1 X2 X3

  work1 = zeros(nxp2,1);
  work2 = zeros(nxp2,1);
  work1(X2)  = 0.5*(ex(X1)+ex(X2));
  work1(nxp2)= work1(2);
  work2(X2)  = 0.5*(by(X3)+by(X2));
  work2(1)   = work2(nxp1);

  %--
  n2=0;
  for  k=1:prm.ns
    n1  = n2;
    n2  = n2 + prm.np(k);

    for m = (n1+1):n2
      i = floor(x(m) +2.0);
      sf2 = (x(m) +2.0 -i)*prm.qm(k);
      sf1 = prm.qm(k) - sf2;
     
      ih = floor(x(m) +1.5);
      sh2 = (x(m) +1.5 -ih)*prm.qm(k);
      sh1 = prm.qm(k) - sh2;

      i1 = i+1;
      ih1 = ih+1;
  
      ex1 = sf1*work1(i) + sf2*work1(i1);
      ey1 = sf1*ey(i)    + sf2*ey( i1);
      ez1 = sh1*ez(ih)   + sh2*ez(ih1);

      bx1 = bx0*prm.qm(k);
      by1 = sh1*work2(ih)+ sh2*work2(ih1);
      bz1 = sh1*bz(ih)   + sh2*bz(ih1);
	        
      g = prm.cv /sqrt(cs - vx(m)^2 - vy(m)^2 - vz(m)^2);

      ux = vx(m)*g + ex1;
      uy = vy(m)*g + ey1;
      uz = vz(m)*g + ez1;

      g = prm.cv/sqrt(cs + ux*ux +uy*uy +uz*uz);

      bx1 = bx1*g;
      by1 = by1*g;
      bz1 = bz1*g;

      boris = 2.0/(1+ bx1*bx1 +by1*by1 +bz1*bz1);

      uxt = ux + uy*bz1 - uz*by1;
      uyt = uy + uz*bx1 - ux*bz1;
      uzt = uz + ux*by1 - uy*bx1;

      ux = ux + boris*(uyt*bz1 -uzt*by1) +ex1;
      uy = uy + boris*(uzt*bx1 -uxt*bz1) +ey1;
      uz = uz + boris*(uxt*by1 -uyt*bx1) +ez1;

      g = prm.cv /sqrt(cs + ux*ux + uy*uy + uz*uz);

      vx(m) =ux*g;
      vy(m) =uy*g;
      vz(m) =uz*g;
    end
  end

return;
