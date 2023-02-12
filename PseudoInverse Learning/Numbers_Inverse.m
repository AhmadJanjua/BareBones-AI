% Preprocess Number Data
p1 = [1 -1 -1 -1 -1 1 -1 1 1 1 1 -1 -1 1 1 1 1 -1 -1 1 1 1 1 -1 1 -1 -1 -1 -1 1].';
p2 = [1 1 1 1 1 1 -1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 1 1 1 1 1 1 1 1 1].';
p3 = [-1 1 1 1 1 1 -1 1 1 -1 -1 -1 -1 1 1 -1 1 -1 1 -1 -1 1 1 -1 1 1 1 1 1 -1].';

% Create noisy inputs
pn1 = [1 1 -1 -1 -1 1 -1 1 1 1 -1 -1 -1 1 1 1 1 1 -1 1 1 1 1 -1 1 -1 -1 -1 -1 1].';
pn2 = [1 -1 1 1 1 1 -1 1 1 1 1 1 -1 1 -1 -1 -1 -1 1 1 1 1 1 1 -1 1 1 1 1 1].';
pn3 = [1 1 1 1 1 1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 1 -1 -1 1 1 -1 1 1 -1 1 1 -1].';

% Normalize the input vector
P = normc([p1 p2 p3]);
PN = normc([pn1 pn2 pn3]);

% Autoassociate the outputs
T = P;

% Find the Pseudo inverse of noisy and regular data
Piv = pinv(P);
PNiv = pinv(PN);

% Use Psuedo Rule for initial inputs
W = T*Piv;

% Update the Pseudo with noisy data
W = W + T*PNiv;

% Correlation Table for normal input
an = zeros(3,3);
for i = 1:3
    for j = 1:3
        an(i,j) = corr2(T(:,i),W*P(:,j));
    end
end

% Make the table labels
tbl = array2table(an);
tbl.Properties.VariableNames(1:3) = {'Output 1','Output 2', 'Output 3'};
tbl.Properties.RowNames(1:3) = {'Pattern 1','Pattern 2', 'Pattern 3'};
display(tbl);


% Correlation Table for noisy input
an = zeros(3,3);
for i = 1:3
    for j = 1:3
        an(i,j) = corr2(T(:,i),W*PN(:,j));
    end
end

% Make the table labels
tbl = array2table(an);
tbl.Properties.VariableNames(1:3) = {'Output 1','Output 2', 'Output 3'};
tbl.Properties.RowNames(1:3) = {'Pattern 1','Pattern 2', 'Pattern 3'};
display(tbl);

% Make plot of all images
for i = 1:3
    pic = reshape(W*P(:,i), 6,5);
    subplot(2,3,i), imshow(pic,[]);
end
for i = 1:3
    pic = reshape(W*PN(:,i), 6,5);
    subplot(2,3,i+3), imshow(pic,[]);
end