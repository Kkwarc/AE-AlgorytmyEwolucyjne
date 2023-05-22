clear all
close all
clc

% for plotting
global history_b history_w1 history_w2 history_w3
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
[w, b] = learning(xl, yl, 0.9);
disp("Testing data accuracy [%]")
disp(countGood(xt, yt, w, b)/length(yt)*100)
% x = forward(weights, xl(1, :));

printPerceptronParams(history_w1, history_w2, history_w3, history_b)

printPoints(x, y)


%% learning
function [w, b] = learning(dataX, dataY, ni)
    global history_w1 history_w2 history_w3 history_b
    dataLength = length(dataY);
    w = zeros(1, 3);
    b = 0;
    r = max(max(abs(dataX(:, 1)), max(abs(dataX(:, 2)), max(abs(dataX(:, 3))))));
    % r = 0;
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


function printPerceptronParams(history_w1, history_w2, history_w3, history_b)
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
end

function printPoints(dataX, dataY)
    global history_b history_w1 history_w2 history_w3
    
    % Tworzenie wykresu powierzchniowego 3D
    figure;
    for i=1:length(history_b)
        b = history_b(i);
        w1 = history_w1(i);
        w2 = history_w2(i);
        w3 = history_w3(i);

        x = linspace(-5, 5, 100);
        y = -(b + w1 * x) / w2;

        plot(x, y, 'b', 'LineWidth', 2);
        
        xlabel('X');
        ylabel('Y');
        title(['Wykres 2D', ', i: ', num2str(i)]);
    
        hold on
        grid on
    
        for k=1:length(dataY)
            if dataY(k) == 1
                scatter(dataX(k, 1), dataX(k, 2), 'r', 'filled');
            else 
                scatter(dataX(k, 1), dataX(k, 2), 'b', 'filled');
            end
        end
        hold off
        drawnow;
    
        % Zapisywanie klatki do pliku GIF
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);

        if i == 1
            imwrite(imind, cm, 'animacja.gif', 'gif', 'Loopcount', inf);
        else
            imwrite(imind, cm, 'animacja.gif', 'gif', 'WriteMode', 'append');
        end 
    end
    
    % Wyświetlanie animacji
    imshow('animacja.gif');
end