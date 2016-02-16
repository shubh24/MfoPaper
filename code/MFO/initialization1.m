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

% This function creates the first random population of moths

function X=initialization1(SearchAgents_no, ess, dat)

ratio = dat(:, 1)./dat(:, 2);
[rat ord] = sort(ratio,'descend');

dim = ess(1);
max_wt = ess(2)
wt = 0;
row = zeros(1, dim);
idx = 1;

for i = 1:dim
	if(wt + dat(ord(i), 2) <= max_wt)
		wt = wt + dat(ord(i), 2);
		row(ord(i)) = 1;
	end
end
row;
[fit wt] = knap(row, ess, dat)

X = zeros(SearchAgents_no, dim);

X= round(rand(SearchAgents_no,dim));

X(1,:) = row;
