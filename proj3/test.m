clear all
close all
clc

[x, y] = AEproj3_data(310173);
xl = [x(1:8, :); x(11:18, :)];
yl = [y(1:8, :); y(11:18, :)];
xt = [x(9:10, :); x(19:20, :)];
yt = [y(9:10, :); y(19:20, :)];


disp("Testing data accuracy [%]")
disp(countGood(xt, yt, [0, 0, 0], 0)/length(yt)*100)
[w, b] = learning(xl, yl, 0.9);
disp("Testing data accuracy [%]")
disp(countGood(xt, yt, w, b)/length(yt)*100)
% x = forward(weights, xl(1, :));

%% learning
function [w, b] = learning(dataX, dataY, ni)
    dataLength = length(dataY);
    w = zeros(1, 3);
    b = 0;
    r = 1;
    disp("Starting learning data accuracy [%]")
    disp(countGood(dataX, dataY, w, b)/length(dataY)*100)
    for k=1:dataLength
        disp("K: " + num2str(k))
        disp(countGood(dataX, dataY, w, b)/length(dataY)*100)
        if forward(w, b, dataX(k, :)) ~= dataY(k)
            w = w + ni * dataY(k) * dataX(k, :);
            b = b - ni * r*r;
        end
    end
    disp("Ending learning data accuracy [%]")
    disp(countGood(dataX, dataY, w, b)/length(dataY)*100)
    disp('W: ' + string(w))
    disp("B = " + num2str(b))
end

function n = countGood(dataX, dataY, w, b)
    n = 0;
    dataLength = length(dataY);
    for k=1:dataLength
        if forward(w, b, dataX(k, :)) == dataY(k)
            n = n + 1;
        end
    end
end

function class = forward(w, b, inputs)
    class = sign(b+w*inputs');
end
