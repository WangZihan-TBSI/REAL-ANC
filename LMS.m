% Copyright @ Zihan Wang (2019214609)
% ANC by LMS algorithm
% Usage: [e, y, w] = myLMS(d, x, mu, M)
% Inputs:
% error_mic  - the signal from error mic 
% ref_mic  - the signal from refernce mic, mixed with noise and music 
% mu - the gradient decend stepsize parameter
% M  - the number of taps
% Outputs:
% ee - the estimation error 
% op - output antinoise
% f_para - filter parameters
% ------------------------------------------------------------------------
function [ee, output, f_para] = LMS(err_mic, ref_mic, mu, M)
Ns = length(err_mic);
xk = zeros(M,1);% initialise a vector for signal input the filter
weight = zeros(M,1);% initialize a all zero weight
output = zeros(Ns,1);% initialise a vector for output antinoise
ee = zeros(Ns,1); % initialise a vector for estimation error
for n = 1:Ns
    xk = [xk(2:M);ref_mic(n)];% [x(n-M-1);...;x(n-1);x(n1)] 
    output(n) = weight' * xk; % calculate output signal
    ee(n) = err_mic(n) - output(n); % calculate estimation error
    weight = weight + mu * ee(n) * xk; % update the weight 
    f_para(:,n) = weight;
end
output=-output;
end