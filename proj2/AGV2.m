clear all
close all

items = skrypt1();
itemsLength = length(items);
maxW = get_max_weight(items, itemsLength);

opts = optimoptions('ga', 'MaxStallGenerations', 50, 'PopulationSize',40,"MaxGenerations",100);

lb(1:1:32) = 0;
ub(1:1:32) = 1;

calkowite_parametry(1:1:32) = (1:1:32);

wektor = ga(@(x) forAG(x, items, maxW, itemsLength), 32, [], [], [], [], lb, ub, [], calkowite_parametry, opts);


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
   disp("Items:")
   disp(itemsGet)
   items = transformBinaryToItems(itemsGet, items, itemsLength);
   valid = isValid(items, maxW, itemsLength);
   if valid == false
       value = 0;
   else
       value = -getValue(items, itemsLength);
   end
   disp("Value:")
   disp(-value)
   weight = getWeight(items, itemsLength);
   disp("Weight:")
   disp(weight)
end