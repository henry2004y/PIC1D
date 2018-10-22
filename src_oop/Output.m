classdef Output < handle

   
   properties
      fieldsave(5,:,:) {double}
      kspecsave(5,:,:) {double}
      engsave(3,:) {double}
   end
   
   methods
      function obj = Output(prm)
         obj.fieldsave = nan(5, prm.nxp2, prm.nplot+1);
         obj.kspecsave = nan(5, prm.nx/2, prm.nplot+1);
         obj.engsave = zeros(3,prm.nplot+1);
      end
   end
    

end