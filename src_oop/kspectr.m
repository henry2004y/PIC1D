function ksp = kspectr(f,prm)
%
% k-Spectrum
%

spec = fft(f);
ksp = 2/prm.nx*abs(spec(1:(prm.nx/2),:));
  
end

