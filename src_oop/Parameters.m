classdef Parameters < handle
% Input parameters for the simulation.
   
   properties
      % grid spacing
      dx  double {mustBePositive}
      % time step
      dt  double {mustBePositive}
      % number of grid points
      nx  double {mustBeInteger}
      % number of particle species
      ntime  double {mustBeInteger, mustBeNonnegative}
      % number of outputs
      nplot double {mustBeInteger, mustBePositive}
      % speed of light
      cv  double {mustBePositive}
      % cyclotron frequency of species
      wc  double {mustBeReal}
      % amplitude of an external current jz
      ajamp double {mustBeNonnegative}
      % amplitude of electric field
      eamp double {mustBePositive}
      % maximum range for plotting the electric field
      emax double {mustBeReal}
      % amplitude of magnetic field
      bamp double {mustBePositive}
      % maximum range for plotting the magnetic field
      bmax double {mustBeReal}
      % control parameter for electrostatic option
      iex double {mustBeMember(iex,[0,1,2])}
      % maximum range for plotting velocity
      vmax double {mustBeReal}
      % number of bins for deriving the particle distribution function
      nv double {mustBeInteger}
      % frequency of the external current jz
      wj double {mustBeNonnegative}
      % number of particle species
      ns double {mustBeInteger, mustBePositive}
      % number of particles for species
      np double {mustBeInteger, mustBePositive}
      % plasma frequency of species
      wp double {mustBePositive}
      % charge-to-mass ratio of species
      qm double {mustBeReal}
      % parallel thermal velocity of species
      vpa double {mustBePositive}
      % perpendicular thermal velocity of species
      vpe double {mustBePositive}
      % drift velocity of species
      vd double {mustBeNonnegative}
      % pitch angle (degrees) of species
      pch double {mustBeGreaterThanOrEqual(pch,0), mustBeLessThanOrEqual(pch,180)}
      %
      icolor
      %
      iparam
      %
      diagtype
      angle  double {mustBeGreaterThanOrEqual(angle,0), mustBeLessThanOrEqual(angle,90)}
      
   end
   
   % Actually I am not sure if this should be calculated only once. It
   % might be better. 
   % For example, in the initialization part, slx has been used several 
   % times inside the nested loop. q is used in function charge.
   properties (Dependent)
      slx
      npt
      nxp1
      nxp2
      X1
      X2
      X3
      cs
      tcs
      q
      mass
      rho0
      bx0
      by0
      ifdiag
   end
   
   methods
      function obj = Parameters(fname)
         % read input parameters and set values
         
         if nargin==0
            fname = 'input_tmp.dat';  % default input filename
         end
         
         try
            fid = fopen(fname);
            C = textscan(fid,'%s%s','delimiter','=;','commentstyle','matlab');
            [StrName,StrValue] = C{:};
            fclose(fid);
         catch
            errordlg(sprintf('Can''t open input file: %s',fname),'Error')
         end
         
         for l=1:length(StrName)
            value = eval(char(StrValue(l)));
            prmname = strtrim(StrName{l});
            switch prmname
               case 'dx'
                  obj.dx = value;
               case 'dt'
                  obj.dt = value;
               case 'nx'
                  obj.nx = value;
               case 'ntime'
                  obj.ntime = value;
               case 'nplot'
                  obj.nplot = value;
               case 'cv'
                  obj.cv = value;
               case 'wc'
                  obj.wc = value;
               case 'ajamp'
                  obj.ajamp = value;
               case 'eamp'
                  obj.eamp = value;
               case 'emax'
                  obj.emax = value;
               case 'bamp'
                  obj.bamp = value;
               case 'bmax'
                  obj.bmax = value;
               case 'iex'
                  obj.iex = value;
               case 'vmax'
                  obj.vmax = value;
               case 'nv'
                  obj.nv = value;
               case 'wj'
                  obj.wj = value;
               case 'ns'
                  obj.ns = value;
               case 'np'
                  obj.np = value;
               case 'wp'
                  obj.wp = value;
               case 'qm'
                  obj.qm = value;
               case 'vpa'
                  obj.vpa = value;
               case 'vpe'
                  obj.vpe = value;
               case 'vd'
                  obj.vd = value;
               case 'pch'
                  obj.pch = value;
               case 'icolor'
                  obj.icolor = value;
               case 'iparam'
                  obj.iparam = value;
               case 'diagtype'
                  obj.diagtype = value;
               case 'angle'
                  obj.angle = value;
               otherwise
                  error('Plese check input parameter %s.',prmname)
            end
         end
      end
      
      % Get the dependent vars
      
      function value = get.slx(obj)
         value = obj.nx;
      end
      
      function value = get.npt(obj)
         value = sum(obj.np(1:obj.ns));
      end      
      
      function value = get.nxp1(obj)
         value = obj.nx+1;
      end
      
      function value = get.nxp2(obj)
         value = obj.nx+2;
      end
      
      function value = get.X1(obj)
         value = 1:obj.nx;
      end
      
      function value = get.X2(obj)
         value = 2:(obj.nx+1);
      end
      
      function value = get.X3(obj)
         value = 3:(obj.nx+2);
      end
      
      function value = get.cs(obj)
         value = obj.cv^2;
      end
      
      function value = get.tcs(obj)
         value = 2*obj.cs;
      end      
      
      function value = get.q(obj)
         value = obj.nx ./ obj.np(1:obj.ns) .* (obj.wp(1:obj.ns).^2) ./ ...
            obj.qm(1:obj.ns);
      end 
      
      % This is a case where you have inter-dependency.
      function value = get.mass(obj)
         value = obj.q ./ obj.qm(1:obj.ns);
      end
      
      function value = get.rho0(obj)
         value = -sum(obj.q(1:obj.ns) .* obj.np(1:obj.ns)) / obj.nx *...
            ones(obj.nxp2,1);
      end
      
      function value = get.bx0(obj)
         theta = pi/180*obj.angle;
         value = obj.wc/obj.qm(1)*cos(theta);
      end

      function value = get.by0(obj)
         theta = pi/180*obj.angle;
         value = obj.wc/obj.qm(1)*sin(theta);
      end   
      
      function value = get.ifdiag(obj)
         value = ceil(obj.ntime/obj.nplot);
      end
   end

end