%
% Time series field plot (Ex,Ey,Ez,By,Bz)
%
function hdiag = plotts(hdiag,n,jdiag)

  global prm ren
  global X1 X2 X3
  
  global ifdiag
  global field

  fielddata = squeeze(field(n,X2,:));

  switch n
   case {1,2,3}
    fielddata = fielddata*ren.e;
    m = prm.emax;
   case {4,5}
    fielddata = fielddata*ren.b;
    m = prm.bmax;
  end
  
  str = {'Ex','Ey','Ez','By','Bz'};

  if jdiag == 1
    hold on;

    tt = (0:ifdiag:prm.ntime)*prm.dt;
    xx = 0:prm.dx:(prm.nx-1)*ren.x;

    hdiag.plt(hdiag.nplt).hplot = imagesc(xx,tt,fielddata');
    xlabel('X');
    ylabel('Time');
    title(sprintf('%s (min: %g, max: %g)',char(str(n)),-m,m));
  
    axis([0, xx(end), 0,tt(end)]);
    caxis([-m, m]);
    
    hold off;
  else
    set(hdiag.plt(hdiag.nplt).hplot,'cdata',fielddata');
  end

  if m <= 0
    m = max(max(abs(fielddata)));
    caxis([-m, m]);
    title(sprintf('%s (min: %5.3g, max: %5.3g)',char(str(n)),-m,m));
  end
return
