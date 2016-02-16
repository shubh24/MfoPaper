%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BBA source codes version 1.1                                     %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili, S. M. Mirjalili, X. Yang              %
%               Binary Bat Algorithm, Neural Computing and          %
%               Application, in press,                              %
%               DOI: 10.1007/s00521-013-1525-5                      %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
clc
warning ("off", "Octave:broadcast");

CostFunction=@(x) MyCost(x); % Modify or replace Mycost.m according to your cost funciton

Max_iteration=1500; % Maximum number of iterations
noP=50; % Number of particles

A=1;      % Loudness  (constant or decreasing)
r=.90;      % Pulse rate (constant or decreasing)

[ess dat] = file("../../data/ks_45_0");

%BPSO with s-shaped family of transfer functions
[gBest, gBestScore ,ConvergenceCurve]=BBA1(noP, A, r, Max_iteration, ess, dat);

plot(ConvergenceCurve,'DisplayName','BBA','Color', 'r');
hold on


title(['\fontsize{12}\bf Convergence curve']);
xlabel('\fontsize{12}\bf Iteration');ylabel('\fontsize{12}\bf Average Best-so-far');
legend('\fontsize{10}\bf BBA',1);
grid on
axis tight

save resuls

