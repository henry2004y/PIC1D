function [field] = getCharge(particle,field,prm)
%getCharge Calculate the charge on the grid from particles
%

x = particle.x;
field.rho = prm.rho0;

n2 = 0;
for k=1:prm.ns
   n1 = n2;
   n2 = n1 + prm.np(k);
   for m = (n1+1):n2
      i  = floor(x(m) + 2.0);
      i1 = i + 1;
      s2 = (x(m)+ 2.0 - i)*prm.q(k);
      s1 = prm.q(k) - s2;
      field.rho(i ) = field.rho(i ) + s1;
      field.rho(i1) = field.rho(i1) + s2;
   end
end

field.rho(2) = field.rho(2) + field.rho(prm.nxp2) - prm.rho0(2);
field.rho(1) = field.rho(prm.nxp1);
field.rho(prm.nxp2) = field.rho(2);
		
end
