%
%
%
function fv = vdist(v)

  global prm
  global q

  v2 =  prm.vmax;
  v1 = -v2;
  dv = (v2 - v1)/prm.nv;
  dvi = 1.0/dv;  

  fv = zeros(2,prm.nv+1);
    
  n1 = 0;
  n2 = 0;
  for k=1:prm.ns
    n1 = n2;
    n2 = n1 + prm.np(k);
    
    qabs = abs(q(k));
    if q(k) < 0
      qsign = 1;
    else
      qsign = 2;
    end
    
    for m = (n1+1):n2
      if (v(m) < v1) | (v(m) >= v2)
        continue;
      end
      vi = (v(m)-v1)*dvi+1;

      i = floor(vi);
      i1 = i+1;
      s2 = (vi -i)*qabs;
      s1 = qabs -s2;
      fv(qsign,i) = fv(qsign,i) + s1;
      fv(qsign,i1)= fv(qsign,i1)+ s2;
    end
  end 
  f = sum(fv,2)*dv;
  if f(1)
      fv(1,:) = fv(1,:)/f(1);
  end
  if f(2)
      fv(2,:) = fv(2,:)/f(2);
  end
  
return
