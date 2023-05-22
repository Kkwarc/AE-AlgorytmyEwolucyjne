clear all
close all
clc

global history_b history_w1 history_w2 history_w3
history_w1 = [];
history_w2 = [];
history_w3 = [];
history_b = [];

[x, y] = AEproj3_data(310173); 

D = [x, y];

[w, b] = linearClassification(D, 0.9);

printPerceptronParams(history_w1, history_w2, history_w3, history_b)

printPoints(x, y)

function [w, b] = linearClassification(D, eta)
    % Wybieranie losowych wierszy
    numRows = size(D, 1);
    selectedRows = randperm(numRows, 16);
    allRows = 1:numRows;
    missingRows = setdiff(allRows, selectedRows);    
    
    % Tworzenie nowej macierzy 16x4
    learn = D(selectedRows, :);
    test = D(missingRows, :);

    global history_w1 history_w2 history_w3 history_b
    % Inicjalizacja wag w i biasu b
    w = zeros(size(learn, 2) - 1, 1);
    b = 0;
    
    % Obliczenie promienia r
    r = max(vecnorm(learn(:, 1:end-1)'));
    
    % Powtarzaj do momentu, gdy wszystkie punkty są sklasyfikowane poprawnie
    while ~all(classify(learn, w, b) == learn(:, end))
        % Iteracja po wszystkich punktach
        for i = 1:size(learn, 1)
            xi = learn(i, 1:end-1)';
            yi = learn(i, end);
            
            % Jeśli punkt jest nieprawidłowo sklasyfikowany, zaktualizuj wagi
            if sign(w' * xi - b) ~= yi
                w = w + eta * yi * xi;
                b = b - eta * yi * r^2;
            end
            history_w1 = [history_w1 w(1)];
            history_w2 = [history_w2 w(2)];
            history_w3 = [history_w3 w(3)];
            history_b = [history_b b];
            disp(classify(test, w, b) == test(:, end))
        end
    end
end

function classification = classify(D, w, b)
    % Klasyfikacja punktów na podstawie wag w i biasu b
    classification = sign(D(:, 1:end-1) * w - b);
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