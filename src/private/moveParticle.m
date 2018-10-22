function particle = moveParticle(particle,prm)
%moveParticle Update the position in one step
%
%INPUTS:
% particle:
% prm:
%
%OUTPUT:
% particle:

slx = prm.slx;
x = particle.x; vx = particle.vx;

x = x + vx;
% Periodic BC
x = x + slx.*(x<0.0) - slx.*(x>=slx);

particle.x = x;


end