%
% k-Spectrum
%
function ksp = kspectr(f)

  global prm

  spec = fft(f);
  ksp = 2/prm.nx*abs(spec(1:(prm.nx/2),:));
  
return

