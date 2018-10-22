%
%
% m=1: ex
%   2: ey
%   3: ez
%   4: by
%   5: bz
function hdiag = plotkspectrum(hdiag, m, jdiag)

  global ren prm
  global X1 X2 X3

  global bx0 by0
  
  global ex ey ez
  global    by bz
  
  %
  switch m
   case 1
    f = ex(X2);
    re = ren.e;
   case 2
    f = ey(X2);
    re = ren.e;
   case 3
    f = ez(X2);
    re = ren.e;
   case 4
    f = by(X2)-by0;
    re = ren.b;
   case 5
    f = bz(X2);
    re = ren.b;
  end    

  %
  ksp = kspectr(f);
  ksp = ksp*re;
  ksp2 = ksp(2:end);
  
  %
  if jdiag == 1
    kmin = 2*pi/prm.nx;
    kmax = kmin*(prm.nx/2);
    hdiag.plt(hdiag.nplt).kmax = kmax;
    hdiag.plt(hdiag.nplt).kmin = kmin;
    k = 0:kmin:(kmax-kmin);

    hdiag.plt(hdiag.nplt).hplot = plot(k,ksp,'k-');
    
    set(gca,'Yscale','log');
    xlabel('k');
    str={'Ex','Ey','Ez','By','Bz'};
    ylabel(str(m));
  else
    set(hdiag.plt(hdiag.nplt).hplot,'ydata',ksp);
  end
  
  %
  mmax = max(ksp2);
  mmin = min(ksp2);
  if mmax == 0
    mmax = 1;
    mmin = 0.01;
  end
  mmax=10^ceil(log10(mmax));
  mmin=10^floor(log10(mmin));
  
  kmax = hdiag.plt(hdiag.nplt).kmax;
  kmin = hdiag.plt(hdiag.nplt).kmin;
  axis([0 kmax mmin mmax]);
  
return