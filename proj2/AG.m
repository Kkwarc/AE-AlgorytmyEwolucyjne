items = skrypt1();
myBackPack = BackPack(items);
disp(myBackPack.maxW)

opts = optimoptions('ga', 'MaxStallGenerations', 50, 'PopulationSize',30,"MaxGenerations",100);

lb(1:1:32) = 0;
ub(1:1:32) = 1;

calkowite_parametry(1:1:32) = (1:1:32);

wektor = ga(@(x) myBackPack.forAG(x), 32, [], [], [], [], lb, ub, [], calkowite_parametry, opts);