% Clear previous values and command window
clc; clear;

% set alpha value: found through experiment (fastest result)
alpha = .04;

% Normalize the inputs
P = normc([ ...
    process("characters\char1_a.bmp") process("characters\char1_b.bmp") process("characters\char1_c.bmp") process("characters\char1_d.bmp") ...
    process("characters\char1_e.bmp") process("characters\char1_f.bmp") process("characters\char1_g.bmp") process("characters\char1_h.bmp") ...
    process("characters\char1_i.bmp") process("characters\char1_j.bmp") process("characters\char1_k.bmp") process("characters\char1_l.bmp") ...
    process("characters\char1_m.bmp") process("characters\char1_n.bmp") process("characters\char1_o.bmp") process("characters\char1_p.bmp") ...
    process("characters\char1_q.bmp") process("characters\char1_r.bmp") process("characters\char1_s.bmp") process("characters\char1_t.bmp") ...
    process("characters\char1_u.bmp") process("characters\char1_v.bmp") process("characters\char1_w.bmp") process("characters\char1_x.bmp") ...
    process("characters\char1_y.bmp") process("characters\char1_z.bmp") ...
    ]);

% Autoassociate output
T = P;

% get dimensions of original images
[row, col] = myDim("characters\char1_a.bmp");

% Get number of rows and columns of inputs and test
[rowP , colP] = size(P);
[rowT, colT] = size(T);

% Display original images
for i = 1:colP
    pic = reshape(P(:,i), row,col);
    subplot(4,colP,i), imshow(pic,[]);
end

% initial weight and bias is zero
W = zeros(rowT,rowP);
B = 0;
% Vector with mean square error values per iteration
MSE_vector = [];

% Iterate through the values and update the value for W and B
% using the LMS Algorithm
while mse(W*P + B, T) > 1e-10
%for i = 1:100
    A = W*P + B;
    E = T - A;

    W = W + 2*alpha*E*P.';
    B = B + 2*alpha*E;

    MSE_vector(end+1) =  mse(W*P + B, T);
end

% Display Output model
for i = 1:colP
    pic = reshape( W*P(:,i)+B(:,i) , row,col );
    subplot(4,colP,i+colP), imshow(pic,[]);
end

% Correlation Table for input
an = zeros(colP);
for i = 1:colP
    for j = 1:colP
        an(i,j) = corr2(T(:,i),W*P(:,j)+B(:,j));
    end
end

% Make the table labels
tbl = array2table(an);
display(tbl);

% Plotting the error curve based on the number of iterations
stretch = [];
for i = 1:2*colP
    stretch(end+1) = 2*colP+i;
end

subplot(4,colP,stretch);
semilogy(MSE_vector);



%%%%%%% FUNCTIONS %%%%%%%%%

% get orignal matrix size
function [row, col] = myDim(path)
    arguments
        path {mustBeFile}
    end
    RGB = imread(path);
    P = double(RGB);
    [row,col] = size(P);
end

% Pre-process image to a single column vector
function P = process(path)
    arguments
        path {mustBeFile}
    end
    RGB = imread(path);
    P = double(RGB);
    [row,col] = size(P);
    P = reshape(P, row*col, 1);
end


