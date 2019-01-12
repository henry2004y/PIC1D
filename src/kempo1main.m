function kempo1main(fname)
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
% Modified by Hongyang Zhou, 09/09/2018 at ISSS13
% Fixed the GUI issue with my modification to set_parameters, 10/19/2018
% Removed pause/exit option by exit_flag during the run, because I think 
% it affects performance and is useless. 10/19/2018
% Renaming functions and variables. 10/20/2018
%****************************************************************

%% Read parameters and normalization
if nargin ~= 0
   [prm,ren] = setParameters(fname);
else
   [prm,ren] = setParameters;
end

%% Initialization
particle = initParticle(prm);
field    = initField(prm);
[hdiag,output] = initDiagnostics(prm);

particle = moveParticle(particle,prm);
if prm.iex
   field = getCharge(particle, field, prm);
   field = calcEfieldFromPoisson(field, prm);
end

%% Main loop
jtime = 0;
jdiag = 1;

% Diagnostics at initial time
[hdiag,output] = diagnose(hdiag, particle, field, output, prm, jtime,...
   jdiag, ren);
if prm.nplot == 0
   return
end

% Time advance loop
for jtime = 1:prm.ntime
   %fprintf("step=%d\n",jtime)

   if prm.iex == 2
      particle = updateVelocity(particle, field, prm);
      particle = moveParticle(particle, prm);
      particle = moveParticle(particle, prm);
      field    = getCharge(particle, field, prm);
      field    = calcEfieldFromPoisson(field, prm);
   else
      field    = updateBfield(field,prm);
      particle = updateVelocity(particle, field, prm);
      particle = moveParticle(particle, prm);
      field    = current(particle, field, jtime, prm);
      field    = updateBfield(field, prm);
      field    = updateEfield(field, prm);
      particle = moveParticle(particle, prm);
   end
   
   % Diagnostics during the run
   if mod(jtime,prm.ifdiag) == 0
      jdiag = jdiag + 1;
      [hdiag,output] = diagnose(hdiag, particle, field, output, prm,...
         jtime, jdiag, ren);
   end
end

% Diagnostics at the final timestep
LastDiagnostics(hdiag, prm, jtime, output, ren);

end