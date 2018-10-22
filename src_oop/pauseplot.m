%
% pauseplot
%
function pauseplot(hfig)

  global flag_exit;

  % ESC key
  if double(get(hfig,'CurrentCharacter')) == 27
    exitplot(hfig);
    return
  end


  % any key
  flag = get(hfig,'UserData');

  if isempty(flag) 
    set(hfig,'UserData','pause');
    set(hfig,'Name','(Pause)');
  elseif strcmp(flag,'exit') == 0
    set(hfig,'UserData',[]);
    set(hfig,'Name','');
    uiresume(hfig);
  end
  
return


