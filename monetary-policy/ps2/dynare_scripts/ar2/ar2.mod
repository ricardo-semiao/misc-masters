//
// AR(1) model
//
var x;
varexo e;

parameters rho1 rho2 se;

rho1 = 0.70;
rho2 = -0.5;
se = 0.02;

model;
x = rho1*x(-1)+rho2*x(-2)+e;
end;

initval;
e=0;
x=0;
end;

steady;
check;

shocks;
var e;
stderr se;
end;

stoch_simul(irf = 40, nodisplay);
