%______________________________________________________________________________________________
%  Moth-Flame Optimization Algorithm (MFO)                                                            
%  Source codes demo version 1.0                                                                      
%                                                                                             
%  Developed in MATLAB R2011b(7.13)                                                                   
%                                                                                                     
%  Author and programmer: Seyedali Mirjalili                                                          
%                                                                                                     
%         e-Mail: ali.mirjalili@gmail.com                                                             
%                 seyedali.mirjalili@griffithuni.edu.au                                               
%                                                                                                     
%       Homepage: http://www.alimirjalili.com                                                         
%                                                                                                     
%  Main paper:                                                                                        
%  S. Mirjalili, Moth-Flame Optimization Algorithm: A Novel Nature-inspired Heuristic Paradigm, 
%  Knowledge-Based Systems, DOI: http://dx.doi.org/10.1016/j.knosys.2015.07.006
%_______________________________________________________________________________________________
% You can simply define your cost in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iteration = maximum number of generations
% SearchAgents_no = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single number numbers

% To run MFO: [Best_score,Best_pos,cg_curve]=MFO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj)
%______________________________________________________________________________________________

function [Best_flame_score,Best_flame_pos,Convergence_curve]=MFO(N,Max_iteration, ess, dat)

display('MFO is optimizing your problem');

dim = ess(1)

%Initialize the positions of moths
Moth_pos=initialization(N,dim);

Convergence_curve=zeros(1,Max_iteration);

Iteration=1;

% Main loop
while Iteration<Max_iteration+1
    
    % Number of flames Eq. (3.14) in the paper
    Flame_no=round(N-Iteration*((N-1)/Max_iteration));
     
    for i=1:size(Moth_pos,1)
	[fit wt] = knap(Moth_pos(i,:), ess, dat);
	if fit == 0 && wt > 0
		one = Moth_pos(i,:) == 1;
		index = find(one);
		len = size(index)(2);
		while wt > ess(2)
			idx = floor(rand()*len) + 1;
			Moth_pos(i,index(idx)) = 0;
			wt = wt - dat(index(idx), 2);
		end
	end
	Moth_fitness(1,i) = knap(Moth_pos(i, :), ess, dat)(1);
    end
    
    if Iteration==1
        % Sort the first population of moths
        [fitness_sorted I]=sort(Moth_fitness, 'descend');
        sorted_population=Moth_pos(I,:);

        % Update the flames
        best_flames=sorted_population;
        best_flame_fitness=fitness_sorted;
    else
        
        % Sort the moths
        double_population=[previous_population;best_flames];
        double_fitness=[previous_fitness best_flame_fitness];
        
        [double_fitness_sorted I]=sort(double_fitness, 'descend');
        double_sorted_population=double_population(I,:);
        
        fitness_sorted=double_fitness_sorted(1:N);
        sorted_population=double_sorted_population(1:N,:);
        
        % Update the flames
        best_flames=sorted_population;
        best_flame_fitness=fitness_sorted;
    end
    
    % Update the position best flame obtained so far
    Best_flame_score=fitness_sorted(1);
    Best_flame_pos=sorted_population(1,:);
      
    previous_population=Moth_pos;
    previous_fitness=Moth_fitness;
    
    % a linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
    a=-1+Iteration*((-1)/Max_iteration);

    for i=1:size(Moth_pos,1)
	b = 1;
        t = (a-1).*rand(1, size(Moth_pos, 2)) + ones(1, size(Moth_pos, 2));
        
	spiral1 = exp(b.*t).*cos(t.*2*pi);		#2
	spiral2 = b*cos((2*pi).*t)./2*pi.*t;			#3
	spiral3 = b*cos(2*pi.*t)./(2*pi.*(abs(t).^0.5));	#1
	val = 1./(1+e.^(-spiral1));
	val = val > 0.5;
 		
         
	if i<=Flame_no % Update the position of the moth with respect to its corresponsing flame
        
		Moth_pos(i,:) = xor(val,sorted_population(i, :));
        
	else % Update the position of the moth with respct to one flame
            
		Moth_pos(i,:) = xor(val,sorted_population(Flame_no, :));
            
        end
    end

    Convergence_curve(Iteration)=Best_flame_score;
    
    % Display the iteration and best optimum obtained so far
    if mod(Iteration,50)==0
        display(['At iteration ', num2str(Iteration), ' the best fitness is ', num2str(Best_flame_score)]);
    end
    Iteration=Iteration+1; 
end

