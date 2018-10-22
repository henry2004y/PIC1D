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
%          Version 3.0   March 15, 2005
%
%****************************************************************
function kempo1main(input_filename)

  clear global
  warning off

  global prm       % input parameters
  global ren       % normalize factor

  global q mass rho0

  global slx       % system length x
  global nxp1 nxp2 % nx+1, nx+2
  global X1 X2 X3  % 1:nx, 2:nxp1, 3:nxp3
  global cs tcs    % c^2, 2*c^2

  % field
  global ex ey ez
  global bx by bz
  global ajx ajy ajz
  global rho

  % particles
  global vx vy vz
  global x

  % diagnostics
  global ifdiag    % interval for diagnostics
  global eng       % for energy plot
  global field     % field date for wk plot

  global flag_exit

  flag_exit = 0;
  
  %-- read parameters --
  if ~exist('input_filename')
    input_filename = 'input_tmp.dat';  % default input filename
  end
  prm = input_param(input_filename);
  if isempty(prm)
    return
  end
  
  %-- initialize --
  hdiag = diagnostics_init;
  colormap jet;
  %--
  [prm,ren] = renorm(prm);
  initial(prm, hdiag);

  x = position(x,vx);
  if prm.iex
    rho= charge(x);
    ex = poisson(ex, rho);
  end

  %-----------
  % Main loop
  %-----------
  jtime = 0;
  jdiag = 1;

  %-- diagnostics --
  hdiag = diagnostics(hdiag, jtime, jdiag); 
  if prm.nplot == 0
    return
  end
  
  %--
  for jtime = 1:prm.ntime

    %--
    if prm.iex == 2
      [ vx, vy, vz] = rvelocity(vx,vy,vz, ex,ey,ez, by,bz, x); 
      x = position(x,vx);
      x = position(x,vx);
      rho= charge(x);
      ex = poisson(ex, rho);
    else
      [     by, bz] = bfield(   by,bz, ey,ez);
      [ vx, vy, vz] = rvelocity(vx,vy,vz, ex,ey,ez, by,bz, x); 
      x = position(x,vx);
      [ajx,ajy,ajz] = current(ajx,ajy,ajz,vx,vy,vz,x,jtime); 
      [     by, bz] = bfield(   by,bz, ey,ez);
      [ ex, ey, ez] = efield(ex,ey,ez, by,bz, ajx,ajy,ajz);
      x = position(x,vx);
    end

    %-- diagnostics --
    if mod(jtime,ifdiag)==0
      jdiag = jdiag+1;
      hdiag = diagnostics(hdiag, jtime, jdiag); 
    end
    if flag_exit
      break;
    end
  end

  %-- diagnostics --
  if ~flag_exit
    diagnostics_last(hdiag, jtime); 
  end

return
