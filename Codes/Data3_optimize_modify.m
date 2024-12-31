
%% Optimization Using fmincon

% Load your data
% Replace with actual data
% pt_real = ...; % Real pt values
% BC_real = ...; % Real BC values
% div = ...;     % Known array div
% Lambda = ...;  % Known array Lambda
% height_sim = ...; % Known array height_sim

% Set number of time steps
N = length(pt_real);

% Define expanded bounds for t1 and t2
t1_min = -500; t1_max = 50;   %positive makes outcome larger
t2_min = -10; t2_max = 10;   %negative makes outcome smaller

% Define bounds
lb = [repmat(t1_min, 1, N), repmat(t2_min, 1, N)];
ub = [repmat(t1_max, 1, N), repmat(t2_max, 1, N)];

% Set options for particleswarm
options = optimoptions('particleswarm', 'Display', 'iter', ...
                       'SwarmSize', 200, 'MaxIterations', 300);

% Run particleswarm optimization
optimal_params = particleswarm(@(params) ...
    corr_coefficient_function(params, pt_real, BC_real, div, Lambda, height_sim), ...
                               2 * N, lb, ub, options);

% Extract optimal t1 and t2
t1_optimal = optimal_params(1:N);
t2_optimal = optimal_params(N+1:end);

%% save or not 

save ./Mat_Files/t1_optimal.mat t1_optimal
save ./Mat_Files/t2_optimal.mat t2_optimal


%% Plot the results

% Simulate BC_control with the optimal parameters
[~, BC_control_optimal] = simulate_pt_BC_dynamic(t1_optimal, t2_optimal, pt_real, div, Lambda, height_sim);

% Plot the results
figure;
plot(1:N, BC_real, 'b-', 'LineWidth', 2); hold on;
BC_control_optimal_smooth=smoothdata(BC_control_optimal, 'gaussian', 25);
plot(1:N, BC_control_optimal_smooth, 'r--', 'LineWidth', 2);
legend('BC\_real', 'BC\_control\_optimal');
xlabel('Time Step');
ylabel('BC Value');
title('Comparison of BC\_real and BC\_control (Optimized)');
grid on;



%% The objective function Using Correlation Coefficient
% maximizing the r is equivalent to minimizing 1-r

function corr_loss = corr_coefficient_function(params, pt_real, BC_real, div, Lambda, height_sim)
    % Extract t1 and t2 from params
    N = length(pt_real);
    t1 = params(1:N);
    t2 = params(N+1:end);
    
    % Simulate pt_control and BC_control
    [~, BC_control] = simulate_pt_BC_dynamic(t1, t2, pt_real, div, Lambda, height_sim);
    
    % Calculate correlation coefficient between BC_real and BC_control
    corr_coeff = corr(BC_real', BC_control');
    
    % Loss is 1 - correlation coefficient
    corr_loss = 1 - corr_coeff;
end



%% Simulation Function
% calculate BC_control and pt_control for given t1,t2

function [pt_control, BC_control] = simulate_pt_BC_dynamic(t1, t2, pt_real, div, Lambda, height_sim)
    % Initialize pt_control
    pt_control = zeros(size(pt_real));
    pt_control(1) = pt_real(1); % Initial value

    % Calculate pt_control dynamically
    for i = 1:(length(pt_real) - 1)
        pt_control(i+1) = pt_control(i) + t1(i) * div(i) * pt_control(i) + t2(i) * Lambda(i) * pt_control(i);
    end

    % Calculate BC_control
    BC_control = pt_control ./ height_sim;
end



