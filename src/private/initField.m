function field = initField(prm)
%initField Initialization of field variables
% 
%INPUT:
% prm: simulation parameters
%
%OUTPUT:
% field: field info

field.rho = zeros(prm.nxp2,1);
field.ex  = zeros(prm.nxp2,1);
field.ey  = zeros(prm.nxp2,1);
field.ez  = zeros(prm.nxp2,1);
field.by  = ones(prm.nxp2,1)*prm.by0;
field.bz  = zeros(prm.nxp2,1);
field.ajx = zeros(prm.nxp2,1);
field.ajy = zeros(prm.nxp2,1);
field.ajz = zeros(prm.nxp2,1);

end

