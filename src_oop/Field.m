classdef Field < handle

   
   properties
      ex  double
      ey  double
      ez  double
      by  double
      bz  double
      rho double 
      ajx double
      ajy double
      ajz double
   end
   
   methods
      function obj = Field(prm)
         obj.rho = zeros(prm.nxp2,1);
         obj.ex = zeros(prm.nxp2,1);
         obj.ey = zeros(prm.nxp2,1);
         obj.ez = zeros(prm.nxp2,1);
         obj.by = ones(prm.nxp2,1)*prm.by0;
         obj.bz = zeros(prm.nxp2,1);
         obj.ajx = zeros(prm.nxp2,1);
         obj.ajy = zeros(prm.nxp2,1);
         obj.ajz = zeros(prm.nxp2,1);
      end
   end
    

end

