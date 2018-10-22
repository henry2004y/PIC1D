
%****************************************************************
%
%  KEMPO1
%    Kyoto university ElectroMagnetic Particle cOde: 1D version
%
%
%  FORTRAN Version (Ver. 1) 
%          developed by 
%          Yoshiharu Omura and Hiroshi Matsumoto
%          Research Institute for Sustainable Humanosphere,
%          Kyoto Universityy
%          Uji, Kyoto, 611-0011, Japan   
%          E-mail: omura@rish.kyoto-u.ac.jp
%          FAX:  +81-774-31-8463
%
%  MATLAB Version (Ver. 2) 
%          developed for Lecture on "Electromagnetic Simulations"
%          by Yoshiharu Omura and Hideyuki Usui 
%          Graduate Course of Electrical Engineering, Kyoto University
%
%  MATLAB Version with User Interface and Graphic Diagnostics (Ver. 3) 
%          developed by Koichi Shin and Yoshiharu Omura 
%          for 7th International School for Space Simulations (ISSS-7) 
%          March 26-31, 2005, Kyoto Japan
%          Supported by COE21/KAGI Program
%
%          Copyright(c) 1993-2005, Space Simulation Group,
%          RISH, Kyoto University, All rights reserved.
%
%          Version 3.2   March 30, 2005
%          Version 3.3   March 17, 2016 for MATLAB R2014b
%
%****************************************************************

%
% KEMPO1 Application M-file for kempo1.fig
%
%    FIG = KEMPO1 launch kempo1 GUI.
%    KEMPO1('callback_name', ...) invoke the named callback.
%
function varargout = kempo1(varargin)
% Last Modified by GUIDE v2.5 17-Mar-2016 17:18:21

global KEMPO_VERSION
KEMPO_VERSION = 'KEMPO1 Version 3.3';

if nargin == 0  % LAUNCH GUI
  %-- Startup --
  try
    hsp = splash_screen;
    if verLessThan('matlab','8.4')
        hspfig = hsp;
    else
        hspfig = hsp.Number;
    end
    ht = timer('TimerFcn',sprintf('delete(%d)',hspfig),'StartDelay',3);
    start(ht);
    %set(hspfig,'KeyPressFcn','delete(gcbo)');
    %set(hspfig,'ButtonDownFcn','delete(gcbo)');
  catch
    return;
    hspfig = 0;
  end

  %
  fig = openfig(mfilename,'reuse','invisible');
  %fig = openfig(mfilename,'reuse');
  % Generate a structure of handles to pass to callbacks, and store it. 
  handles = guihandles(fig);

  %
  handles.prm = [];
  
  filename = '../init/input_tmp.dat';
  prm = input_param(filename);
  if isempty(prm)
    return;
  end
  handles = param_set(handles, prm);
  
  str = menutext;
  set(handles.popup_plot1,'String',str);
  set(handles.popup_plot2,'String',str);
  set(handles.popup_plot3,'String',str);
  set(handles.popup_plot4,'String',str);

  if hspfig
    try
      uiwait(hspfig)
    catch
    end
  end
  set(fig,'Visible','on')
  %--
    
  guidata(fig, handles);

  if nargout > 0
    varargout{1} = fig;
  end

