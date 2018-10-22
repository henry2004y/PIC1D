function rvelocity(particle, field, prm)
% Update velocity in one step

% References to class obj
p = particle;
f = field;

nxp1 = prm.nxp1; nxp2 = prm.nxp2; ns = prm.ns; np = prm.np;
qm = prm.qm; 
bx0 = prm.bx0;
cs = prm.cs;
X1 = prm.X2; X2 = prm.X2; X3 = prm.X3;

work1 = zeros(nxp2,1);
work2 = zeros(nxp2,1);
work1(X2) = 0.5*(f.ex(X1) + f.ex(X2));
work1(nxp2)= work1(2);
work2(X2) = 0.5*(f.by(X3) + f.by(X2));
work2(1) = work2(nxp1);

%-----
n2 = 0;
for k=1:ns
   n1 = n2;
   n2 = n2 + np(k);
   
   for m=(n1+1):n2
      i = floor(p.x(m) + 2.0);
      sf2 = (p.x(m) + 2.0 - i)*qm(k);
      sf1 = qm(k) - sf2;
      
      ih = floor(p.x(m) + 1.5);
      sh2 = (p.x(m) + 1.5 - ih)*qm(k);
      sh1 = qm(k) - sh2;
      
      i1 = i + 1;
      ih1 = ih + 1;
      
      ex1 = sf1*work1(i) + sf2*work1(i1);
      ey1 = sf1*f.ey(i)  + sf2*f.ey( i1);
      ez1 = sh1*f.ez(ih) + sh2*f.ez(ih1);
      
      bx1 = bx0*prm.qm(k);
      by1 = sh1*work2(ih) + sh2*work2(ih1);
      bz1 = sh1*f.bz(ih)  + sh2*f.bz(ih1);
      
      g = prm.cv / sqrt(cs - p.vx(m)^2 - p.vy(m)^2 - p.vz(m)^2);
      
      ux = p.vx(m)*g + ex1;
      uy = p.vy(m)*g + ey1;
      uz = p.vz(m)*g + ez1;
      
      g = prm.cv/sqrt(cs + ux*ux + uy*uy + uz*uz);
      
      bx1 = bx1*g;
      by1 = by1*g;
      bz1 = bz1*g;
      
      boris = 2.0/(1+ bx1*bx1 + by1*by1 + bz1*bz1);
      
      uxt = ux + uy*bz1 - uz*by1;
      uyt = uy + uz*bx1 - ux*bz1;
      uzt = uz + ux*by1 - uy*bx1;
      
      ux = ux + boris*(uyt*bz1 - uzt*by1) + ex1;
      uy = uy + boris*(uzt*bx1 - uxt*bz1) + ey1;
      uz = uz + boris*(uxt*by1 - uyt*bx1) + ez1;
      
      g = prm.cv /sqrt(cs + ux*ux + uy*uy + uz*uz);
      
      % this is causing speed issue. Why?
      p.vx(m) = ux*g;
      p.vy(m) = uy*g;
      p.vz(m) = uz*g;
   end
end

end
