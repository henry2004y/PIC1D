function particle = position(particle,prm)
% Update the position in one step

slx = prm.slx;
p = particle;

p.x = p.x + p.vx;
% Periodic BC
p.x = p.x + slx.*(p.x<0.0) - slx.*(p.x>=slx);

end