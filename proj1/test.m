opts = optimoptions('ga', 'MaxStallGenerations', 50, 'PopulationSize',50,"MaxGenerations",100);

down_lim = [-5, -5];
up_lim = [5, 5];

wektor = ga(@(x) fbanan(x, -1, 1.5), 2, [], [], [], [], down_lim, up_lim, [], [], opts);
disp(wektor)
disp(fbanan(wektor, -1, 1.5))
