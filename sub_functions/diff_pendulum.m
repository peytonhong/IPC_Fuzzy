function dX = diff_pendulum(~, X)
global M m bx bq l g J F
dX = zeros(4,1);

% Lagrangian equation
dX(1) = X(2);
dX(2) = 1/(M+m-m*cos(X(3))^2)*(m*g*sin(X(3))*cos(X(3)) - m*bq*cos(X(3))*X(4) - m*l*X(4)^2*sin(X(3)) + F - bx*X(2));
dX(3) = X(4);
dX(4) = 1/((M+m)*l/cos(X(3)) - m*l*cos(X(3)))*((M+m)*g*tan(X(3)) - (M+m)/cos(X(3))*bq*X(4) - m*l*X(4)^2*sin(X(3)) + F - bx*X(2));

% Text book equation : Not good
% dX(1) = X(2);
% dX(2) = ((J+m*l^2)/((M+m)*(J+m*l^2)-(m*l*cos(X(3)))^2)*(F + m^2*l^2*g*sin(X(3))*cos(X(3))/(J+m*l^2)) - m*l*cos(X(3))*bq*X(4)/(J+m*l^2) + m*l*X(4)^2*sin(X(3)) - bx*X(2));
% dX(3) = X(4);
% dX(4) = ( (m*l*cos(X(3)))/((m*l*cos(X(3)))^2-(M+m)*(J+m*l^2)) )*( F - (M+m)*g*tan(X(3)) + (M+m)*bq/(m*l*cos(X(3)))*X(4) + m*l*X(4)^2*sin(X(3)) - bx*X(2) );

end