clear
clc
close all
%% Call dynare and store result

% Set up the array of parameters
array_phi_pi = [1.1, 2, 10, 100];
array_theta = [0.1,0.33,0.67,0.99];

% Create an object to store IRF result
collect = struct();

% Fix theta and loop over phi_pi
dynare_inputs.param_values.theta = 0.67;

for i = 1:length(array_phi_pi)
    dynare_inputs.param_values.phi_pi = array_phi_pi(i);

    % Generate a unique field name for each iteration
    irf_name = "irfs_phi_pi_" + i;

    % Run Dynare
    dynare NKDSGE_monet_model.mod

    collect.(irf_name) = oo_.irfs;
end

% Fix phi_pi and loop over theta
dynare_inputs.param_values.phi_pi = 1.2;

for j = 1:length(array_theta)
    dynare_inputs.param_values.theta = array_theta(j);
    irf_name =  "irfs_theta_"+j;
    dynare NKDSGE_monet_model.mod
    collect.(irf_name) = oo_.irfs;
end;

disp(collect);
%% Display: Set parameters

% Define parameters
xaxis = 0:14;  
yaxis = zeros(size(xaxis));  % Horizontal zero-line

% Define colors and markers for different phi_pi values
colors = {'k', 'b', 'r', 'g'};
markers = {'-o', '-s', '-d', '-*'};
var_names = {'y_e', 'pi_e', 'l_e', 'v_e'};  % Variables for subplots
titles = {'Output', 'Inflation', 'Employment', 'Productivity'};

%% Display: Loop over phi_pi
 
% Create figure and use tiled layout (better spacing than subplot)
fig = figure;
tiledlayout(2,2);

% Loop through subplots
for v = 1:length(var_names)
    nexttile;  % Move to the next subplot
    hold on;
    set(gca, 'Box', 'on', 'FontSize', 16);

    % Loop through phi_pi values to plot each IRF
    for i = 1:length(array_phi_pi)
        phi_pi_label = array_phi_pi(i);
        field_name = sprintf('irfs_phi_pi_%d', i);  % Dynamic field name
        plot(xaxis, collect.(field_name).(var_names{v}), markers{i}, ...
             'Color', colors{i}, 'LineWidth', 1.5);
    end

    % Plot zero-line
    plot(xaxis, yaxis, 'r--', 'LineWidth', 1);

    hold off;
    title(titles{v}, 'FontWeight', 'bold');
end

% Add legend to first subplot only
lgd = legend(compose('$\\phi_{\\pi}$ = %.2f', array_phi_pi), ...
             'Location', 'best', 'Interpreter', 'latex', 'FontSize', 14);
lgd.Layout.Tile = 'north';  % Place the legend outside subplots

% Save figure
saveas(fig,'phi_pi.png');

%% Display: Loop over theta

% Create figure and use tiled layout (better spacing than subplot)
fig2 = figure;
tiledlayout(2,2);

% Loop through subplots
for h = 1:length(var_names)
    nexttile;  % Move to the next subplot
    hold on;
    set(gca, 'Box', 'on', 'FontSize', 16);

    % Loop through phi_pi values to plot each IRF
    for k = 1:length(array_theta)
        phi_pi_label = array_theta(k);
        field_name = sprintf('irfs_theta_%d', k); 
        plot(xaxis, collect.(field_name).(var_names{h}), markers{k}, ...
             'Color', colors{k}, 'LineWidth', 1.5);
    end

    % Plot zero-line
    plot(xaxis, yaxis, 'r--', 'LineWidth', 1);

    hold off;
    title(titles{h}, 'FontWeight', 'bold');
end

% Add legend to first subplot only
lgd = legend(compose('$\\theta$ = %.2f', array_theta), ...
             'Location', 'best', 'Interpreter', 'latex', 'FontSize', 14);
lgd.Layout.Tile = 'north';  % Place the legend outside subplots

% Save figure
saveas(fig2,'theta.png');

