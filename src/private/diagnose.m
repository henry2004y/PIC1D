function [hdiag,output] = diagnose(hdiag, particle, field, output,...
   prm, jtime, jdiag, ren)
%diagnose Show diagnostics during the simulation
%
%INPUTS:
% hdiag:    struct of setup related to figures of diagnostics
% particle: particle info
% field:    field info
% output:   
% prm:      struct of parameters
% jtime:    current simulation time
% jdiag:
% ren:
%
%OUTPUTS:
% hdiag:    struct of setup related to figures of diagnostics
% output:   

by0 = prm.by0;
X2 = prm.X2;

% referencees
f = field;
ex = field.ex; ey = field.ey; ez = field.ez;
by = field.by; bz = field.bz;

%
if hdiag.flag_eng
   output.engsave(:,jdiag) = getEnergy(f, particle, prm);
end
if hdiag.flag_field
   output.fieldsave(:,:,jdiag) = [ex, ey, ez, by-by0, bz]';
end
if hdiag.flag_kspec
   output.kspecsave(:,:,jdiag) = kSpectrum(...
      [ex(X2),ey(X2),ez(X2),by(X2)-by0,bz(X2)],prm)';
end

%---------
% graphics
%---------
% what if I comment this out?
%figure(hdiag.fig)

%
for l=1:length(prm.diagtype)
   %axes(hdiag.axes(l))
   try
      set(gcf,'CurrentAxes',hdiag.axes(l));
   catch
      error('figure closed!')
   end
   hdiag.nplt = l; % plate number
   
   type = prm.diagtype(l);
   switch type
      case {1,2,3}
         hdiag = plotPhase(hdiag, type, jdiag, particle, prm,ren);
      case 4
         hdiag = plotVS(hdiag,jdiag, particle,prm,ren);
      case {5,6,7,8,9}
         hdiag = plotField(hdiag, type-4, jdiag, field, prm,ren);
      case 10
         hdiag = plotWave(hdiag,jdiag,particle,field,prm,ren);
      case 11
         hdiag = plotEnergy(hdiag,jdiag,output.engsave,prm,ren);
      case {12,13,14}
         hdiag = plotVdist(hdiag,type-11,jdiag,particle,prm,ren);
      case {15,16,17,18,19}
         hdiag = plotKspectrum(hdiag,type-14,jdiag, field, prm, ren);
      case {20,21,22,23,24}
         % reserved for wk plot
      case {25,26,27,28,29}
         % time series plot
         hdiag = ...
            plotTimeseries(hdiag,type-24,jdiag,output.fieldsave,prm,ren); 
      case {30,31,32,33,34}
         % time series k plot
         hdiag = ...
            plotTimeseriesK(hdiag,type-29,jdiag,output.kspecsave,prm,ren); 
      otherwise
         error('Error: %s',mfilename);
   end
   
end

% Title
set(hdiag.htitle,'String',...
   sprintf('Time: %5.3f/%5.3f',jtime*prm.dt,prm.ntime*prm.dt));

% using pause instead of drawnow improves performance, but it is less clear
%pause(0.002)
drawnow

% comment out for speed
%-------------------- by T. Nogi Sep. 9, 2018 -----------
% hManager = uigetmodemanager(hdiag.fig);
% try   % For version ealier than MATLAB 2014a
%    set(hManager.WindowListenerHandles, 'Enable', 'off');  % HG1
% catch % For version later than  MATLAB 2014b
%    [hManager.WindowListenerHandles.Enabled] = deal(false);  % HG2
% end
% set(hdiag.fig, 'WindowKeyPressFcn', []);
% set(hdiag.fig, 'KeyPressFcn', 'pauseplot(gcbo)');
%--------------------------------------------------------


end

