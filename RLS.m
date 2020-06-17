% Copyright @ Zihan Wang (2019214609)
% ANC by RLS - recursive least squares algorithm
% Inputs:
% error_mic  - the signal from error mic 
% y  - the signal from refernce mic, mixed with noise and music 
% lamda - the weight parameter, 权重
% M  - the number of taps. 滤波器阶数
% Outputs:
% ee - the estimation error 
% op - output antinoise
% f_para - filter parameters
% ------------------------------------------------------------------------
function [ee, op, f_para] = RLS(err_mic, y,lamda,M)
Ns = length(err_mic);% size of the signal
I = eye(M);% identity mat with the size of filter taps
P = 0.01 * I;% initialize the information matrix P
weight = zeros(M,1);% initialize a all zero weight
op = zeros(Ns, 1);% initialise a vector for output antinoise
ee = zeros(Ns, 1); % initialise a vector for estimation error
yk = zeros(M,1);% initialise a vector for signal input the filter
for n = 1:Ns
    yk = [y(n); yk(1:M-1)];% [y(n);y(n-1);...;y(n-M-1)] 
    K = (P * yk) ./ (lamda + yk' * P * yk); %the gain matrix
    op(n) = yk'*weight;% calculate output signal
    ee(n) = err_mic(n) - op(n);% calculate estimation error
    weight = weight + K * ee(n);% update the weight 
    P = (P - K * yk' * P) ./ lamda; % update the information matrix
    f_para(:,n) = weight;
end
op=-op;
end