else
  if ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

  try
    if (nargout)
      [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    else
      feval(varargin{:}); % FEVAL switchyard
    end
  catch
    %disp(lasterr);
    %errordlg(lasterr);
    errordlg('ERROR: Plese check parameters!','ERROR');
  end

  end
  return;
end

return;


%--------------------------------------------------------------------
function str = menutext

  str = {'Vx - X';'Vy - X';'Vz - X'; ...
         'Vx-Vy-Vz'; ...
         'Ex(X)';'Ey(X)';'Ez(X)';'By(X)';'Bz(X)'; ...
         'VyzEByz-X'; ...
         'Energy'; ...
         'f(Vx)';'f(Vy)';'f(Vz)'; ...
         'Ex(k)';'Ey(k)';'Ez(k)';'By(k)';'Bz(k)'; ...
         'Ex(w,k)';'Ey(w,k)';'Ez(w,k)';'By(w,k)';'Bz(w,k)'; ...
         'Ex(t,X)';'Ey(t,X)';'Ez(t,X)';'By(t,X)';'Bz(t,X)'; ...
         'Ex(t,k)';'Ey(t,k)';'Ez(t,k)';'By(t,k)';'Bz(t,k)'; ...
        };

return


%--------------------------------------------------------------------
% EDIT_BOX: number species 
%--------------------------------------------------------------------
function varargout = edit_ns_Callback(h, eventdata, handles, varargin)

% svae previous parameters for species
nsold = handles.prm.ns;
handles = get_species(handles, handles.prm.sp);

%
ns = fix(str2double(get(handles.edit_ns,'String')));

if ns == nsold
  return;
end
if ns <= 0
  errordlg('Error: NS');
  return;
end

% create new species
if ns > nsold;
  for k = (nsold+1):ns
    handles.prm.np(k) = handles.prm.np(k-1);
    handles.prm.wp(k) = handles.prm.wp(k-1); 
    handles.prm.qm(k) = handles.prm.qm(k-1); 
    handles.prm.vpa(k)= handles.prm.vpa(k-1);
    handles.prm.vpe(k)= handles.prm.vpe(k-1);
    handles.prm.vd(k) = handles.prm.vd(k-1);
    handles.prm.pch(k)= handles.prm.pch(k-1);
  end
end

%
set(handles.popup_sp,'Value',ns);
str = '';
for k = 1:ns
  str = [str;sprintf('Species %2d',k)];
end
set(handles.popup_sp,'String',str);

%
handles.prm.ns = ns;
handles.prm.sp = ns;

%
set_species(handles, ns);

%
guidata(gcf, handles);
return;


%--------------------------------------------------------------------
% POPUP_MENU: Species No.
%--------------------------------------------------------------------
function varargout = popup_sp_Callback(h, eventdata, handles, varargin)


% svae previous parameters for species
sp = handles.prm.sp;
handles = get_species(handles,sp);

% set parameters for species
n = get(h,'Value');
set_species(handles, n);
handles.prm.sp = n;

%
guidata(gcf, handles);
return;


%--------------------------------------------------------------------
% get parameters
%--------------------------------------------------------------------
function prm = param_get(handles)

sp = get(handles.popup_sp,'Value');
handles = get_species(handles, sp);

prm = handles.prm;
prm.ns = str2double(get(handles.edit_ns,'String'));

%
prm.dx = str2double(get(handles.edit_dx,'String'));
prm.dt = str2double(get(handles.edit_dt,'String'));
prm.nx = str2double(get(handles.edit_nx,'String'));
prm.ntime = str2double(get(handles.edit_ntime,'String'));

prm.cv = str2double(get(handles.edit_cv,'String'));
prm.wc = str2double(get(handles.edit_wc,'String'));
prm.angle = str2double(get(handles.edit_angle,'String'));

%
prm.ajamp = str2double(get(handles.edit_ajamp,'String'));
prm.wj = str2double(get(handles.edit_wj,'String'));
%prm.eamp = str2double(get(handles.edit_eamp,'String'));
%prm.bamp = str2double(get(handles.edit_bamp,'String'));

%
if get(handles.radio_iex0,'Value')
  prm.iex = 0;
elseif get(handles.radio_iex2,'Value')
  prm.iex = 2;
else
  prm.iex = 1;
end

%
prm.nplot= str2double(get(handles.edit_nplot,'String'));
prm.emax = str2double(get(handles.edit_emax,'String'));
prm.bmax = str2double(get(handles.edit_bmax,'String'));
prm.vmax = str2double(get(handles.edit_vmax,'String'));
prm.nv   = str2double(get(handles.edit_nv,'String'));

prm.icolor   = get(handles.check_icolor,'Value');
prm.iparam   = get(handles.check_iparam,'Value');

%
prm.diagtype(1) = get(handles.popup_plot1,'Value');
prm.diagtype(2) = get(handles.popup_plot2,'Value');
prm.diagtype(3) = get(handles.popup_plot3,'Value');
prm.diagtype(4) = get(handles.popup_plot4,'Value');

return

%--------------------------------------------------------------------
% BUTTTON: 
%--------------------------------------------------------------------
function varargout = btn_ok_Callback(h, eventdata, handles, varargin)

prm = param_get(handles);

if prm.ntime < prm.nplot
  errordlg('NTIME < NPLOT','Error')
  return
end
if (prm.ntime/prm.nplot) - fix(prm.ntime/prm.nplot) ~= 0
  errordlg('NTIME/NPLOT must be INTEGER')
  return
end
%if prm.dx < prm.cv*prm.dt
%  errordlg('Courant condition is not satisfied.','Error')
%  return
%end
  
filename = 'input_tmp.dat';
save_param(filename,prm);

kempo1main(filename);

return;

%--------------------------------------------------------------------
% get parameters for species
%--------------------------------------------------------------------
function handles = get_species(handles, sp)

  handles.prm.ns = str2double(get(handles.edit_ns,'String'));
  handles.prm.np(sp) = str2double(get(handles.edit_np,'String'));
  handles.prm.wp(sp) = str2double(get(handles.edit_wp,'String'));
  handles.prm.qm(sp) = str2double(get(handles.edit_qm,'String'));
  handles.prm.vpa(sp) = str2double(get(handles.edit_vpa,'String'));
  handles.prm.vpe(sp) = str2double(get(handles.edit_vpe,'String'));
  handles.prm.vd(sp) = str2double(get(handles.edit_vd,'String'));
  handles.prm.pch(sp) = str2double(get(handles.edit_pch,'String'));

return;

%--------------------------------------------------------------------
% set parameters for species
%--------------------------------------------------------------------
function set_species(handles, sp)

  (set(handles.edit_np,'String',handles.prm.np(sp)));
  (set(handles.edit_wp,'String',handles.prm.wp(sp)));
  (set(handles.edit_qm,'String',handles.prm.qm(sp)));
  (set(handles.edit_vpa,'String',handles.prm.vpa(sp)));
  (set(handles.edit_vpe,'String',handles.prm.vpe(sp)));
  (set(handles.edit_vd,'String',handles.prm.vd(sp)));
  (set(handles.edit_pch,'String',handles.prm.pch(sp)));

return;

%--------------------------------------------------------------------
% save parameters 
%--------------------------------------------------------------------
function save_param(filename, prm)

  fid = fopen(filename,'w');

  fprintf(fid,'%  KEMPO1 / input parameters\n\n');

  %
  fprintf(fid,'% --  --\n');
  fprintf(fid,'dx = %f;\n',prm.dx);
  fprintf(fid,'dt = %f;\n',prm.dt);
  fprintf(fid,'nx = %f;\n',prm.nx);
  fprintf(fid,'ntime = %f;\n',prm.ntime);
  fprintf(fid,'cv = %f;\n',prm.cv);
  fprintf(fid,'wc = %f;\n',prm.wc);
  fprintf(fid,'angle = %f;\n',prm.angle);
  fprintf(fid,'\n');

  % species
  fprintf(fid,'% -- species --\n');
  fprintf(fid,'ns = %f;\n', prm.ns );

  l = sprintf('%f, ',prm.np(1:prm.ns));
  fprintf(fid,'np = [%s];\n',l);
  l = sprintf('%f, ',prm.wp(1:prm.ns));
  fprintf(fid,'wp = [%s];\n',l);
  l = sprintf('%f, ',prm.qm(1:prm.ns));
  fprintf(fid,'qm = [%s];\n',l);
  l = sprintf('%f, ',prm.vpa(1:prm.ns));
  fprintf(fid,'vpa = [%s];\n',l);
  l = sprintf('%f, ',prm.vpe(1:prm.ns));
  fprintf(fid,'vpe = [%s];\n',l);
  l = sprintf('%f, ',prm.vd(1:prm.ns));
  fprintf(fid,'vd = [%s];\n',l);
  l = sprintf('%f, ',prm.pch(1:prm.ns));
  fprintf(fid,'pch = [%s];\n',l);
  fprintf(fid,'\n');

  fprintf(fid,'% --  --\n');
  fprintf(fid,'iex = %f;\n',prm.iex);
  fprintf(fid,'\n');

  %
  fprintf(fid,'% --  --\n');
  fprintf(fid,'ajamp = %f;\n',prm.ajamp);
  fprintf(fid,'wj = %f;\n',prm.wj);
  %fprintf(fid,'eamp = %f;\n',prm.eamp);
  %fprintf(fid,'bamp = %f;\n',prm.bamp);
  fprintf(fid,'\n');

  % diag.
  fprintf(fid,'% -- diagnostics --\n');
  fprintf(fid,'nplot = %f;\n',prm.nplot);
  fprintf(fid,'nv = %f;\n',prm.nv);
  fprintf(fid,'icolor = %f;\n',prm.icolor);
  fprintf(fid,'iparam = %f;\n',prm.iparam);
  fprintf(fid,'vmax = %f;\n',prm.vmax);
  fprintf(fid,'emax = %f;\n',prm.emax);
  fprintf(fid,'bmax = %f;\n',prm.bmax);

  l = sprintf('%f, ',prm.diagtype);
  fprintf(fid,'diagtype = [%s];\n',l);

  fclose(fid);
return;

%--------------------------------------------------------------------
% set parameters to GUI
%--------------------------------------------------------------------
function handles = param_set(handles,prm)

%
try;set(handles.edit_dx,'String',num2str(prm.dx));catch;end;
try;set(handles.edit_dt,'String',num2str(prm.dt));catch;end;
try;set(handles.edit_nx,'String',num2str(prm.nx));catch;end;
try;set(handles.edit_ntime,'String',num2str(prm.ntime));catch;end;

try;set(handles.edit_cv,'String',num2str(prm.cv));catch;end;
try;set(handles.edit_wc,'String',num2str(prm.wc));catch;end;
try;set(handles.edit_angle,'String',num2str(prm.angle));catch;end;

%
try;set(handles.edit_wj,'String',num2str(prm.wj));catch;end;
try;set(handles.edit_ajamp,'String',num2str(prm.ajamp));catch;end;
%try;set(handles.edit_eamp,'String',num2str(prm.eamp));catch;end;
%try;set(handles.edit_bamp,'String',num2str(prm.bamp));catch;end;

%
try;set(handles.edit_nplot,'String',num2str(prm.nplot));catch;end;

try
  set(handles.radio_iex0,'Value',0);
  set(handles.radio_iex1,'Value',0);
  set(handles.radio_iex2,'Value',0);
  switch prm.iex
   case 0
    set(handles.radio_iex0,'Value',1);
   case 2
    set(handles.radio_iex2,'Value',1);
   otherwise
    set(handles.radio_iex1,'Value',1);
  end
catch
end

try;set(handles.edit_bmax,'String',num2str(prm.bmax));catch;end;
try;set(handles.edit_emax,'String',num2str(prm.emax));catch;end;
try;set(handles.edit_vmax,'String',num2str(prm.vmax));catch;end;
try;set(handles.edit_nv,'String',num2str(prm.nv));catch;end;

try;set(handles.check_icolor,'Value',prm.icolor);catch;end;
try;set(handles.check_iparam,'Value',prm.iparam);catch;end;

%
try;set(handles.popup_plot1,'Value',prm.diagtype(1));catch;end;
try;set(handles.popup_plot2,'Value',prm.diagtype(2));catch;end;
try;set(handles.popup_plot3,'Value',prm.diagtype(3));catch;end;
try;set(handles.popup_plot4,'Value',prm.diagtype(4));catch;end;


%
try;set(handles.edit_ns,'String',num2str(prm.ns));catch;end;

handles.prm.ns = prm.ns;
handles.prm.np = prm.np;
handles.prm.qm = prm.qm;
handles.prm.wp = prm.wp;
handles.prm.vpa = prm.vpa;
handles.prm.vpe = prm.vpe;
handles.prm.vd = prm.vd;
handles.prm.pch = prm.pch;

sp = 1; %current species number
handles.prm.sp = sp;
set_species(handles,sp);

%
for k = 1:prm.ns
  l(k) = {sprintf('Species %2d',k)};
end
try;set(handles.popup_sp,'Value',sp);catch;end;
try;set(handles.popup_sp,'String',l);catch;end;

%
guidata(handles.figure1, handles);

return;

%--------------------------------------------------------------------
% BUTTON: exit 
%--------------------------------------------------------------------
function varargout = btn_cancel_Callback(h, eventdata, handles, varargin)

  close all
  delete(gcf)

return;

%--------------------------------------------------------------------
% BUTTON: load parameters
%--------------------------------------------------------------------
function varargout = btn_load_Callback(h, eventdata, handles, varargin)

  [filename, pathname] = uigetfile('*.dat');
  if filename
    input_filename = [pathname,filename];
    prm = input_param(input_filename);
    param_set(handles, prm);
  end


return;

%--------------------------------------------------------------------
% BUTTON: save parameters
%--------------------------------------------------------------------
function varargout = btn_save_Callback(h, eventdata, handles, varargin)

  %prm = param_get(handles);
  [filename, pathname] = uiputfile('*.dat');
  if filename
    save_filename = [pathname,filename];

    prm = param_get(handles);
    save_param(save_filename,prm);
  end

return;


%--------------------------------------------------------------------
% BUTTON: preview parameters
%--------------------------------------------------------------------
function varargout = btn_preview_Callback(h, eventdata, handles, varargin)

prm = param_get(handles);

% make dialog box
fig = dialog('Units','characters','Color',[1,1,1]);
pos = get(fig,'Position');
posstr = [5,5,(4+prm.ns*7)*2,10*1.5];
pos = [pos(1),pos(2),posstr(1)*2+posstr(3),posstr(2)+posstr(4)+2];
set(fig,'Position',pos);
uicontrol(fig,'String','OK','CallBack','delete(gcf)');

%
k = 1:prm.ns;
str(1) = {['NS :' sprintf(' %g',prm.ns)]};
str(2) = {['']};
str(3) = {['No.:' sprintf(' %6.4g',k)]};
str(4) = {['QM :' sprintf(' %6.4g',prm.qm(k))]};
str(5) = {['WP :' sprintf(' %6.4g',prm.wp(k))]};
str(6) = {['VPE:' sprintf(' %6.4g',prm.vpe(k))]};
str(7) = {['VPA:' sprintf(' %6.4g',prm.vpa(k))]};
str(8) = {['VD :' sprintf(' %6.4g',prm.vd(k))]};
str(9) = {['PCH:' sprintf(' %6.4g',prm.pch(k))]};
str(10)= {['NP :' sprintf(' %6.4g',prm.np(k))]};

%
if prm.dx < prm.cv*prm.dt
  str(11)= {['']};
  str(12)= {['Warning: Courant condition is not satisfied.']};

  posstr(4) = 13*1.5;
  pos = [pos(1),pos(2),posstr(1)*2+posstr(3),posstr(2)+posstr(4)+2];
  set(fig,'Position',pos);
end

%
h = uicontrol(fig,'style','text','String',str, ...
              'Units','characters', 'Position',posstr, ...
              'FontName','FixedWidth','HorizontalAlignment','left', ...
               'FontSize',10,'BackgroundColor',[1,1,1]);
return;


%--------------------------------------------------------------------
% RADIO_BUTTON: IEX
%--------------------------------------------------------------------
function varargout = radio_iex0_Callback(h, eventdata, handles, varargin)
set(handles.radio_iex0,'Value',1)
set(handles.radio_iex1,'Value',0)
set(handles.radio_iex2,'Value',0)
return

function varargout = radio_iex1_Callback(h, eventdata, handles, varargin)
set(handles.radio_iex0,'Value',0)
set(handles.radio_iex1,'Value',1)
set(handles.radio_iex2,'Value',0)
return

function varargout = radio_iex2_Callback(h, eventdata, handles, varargin)
set(handles.radio_iex0,'Value',0)
set(handles.radio_iex1,'Value',0)
set(handles.radio_iex2,'Value',1)
return

%--------------------------------------------------------------------


%--------------------------------------------------------------------
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function about_Callback(hObject, eventdata, handles)

  try
    hfig = splash_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)');
    uiwait(hfig);
  catch
  end

