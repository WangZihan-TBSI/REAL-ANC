% kalmanANC.m - recursive least squares algorithm
% Inputs:
% error_mic  - the signal from error mic of size Ns, 
% y  - the noise signal from refernce mic 
% lamda - the weight parameter, 权重
% M  - the number of taps. 滤波器阶数
% Outputs:
% e - the output error vector of size Ns
% op - output coefficients
% w - filter parameters
% ------------------------------------------------------------------------
function [error,op,f_param] = kalmanANC(err_mic,y,M)
Ns = length(err_mic);
%% kalman filter initializing
% weight = zeros(M,1);% initialize a all zero weight
H = diag([1, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6, 0.55]);
I = 1;
op = zeros(Ns, 1);% initialise a vector for output antinoise
weight = normrnd(0,1,[1 10]);
f_param(1:Ns+1,1:M) = 0;
f_param(1,:) = weight;
yk = zeros(M,1);% initialise a vector for signal input the filter
P = eye(M);
%% Kalman filter updating equation
for n = 1:Ns
    yk = [y(n); yk(1:M-1)];
    desire = sum(H*(diag(weight)*yk));
    yk = H*yk;
    op(n) = weight*yk;
    error = desire - op(n);
    gain = P*yk./(transpose(yk)*P*yk + (1*I)^2) ;
    weight = weight + transpose(gain*error');
    P = P - gain*transpose(yk)*P;
    f_param(n+1,:) = weight;
    %e_log(i) = (error/(weight*output));
end
op = -op;
end