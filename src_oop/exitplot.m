%
% exitplot
%
function exitplot(hfig)

  global flag_exit;

  data = get(hfig,'UserData');

  if strcmp(data,'exit') == 0

    flag_exit = 1;
    set(hfig,'UserData','exit');

    uiresume(hfig);
 
    delete(hfig);
  end
return

