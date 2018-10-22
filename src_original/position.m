%
%
%
function x = position(x,vx)

  global prm
  global slx

  x = x +vx;
  x = x +slx.*(x<0.0) -slx.*(x>=slx);

return
