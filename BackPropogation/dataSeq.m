p = 0.35;       % first data point
x = 1;

% Remaining 199 data point (2 is inclusive)
for i = 2:200
    x(end+1) = i;
    n = 4* p(end) *(1- p(end) );
    p(end+1) = n;
end
plot(x,p);
p = p.';
save dataSequence.mat p