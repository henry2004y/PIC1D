function eng = getEnergy(field,particle,prm)
%getEnergy Calculate the energy for diagnostic

X2 = prm.X2;
nx = prm.nx;
cs = prm.cs;
by0 = prm.by0;
np = prm.np;
mass = prm.mass;

% references
ex = field.ex; ey = field.ey; ez = field.ez;
by = field.by; bz = field.bz;

vx = particle.vx; vy = particle.vy; vz = particle.vz;

if prm.UseGPU
   eng = zeros(3,1,'gpuArray');
else
   eng = zeros(3,1);
end
   
% electric energy
te = sum(ex(X2).^2 + ey(X2).^2 + ez(X2).^2);
eng(1) = 0.5*te/nx;

% magnetic energy
eng(2) = 0.5*sum((by(X2) - by0).^2 + bz(X2).^2)*cs/nx;

% kinetic energy
n2 = 0;
for k=1:prm.ns
   n1  = n2 + 1;
   n2  = n2 + np(k);
   
   m = n1:n2;
   ke = sum(prm.cv ./sqrt(cs - vx(m).^2 - vy(m).^2 - vz(m).^2) - 1.0);
   eng(3) = eng(3) + ke*mass(k)*cs/nx;
end

end
