function hdiag = plottsk(hdiag,n,jdiag,kspec,prm,ren)
%
% Time series k-spectrum plot (Ex,Ey,Ez,By,Bz)
%


ifdiag = prm.ifdiag;

switch n
   case {1,2,3}
      re = ren.e;
   case {4,5}
      re = ren.b;
end

kspecdata = squeeze(kspec(n,:,:));
kspecdata = kspecdata*re;

mmax = max(max(kspecdata(2:end,:)));
mmin = max(min(kspecdata(2:end,:)));
if mmax == 0
   mmax = 0.002;
   mmin = 0.001;
end
mmax=10^ceil(log10(mmax));
mmin=10^floor(log10(mmin));

kspecdata = log10(kspecdata);

if jdiag == 1
   hold on;
   
   tt = (0:ifdiag:prm.ntime)*prm.dt;
   kmin = 2*pi/prm.nx;
   kmax = kmin*(prm.nx/2);
   kk = 0:kmin:(kmax-kmin);
   hdiag.plt(hdiag.nplt).hplot = imagesc(kk,tt,kspecdata');
   xlabel('k');
   ylabel('Time');
   
   axis([0, kmax, 0,tt(end)]);
   
   hold off;
else
   set(hdiag.plt(hdiag.nplt).hplot,'cdata',kspecdata');
end

caxis([log10(mmin), log10(mmax)]);
str = {'Ex','Ey','Ez','By','Bz'};
title(sprintf('log %s (min: %4.1f, max: %4.1f)', ...
   char(str(n)),log10(mmin),log10(mmax)));

end
