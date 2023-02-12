function HebbFace()
    %{
    p1 = process("Images\AudreyHepburn.jpg");
    p2 = process("Images\BillGates.jpg");
    p3 = process("Images\MrWhite.jpg");
    p4 = process("Images\SheldonCooper.jpg");
    p5 = process("Images\TaylorSwift.jpg");
    %}
    row =64;
    col = 64;
    p1 = process("Test\beyonce.jpg");
    p2 = process("Test\einstein.jpg");
    p3 = process("Test\marie-curie.jpg");
    p4 = process("Test\michael-jackson.jpg");
    p5 = process("Test\queen.jpg");

    % Add noise to all the images
    pn1 = awgn(p1,20,'measured');
    pn2 = awgn(p2,20,'measured');
    pn3 = awgn(p3,20,'measured');
    pn4 = awgn(p4,20,'measured');
    pn5 = awgn(p5,20,'measured');

    % Normalize the inputs
    P = normc([p1 p2 p3 p4 p5]);
    PN = normc([pn1 pn2 pn3 pn4 pn5]);

    % Autoassociate output
    T = P;
    
    % Display
    for i = 1:5
        pic = reshape(P(:,i), row,col);
        subplot(4,5,i), imshow(pic,[]);
    end
    for i = 1:5
        pic = reshape(PN(:,i), row,col);
        subplot(4,5,i+5), imshow(pic,[]);
    end

    % Get initial wieght matrix using the hebb rule
    W = T*P.';
    
    % Get updated Matrix using the hebb rule
    W = W + T*PN.';
    
    % Display
    for i = 1:5
        pic = reshape(W*P(:,i), row,col);
        subplot(4,5,i+10), imshow(pic,[]);
    end
    for i = 1:5
        pic = reshape(W*PN(:,i), row,col);
        subplot(4,5,i+15), imshow(pic,[]);
    end
    tbl = zeros(5,5);
    for i = 1:5
        for j = 1:5
            tbl(i,j) = corr2(P(:,i),W*P(:,j));
        end
    end

    % Correlation Table for regular input
    an = zeros(5,5);
    for i = 1:5
        for j = 1:5
            an(i,j) = corr2(T(:,i),W*P(:,j));
        end
    end

    % Make the table labels
    tbl = array2table(an);
    tbl.Properties.VariableNames(1:5) = {'Output 1','Output 2', 'Output 3', 'Output 4','Output 5'};
    tbl.Properties.RowNames(1:5) = {'Face 1','Face 2', 'Face 3', 'Face 4', 'Face 5'};
    display(tbl);

    % Correlation Table for noisy input
    an = zeros(5,5);
    for i = 1:5
        for j = 1:5
            an(i,j) = corr2(T(:,i),W*PN(:,j));
        end
    end

    % Make the table labels
    tbl = array2table(an);
    tbl.Properties.VariableNames(1:5) = {'Output 1','Output 2', 'Output 3', 'Output 4','Output 5'};
    tbl.Properties.RowNames(1:5) = {'Face 1','Face 2', 'Face 3', 'Face 4', 'Face 5'};
    display(tbl);

end

% Pre-process image to a single column vector
function P = process(path)
    arguments
        path {mustBeFile}
    end
    RGB = imread(path);
    grey = im2gray(RGB);
    P = double(grey);
    [row,col] = size(P);
    P = reshape(P, row*col, 1);
end