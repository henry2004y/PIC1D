function prm = initial(prm, hdiag)
% set full parameters

%   global q mass rho0
%
%   global npt % total number particles
%   global slx % system length x
%
%   global bx0 by0
%
%   global ex ey ez
%   global bx by bz
%   global ajx ajy ajz
%   global rho
%
%   global vx vy vz
%   global x
%
%   global nxp1 nxp2 % nx+1, nx+2
%   global X1 X2 X3
%
%   global cs tcs    % cv^2, 2*cv^2
%
%   global ifdiag
%
%   % diagnostics
%   global field % field data for wk plot
%   global kspec % k-spectrum
%   global eng   % energy

prm.slx = prm.nx; slx = prm.slx;
npt = sum(prm.np(1:prm.ns));
prm.nxp1 = prm.nx+1;
prm.nxp2 = prm.nx+2; nxp2 = prmn.nxp2;
prm.X1 = 1:prm.nx;
prm.X2 = 2:(prm.nx+1);
prm.X3 = 3:(prm.nx+2);
prm.cs = prm.cv*prm.cv; cs = prm.cs;
prm.tcs = 2.0*cs;

%
prm.q = prm.nx ./ prm.np(1:prm.ns) .* (prm.wp(1:prm.ns).^2) ./ ...
   prm.qm(1:prm.ns); q = prm.q;
prm.mass = prm.q ./ prm.qm(1:prm.ns);
rho0 = -sum(q(1:prm.ns) .* prm.np(1:prm.ns)) / prm.nx;
prm.rho0 = rho0*ones(nxp2,1);

%
theta = pi/180*prm.angle;
costh = cos(theta);
sinth = sin(theta);

%
b0 = prm.wc/prm.qm(1);
prm.bx0 = b0*costh;
prm.by0 = b0*sinth;


%
prm.ifdiag = ceil(prm.ntime/prm.nplot);

%-- Field Initialization --
ex = zeros(nxp2,1);
ey = zeros(nxp2,1);
ez = zeros(nxp2,1);
by = ones(nxp2,1)*by0;
bz = zeros(nxp2,1);

ajx = zeros(nxp2,1);
ajy = zeros(nxp2,1);
ajz = zeros(nxp2,1);

rho = zeros(nxp2,1);

% particles
x   = zeros(npt,1);
vx  = zeros(npt,1);
vy  = zeros(npt,1);
vz  = zeros(npt,1);

% diagnostics
if hdiag.flag_field
   field = ones(5, nxp2, prm.nplot+1)*NaN;
end
if hdiag.flag_kspec
   kspec = ones(5, prm.nx/2, prm.nplot+1)*NaN;
end
if hdiag.flag_eng
   eng = ones(3,prm.nplot+1)*0;
end

%-- Particle Initialization --
n2 = 0;
for k=1:prm.ns
   n1 = n2;
   n2 = n2 +prm.np(k);
   
   phi = pi/180.0*prm.pch(k);
   vdpa = prm.vd(k)*cos(phi);
   vdpe = prm.vd(k)*sin(phi);
   
   xx = 0;
   nphase = 1;
   phase = 0;
   
   for i=(n1+1):n2
      if mod(i,nphase) == 0
         phase = 2*pi*rand;
         xx = xx+ prm.nx/prm.np(k);
      else
         phase = phase + 2*pi/nphase;
      end
      
      x(i) = xx;
      if x(i) < 0.0
         x(i) = x(i) +slx;
      end
      if x(i) >= slx
         x(i) = x(i) -slx;
      end
      
      uxi = prm.vpa(k)*randn +vdpa;
      uyi = prm.vpe(k)*randn +vdpe*cos(phase);
      uz  = prm.vpe(k)*randn +vdpe*sin(phase);
      
      % rotation to the direction of the magnetic field
      ux = costh*uxi-sinth*uyi;
      uy = sinth*uxi+costh*uyi;
      
      %
      g = prm.cv /sqrt(cs + ux*ux + uy*uy + uz*uz);
      
      vx(i) = ux*g;
      vy(i) = uy*g;
      vz(i) = uz*g;
   end
end

end
