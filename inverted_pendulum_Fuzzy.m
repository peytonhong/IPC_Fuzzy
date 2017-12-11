% Inverted Pendulum Control
% Fuzzy control
% 2017.12.05 È«È¿¼º
close all; clear;
addpath ./sub_functions
global M m bx bq l g J F
%% pendulum parameters
M   = 2;        % [kg]
m   = 0.8;      % [kg]
bx  = 0.005;    % [kg/s]
bq  = 0.0005;   % [kg m^2/s]
l   = 0.25;     % [m]
g   = 9.81;     % [m/s^2]
J   = 0.0326;   % [kg m]
F   = 0;        % [N]
T_final = 10;   % [s]
Ts = 0.01;      % control step time [s]
video_flag = 0; % choose 1 if you want to save a video file of plot animation

%% initial condition
X   = [-0.5; 0; 15*pi/180; 0];
xd      = 0;
xd_dot  = 0;
qd      = 0;
qd_dot  = 0;

%% Fuzzy Control
% Fuzzy data normalization
x_normal = 12;       % [m]
dx_normal = 1.5;      % [m/s]
q_normal = 360*pi/180;      % [rad]
dq_normal = 180*pi/180; % [rad/s]
u_normal = 1000;     % [N]

% data save
X_Fuzzy = zeros(T_final/Ts+1,4);
time_Fuzzy = zeros(T_final/Ts+1,1);
F_save = zeros(T_final/Ts+1,1);
u_save = zeros(T_final/Ts+1,2);
X_Fuzzy(1,:) = X';
count = 2;
x_prev = X(1);
q_prev = X(3);
for time=Ts:Ts:T_final
    
    ex  = xd - X(1);         % error of cart position   
    dex = x_prev - X(1);     % error difference of cart position   
    
    eq  = qd - X(3);         % error of pendulum angle
    deq = q_prev - X(3);     % error difference of pendulum angle
    
    % Fuzzy control (u_x: cart position, u_q: pendulum angle)
    u_x = defuzzification(fuzzy_inference(fuzzification(ex/x_normal, dex/dx_normal))) * u_normal*1;
    u_q = defuzzification(fuzzy_inference(fuzzification(eq/q_normal, deq/dq_normal))) * u_normal*2;
    u_save(count,:) = [u_x, u_q];

    F = -u_x + u_q;
    
    x_prev = X(1);
    q_prev = X(3);
    
    [T, X_next] = ode45(@diff_pendulum, [0, Ts], X);
    X = X_next(end,:)';
    X_Fuzzy(count,:) = X';
    time_Fuzzy(count) = time;
    F_save(count) = F;
    count = count + 1;   
end


%% Free fall (No control)
%[T, Z_ode] = ode45(@diff_pendulum, [0, T_final], X);

%% Make video
if video_flag == 1
    % Video file open
    makeVideo = VideoWriter('IPC_Fuzzy');
    % Frame Rate - Frames per second
    makeVideo.FrameRate = 100;
    % Quality - ¿ë·®°ú °ü·Ã µÊ (0 ~ 100)
    makeVideo.Quality = 80;
    open(makeVideo);
end

%% Plot
X_result = X_Fuzzy;
Time_result = time_Fuzzy;

figure(1)
axis_limit = 1;
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
    axis([-axis_limit axis_limit -0.5 0.5])
    sim_status = sprintf('Simulation time: %5.2f s',Time_result(i));
    title(sim_status,'FontSize',13)
    
    if video_flag == 1 && rem(Time_result(i),0.01) == 0
        frame = getframe(gcf);
        writeVideo(makeVideo,frame);
    end
    
    pause(Ts);
end

if video_flag == 1
    close(makeVideo);
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
hold on
plot(Time_result, u_save(:,1),'r')
plot(Time_result, u_save(:,2),'c')
grid on
xlabel('Time [s]')
ylabel('Force [N]')
legend('Input force', 'u_x', 'u_q')
