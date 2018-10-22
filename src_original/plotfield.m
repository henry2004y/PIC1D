%
% Field plot (Ex,Ey,Ez,By,Bz)
%
function hdiag = plotfield(hdiag, n, jdiag)
  global prm ren
  global nxp2
  global X1 X2 X2

  global ex ey ez
  global by bz
  global bx0 by0
  
  switch n
   case 1
    f = ex*ren.e;
    m = prm.emax;
   case 2
    f = ey*ren.e;
    m = prm.emax;
   case 3
    f = ez*ren.e;
    m = prm.emax;
   case 4
    f = (by-by0)*ren.b;
    m = prm.bmax;
   case 5
    f = bz*ren.b;
    m = prm.bmax;
  end

  if jdiag == 1
    xx = 0:prm.dx:(prm.nx-1)*ren.x;
    hdiag.plt(hdiag.nplt).hplot(n) = plot(xx, f(X2),'k-','LineWidth',2);

    if m > 0 
      axis([0 (prm.nx-1)*ren.x  -m m]);
    else
      set(gca,'xlim',[0 (prm.nx-1)*ren.x]);
    end
    xlabel('X');
    str = {'Ex','Ey','Ez','By','By'};
    ylabel(str(n))
  else
    set(hdiag.plt(hdiag.nplt).hplot(n),'ydata',f(X2))
  end
    
return
