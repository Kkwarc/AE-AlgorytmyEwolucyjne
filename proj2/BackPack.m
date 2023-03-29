classdef BackPack
    properties
        all_items
        itemsLength
        maxW
    end
    
    methods
        function obj = BackPack(items)
            obj.all_items = items;
            obj.itemsLength = length(items);
            obj.maxW = get_max_weight(obj.all_items);
        end
        
        function maxW = get_max_weight(items)
            W = 0;
            for i=1:obj.itemsLength
                W = W + items(i, 2);
            end
            maxW = W * 3/10;
        end
        
        function valid = isValid(itemsGet)
            W = 0;
            for i=1:obj.itemsLength
                W = W + itemsGet(i, 2);
            end
            if W > obj.maxW
                valid = false; 
            else
                valid = true;
            end
        end
        
        function value = getValue(itemsGet)
            value = 0;
            for i=1:obj.itemsLength
                value = value + itemsGet(i, 1);
            end
        end
        
        function value = forAG(itemsGet)
           valid = obj.isValid(itemsGet);
           if valid == false
               value = 999999;
           else
               value = -getValue(itemsGet);
           end
        end
        
    end
end