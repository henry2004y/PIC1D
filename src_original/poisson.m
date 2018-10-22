%
%
%
function ex = poisson(ex, rho)

  global nxp1 nxp2
  global X1 X2 X3

  global prm
  
  for i = 2:nxp1
    ex(i)= ex(i-1)+rho(i);
  end

  ex0 = sum(ex(X2))/prm.nx;
  ex(X2)  = ex(X2) -ex0;
  ex(1)   = ex(nxp1);
  ex(nxp2)= ex(2);

return
