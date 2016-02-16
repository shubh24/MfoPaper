clear all
clc

SearchAgents_no = 40; % Number of search agents
filelist = [4, 19, 30, 40, 45, 50, 60, 82, 100, 106];
Max_iteration = 1000; % Maximum numbef of iterations
cum = zeros(10,3);
iter = 1;
while iter <= 10
	%filename = strcat('ks_', int2str(filelist(iter)), '_0')
	filename = strcat('ks_60_0')
	[ess dat] = file(strcat("../../data/", filename));

	[Best_score1,Best_pos,cg_curve1]=MFO1(SearchAgents_no,Max_iteration, ess, dat);
	[Best_score2,Best_pos,cg_curve2]=MFO2(SearchAgents_no,Max_iteration, ess, dat, 1); %V-shaped transfer function
	[Best_score3,Best_pos,cg_curve3]=MFO2(SearchAgents_no,Max_iteration, ess, dat, 2); %S-shaped transfer function

	%greedy_val = greedy(ess, dat);
	%cg_curve3 = ones(1, Max_iteration);
	%cg_curve3 = cg_curve3*greedy_val;

	x = [1:Max_iteration];

	%save ("-v7", strcat("./curves/", filename), "cg_curve1", "cg_curve2", "cg_curve3");

	semilogx(x, cg_curve1, cg_curve3, "r");
	limit=ylim;
	hold on;
	semilogx(x, cg_curve2, "c");
	hold off;
	ylim([limit(1),limit(2) + 1.1*(limit(2)-limit(1))]);
    xlabel("Iteration");
    ylabel("Target Value");
	legend({'fly function', 'V-shaped transfer function', 'S-shaped transfer function'})
	print -djpg img;
	close all hidden;
	res = [Best_score1, Best_score2, Best_score3];
	csvwrite(strcat('./out/', filename, '.csv'), res);
	cum(iter,:) = res;
	rename('img.jpg', strcat(filename, num2str(iter), '.jpg'));
	%movefile(strcat(filename, num2str(iter), '.jpg'), './out');
	display(['The best solution obtained by MFO1 is : ', num2str(Best_pos)]);
	%display(['The best optimal value of the objective funciton found by MFO1 is : ', num2str(Best_score1)]);

	iter = iter+1;
end
csvwrite(strcat('./out/', filename, '.csv1'), cum);
