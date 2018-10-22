function diagnostics_last(hdiag, prm, jtime,output,ren)

  
figure(hdiag.fig)

%
for k=1:length(prm.diagtype)
   axes(hdiag.axes(k))
   
   n = prm.diagtype(k);
   switch n
      %case 10
      % axes(hdiag.hlegend)
      case {20,21,22,23,24}
         plotspectr(n-19,prm,output.fieldsave,ren);
         %h = get(gca,'xlabel');
         %set(h,'Units','Normalized')
         %set(h,'Position',[0.5,-0.13,10])
   end
end

if hdiag.flag_rot
   rotate3d on
end

end

