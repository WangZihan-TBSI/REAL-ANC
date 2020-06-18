% Copyright @ Zihan Wang (2019214609)
% ANC by NLMS algorithm
% Inputs:
% error_mic  - the signal from error mic 
% ref_mic  - the signal from refernce mic, mixed with noise and music 
% mu - the gradient decend stepsize parameter
% M  - the number of taps
% a - normalised step sized
% Outputs:
% ee - the estimation error 
% op - output antinoise
% f_para - filter parameters
function [ee,output, f_para] = NLMS(err_mic, ref_mic, mu, M, a)
Ns = length(err_mic);
xk = zeros(M,1);% initialise a vector for signal input the filter
weight = zeros(M,1);% initialize a all zero weight
output = zeros(Ns,1);% initialise a vector for output antinoise
ee = zeros(Ns,1); % initialise a vector for estimation error

for n = 1:Ns
    xk = [xk(2:M);ref_mic(n)];% [x(n-M-1);...;x(n-1);x(n1)] 
    output(n) = weight' * xk; % calculate output signal
    ee(n) = err_mic(n) - output(n); % calculate estimation error
    k = mu/(a + xk'*xk);
    weight = weight + k * ee(n) * xk;
    f_para(:,n) = weight;
end
end