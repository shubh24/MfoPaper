% Modified source code :

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


% Main source code :
% ======================================================== % 
% Files of the Matlab programs included in the book:       %
% Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,  %
% Second Edition, Luniver Press, (2010).   www.luniver.com %
% ======================================================== %    

% -------------------------------------------------------- %
% Bat-inspired algorithm for continuous optimization (demo)%
% Programmed by Xin-She Yang @Cambridge University 2010    %
% -------------------------------------------------------- %
% Usage: bat_algorithm([Particle_No Loudness Pulse_rate Variable_no Max_iteration Costfunction]);                     %

function [best,fmax,cg_curve]=BBA(n, A, r, Max_iter, ess, dat)

% Display help
%help bat_algorithm.m

%n is the population size, typically 10 to 25
%A is the loudness  (constant or decreasing)
%r is the pulse rate (constant or decreasing)
%d is the dimension of the search variables
%Max_iter is the maximum number of iteration

% This frequency range determines the scalings
Qmin=-1;         % Frequency minimum
Qmax=1;         % Frequency maximum
% Iteration parameters
N_iter=0;       % Total number of function evaluations
gmm = 0.9
alp = 0.8

d = ess(1);

% Initial arrays
Q=zeros(n,1);   % Frequency
v=zeros(n,1);   % Velocities
Sol=zeros(n,d);
S = zeros(1, d);
cg_curve=zeros(1,Max_iter);
rate = ones(n, 1);
A = d*ones(n, 1);

% Initialize the population/solutions

for i=1:n,
	Sol(i,:) = round(rand(1,d));
	v(i) = round(rand*d);
end

for i=1:n,
	Fitness(i)=knap(Sol(i,:), ess, dat);
end

% Find the current best
[fmax,I]=max(Fitness);
best=Sol(I,:);

% ======================================================  %
% Note: As this is a demo, here we did not implement the  %
% reduction of loudness and increase of emission rates.   %
% Interested readers can do some parametric studies       %
% and also implementation various changes of A and r etc  %
% ======================================================  %

% Start the iterations -- Binary Bat Algorithm
while (N_iter<Max_iter)
	% Loop over all bats/solutions
	N_iter=N_iter+1;
	cg_curve(N_iter)=fmax;
	for i=1:n
		Q(i) = Qmin + (Qmax-Qmin)*rand;
		dist = sum(Sol(i,:) != best);
	  	
		v(i) = round(v(i) + (dist).*Q(i));
		Sol(i,:) = fly(Sol(i,:), best, v(i));
		S = Sol(i,:);
		if rand < rate(i)  % Pulse rate
			dist = round(rand*mean(A));

			%fly the bat around the current point
			idx = randperm(d)(1:dist);
			S(idx) = ~Sol(i,idx);
		end   

		Fnew = knap(S, ess, dat); % Evaluate new solutions

		if (Fnew >= Fitness(i)) && (rand<A)  % If the solution improves or not too loudness
			Sol(i,:) = S;
			%rate(i) = r.*(1-exp(-gmm*N_iter));	
			A(i) = alp*A(i);
			Fitness(i)=Fnew;
		end

		% Update the current best
		if Fnew >= fmax,
			best=Sol(i,:);
				fmax=Fnew;
		end
	end

	% Output/display
	if mod(N_iter, 50) == 0
		disp(['Number of evaluations: ',num2str(N_iter)]);
		disp([' fmax=',num2str(fmax)]);

	end
end
