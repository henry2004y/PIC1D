function eng = energy(field,particle,prm)
% Calculate the energy for diagnostic

% reference to class obj
f = field;
p = particle;

X2 = prm.X2;
nx = prm.nx;
cs = prm.cs;
by0 = prm.by0;
np = prm.np;
mass = prm.mass;

eng = zeros(3,1);

% electric
te = sum(f.ex(X2).^2 + f.ey(X2).^2 + f.ez(X2).^2);
eng(1) = 0.5*te/nx;

% magnetic
eng(2) = 0.5*sum((f.by(X2) - by0).^2 + f.bz(X2).^2)*cs/nx;

% kinetic
n2 = 0;
for k=1:prm.ns
   n1  = n2 + 1;
   n2  = n2 + np(k);
   
   m = n1:n2;
   ke = sum(prm.cv ./sqrt(cs - p.vx(m).^2 - p.vy(m).^2 - p.vz(m).^2) - 1.0);
   eng(3) = eng(3) + ke*mass(k)*cs/nx;
end

end
