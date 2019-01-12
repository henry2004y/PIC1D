function particle = updateVelocity(particle, field, prm)
%updateVelocity Update velocity in one step.
%
%INPUTS:
% particle: particle info
% field   : field info
% prm     : simulation parameters
%
%OUTPUTS:
% particle: particle info
%
% The orginal code uses a loop over particles, which is slow in Matlab and
% not suitable for transforming to GPU-enabled code. I rewrite the Boris
% method with matrix operation to make it much faster.

nxp1 = prm.nxp1; nxp2 = prm.nxp2; ns = prm.ns; np = prm.np;
qm = prm.qm;
bx0 = prm.bx0;
cs = prm.cs;
X1 = prm.X1; X2 = prm.X2; X3 = prm.X3;

% References
x = particle.x;
vx = particle.vx; vy = particle.vy; vz = particle.vz;
ex = field.ex; ey = field.ey; ez = field.ez;
by = field.by; bz = field.bz;

if prm.UseGPU
   work1 = zeros(nxp2,1,'gpuArray');
   work2 = zeros(nxp2,1,'gpuArray');
else
   work1 = zeros(nxp2,1);
   work2 = zeros(nxp2,1);
end
work1(X2) = 0.5*(ex(X1) + ex(X2));
work1(nxp2)= work1(2);
work2(X2) = 0.5*(by(X2) + by(X3));
work2(1) = work2(nxp1);

%-----
n2 = 0;
for k=1:ns % Loop over species
   n1 = n2;
   n2 = n2 + np(k);
   m = (n1+1):n2;
   i = floor(x(m) + 2.0);
   sf2 = (x(m) + 2.0 - i)*qm(k);
   sf1 = qm(k) - sf2;
   
   ih = floor(x(m) + 1.5);
   sh2 = (x(m) + 1.5 - ih)*qm(k);
   sh1 = qm(k) - sh2;
   
   i1 = i + 1;
   ih1 = ih + 1;
   
   ex1 = sf1.*work1(i) + sf2.*work1(i1);
   ey1 = sf1.*ey(i)  + sf2.*ey( i1);
   ez1 = sh1.*ez(ih) + sh2.*ez(ih1);
   
   bx1 = bx0.*prm.qm(k);
   by1 = sh1.*work2(ih) + sh2.*work2(ih1);
   bz1 = sh1.*bz(ih)  + sh2.*bz(ih1);
   
   g = prm.cv ./ sqrt(cs - vx(m).^2 - vy(m).^2 - vz(m).^2);
   
   ux = vx(m).*g + ex1;
   uy = vy(m).*g + ey1;
   uz = vz(m).*g + ez1;
   
   g = prm.cv ./ sqrt(cs + ux.^2 + uy.^2 + uz.^2);
   
   bx1 = bx1.*g;
   by1 = by1.*g;
   bz1 = bz1.*g;
   
   boris = 2 ./ (1+ bx1.^2 + by1.^2 + bz1.^2);
   
   uxt = ux + uy.*bz1 - uz.*by1;
   uyt = uy + uz.*bx1 - ux.*bz1;
   uzt = uz + ux.*by1 - uy.*bx1;
   
   ux = ux + boris.*(uyt.*bz1 - uzt.*by1) + ex1;
   uy = uy + boris.*(uzt.*bx1 - uxt.*bz1) + ey1;
   uz = uz + boris.*(uxt.*by1 - uyt.*bx1) + ez1;
   
   g = prm.cv ./ sqrt(cs + ux.^2 + uy.^2 + uz.^2);
   
   vx(m) = ux.*g;
   vy(m) = uy.*g;
   vz(m) = uz.*g;
end


particle.vx = vx; particle.vy = vy; particle.vz = vz;

end