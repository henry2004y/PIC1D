function prm = input_param(fname)
% read input parameters
%INPUT:
% fname: filename
%OUTPUT:
% prm: parameters setup
%

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

end