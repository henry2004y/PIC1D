function [prm,ren] = setParameters(fname,DoReadDirect)
%SetParameters Read init .dat file and set parameters
%
%I think I need a way for reading different input files.
%
%INPUTS:
% fname: file name for input parameters
% DoReadDirect: logical for reading raw data from file. Default is false
%
%OUTPUTS:
% prm: simulation parameters
% ren: renormalization units?

if nargin==0
   fname = '../init/default.dat';  % default input filename
elseif nargin ==1
   DoReadDirect = false;
end

try
   fid = fopen(fname);
   C = textscan(fid,'%s%s','delimiter','=;','commentstyle','matlab');
   [StrName,StrValue] = C{:};
   fclose(fid);
catch
   errordlg(sprintf('Can''t open input file: %s',fname),'Error')
end

% Set parameters directly from input file
for l=1:length(StrName)
   value = eval(char(StrValue(l)));
   prmname = strtrim(StrName{l});
   switch prmname
      case 'dx'
         prm.dx = value;
      case 'dt'
         prm.dt = value;
      case 'nx'
         prm.nx = value;
      case 'ntime'
         prm.ntime = value;
      case 'nplot'
         prm.nplot = value;
      case 'cv'
         prm.cv = value;
      case 'wc'
         prm.wc = value;
      case 'ajamp'
         prm.ajamp = value;
      case 'eamp'
         prm.eamp = value;
      case 'emax'
         prm.emax = value;
      case 'bamp'
         prm.bamp = value;
      case 'bmax'
         prm.bmax = value;
      case 'iex'
         prm.iex = value;
      case 'vmax'
         prm.vmax = value;
      case 'nv'
         prm.nv = value;
      case 'wj'
         prm.wj = value;
      case 'ns'
         prm.ns = value;
      case 'np'
         prm.np = value;
      case 'wp'
         prm.wp = value;
      case 'qm'
         prm.qm = value;
      case 'vpa'
         prm.vpa = value;
      case 'vpe'
         prm.vpe = value;
      case 'vd'
         prm.vd = value;
      case 'pch'
         prm.pch = value;
      case 'icolor'
         prm.icolor = value;
      case 'iparam'
         prm.iparam = value;
      case 'diagtype'
         prm.diagtype = value;
      case 'angle'
         prm.angle = value;
      otherwise
         error('Plese check input parameter %s.',prmname)
   end
end

% Return if calling from GUI, where there's no need to do normalization and
% calculate derived parameters.
if DoReadDirect, return, end

% Intermediate temporary vars
theta = pi/180*prm.angle;

%-- renormalization --
[prm,ren] = renorm(prm);

% Set derived parameters
prm.slx = prm.nx;
prm.npt = sum(prm.np(1:prm.ns));
prm.nxp1 = prm.nx+1;
prm.nxp2 = prm.nx+2;
prm.X1 = 1:prm.nx; prm.X2 = 2:(prm.nx+1); prm.X3 = 3:(prm.nx+2);
prm.cs = prm.cv^2;
prm.tcs = 2*prm.cs;
prm.q = prm.nx ./ prm.np(1:prm.ns) .* (prm.wp(1:prm.ns).^2) ./ ...
            prm.qm(1:prm.ns);
prm.mass = prm.q ./ prm.qm(1:prm.ns);
prm.rho0 = -sum(prm.q(1:prm.ns) .* prm.np(1:prm.ns)) / prm.nx *...
            ones(prm.nxp2,1);
prm.bx0 = prm.wc/prm.qm(1)*cos(theta);
prm.by0 = prm.wc/prm.qm(1)*sin(theta);
prm.ifdiag = ceil(prm.ntime/prm.nplot);

end

