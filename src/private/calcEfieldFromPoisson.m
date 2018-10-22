function field = calcEfieldFromPoisson(field, prm)
%calcEfieldFromPoisson Calculate Ex from Poisson equation
%

X2 = prm.X2; nx = prm.nx; nxp1 = prm.nxp1; nxp2 = prm.nxp2;

ex = field.ex;
rho = field.rho;

% This is wrong
%ex(X2) = ex(X2-1) + rho(X2);

for i = 2:nxp1
   ex(i)= ex(i-1) + rho(i);
end

ex0 = sum(ex(X2))/nx;
ex(X2) = ex(X2) - ex0;
ex(1) = ex(nxp1);
ex(nxp2) = ex(2);

field.ex = ex;

end
