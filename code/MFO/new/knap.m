function [fit wt] = knap(x, ess, dat)

max_wt = ess(2);
N = ess(1);
out = x*dat;
fit = out(1);
wt = out(2);

%applying the weight constraint
if wt > max_wt
	fit = 0;
end

