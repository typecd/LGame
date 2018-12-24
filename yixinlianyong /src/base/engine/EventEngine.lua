EventName = {

    UPDATE_GOLD = "UPDATE_GOLD"
    
}

EventEngine = {};

local observers = {};

function EventEngine.isObserverExists(obj, listener)
    if observers[obj] then
        for k,v in pairs(observers[obj]) do
            if listener == v then
                return k;
            end
        end
    end
    return nil;
end

function EventEngine.register(obj, listener)
    -- if observers[obj] then
    --     if not EventEngine.isObserverExists(obj, listener) then
    --         table.insert(observers[obj], listener);
    --     end
    -- else
    --     local ls = {};
    --     table.insert(ls, listener)
    --     observers[obj] = ls;
    -- end
    observers[obj] = listener;
end

function EventEngine.unregister(obj)
    -- local i = EventEngine.isObserverExists(obj, listener);
    -- if i then
    --     table.remove(observers[obj], i);
    -- end
    if observers[obj] then 
        observers[obj] = nil;
    end
end

function EventEngine.unregisterAll()
    observers = {};
end

function EventEngine.dispatch(event, data)
    -- if obj and observers[obj] then
        -- local callbacks = observers[obj];
        -- for k, v in pairs(callbacks) do
        --     v(data);
        -- end
    -- end
    -- bba.log("EventEngine.dispatch event: %s , data : %s", event, data)
    for k, v in pairs(observers) do
        v(k, event, data);
    end 
end
