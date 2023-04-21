clear all
close all

items = skrypt1();
itemsLength = length(items);
maxW = get_max_weight(items, itemsLength);

lb(1:1:32) = 0;
ub(1:1:32) = 1;

calkowite_parametry(1:1:32) = (1:1:32);


el = [0, 1, 2];
%mutacja -> tylko jedna
mutRatio = [0.1, 0.3];
%selekcja -> dwie
sel = ['selectionroulette', 'selectiontournament'];
turSize = [2, 4];
% {@selectiontournament,size}

%krzyżowanie
crossF = [{@crossoverscattered}, {@crossoversinglepoint}];
popSize = [10, 100];
MaxGen = [50, 100];
i=0;
for a=1:length(el)
   for b=1:length(mutRatio)
      for c=1:length(sel)
         for d=1:length(turSize)
             for e=1:length(crossF)
                 for f=1:length(popSize)
                    for g=1:length(MaxGen)
                        elit = el(a);
                        mr = mutRatio(b);
                        cf = crossF(e);
                        sf = sel(c);
                        ts = turSize(d);
                        ps = popSize(f);
                        mg = MaxGen(g);
                        disp("Elita: " + elit)
                        disp("MutRatio: " + mr)
%                         disp("CrossoverFcn: " + cell2str(cf))
                        disp("SelectionFcn: " + sf)
                        disp("Popsize: " + ps)
                        disp("MaxGen: " + mg);
                        
                        opts = optimoptions('ga', 'Display', 'iter', ...
                            'EliteCount', elit, ...
                            'MutationFcn', {@mutationuniform, mr}, ...
                            'CrossoverFcn', cf, ...
                            'SelectionFcn', 'selectionroulette', ...
                            'PopulationSize',ps,"MaxGenerations",mg);
                    
                        if strcmp(sf,'selectiontournament')
                            opts = optimoptions('ga', 'Display', 'iter', ...
                                'EliteCount', elit, ...
                                'MutationFcn', {@mutationuniform, mr}, ...
                                'CrossoverFcn', cf, ...
                                'SelectionFcn', {@selectiontournament, ts}, ...
                                'PopulationSize',ps,"MaxGenerations",mg);
                        end
                        
                        wektor = ga(@(x) forAG(x, items, maxW, itemsLength), 32, [], [], [], [], lb, ub, [], calkowite_parametry, opts);
                        disp(wektor)
                        disp(i)
                        i = i + 1;
                    end
                 end
             end
         end
      end
   end
end


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
%    disp("Items:")
%    disp(itemsGet)
   items = transformBinaryToItems(itemsGet, items, itemsLength);
   valid = isValid(items, maxW, itemsLength);
   if valid == false
       value = 0;
   else
       value = -getValue(items, itemsLength);
   end
%    disp("Value:")
%    disp(-value)
   weight = getWeight(items, itemsLength);
%    disp("Weight:")
%    disp(weight)
end