%
% plotvs
%   velocity space plot
%
function hdiag = plotvs(hdiag,jdiag)

  global prm ren
  global nxp1 nxp2

  global vx vy vz
  
  [view_az,view_el] = view;
 
  vvx = vx*ren.v;
  vvy = vy*ren.v;
  vvz = vz*ren.v;

  m = prm.vmax*ren.v;

  if jdiag == 1
    hold on
    if prm.icolor
      n1 = 0;
      n2 = 0;
      for k = 1:prm.ns
        n1 = n2+1;
        n2 = n2+prm.np(k);
        n12 = n1:n2;
        hplot(k) = plot3(vvx(n12),vvy(n12),vvz(n12),'.', ...
                         'color',hdiag.color(mod(k-1,7)+1,:));
        try;set(hplot(k),'DisplayName',sprintf('Sp. %d',k));catch;end;
      end
    else
      hplot = plot3(vvx,vvy,vvz,'k.');
    end
    hold off;

    axis equal
    axis([-m m -m m -m m]);
    xlabel('Vx')
    ylabel('Vy')
    zlabel('Vz')

    hdiag.plt(hdiag.nplt).hplot = hplot;
  else
    hplot = hdiag.plt(hdiag.nplt).hplot;
    if prm.icolor
      n1 = 0;
      n2 = 0;
      for k = 1:prm.ns
        n1 = n2+1;
        n2 = n2+prm.np(k);
        n12 = n1:n2;
        set(hplot(k),'xdata',vvx(n12),'ydata',vvy(n12),'zdata',vvz(n12))
      end
    else
      set(hplot,'xdata',vvx,'ydata',vvy,'zdata',vvz)
    end
  end
  
  view(view_az,view_el)

return
