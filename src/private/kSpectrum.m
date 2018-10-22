function ksp = kSpectrum(f,prm)
%kSpectrum Get k-Spectrum
%

spec = fft(f);
ksp = 2/prm.nx*abs(spec(1:(prm.nx/2),:));
  
end

