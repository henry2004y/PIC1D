%
% plotwave
%   Vy,Vz,Ey,Ez,By,Bz - X plot
%
function hdiag = plotwave(hdiag, jdiag)

  global prm ren
  global nxp1 nxp2
  global bx0 by0

  global ex ey ez
  global    by bz
  global vx vy vz
  global x

  global X2
  
  [view_az,view_el] = view;
 
  vvy = vy*ren.v;
  vvz = vz*ren.v;
  xx  = x*ren.x;

  eey = ey(X2)*ren.e;
  eez = ez(X2)*ren.e;
  bby = (by(X2)-by0)*ren.b;  
  bbz = bz(X2)*ren.b;  

  m = prm.vmax*ren.v;

  flag_normalize = 1; % normalize
  if flag_normalize
    vvy = vvy/(prm.vmax*ren.v);
    vvz = vvz/(prm.vmax*ren.v);
    eey = eey/prm.emax;
    eez = eez/prm.emax;
    bby = bby/prm.bmax;  
    bbz = bbz/prm.bmax;  
    m = 1;
  end

  if jdiag == 1
    hold on
  
    if prm.icolor
      n1 = 0;
      n2 = 0;
      for k = 1:prm.ns
        n1 = n2+1;
        n2 = n2+prm.np(k);
        n12 = n1:n2;
        hplot(k) = plot3(xx(n12),vvy(n12),vvz(n12),'.', ...
                         'Color',hdiag.color(mod(k-1,7)+1,:));
        try;set(hplot(k),'DisplayName',sprintf('Sp. %d',k));catch;end;
      end
    else
      hplot = plot3(xx,vvy,vvz,'k.');
    end
  
    xf = 0:prm.dx:(prm.nx-1)*ren.x;
    hplotf(1) = plot3(xf,eey,eez,'c-','LineWidth',2);
    hplotf(2) = plot3(xf,bby,bbz,'m-','LineWidth',2);
    try;set(hplotf(1),'DisplayName',sprintf('Ey, Ez'));catch;end;
    try;set(hplotf(2),'DisplayName',sprintf('By, Bz'));catch;end;

    hold off;
  
    set(gca, 'DataAspectRatio',[prm.nx*ren.x/3.6,m,m])
    axis([0 prm.nx*ren.x -m m -m m]);
    xlabel('X')
    ylabel('Vy, Ey, By')
    zlabel('Vz, Ez, Bz')
    title(sprintf('Vmax:%4.2g, Emax:%4.2g, Bmax:%4.2g', ...
                  prm.vmax*ren.v,prm.emax,prm.bmax))
    
    hdiag.plt(hdiag.nplt).hplot = hplot;
    hdiag.plt(hdiag.nplt).hplotf = hplotf;

  else

    hplot = hdiag.plt(hdiag.nplt).hplot;
    hplotf = hdiag.plt(hdiag.nplt).hplotf;

    if prm.icolor
      n1 = 0;
      n2 = 0;
      for k = 1:prm.ns
        n1 = n2+1;
        n2 = n2+prm.np(k);
        n12 = n1:n2;
        set(hplot(k),'xdata',xx(n12),'ydata',vvy(n12),'zdata',vvz(n12))
      end
    else
      set(hplot,'xdata',xx,'ydata',vvy,'zdata',vvz)
    end
    set(hplotf(1),'ydata',eey,'zdata',eez)
    set(hplotf(2),'ydata',bby,'zdata',bbz)
  end
  
  view(view_az,view_el)

return
