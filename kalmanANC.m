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
function [error,op,f_param] = kalmanANC(err_mic,ref_mic,M)
Ns = length(err_mic);
%% kalman filter initializing
weight = zeros(M,1);% initialize a all zero weight
I = eye(M);
op = zeros(Ns, 1);% initialise a vector for output antinoise
xk = zeros(M,1);% initialise a vector for signal input the filter
P = eye(M);
%% Kalman filter updating equation
for n = 1:Ns
    xk = [ref_mic(n); xk(1:M-1)];
    desire = sum((diag(weight)*xk));
    op(n) = xk'*weight;
    error = desire - op(n);
    gain = (P*xk)'*pinv(xk'*P*xk + I) ;
    weight = weight + (gain*error')';
    P = (I - (gain*xk)')*P;
    f_param(:,n) = weight;
end
op = -op;
end