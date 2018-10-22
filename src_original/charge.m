%
%
%
function rho = charge(x)

  global prm
  global nxp1 nxp2

  global q
  global rho0

  rho = rho0;

  n2 = 0;
  for k=1:prm.ns
    n1 = n2;
    n2 = n1 + prm.np(k);
    for m = (n1+1):n2
      i  = floor(x(m)+ 2.0);
      i1 = i+1;
      s2 = (x(m)+ 2.0 - i)*q(k);
      s1 = q(k) - s2;
      rho(i ) = rho(i ) + s1;
      rho(i1) = rho(i1) + s2;
    end
  end
	
  rho(2)    = rho(2) +rho(nxp2) -rho0(2);
  rho(1)    = rho(nxp1);
  rho(nxp2) = rho(2);
		
return
