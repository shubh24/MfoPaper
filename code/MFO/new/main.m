clear all
clc

SearchAgents_no=30; % Number of search agents

Max_iteration=1500; % Maximum numbef of iterations

[ess dat] = file("../../data/ks_100_0");
[Best_score,Best_pos,cg_curve]=MFO1(SearchAgents_no,Max_iteration, ess, dat);

display(['The best solution obtained by MFO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by MFO is : ', num2str(Best_score)]);
