%****************************************************************
%   fourier transform in space and time
%                  by y.omura   rasc, kyoto univ.
%
% icnt=0  fft in both x(z) and y(t) compornents
% icnt=1  fft in y(t) compornent
% icnt=2  fft in x(z) compornent
% 
% wk1: work 1
% wk2: work 2
%
%****************************************************************
function ar = wkfft(ar,n1,m1,n,m,icnt)

rni=2.0/n;
rmi=2.0/m;

n2=n/2.0;
m2=m/2.0;

ii = 1:n;
jj = 1:m;

% X direction
if icnt ~= 1
  for j=1:m
    wk1 = ar(ii,j);
    wk1 = realfft(wk1,n);
    ar(ii,j)=wk1(ii)'*rni;
  end

  ar(ii,1)=0.5*ar(ii,1);
  ar(ii,2)=0.5*ar(ii,2);
end    

% Y direction
if icnt ~= 2
  for i=1:n
    wk2=ar(i,1:m);
    wk2 =realfft(wk2,m);
    ar(i,jj)=wk2(jj)*rmi;
  end
end

ar(ii,1)=abs(ar(ii,1));
ar(ii,2)=abs(ar(ii,2));

ar1=0.5*ar(1,jj);
ar2=0.5*ar(2,jj);
ar(1,jj)=abs(ar1(jj));
ar(2,jj)=abs(ar2(jj));


%
for i=1:2
  j=3;
  for l=2:m2
    ar1=ar(i,j);
    ar2=ar(i,j+1);
    sq=ar1*ar1+ar2*ar2;
    ara=sqrt(sq);
    if ara == 0
      ara=0.0001;
    end
    t1=acos(ar2/ara);
    if ar1 < 0
      t1=t1+pi;
    end
    ar(i  ,j  )=ara;
    ar(i  ,j+1)=t1;
    j=j+2;
  end      
end

%
for j=1:2
  i=3;
  for l=2:n2
    ar1=ar(i,j);
    ar2=ar(i+1,j);
    sq=ar1*ar1+ar2*ar2;
    ara=sqrt(sq);
    ar(i  ,j  )=ara;
    ar(i+1,j  )=ara;
    i=i+2;
  end
end

%
j=3;
for l=2:m2
  i=3;
  for k=2:n2
    cc=ar(i  ,j  ); % cos cos
    cs=ar(i  ,j+1); % cos sin
    sc=ar(i+1,j  ); % sin cos
    ss=ar(i+1,j+1); % sin sin

    sq=(cs-sc)^2+(cc+ss)^2;
    ar(i  ,j)=0.5*sqrt(sq);

    sq=(cs+sc)^2+(cc-ss)^2;
    ar(i+1,j)=0.5*sqrt(sq);

    %
    ar1=ar(i,j);
    if ar1==0;
      ar1=0.0001;
    end
    tc1=0.5*(cs-sc)/ar1;

    t1=acos(tc1);
    tsign=cc+ss;
    if tsign < 0
      t1=t1+pi;
    end
    
    %
    ar2=ar(i+1,j);
    if ar2==0;
      ar2=0.0001;
    end
    tc2=0.5*(cs+sc)/ar2;

    t2=acos(tc2);
    tsign=cc-ss;
    if tsign < 0 % note
      t2=t2+pi;
    end

    ar(i  ,j+1)=t1;
    ar(i+1,j+1)=t2;

    i=i+2;
  end
  j=j+2;
end

return


%
%
%
function ret = realfft(x,n)

  x = fft(x,n);

  ret(1) = real(x(1));
  ret(2) = real(x(n/2+1));

  i = 1:(n/2-1);
  i2= i*2;
  ret(i2+1) = real(x(i+1));
  ret(i2+2) = imag(x(i+1));

return;
