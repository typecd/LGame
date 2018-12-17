EventManager = class("EventManager")

function EventManager:getInstance()
    if self._instance == nil then
        self._instance = EventManager.new();
    end
    return self._instance;
end

function EventManager:ctor()
    self.eventTable = {};
end

function EventManager:add(eventKey, func, object)
    self.eventTable[eventKey] = self.eventTable[eventKey] or {};
    if self._isNotExist(self.eventTable[eventKey], object) then
        table.insert(self.eventTable[eventKey], {
            scope = object,
            func = func
        });
    end
end

function EventManager:remove(eventKey, object)
    assert(eventKey);
    assert(object);
    local event = self.eventTable[eventKey];
    if not event then
        return;
    end
    for i = #event, 1, -1 do
        if event[i].scope == object then
            table.remove(event, i);
        end
    end
end

function EventManager:removeByFunc(func)
    assert(func);
    for _, v in pairs(self.eventTable) do
        for i = #v, 1, -1 do
            if v[i].func == func then
                table.remove(v, i);
            end
        end
    end
end

-- 清除对象的所有回调
function EventManager:removeAll(object)
    assert(object);
    for _, v in pairs(self.eventTable) do
        for i = #v, 1, -1 do
            if v[i].scope == object then
                table.remove(v, i);
            end
        end
    end
end

function EventManager:clean()
    self.eventTable = {};
end

-- 派发事件
function EventManager:dispatch(eventKey, ...)
    assert(eventKey);
    local event = self.eventTable[eventKey];
    if not event then
        return;
    end;
    for _, v in pairs(event) do
        if v.scope then
            v.func(v.scope, eventKey, ...);
        else
            v.func(eventKey, ...);
        end
    end
end

function EventManager._isNotExist(target, scope)
    for _, v in pairs(target) do
        if v.scope == scope then
            return false;
        end
    end
    return true;
end
