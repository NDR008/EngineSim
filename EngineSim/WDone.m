function [ Work ] = WDone( P, V )
%   [ Work ] = WDone( P, V )
%   WDone estimates the work done for a given set of P, V, values
temp = size(P,2);
Work = 0;

for cnt=2:temp
    Work = Work + (P(cnt)+P(cnt-1))/2*(V(cnt)-V(cnt-1));
end
end
