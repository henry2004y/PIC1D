function hdiag = plotVdist(hdiag, n, jdiag, particle, prm, ren)
%plotVdist Plot velocity distribution
%
%INPUTS:
% hdiag:
% n    :
% jdiag:
% particle:
% prm  :
% ren  :
%
%OUTPUTS:
% hdiag:

vx = particle.vx; vy = particle.vy; vz = particle.vz;

switch n
   case 1
      fv = vdist(vx,prm)/ren.v;
   case 2
      fv = vdist(vy,prm)/ren.v;
   case 3
      fv = vdist(vz,prm)/ren.v;
   otherwise
      error('Error: %s',mfilename)
end

[fvmax,index] = max(fv,[],2);

if jdiag == 1
   dv = 2*prm.vmax*ren.v/prm.nv;
   vv = -prm.vmax*ren.v:dv:(prm.vmax*ren.v);
   
   hold on
   if fvmax(1)
      if prm.iparam
         h = plot(vv,fv(1,:),'-','Color',[0.7 0.7 0.8]);
         try set(h,'DisplayName','Electrons');catch;end
      end
      hplot(1) = plot(vv,fv(1,:),'Color',[0 0 0.9]);
      try set(hplot(1),'DisplayName','Electrons');catch;end
      htext(1) = text(fv(1,index(1)),fvmax(1),' e','Color',[0 0 0.9], ...
         'VerticalAlignment','Bottom','FontWeight','bold');
   end
   if fvmax(2)
      if prm.iparam
         h = plot(vv,fv(2,:),'-','Color',[0.8 0.7 0.7]);
         try set(h,'DisplayName','Ions');catch;end
      end
      hplot(2) = plot(vv,fv(2,:),'Color',[0.9 0 0]);
      try set(hplot(2),'DisplayName','Ions');catch;end 
      htext(2) = text(fv(2,index(2)),fvmax(2),' i','Color',[0.9 0 0], ...
         'VerticalAlignment','Bottom','FontWeight','bold');
   end
   
   hcv = [];
   if prm.iparam
      ylim = get(gca,'ylim');
      hcv(1) = plot([prm.cv*ren.v, prm.cv*ren.v], ylim,'k:');
      hcv(2) = plot([-prm.cv*ren.v, -prm.cv*ren.v], ylim,'k:');
      try set(hcv(1),'DisplayName','CV');catch;end
      try set(hcv(2),'DisplayName','CV');catch;end
   end
   
   hold off
   
   str = {'Vx','Vy','Vz'};
   xlabel(str(n));
   ylabel(sprintf('f(%s)',char(str(n))))
   
   set(gca,'xlim',[-prm.vmax*ren.v prm.vmax*ren.v])
   
   hdiag.plt(hdiag.nplt).hplot = hplot;
   hdiag.plt(hdiag.nplt).htext = htext;
   hdiag.plt(hdiag.nplt).hcv = hcv;
   hdiag.plt(hdiag.nplt).vv = vv;
   
else
   hplot = hdiag.plt(hdiag.nplt).hplot;
   htext = hdiag.plt(hdiag.nplt).htext;
   hcv = hdiag.plt(hdiag.nplt).hcv;
   vv = hdiag.plt(hdiag.nplt).vv;
   
   ylim = get(gca,'ylim');
   for i = 1:2
      if fvmax(i)
         set(hplot(i),'ydata',fv(i,:))
         set(htext(i),'Position', [vv(index(i)) fvmax(i) 0])
         
         if prm.iparam
            set(hcv(i),'ydata', ylim);
         end
      end
   end
end

   function fv = vdist(v,prm)
      % Calculate the distribution function
      
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
         
         qabs = abs(prm.q(k));
         if prm.q(k) < 0
            qsign = 1;
         else
            qsign = 2;
         end
         
         for m = (n1+1):n2
            if (v(m) < v1) || (v(m) >= v2); continue; end
            
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
      
   end

end

