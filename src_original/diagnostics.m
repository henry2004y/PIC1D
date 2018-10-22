%
% diagnostics
%
% hdiag: handles
%
function hdiag = diagnostics(hdiag, jtime, jdiag)
  global prm ren

  global ex ey ez by bz vx vy vz
  global bx0 by0
  global eng
  global field
  global kspec

  global X1 X2 X3
  
  global flag_exit;

  try
    % pause check
    flag = get(hdiag.fig,'UserData');
    if strcmp(flag,'pause')
      uiwait(hdiag.fig);
    end

    % exit chack
    flag = get(hdiag.fig,'UserData');
    if strcmp(flag,'exit')
      flag_exit = 1;
      return;
    end
  
  catch
    return
  end

  % 
  if hdiag.flag_eng
    eng(:,jdiag) = energy(ex,ey,ez,by,bz,vx,vy,vz);
  end
  if hdiag.flag_field
    field(:,:,jdiag) = [ex,ey,ez,by-by0,bz]';
  end
  if hdiag.flag_kspec
    kspec(:,:,jdiag) = kspectr([ex(X2),ey(X2),ez(X2),by(X2)-by0,bz(X2)])';
  end

  
  %
  % graphics
  %
  figure(hdiag.fig)

  %
  for l=1:length(prm.diagtype)
    %axes(hdiag.axes(l))
    set(gcf,'CurrentAxes',hdiag.axes(l));
    hdiag.nplt = l; % plate number
    
    type = prm.diagtype(l);
    switch type
     case {1,2,3}
      hdiag = plotphs(hdiag, type, jdiag);
     case 4
      hdiag = plotvs(hdiag,jdiag);
     case {5,6,7,8,9}
      hdiag = plotfield(hdiag, type-4, jdiag);
     case 10
      hdiag = plotwave(hdiag,jdiag);
     case 11
      hdiag = plotenergy(hdiag,jdiag);
     case {12,13,14}
      hdiag = plotvdist(hdiag,type-11,jdiag);
     case {15,16,17,18,19}
      hdiag = plotkspectrum(hdiag,type-14,jdiag);
     case {20,21,22,23,24}
      % reserved for wk plot
     case {25,26,27,28,29}
      hdiag = plotts(hdiag,type-24,jdiag); % time series plot
     case {30,31,32,33,34}
      hdiag = plottsk(hdiag,type-29,jdiag); % time series k plot
     otherwise
      error(sprintf('Error: %s',mfilename));
    end

  end
  
  % Title
  set(hdiag.htitle,'String',sprintf('Time: %5.3f/%5.3f',jtime*prm.dt,prm.ntime*prm.dt));

  if hdiag.flag_rot
    rotate3d on
  end
  drawnow
return

