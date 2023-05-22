clear all
close all
clc
% for plotting
history_w1 = [];
history_w2 = [];
history_w3 = [];
history_b = [];

[x, y] = AEproj3_data(310173);
xl = [x(1:8, :); x(11:18, :)];
yl = [y(1:8, :); y(11:18, :)];
xt = [x(9:10, :); x(19:20, :)];
yt = [y(9:10, :); y(19:20, :)];


disp("Testing data accuracy [%]")
disp(countGood(xt, yt, [0, 0, 0], 0)/length(yt)*100)
[w, b] = learning(xl, yl, 0.9, history_w1, history_w2, history_w3, history_b);
disp("Testing data accuracy [%]")
disp(countGood(xt, yt, w, b)/length(yt)*100)
% x = forward(weights, xl(1, :));

%% learning
function [w, b] = learning(dataX, dataY, ni, history_w1, history_w2, history_w3, history_b)
    dataLength = length(dataY);
    w = zeros(1, 3);
    b = 0;
    r = max(max(abs(dataX(:, 1)), max(abs(dataX(:, 2)), max(abs(dataX(:, 3))))));
    disp(['R: ', num2str(r)])
    disp("Starting testing data accuracy [%]")
    disp(countGood(dataX, dataY, w, b)/length(dataY)*100)
    for k=1:dataLength
        if forward(w, b, dataX(k, :)) ~= dataY(k)
            w = w + ni * dataY(k) * dataX(k, :);
            b = b - ni * r*r;
        end
        history_w1 = [history_w1 w(1)];
        history_w2 = [history_w2 w(2)];
        history_w3 = [history_w3 w(3)];
        history_b = [history_b b];
    end
    disp("Ending testing data accuracy [%]")
    disp(countGood(dataX, dataY, w, b)/length(dataY)*100)
    disp('W: ' + string(w))
    disp("B = " + num2str(b))

    % for plotting
    figure(1)
    title("Zmiany parametrów klasyfikatora")
    subplot(3,1,1);
    plot(history_w1);
    grid on;
    legend('w1')
    subplot(3,1,2);
    plot(history_w2);
    grid on;
    legend('w2')
    subplot(3,1,3);
    plot(history_w3);
    grid on;
    legend('w3')
    figure(2)
    title("Zmiany parametrów klasyfikatora")
    plot(history_b)
    grid on;
    legend('b')
   
    % Tworzenie animacji
    figure;
    axis([0 10 0 10]); % Ustalenie zakresu osi
    line = animatedline('Color', 'b'); % Inicjalizacja animowanej linii
    
    % Aktualizacja animacji
    for x = 0:0.1:10
        y = sin(x);
        addpoints(line, x, y); % Dodanie nowego punktu do animowanej linii
        drawnow; % Odświeżenie wykresu
    end
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
