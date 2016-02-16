% ============================================================   % 
% Files of the Matlab programs included in the book:             %
% Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,        %
% Second Edition, Luniver Press, (2010).   www.luniver.com       %
% ============================================================   %    

% ------------------------------------------------------------   %
% Bat-inspired algorithm for continuous optimization (demo)      %
% Programmed by Xin-She Yang @Cambridge University 2010          %
% For details, please see the following papers:
% 1) Xin-She Yang, Bat algorithm for multi-objective optimization, 
% Int. J. Bio-Inspired Computation, Vol.3, No.5, 267-274 (2011).
% 2) Xin-She Yang, Xingshi He, Bat Algorithm: Literature Review
% and Applications, Int. J. Bio-Inspired Computation,
% Vol. 5, No. 4, pp. 141-149 (2013).
% ------------------------------------------------------------   %

function Q=moba_demo(NPareto)
if nargin<1, 
    NPareto=40;  % Number of points on the Pareto front 
end
global w;

for k=1:NPareto,
    % Generate a weighting coefficient:w so that w1=w, w2=1-w, w1+w2=1.  
    % Observations suggest that systematically monotonic weights are
    % better than random weights.
    w=k/NPareto; 
    [best,fmin]=bat_algorithm;
    [obj1,obj2]=Funobj(best);
    Q(k,:)=[obj1,obj2];
    % Output/display
  disp(['Weight: ',num2str(w)]);
  disp(['Best Obj1=',num2str(obj1),'   Obj2=',num2str(obj2)]);
   
end
% Display the Pareto front
plot(Q(:,1),Q(:,2),'o');
xlabel('Obj_1'); ylabel('Obj_2');


% The main part of the Bat Algorithm                       % 
% Usage: bat_algorithm([20 0.25 0.5]);                     %

function [best,fmin,N_iter]=bat_algorithm(para)
% Default parameters
if nargin<1,  para=[10 0.25 0.5];  end
n=para(1);      % Population size, typically 10 to 25
A=para(2);      % Loudness  (constant or decreasing)
r=para(3);      % Pulse rate (constant or decreasing)
% This frequency range determines the scalings
Qmin=0;         % Frequency minimum
Qmax=2;         % Frequency maximum
% Iteration parameters
%% In order to obtain better/more accurate results, N_iter
%% should be increased to N_iter=2000 or more if necessary.
N_iter=1000;       % Total number of function evaluations
% Dimension of the search variables
d=3;
% Initial arrays
Q=zeros(n,1);   % Frequency
v=zeros(n,d);   % Velocities
% Initialize the population/solutions
for i=1:n,
  Sol(i,:)=randn(1,d);
  Fitness(i)=Fun(Sol(i,:));
end
% Find the current best
[fmin,I]=min(Fitness);
best=Sol(I,:);

% ======================================================  %
% Note: As this is a demo, here we did not implement the  %
% reduction of loudness and increase of emission rates.   %
% Interested readers can do some parametric studies       %
% and also implementation various changes of A and r etc  %
% ======================================================  %

% Start the iterations -- Bat Algorithm
for i_ter=1:N_iter,
        % Loop over all bats/solutions
        for i=1:n,
          Q(i)=Qmin+(Qmin-Qmax)*rand;
          v(i,:)=v(i,:)+(Sol(i,:)-best)*Q(i);
          S(i,:)=Sol(i,:)+v(i,:);
          % Pulse rate
          if rand>r
              S(i,:)=best+0.01*randn(1,d);
          end

     % Evaluate new solutions
           Fnew=Fun(S(i,:));
     % If the solution improves or not too loudness
           if (Fnew<=Fitness(i)) & (rand<A) ,
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
           end

          % Update the current best
          if Fnew<=fmin,
                best=S(i,:);
                fmin=Fnew;
          end
        end
        
end
% End of the main bat algorithm and output/display can be added here.


% Put your objective functions here
function z=Fun(u)
global w;
[obj1,obj2]=Funobj(u);
z=obj1*w+(1-w)*obj2;

% Two objectives
function [obj1,obj2]=Funobj(u)
% In the simplest 1D case, f1=x^2, f2=(x-2)^2. 
% In the d-dim case, the Pareto front extends from (0,4d) to (4d,0).
obj1=sum(u.^2);
obj2=sum((u-2).^2);


