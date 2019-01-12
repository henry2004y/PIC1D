function field = current(particle, field, jtime, prm)
%CURRENT Calculate the current in one step.
%
% The function used to be deal with one particle at a time with for loop. I
% rewrite the kernel with matrix operations to make it at least 5 times
% faster. 
% Note that the results are not exactly the same for some tests! For each
% step, it is down to machine precision, but as the timestep grows, you can
% see small differences. To be honest, I don't know why.

nx = prm.nx; nxp1 = prm.nxp1; nxp2 = prm.nxp2;
X2 = prm.X2;
np = prm.np; ns = prm.ns;
q = prm.q;
ajamp = prm.ajamp;
wj = prm.wj;

% references
x = particle.x;
vx = particle.vx; vy = particle.vy; vz = particle.vz;

if prm.UseGPU
   ajx = zeros(nxp2,1,'gpuArray');
   ajy = zeros(nxp2,1,'gpuArray');
   ajz = zeros(nxp2,1,'gpuArray');
else
   ajx = zeros(nxp2,1);
   ajy = zeros(nxp2,1);
   ajz = zeros(nxp2,1);
end

%----
n2 = 0;
for k=1:ns
   n1 = n2;
   n2 = n2 + np(k);
   qh = q(k)*0.5;
   
   % This works for all the particles of this species together. For the old
   % scheme per particle, see the original source code or the review
   % history.
   m = (n1+1):n2;
   ih = floor(x(m) + 1.5);
   s2 = (x(m) + 1.5 - ih)*q(k);
   s1 = q(k) - s2;
   
   iMax = max(ih);
   ajy(1:iMax)   = ajy(1:iMax)   + accumarray(ih,vy(m).*s1);
   ajy(2:iMax+1) = ajy(2:iMax+1) + accumarray(ih,vy(m).*s2);
   ajz(1:iMax)   = ajz(1:iMax)   + accumarray(ih,vz(m).*s1);
   ajz(2:iMax+1) = ajz(2:iMax+1) + accumarray(ih,vz(m).*s2);

   %-- charge conservation method --
   if prm.iex
      qhs = qh * sign(vx(m));
      avx = abs(vx(m));
      
      x1 = x(m) + 2.0 - avx;
      x2 = x(m) + 2.0 + avx;
      i1 = floor(x1);
      i2 = floor(x2);
      
      iMax = max(i1);
      ajx(1:iMax) = ajx(1:iMax) + accumarray(i1,(i2 - x1).*qhs);
      iMax = max(i2);
      ajx(1:iMax) = ajx(1:iMax) + accumarray(i2,(x2 - i2).*qhs);
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
ajy(X2) = 0.5*(ajy(X2) + ajy(X2-1));

%-- external current source ----
if ajamp
   ajz(nx/2+1) = ajz(nx/2+1) + ajamp*sin(wj*jtime);
else
   %--cancellation of uniform Jx,Jy,Jz components---
   ajxu = sum(ajx(X2))/nx;
   ajyu = sum(ajy(X2))/nx;
   ajzu = sum(ajz(X2))/nx;
   ajx(X2) = ajx(X2) - ajxu;
   ajy(X2) = ajy(X2) - ajyu;
   ajz(X2) = ajz(X2) - ajzu;
end

field.ajx = ajx; field.ajy = ajy; field.ajz = ajz;

end