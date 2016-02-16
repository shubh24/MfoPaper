function [ess, dat] = file(str)

dat = load(str);
[l b] = size(dat);
ess = (dat(1,:));
dat = (dat(2:l, :));