return

%--------------------------------------------------------------------
function hfig = splash_screen

  global KEMPO_VERSION

  img = imread('about.png');
  imgsize = size(img);

  hfig = figure;
  set(hfig,'menu','none');
  set(hfig,'WindowStyle','modal');
  set(hfig,'resize','off');
  pos = get(hfig,'Position');
  set(hfig,'Position',[pos(1) pos(2) imgsize(2) imgsize(1)]);
  
  himag = image(img);
  set(gca,'position',[0,0,1,1]);
  axis off;

  h = uicontrol(hfig,'Style','Text', ...
                     'BackgroundColor',[1,1,1], ...
                     'Position',[80,0,imgsize(2)-80,30], ...
                     'HorizontalAlignment','right', ...
                     'String',KEMPO_VERSION);

  drawnow
return;


%--------------------------------------------------------------------
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function paramlist_Callback(hObject, eventdata, handles)

  try
    hfig = paramlist_screen;
    uicontrol(hfig,'String','OK','CallBack','delete(gcf)');
    uiwait(hfig);
  catch
  end

return

%--------------------------------------------------------------------
function hfig = paramlist_screen

  
  img = imread('paramlist.png');
  imgsize = size(img);

  hfig = figure;
  set(hfig,'menu','none');
  set(hfig,'WindowStyle','modal');
  set(hfig,'resize','off');
  pos = get(hfig,'Position');
  set(hfig,'Position',[30 30 imgsize(2) imgsize(1)]);
  
  himag = image(img);
  set(gca,'position',[0,0,1,1]);
  axis off;

  drawnow
return;


%--------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
  btn_load_Callback([], [], handles)
return

%--------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
  btn_save_Callback([], [], handles)
return

%--------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
  btn_cancel_Callback([], [], handles)
return
