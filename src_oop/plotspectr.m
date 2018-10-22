function plotspectr(n,prm,field,ren)
%
% wk plot
%


  X2 = prm.X2;
  cs = prm.cs;
  
  str = {'Ex','Ey','Ez','By','Bz'};
  fielddata = squeeze(field(n,X2,:));

  switch n
   case {1,2,3}
    re = ren.e;
   case {4,5}
    re = ren.b;
  end

  %
  wk = wkfft(fielddata,prm.nx,prm.nplot,prm.nx,prm.nplot,0);
  wk = [fliplr(wk(4:2:end,1:2:(end-1))'),wk(1:2:end,1:2:(end-1))'];
  wk2 = [fliplr(wk(4:2:end,1:2:(end-1))'),wk(3:2:end,1:2:(end-1))'];

  wk = wk*re;
  wk = log10(wk);
  wk2 = log10(wk2*re);

  % omega
  isplot=prm.ntime/2;
  isdiag = prm.ntime/prm.nplot;
  wmin = 2*pi/(prm.dt)/2/(prm.nplot/2)/isdiag;
  wmax = wmin*(prm.nplot/2);
  w = 0:wmin:(wmax-wmin);
  
  % wave number
  kmin = 2*pi/prm.nx;
  kmax = kmin*(prm.nx/2-1);
  k = [-kmax:kmin:-kmin,0,kmin:kmin:kmax];

  %
  imagesc(k,w,wk);
  shading flat;
  set(gca,'Yscale','linear');
  xlabel('k');
  ylabel('\omega');

  wkmax = max(max(wk2));
  wkmin = min(min(wk2));
  caxis([wkmin, wkmax])
  
  title(sprintf('log %s (min: %5.2g, max: %5.2g)',char(str(n)),wkmin,wkmax))
  
  wmaxplot = (wmax-wmin);
  kmaxplot = kmax;
  axis([-kmaxplot,kmaxplot,0,wmaxplot])

  % 
  if prm.iparam
    hold on
    kk = [-kmax,0,kmax];

    % light speed
    h = plot(kk,abs(kk*prm.cv*ren.v),'k:'); 
    try;set(h,'DisplayName','CV');catch;end;

    % Vd
    if n == 1
      for l = 1:prm.ns
        ux = prm.vd(l)*cos(prm.pch(l)/180*pi);
        g = prm.cv/sqrt(cs + prm.vd(l)^2);
        vv = ux*g;
        ww = kk*vv*ren.v;
        i = find(ww < 0);
        ww(i) = NaN;
        h = plot(kk,ww,'k-.');
        try;set(h,'DisplayName',sprintf('VD(%d)',l));catch;end;
      end
    end
    
    % WP
    for l = 1:prm.ns
      h = plot([-kmaxplot,kmaxplot],[prm.wp(l),prm.wp(l)]/ren.t,'k--');
      try;set(h,'DisplayName',sprintf('WP(%d)',l));catch;end;
    end
    % WC
    h = plot([-kmaxplot,kmaxplot],abs([prm.wc,prm.wc])/ren.t,'k:');
    try;set(h,'DisplayName',sprintf('WC',l));catch;end;
    
    hold off
  end
  
  drawnow;
return;
