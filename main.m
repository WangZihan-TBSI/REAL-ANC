% Copyright @ Zihan Wang (2019214609)
% demo programm of REAL-ANC
close all;clear;clc;
%% prepare sounds
% read sound files
[loud_music,fs] = audioread('Astronomia.wav');
[quite_music,fs2] = audioread('piano.wav');
[noise1,fsn1] = audioread('fan_noise.wav');
[noise2,fsn2] = audioread('construction_talking_noise.wav');
% trim sound files
music_time = 4;
% the soundtrack include in my repo only have 36 in maximum, you  need
% substitute to your own to try longer music clip
fprintf('Demo music have %d seconds\n',music_time);
loud_music = loud_music(1:music_time*fs,1);
quite_music = quite_music(1:music_time*fs2,1);
noise1 = noise1(1:music_time*fsn1,1);
noise2 = noise2(1:music_time*fsn2,1);
% mix music and noise
mix1 = loud_music+noise1;
mix2 = loud_music+noise2;
mix3 = loud_music+noise1+noise2;
mix4 = quite_music+noise1;
mix5 = quite_music+noise2;
mix6 = quite_music+noise1+noise2;

%% System structure of ANC
%              +-----------+                       +   
% x(k) ---+--->|   P(z)    |--d(n)-----------------> sum --+---> e(n)
%         |    +-----------+                          ^+   |
%         |                                           |    |
%         |                                         y'(n)  |     
%         |    +-----------+          +-----------+   |    |
%         +--->|   W(z)    |--y(n)--->|   H(z)    |---+    |
%         |    +-----------+          +-----------+        |
%         |            ^                                   |
%         |             \----------------\                 |
%         |                               \                |
%         |    +-----------+          +-----------+        |
%         +--->|   C(z)    |--x'(n)-->|    LMS    |<-------+
%              +-----------+          +-----------+        
      
%% algorithm performance comparision
% input Parameters setting：
mu =  0.1;    % LMS stepsize
mu2 = 0.5;    % NLMS stepsize
a = 0.1;     % normalised step sized for NLMS algorithm
lamda = 0.999;%RLS weight        
M=10;         %learned filter length
ref_mic = noise1*2; % the pure noise record by reference microphone, only
                  % used in feedforward [also called input signal]
error_mic = mix4; % sound recorded by error microphone, both used in 
                  % feedforward and feedback [also called desired signal]
% output parameters
% f_para - filter parameters
% op - noise cancelling speaker output signal
% err - output error

% use LMS algorithm
tic
[err_lms, op_lms, f_para_lms] = LMS(error_mic, ref_mic, mu, M);
disp('LMS algorithm spend')
toc
% use NLMS algorithm
tic
[err_nlms, op_nlms, f_para_nlms] = NLMS(error_mic, ref_mic, mu2, M, a);
disp('NLMS algorithm spend')
toc
% Use RLS algorithm (Recursive Least Squares)
tic
[err_rls, op_rls, f_para_rls] = RLS(error_mic, ref_mic, lamda, M);
disp('RLS algorithm spend')
toc
% Use Kalman Filter algorithm
tic
[err_kalman,op_kalman,f_param_kalman] = kalmanANC(error_mic,ref_mic,M);
disp('Kalman Filter algorithm spend')
toc
%% playing the ANC processed sound
disp('playing original NOISY music');
noisy_sound = audioplayer(error_mic,fs);
play(noisy_sound)
pause(music_time+1);% wait till finished playing

disp('playing LMS ANCed music');
ANCed_sound=audioplayer(error_mic+op_lms,fs);
play(ANCed_sound);
pause(music_time+1);% wait till finished playing

disp('playing NLMS ANCed music');
ANCed_sound=audioplayer(error_mic+op_nlms,fs);
play(ANCed_sound);
pause(music_time+1);% wait till finished playing

disp('playing RLS ANCed music');
ANCed_sound=audioplayer(error_mic+op_rls,fs);
play(ANCed_sound);
pause(music_time+1);% wait till finished playing

disp('playing Kalman filter ANCed music');
ANCed_sound=audioplayer(error_mic+op_kalman,fs);
play(ANCed_sound)