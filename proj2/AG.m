clear all
clc
close all

items = skrypt1();
itemsLength = length(items);
maxW = get_max_weight(items, itemsLength);

lb(1:1:32) = 0;
ub(1:1:32) = 1;

calkowite_parametry(1:1:32) = (1:1:32);
 
global history_pop history_Best history_Score history_Std history_Worst history_Avg
history_pop     = {};
history_Score   = {};
history_Best    = [];
history_Worst   = [];
history_Std     = [];
history_Avg     = [];
                        
opts = optimoptions('ga', 'OutputFcn',@gaoutfun, 'Display', 'iter', ...
    'EliteCount', 2, ...
    'CrossoverFraction', 0.9, ...
    'MutationFcn', {@mutationadaptfeasible, 0.5}, ...
    'SelectionFcn', 'selectionroulette', ...
    'PopulationSize',100,"MaxGenerations",250, ...
    'MaxStallGenerations', 50);

wektor = ga(@(x) forAG(x, items, maxW, itemsLength), 32, [], [], [], [], lb, ub, [], calkowite_parametry, opts);
wektor_num = transformBinaryToItems(wektor, items, itemsLength);
wektor_value = getValue(wektor_num, itemsLength);
wektor_weight = getWeight(wektor_num, itemsLength);
disp(wektor)
disp(['Value: ', num2str(wektor_value)])
disp(['Weight: ', num2str(wektor_weight)])


figure(1)
plot(history_Worst)
title("Najgorsze")
figure(2)
plot(history_Std)
title("Odchylenie standardowe")
figure(3)
plot(history_Avg)
title("Średnia")
figure(4)
plot(history_Best)
title("Najlepsze")

%% functions
function maxW = get_max_weight(items, itemsLength)
    W = 0;
    for i=1:itemsLength
        W = W + items(i, 2);
    end
    maxW = W * 3/10;
end

function valid = isValid(itemsGet, maxW, itemsLength)
    W = 0;
    for i=1:itemsLength
        W = W + itemsGet(i, 2);
    end
    if W > maxW
        valid = false; 
    else
        valid = true;
    end
end

function value = getValue(itemsGet, itemsLength)
    value = 0;
    for i=1:itemsLength
        value = value + itemsGet(i, 1);
    end
end

function value = getWeight(itemsGet, itemsLength)
    value = 0;
    for i=1:itemsLength
        value = value + itemsGet(i, 2);
    end
end

function itemsTrans = transformBinaryToItems(binaryItems, items, itemsLength)
    itemsTrans = [];
    for k=1:itemsLength
       if binaryItems(k) == 1
          itemsTrans = [itemsTrans; [items(k, 1) items(k, 2)]];
       else
          itemsTrans = [itemsTrans; [0 0]];
       end
    end
end

function value = forAG(itemsGet, items, maxW, itemsLength)
   items = transformBinaryToItems(itemsGet, items, itemsLength);
   valid = isValid(items, maxW, itemsLength);
   if valid == false
       value = 0;
   else
       value = -getValue(items, itemsLength);
   end
   weight = getWeight(items, itemsLength);
end