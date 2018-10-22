%****************************************************************
%
%  KEMPO1
%    Kyoto university ElectroMagnetic Particle code: 1D version
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

%{
This code must be slow. Let me see if I can rewrite the code with much
faster speed and clearer code structure.
Idea:
1. Remove all global variables
2. Add necessary comments
3. textscan instead of textread and strread
4. str2double, strtrim

Why is my first version so slow?
Checking if real costs too much time...
I found that using handle classes may not be a good idea if you want
performance. Let's forget about OOP in MATLAB simulations...which is sad.
%}

function kempo1main

%global prm       % input parameters
%global ren       % normalize factor

%global q mass rho0

%global slx       % system length x
%global nxp1 nxp2 % nx+1, nx+2
% global X1 X2 X3  % 1:nx, 2:nxp1, 3:nxp3
% global cs tcs    % c^2, 2*c^2

% field
% global ex ey ez
% global bx by bz
% global ajx ajy ajz
% global rho

% particles
% global vx vy vz
% global x

% diagnostics
% global ifdiag    % interval for diagnostics
% global eng       % for energy plot
% global field     % field date for wk plot

% pseudo random number seed
rng('default');
rng(1);

global flag_exit

flag_exit = 0;

%-- read parameters --
% How to pass filename?
prm = Parameters;

%-- renormalization --
[prm,ren] = renorm(prm);

%-- initialization --
[hdiag,output] = diagnostics_init(prm);

particle = Particle(prm);
field = Field(prm);
%prm = initial(prm, hdiag);

position(particle,prm);
if prm.iex
   charge(particle, field, prm);
   poisson(field, prm);
end

%-------------
% Main loop
%-------------
jtime = 0;
jdiag = 1;

%-- diagnostics --
hdiag = diagnostics(hdiag, particle, field, output, prm, jtime, jdiag, ren);
if prm.nplot == 0
   return
end


%--
for jtime = 1:prm.ntime
   %fprintf("step=%d\n",jtime)
   %--
   if prm.iex == 2
      rvelocity(particle, field, prm);
      position(particle, prm);
      position(particle, prm);
      charge(particle, field, prm);
      poisson(field, prm);
   else
      bfield(field,prm);
      rvelocity(particle, field, prm);
      position(particle, prm);
      current(particle, field, jtime, prm);
      bfield(field, prm);
      efield(field, prm);
      position(particle, prm);
   end
   
   %-- diagnostics --
   if mod(jtime,prm.ifdiag)==0
      jdiag = jdiag+1;
      hdiag = diagnostics(hdiag, particle, field,output, prm, jtime, jdiag,ren);
   end
   if flag_exit
      break;
   end
end

%-- diagnostics --
if ~flag_exit
   diagnostics_last(hdiag, prm, jtime,output,ren);
end

end
