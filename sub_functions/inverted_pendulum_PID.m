% Inverted Pendulum Control
% PID control
% Neural network control
% 2017.11.24 È«È¿¼º
close all; clear;
addpath ./sub_functions
global M m bx bq l g J F
%% pendulum parameters
M   = 2;        % [kg]
m   = 0.8;      % [kg]
bx  = 0.005;    % [kg/s]
bq  = 0.0005;   % [kg m^2/s]
% bx  = 1;    % [kg/s]
% bq  = 0.5;   % [kg m^2/s]
l   = 0.25;     % [m]
g   = 9.81;     % [m/s^2]
J   = 0.0326;   % [kg m]
F   = 0;        % [N]
T_final = 10;   % [s]
Ts = 0.01;      % control step time [s]
%% initial condition
X   = [0; 0; 20*pi/180; 0];
xd      = 0;
xd_dot  = 0;
qd      = 0;
qd_dot  = 0;

%% PID Control
% cart position gain
Kpx = 10; 
Kdx = 5;
Kix = 2;
% pendulum position gain
Kpq = 70; 
Kdq = 5;
Kiq = 5;
% error integration (sum)
ex      = 0;
eq      = 0;
ex_sum  = 0;
eq_sum  = 0;
ex_dot  = 0;
eq_dot  = 0;
% data save
X_PID = zeros(T_final/Ts+1,4);
time_PID = zeros(T_final/Ts+1,1);
F_save = zeros(T_final/Ts+1,1);
X_PID(1,:) = X';
count = 2;
for time=Ts:Ts:T_final
    ex_prev = ex;
    ex      = xd - X(1);        % error of cart position    
    ex_dot  = (ex - ex_prev)/Ts;    % error of cart velocity
    ex_sum  = ex_sum + ex*Ts;   % error integration of cart position
    
    eq_prev = eq;
    eq      = qd - X(3);        % error of pendulum position
    eq_dot  = (eq - eq_prev)/Ts;    % error of pendulum velocity
    eq_sum  = eq_sum + eq*Ts;   % error integration of pendulum position
    
    F = -(Kpx*ex + Kdx*ex_dot + Kix*ex_sum) + (Kpq*eq + Kdq*eq_dot + Kiq*eq_sum);

    [T, X_next] = ode45(@diff_pendulum, [0, Ts], X);
    X = X_next(end,:)';
    X_PID(count,:) = X';
    time_PID(count) = time;
    F_save(count) = F;
    count = count + 1;
end


%% Free fall (No control)
%[T, Z_ode] = ode45(@diff_pendulum, [0, T_final], X);


%% Plot
X_result = X_PID;
Time_result = time_PID;

figure(1)
axis_limit = 0.31;
for i=1:size(X_result,1)    
    cart_position_x = X_result(i,1);
    pend_position_x = X_result(i,1) - l*sin(X_result(i,3));
    pend_position_y = l*cos(X_result(i,3));
    
    hold off
    plot(pend_position_x, pend_position_y, 'ok', 'MarkerSize', 25, 'MarkerFaceColor',[0.2 0.9 0.2])   % pendulum
    hold on
    plot(cart_position_x, 0, 'sk', 'MarkerSize', 50, 'MarkerFaceColor',[0.8 0.8 0.8])    % cart
    hold on    
    if cart_position_x > pend_position_x
        plot(linspace(cart_position_x,pend_position_x,2), linspace(0,pend_position_y,2), 'k', 'LineWidth', 3)   % rod
    else
        plot(linspace(cart_position_x,pend_position_x,2), linspace(0,pend_position_y,2), 'r', 'LineWidth', 3)   % rod
    end
    grid on
    xlabel('[m]')
    ylabel('[m]')
    axis([-axis_limit axis_limit -axis_limit axis_limit])
    sim_status = sprintf('Simulation time: %5.2f s',Time_result(i));
    title(sim_status,'FontSize',13)
    pause(Ts);
end

figure(2)
subplot(3,1,1)
plot(Time_result, X_result(:,1:2))
grid on
xlabel('Time [s]')
legend('cart position [m]', 'cart velocity [m/s]')

subplot(3,1,2)
plot(Time_result, X_result(:,3:4)*180/pi)
grid on
xlabel('Time [s]')
legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(3,1,3)
plot(Time_result, F_save)
grid on
xlabel('Time [s]')
ylabel('Force [N]')
legend('Input force')
