function x = fly(moth, flame, dist)
x = zeros(size(moth)(2));
x = moth;
if dist > 0
	diff = flame != moth;
	idx = find(diff);
	len = size(idx)(2);
	if len != 0
		id = unidrnd(len, [1 dist]);
		x(:,idx(id)) = flame(:,idx(id));
	end
else
	diff = flame == moth;
	idx = find(diff);
	len = size(idx)(2);
	if len != 0
		id = unidrnd(len, [1 abs(dist)]);
		x(:,idx(id)) = ~flame(:,idx(id));
	end
end
