function current(particle, field, jtime, prm)
% Calculate the current in one step


nx = prm.nx; nxp1 = prm.nxp1; nxp2 = prm.nxp2;
X2 = prm.X2;
np = prm.np; ns = prm.ns;
q = prm.q;

% references to class obj
f = field; 
p = particle;

f.ajx = zeros(nxp2,1);
f.ajy = zeros(nxp2,1);
f.ajz = zeros(nxp2,1);

%----
n2 = 0;
for k=1:ns
   n1 = n2;
   n2 = n2 + np(k);
   qh = q(k)*0.5;
   
   for m=(n1+1):n2
      ih = floor( p.x(m) + 1.5 );
      s2 = (p.x(m) + 1.5 - ih)*q(k);
      s1 = q(k) - s2;
      ih1= ih+1;
      
      f.ajy(ih)  = f.ajy(ih)  + p.vy(m)*s1;
      f.ajy(ih1) = f.ajy(ih1) + p.vy(m)*s2;
      
      f.ajz(ih)  = f.ajz(ih)  + p.vz(m)*s1;
      f.ajz(ih1) = f.ajz(ih1) + p.vz(m)*s2;
      
      %-- charge conservation method --
      if prm.iex
         qhs = qh * sign(p.vx(m));
         avx = abs(p.vx(m));
         
         x1 = p.x(m) + 2.0 - avx;
         x2 = p.x(m) + 2.0 + avx;
         i1 = floor(x1);
         i2 = floor(x2);
         
         % This is causing me speed issue
         f.ajx(i1) = f.ajx(i1) + (i2 - x1)*qhs;
         f.ajx(i2) = f.ajx(i2) + (x2 - i2)*qhs;
      end
   end
end

%-- boundary --
f.ajx(nxp1) = f.ajx(1) + f.ajx(nxp1);
f.ajx(2)    = f.ajx(2) + f.ajx(nxp2);

f.ajy(nxp1) = f.ajy(1) + f.ajy(nxp1);
f.ajy(2)    = f.ajy(2) + f.ajy(nxp2);
f.ajy(1)    = f.ajy(nxp1);

f.ajz(nxp1) = f.ajz(1) + f.ajz(nxp1);
f.ajz(2)    = f.ajz(2) + f.ajz(nxp2);

%--
f.ajy(X2) = 0.5*(f.ajy(X2) + f.ajy(X2-1));

%-- external current source ----
if prm.ajamp
   f.ajz(nx/2+1) = f.ajz(nx/2+1) + prm.ajamp*sin(prm.wj*jtime);
else
   %--cancellation of uniform Jx,Jy,Jz components---
   ajxu = sum(f.ajx(X2))/nx;
   ajyu = sum(f.ajy(X2))/nx;
   ajzu = sum(f.ajz(X2))/nx;
   f.ajx(X2) = f.ajx(X2) - ajxu;
   f.ajy(X2) = f.ajy(X2) - ajyu;
   f.ajz(X2) = f.ajz(X2) - ajzu;
end

end
