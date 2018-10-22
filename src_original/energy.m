%
%
%
function eng = energy(ex,ey,ez,by,bz,vx,vy,vz)

  global prm ren
  global nxp1 nxp2
  global mass
  global cs
  global X1 X2 X3
  global by0
  
  eng = zeros(3,1);
  
  % electric
  te = sum(ex(X2).^2+ey(X2).^2+ez(X2).^2);
  eng(1) = 0.5*te/prm.nx;

  % magnetic
  eng(2) = 0.5*sum((by(X2)-by0).^2 + bz(X2).^2)*cs/prm.nx;

  % kinetic
  n2 = 0;
  for k=1:prm.ns
    n1  = n2+1;
    n2  = n2 + prm.np(k);
    
    m = n1:n2;
    ke = sum(prm.cv ./sqrt(cs-vx(m).^2-vy(m).^2-vz(m).^2)-1.0);
    eng(3) = eng(3)+ke*mass(k)*cs/prm.nx;
  end

return
