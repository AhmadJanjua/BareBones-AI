% All the input vectors, listed as a matrix
p = [1 2 3 1 2 4; 4 5 3.5 0.5 2 0.5];
[p_row, p_col] = size(p);
% The actual test classifications as an array
t = [1 1 1 0 0 0];
[t_row, t_col] = size(t);

% make an array that tracks the success of each test
is_valid = false(1,t_col);

% keep track of current test group
iter = 0;

% Initializing weight and bias
W = zeros(t_row, p_row);
b = zeros(t_row,1);

% Loop unitl every point is successfully classified
while(~all(is_valid))
    % cycle in between 1,2,...,n 
    iter = 1 + mod(iter,p_col);
    
    % calculate the net input
    n =  W * p(:,iter) + b;

    % calculate the output
    a = hardlim(n);

    % Calculate the difference between output and test
    e = t(:,iter) - a;

    % if the output matches the test, set the current flag to true
    if(all(~e))
        is_valid(iter) = true;
    % if the output differs, reset all flags and update W and b 
    else
        is_valid = false(1,p_col);
        W = W + (e * (p(:,iter).') );
        b = b + e;
    end
end

% Plot the graphs

% make sure the plot doesnt disapear
hold on

all_marks = {'o','+','*','.','x','s','d','^','v','>','<','p','h'};

% Add points
for i = 1:t_row
    for j = 1:t_col
        % if classification is positive mark a blue x
        if(t(i,j) == 1)
            plot(p(1,j),p(2,j),'Color','b','Marker', all_marks{mod(2*i-1,13)});
        % if classification is negative mark a red o
        else
            plot(p(1,j),p(2,j),'Color','r','Marker', all_marks{mod(2*i,13)});
        end
    end
end

% Calculate the domain 
x = min(p)-2 : .1 : max(p)+2;

% Plug into function and multiple lines
for i = 1:size(W,1)
    y = -( W(i,1) * x + b(i) ) / W(i,2);
    % make the decision boundary
    plot(x,y, "black");
end

% Aesthetics
title("Decision Boundary");
xlabel("p1");
ylabel("p2");
grid("minor")
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')
