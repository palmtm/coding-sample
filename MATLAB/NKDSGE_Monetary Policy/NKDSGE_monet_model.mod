var y pi i v l;
varexo e;

parameters theta beta alpha sigma phi epsilon phi_pi phi_y kappa autocor psi;

% Load parameters values
set_param_value('phi_pi',dynare_inputs.param_values.phi_pi);
set_param_value('theta',dynare_inputs.param_values.theta);

% assign parameter values 
beta = 0.99;
alpha = 1/3;
sigma = 1.00;
phi = 1.00;
epsilon = 6.00;
phi_y = 0.5/4;
kappa = (1-beta*theta)*(1/theta-1)*(1-alpha)/((1-alpha+alpha*epsilon)*(sigma+(phi+alpha)/(1-alpha)));
autocor = 0.5;
psi = 0.5;

model;
    y = -1/sigma*(i - pi(+1) + log(beta)) + y(+1);
    pi = beta*pi(+1) + kappa*(y - psi * v);
    i = -log(beta) + phi_pi * pi;
    v = v(-1)*autocor + e; %Productivity shock
    y = v + l;
end;

shocks;
    var e = 0.25^2;
end;

stoch_simul(irf=15, order=1, irf_plot_threshold=0, nograph) y pi i l v;
