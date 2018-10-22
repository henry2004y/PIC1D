%
% phase space plot
% 
function hdiag = plotphs(hdiag, n, jdiag)
  global prm ren npt

  global cs
  
  global vx vy vz
  global x

  switch n
   case 1
       vv = vx*ren.v;
   case 2
       vv = vy*ren.v;
   case 3
       vv = vz*ren.v;
  end
  xx = x*ren.x;

  if jdiag == 1
    hold on

    mksize = 4+ceil(32/sqrt(npt));;

    if prm.icolor
      n1 = 0;
      n2 = 0;
      color = get(gca,'ColorOrder');
      for k = 1:prm.ns
        n1 = n2+1;
        n2 = n2+prm.np(k);
        n1n2 = n1:n2;
        hplot(k) = plot(xx(n1n2),vv(n1n2),'k.', ...
                        'color',color(mod(k-1,7)+1,:), ...
                        'MarkerSize',mksize);
        try;set(hplot(k),'DisplayName',sprintf('Sp. %d',k));catch;end;
      end
    else
      hplot = plot(xx,vv,'k.','MarkerSize',mksize);
    end

    % 
    if prm.iparam
      % CV
      h = plot([0,prm.nx*ren.x],[prm.cv*ren.v,prm.cv*ren.v] ,'k:');
      try;set(h,'DisplayName','CV');catch;end;
      h = plot([0,prm.nx*ren.x],-[prm.cv*ren.v,prm.cv*ren.v],'k:');
      try;set(h,'DisplayName','CV');catch;end;
      % VD
      if n == 1
        for l = 1:prm.ns
          ux = prm.vd(l)*cos(prm.pch(l)/180*pi);
          g = prm.cv/sqrt(cs + prm.vd(l)^2);
          vv = ux*g;
          h = plot([0,prm.nx*ren.x],[vv*ren.v,vv*ren.v],'k-.');
          try;set(h,'DisplayName',sprintf('VD(%d)',l));catch;end;
        end
      end
    end
    
    hold off

    m = prm.vmax*ren.v;
    axis([0 prm.nx*ren.x -m m]);
    xlabel('X');
    str={'Vx','Vy','Vz'};
    ylabel(str(n))
  
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
        set(hplot(k),'xdata',xx(n12),'ydata',vv(n12));
      end
    else
      set(hplot,'xdata',xx,'ydata',vv);
    end
    
  end
  
return

