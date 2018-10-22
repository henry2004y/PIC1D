%
% Energy plot
%
function hdiag = plotenergy(hdiag, jdiag)
  global eng
  global prm ren
  global ifdiag

  totaleng = sum(eng);
  en = [totaleng;eng(1,:);eng(2,:);eng(3,:)]*ren.s;
  
  if jdiag == 1
    t = (0:ifdiag:prm.ntime)*prm.dt;

    color = [[0.9   0.9   0]; ...
             [0     0 0.8]; ...
             [0.8   0   0]; ...
             [0   0.6   0]];
    str = {'T','E','M','K'};

    % lines & dots
    hold on
    for i = 1:4
      helin(i) = plot(t,en(i,:),'Color',color(i,:));
      hedot(i) = plot(t(jdiag),en(i,jdiag),'.', ...
                      'Color',color(i,:),'MarkerSize',15);
    
      % text label
      try
        set(helin(i),'DisplayName',char(str(i)));
        set(hedot(i),'DisplayName',char(str(i)));
      catch;
      end
      hetxt(i) = text(t(jdiag),en(i,jdiag),str(i));
      set(hetxt(i),'VerticalAlignment','bottom', ...
                   'HorizontalAlignment','right', ...
                   'FontWeight','bold')
    end
    hold off
    set(hetxt(1),'HorizontalAlignment','left')
    
    % label
    ylabel('Energy');
    set(gca,'Yscale','log')
    hxl = xlabel('Time');
    set(hxl,'Units','Normalized')
    set(hxl,'Position',[0.5,-0.13,10])

    %
    hdiag.plt(hdiag.nplt).t = t;
    hdiag.plt(hdiag.nplt).helin = helin;
    hdiag.plt(hdiag.nplt).hedot = hedot;
    hdiag.plt(hdiag.nplt).hetxt = hetxt;
  
  else

    %
    t = hdiag.plt(hdiag.nplt).t;
    helin = hdiag.plt(hdiag.nplt).helin;
    hedot = hdiag.plt(hdiag.nplt).hedot;
    hetxt = hdiag.plt(hdiag.nplt).hetxt;

    %
    for i = 1:4
      set(helin(i),'ydata',en(i,:))
      set(hedot(i),'xdata',t(jdiag),'ydata',en(i,jdiag))
      set(hetxt(i),'Position',[t(jdiag),en(i,jdiag),0])
    end
  
  end
      
  %
  mmax = max(max(en));
  mmax = 10^ceil(log10(mmax));
  idx = find(en>0);
  mmin = min(min(en(idx)));
  mmin = 10^(floor(log10(mmin)));
  if isnan(mmax)
    mmax = eps*10;
    mmin = eps;
  end

  axis([0 prm.ntime*prm.dt mmin mmax]);

return
