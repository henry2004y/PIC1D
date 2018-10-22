function particle = initParticle(prm)
%initParticle Initialization of particle variables
%
%INPUT:
% prm: simulation parameters
%
%OUTPUT:
% particle: particle info

% pseudo random number seed
rng('default');
rng(1);

npt = prm.npt;
vpa = prm.vpa; vpe = prm.vpe; vd = prm.vd;
slx = prm.slx; nx = prm.nx; np = prm.np; ns = prm.ns;
cs = prm.cs; angle = prm.angle; pch = prm.pch;

% Allocation 
x  = zeros(npt,1);
vx = zeros(npt,1);
vy = zeros(npt,1);
vz = zeros(npt,1);

% Initialization
n2 = 0;
for k=1:ns
   n1 = n2;
   n2 = n2 + np(k);
   
   phi = pi/180.0*pch(k);
   vdpa = vd(k)*cos(phi);
   vdpe = vd(k)*sin(phi);
   
   xx = 0;
   nphase = 1;
   phase = 0;
   
   for i=(n1+1):n2
      if mod(i,nphase) == 0
         phase = 2*pi*rand;
         xx = xx+ nx/np(k);
      else
         phase = phase + 2*pi/nphase;
      end
      
      x(i) = xx;
      if x(i) < 0.0
         x(i) = x(i) + slx;
      end
      if x(i) >= slx
         x(i) = x(i) - slx;
      end
      
      uxi = vpa(k)*randn + vdpa;
      uyi = vpe(k)*randn + vdpe*cos(phase);
      uz  = vpe(k)*randn + vdpe*sin(phase);
      
      % rotation to the direction of the magnetic field
      costh = cos(pi/180*angle);
      sinth = sin(pi/180*angle);
      ux = costh*uxi - sinth*uyi;
      uy = sinth*uxi + costh*uyi;
      
      %
      g = prm.cv /sqrt(cs + ux*ux + uy*uy + uz*uz);
      
      vx(i) = ux*g;
      vy(i) = uy*g;
      vz(i) = uz*g;
   end
end

particle.x = x;
particle.vx = vx; particle.vy = vy; particle.vz = vz;

end