classdef Particle < handle

   
   properties
      x  double
      vx  double
      vy  double
      vz  double
   end

   methods
      function obj = Particle(prm)
         % Initialization
         obj.x = zeros(prm.npt,1);
         obj.vx = zeros(prm.npt,1);
         obj.vy = zeros(prm.npt,1);
         obj.vz = zeros(prm.npt,1);
         
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
               
               obj.x(i) = xx;
               if obj.x(i) < 0.0
                  obj.x(i) = obj.x(i) + prm.slx;
               end
               if obj.x(i) >= prm.slx
                  obj.x(i) = obj.x(i) - prm.slx;
               end
               
               uxi = prm.vpa(k)*randn + vdpa;
               uyi = prm.vpe(k)*randn + vdpe*cos(phase);
               uz  = prm.vpe(k)*randn + vdpe*sin(phase);
               
               % rotation to the direction of the magnetic field
               costh = cos(pi/180*prm.angle);
               sinth = sin(pi/180*prm.angle);
               ux = costh*uxi - sinth*uyi;
               uy = sinth*uxi + costh*uyi;
               
               %
               g = prm.cv /sqrt(prm.cs + ux*ux + uy*uy + uz*uz);
               
               obj.vx(i) = ux*g;
               obj.vy(i) = uy*g;
               obj.vz(i) = uz*g;
            end
         end
      end
   end
   

end