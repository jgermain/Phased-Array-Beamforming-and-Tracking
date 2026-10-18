% Phased Array Antenna Simulation (Uniform Linear Array)
% -----------------------------------------------------
% Features:
%   - Array factor plotting
%   - Beamwidth + SLL metrics
%   - Target tracking simulation
%   - RMS tracking error
%   - Multi-curve RMS vs HPBW (noise + lag sweeps)
%   - Optional spacing sweep (grating lobes insight)
%
% Author: Josiah Germain

% Housekeeping
close all; clear; clc;

% ==========================
% USER SETTINGS
% ==========================
runTracking = true;
useNormalization = true;
useDecibelPlot  = false;

% Array parameters
lambda = 0.3;
K = 2*pi/lambda;
d = lambda/2;
N = 16;

% ==========================
% TRACKING MODE
% ==========================
if runTracking

    % Time + motion
    t_total = 5;
    dt = 0.01;
    t = 0:dt:t_total;
    theta_target = 20 * sin(2*pi*0.5*t);

    % Imperfections (baseline case)
    lag_steps = 5;
    noise_std = 1.0;

    % Reference beam
    theta_0 = 0;
    B = -K*d*sin(theta_0);

    % Get metrics
    [~, ~, HPBW, ~, SLL_dB, ~, ~] = ...
        computeArrayFactor(K, d, N, B, lambda, true);

    SLL_linear = 10^(SLL_dB/20);

    % Run tracking
    [theta_steered, tracking_error, RMS_error] = ...
        runTrackingSimulation(theta_target, HPBW, SLL_linear, lag_steps, noise_std);

    % ==========================
    % PLOTS
    % ==========================
    figure;

    subplot(2,1,1)
    plot(t, theta_target, 'LineWidth', 1.5); hold on;
    plot(t, theta_steered, '--', 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('Angle (deg)');
    title('Target Tracking');
    legend('Target','Steered Beam');
    grid on;

    text(0.02,0.95,{
        sprintf('N = %d', N)
        sprintf('d = %.2f \\lambda', d/lambda)
        sprintf('HPBW = %.2f°', HPBW)
        sprintf('Lag = %d', lag_steps)
        sprintf('Noise = %.2f°', noise_std)
    },'Units','normalized','VerticalAlignment','top',...
      'BackgroundColor','w','EdgeColor','k');

    subplot(2,1,2)
    plot(t, tracking_error, 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('Normalized Error');
    title('Tracking Error');
    grid on;

    text(0.02,0.95,{
        sprintf('RMS = %.4f', RMS_error)
        sprintf('HPBW = %.2f°', HPBW)
        sprintf('SLL = %.2f dB', SLL_dB)
    },'Units','normalized','VerticalAlignment','top',...
      'BackgroundColor','w','EdgeColor','k');

    % ==========================
    % NOISE SWEEP
    % ==========================
    N_values = 4:2:32;
    noise_levels = [0.2 0.5 1.0 2.0];

    HPBW_values = zeros(size(N_values));
    RMS_matrix = zeros(length(noise_levels), length(N_values));

    for n_idx = 1:length(noise_levels)

        noise_std = noise_levels(n_idx);

        for i = 1:length(N_values)

            N_temp = N_values(i);

            [~, ~, HPBW, ~, SLL_dB, ~, ~] = ...
                computeArrayFactor(K, d, N_temp, B, lambda, true);

            SLL_linear = 10^(SLL_dB/20);

            [~, ~, RMS_error] = ...
                runTrackingSimulation(theta_target, HPBW, SLL_linear, lag_steps, noise_std);

            HPBW_values(i) = HPBW;
            RMS_matrix(n_idx,i) = RMS_error;
        end
    end

    [HPBW_values, idx] = sort(HPBW_values);
    RMS_matrix = RMS_matrix(:, idx);

    figure; hold on; grid on;
    for i = 1:length(noise_levels)
        plot(HPBW_values, RMS_matrix(i,:), 'o-', 'LineWidth', 1.5);
    end

    xlabel('HPBW (deg)');
    ylabel('RMS Error');
    title('RMS Error vs Beamwidth (Noise Sweep)');
    legend(arrayfun(@(x) sprintf('\\sigma=%.1f°',x), noise_levels,'UniformOutput',false));

    % ==========================
    % LAG SWEEP
    % ==========================
    lag_values = [0 2 5 10];
    RMS_lag = zeros(length(lag_values), length(N_values));

    for l_idx = 1:length(lag_values)

        lag_steps = lag_values(l_idx);

        for i = 1:length(N_values)

            N_temp = N_values(i);

            [~, ~, HPBW, ~, SLL_dB, ~, ~] = ...
                computeArrayFactor(K, d, N_temp, B, lambda, true);

            SLL_linear = 10^(SLL_dB/20);

            [~, ~, RMS_error] = ...
                runTrackingSimulation(theta_target, HPBW, SLL_linear, lag_steps, noise_std);

            RMS_lag(l_idx,i) = RMS_error;
        end
    end

    figure; hold on; grid on;
    for i = 1:length(lag_values)
        plot(HPBW_values, RMS_lag(i,:), 'o-', 'LineWidth', 1.5);
    end

    xlabel('HPBW (deg)');
    ylabel('RMS Error');
    title('RMS Error vs Beamwidth (Lag Sweep)');
    legend(arrayfun(@(x) sprintf('Lag=%d',x), lag_values,'UniformOutput',false));

    % ==========================
    % ELEMENT SPACING SWEEP
    % ==========================
    d_values = [lambda/2, 0.75*lambda];
    RMS_spacing = zeros(length(d_values), length(N_values));

    for d_idx = 1:length(d_values)

        d_temp = d_values(d_idx);

        for i = 1:length(N_values)

            N_temp = N_values(i);

            [~, ~, HPBW, ~, SLL_dB, ~, ~] = ...
                computeArrayFactor(K, d_temp, N_temp, B, lambda, true);

            SLL_linear = 10^(SLL_dB/20);

            [~, ~, RMS_error] = ...
                runTrackingSimulation(theta_target, HPBW, SLL_linear, lag_steps, noise_std);

            RMS_spacing(d_idx,i) = RMS_error;
        end
    end

    figure; hold on; grid on;
    for i = 1:length(d_values)
        plot(HPBW_values, RMS_spacing(i,:), 'o-', 'LineWidth', 1.5);
    end

    xlabel('HPBW (deg)');
    ylabel('RMS Error');
    title('RMS Error vs Beamwidth (Spacing Sweep)');
    legend({'d = \lambda/2','d = 0.75\lambda'});

end

% ==========================
% ARRAY FACTOR MODE
% ==========================
if ~runTracking

    theta_deg_input = 0;
    theta_0 = deg2rad(theta_deg_input);
    B = -K*d*sin(theta_0);

    [theta_deg, AF_plot, HPBW, FNBW, SLL_dB, idxL, idxR] = ...
        computeArrayFactor(K, d, N, B, lambda, useNormalization);

    figure; hold on; grid on;

    if useDecibelPlot
        plot(theta_deg, 20*log10(AF_plot),'LineWidth',1.5);
        ylabel('dB');
    else
        plot(theta_deg, AF_plot,'LineWidth',1.5);
        ylabel('Magnitude');
    end

    xlabel('Angle (deg)');
    title('Array Factor');

    xline(theta_deg(idxL),'--');
    xline(theta_deg(idxR),'--');

end

% ==========================
% FUNCTION: TRACKING
% ==========================
function [theta_steered, tracking_error, RMS_error] = ...
    runTrackingSimulation(theta_target, HPBW, SLL_linear, lag_steps, noise_std)

    theta_steered = zeros(size(theta_target));
    tracking_error = zeros(size(theta_target));
    hist = zeros(size(theta_target));

    for k = 1:length(theta_target)

        theta_true = theta_target(k);

        noise = noise_std*randn;
        interference = SLL_linear*randn;

        meas = theta_true + noise + interference;
        hist(k) = meas;

        if k > lag_steps
            theta_steer = hist(k-lag_steps);
        else
            theta_steer = meas;
        end

        theta_steered(k) = theta_steer;

        tracking_error(k) = (theta_steer - theta_true)/HPBW;

    end

    RMS_error = sqrt(mean(tracking_error.^2));
end

% ==========================
% FUNCTION: ARRAY FACTOR
% ==========================
function [theta_deg, AF_plot, HPBW, FNBW, SLL_dB, idxL, idxR] = ...
    computeArrayFactor(K,d,N,B,lambda,useNormalization)

    theta = linspace(-pi/2, pi/2, 1000);

    AF = zeros(size(theta));
    for n=0:N-1
        AF = AF + exp(1i*n*(K*d*sin(theta)+B));
    end

    AF_mag = abs(AF);
    peak = max(AF_mag);

    [~, idxMax] = max(AF_mag);

    idxL = idxMax;
    while idxL>1 && AF_mag(idxL)>=0.707*peak
        idxL=idxL-1;
    end

    idxR = idxMax;
    while idxR<length(AF_mag) && AF_mag(idxR)>=0.707*peak
        idxR=idxR+1;
    end

    HPBW = rad2deg(theta(idxR)-theta(idxL));
    FNBW = 2*asind(lambda/(N*d));

    side = AF_mag;
    side(idxL:idxR)=0;
    SLL = max(side)/peak;
    SLL_dB = 20*log10(SLL);

    if useNormalization
        AF_plot = AF_mag/peak;
    else
        AF_plot = AF_mag;
    end

    theta_deg = rad2deg(theta);
end
