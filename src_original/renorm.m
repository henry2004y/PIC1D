%
% renormalize
%
function [prm, ren] = renorm(prm)

  ren.x = prm.dx;
  ren.t = prm.dt/2;
  ren.v = ren.x/ren.t;
  ren.e = ren.x/(ren.t^2);
  ren.b = 1.0/ren.t;
  ren.j = ren.x/(ren.t^3);
  ren.r = 1.0/(ren.t^2);
  ren.s = (ren.x^2)/(ren.t^4);

  prm.cv = prm.cv / ren.v;
  prm.wc = prm.wc * ren.t;

  prm.wp  = prm.wp  .* ren.t;
  prm.vpa = prm.vpa ./ ren.v;
  prm.vpe = prm.vpe ./ ren.v;
  prm.vd  = prm.vd  ./ ren.v;

  prm.vmax = prm.vmax ./ ren.v;

  prm.wj = prm.wj * ren.t;
  prm.ajamp = prm.ajamp / ren.j;
  
return; 
