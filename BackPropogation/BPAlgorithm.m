function BPAlgorithm()
    % load in data points - generated in file dataSequence
    load('dataSequence.mat', 'p');
    % number of test samples
    sample_num = 190;

    %% Initialize Weight and bias and learning rate
    % row is number of neurons, column is number of inputs
    % hidden layer
    W1 = randn(5,2);
    b1 = randn(5,1);
    % output layer
    W2 = randn(1,5);
    b2 = randn();
    % learing rate
    alpha = 0.1;
    
    %% Initialize error tracking
    % error threshold
    threshold = 0.015;
    % vector of iteration error
    err_vec = zeros(1, sample_num-2);
    % vector of mean square error
    mse_vec = [];
    
    % infinite loop
    while 1
        % Complete 1 iteration
        for i = 3:sample_num
            %% Propogate inputs forward through the network
            a0 = [p(i-1) p(i-2)]';
            a1 = logsig( W1*a0 + b1);
            a2 = purelin(W2*a1 + b2);
            % calculate the error
            e = p(i) - a2;
    
            %% Propogate the error sensitivity backwards
            % derivative of pure linear function is 1
            s2 = -2 * 1 * e;
            % d/dx logsig * W2 * previous derivative
            s1 = ddxsig(a1) * W2' * s2;
    
            %% Update the weight and bias
            % for output layer
            W2 = W2 - ( alpha * s2 * a1');
            b2 = b2 - ( alpha * s2);
            % for hidden layer
            W1 = W1 - ( alpha * s1 * a0');
            b1 = b1 - ( alpha * s1);
    
            %% update the error vector
            err_vec(i-2) = e;
        end
        % append current mean square error
        mse_vec(end+1) = mse(err_vec);

        % when the mse is less break from loop
        if( mse_vec(end) < threshold)
            break;
        end
    end

    %% Plot MSE vs iteration
    x = 1:1:length(mse_vec);
    plot(x,mse_vec);

    %% Test the network
    % initialize the arrays
    original = size(10);
    predicted = size(10);
    difference  = size(10);
    % calculate
    for i = 191:200
        j = i - 190;
        a0 = [p(i-1) p(i-2)]';
        a1 = logsig( W1*a0 + b1);
        original(j) = purelin(W2*a1 + b2);
        predicted(j) = p(i);
        difference(j) = abs(original(j)-predicted(j));
    end
    x = 1:1:10;
    figure;plot(x,original,'O'), hold on;
    plot(x,predicted, 'X');

    % Transpose for table
    original = original';
    predicted = predicted';
    difference = difference';
    % Create the table
    results = table(original, predicted, difference);
    display(results);

end

%% Functions
function result = ddxsig(x)
    temp = zeros(1,length(x));
    for i = 1:1:length(x)
        temp(i) = x(i)*(1-x(i));
    end
    result = diag(temp);
end