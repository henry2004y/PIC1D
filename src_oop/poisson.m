function poisson(field, prm)
% Calculate Ex from Poisson equation

f = field; % reference to the Field obj

f.ex(prm.X2) = f.ex(prm.X2-1) + f.rho(prm.X2);

ex0 = sum(f.ex(prm.X2))/prm.nx;
f.ex(prm.X2) = f.ex(prm.X2) - ex0;
f.ex(1) = f.ex(prm.nxp1);
f.ex(prm.nxp2) = f.ex(2);

end
