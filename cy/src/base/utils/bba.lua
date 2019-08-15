local bba = {}

bba.log = function(...)
    if DEBUG_LOG then
        if DUMP_TRACE then 
            local traceback = string.split(debug.traceback("", 2), "\n");
            local trace = string.trim(traceback[3]);
            local _, _, file_name, line_number, function_name = string.find(trace, '(%w+%)[^%d]*(%d+)[^\']*\'(%w+)\'');
            if file_name == nil then
                print(os.time(), trace);
            else
                print(string.format("%s %s line: %s", file_name, function_name, line_number));
            end
        end

        if(... == nil) then 
            print("-------------LOGGING NULL-------------");
        else
            if(type(...) == "string") then
                printf(...);
            else
                dump(...);
            end
        end
    end
end

bba.format = function(s, ...)
    -- s格式："{1}巴拉巴拉{2}{3}巴拉巴拉{4}"。注意不能带%%，原来的%s和%d在changeString.py里处理了，先加的字符串注意格式
    -- print(s);
    -- 发版的时候这个最好打开以防万一
    -- if string.find(s, "%%s") or string.find(s, "%%02") then
    --     -- bba.log("keep string format>>>>>>");
    --     return string.format(s, ...);
    -- end
    local ret = s;
    if ... then
        -- bba.log("transform>>>>");
        local params = {...};
        ret = string.gsub(s, "%{(%d+)%}", function(match)
            return params[tonumber(match)];
        end);
    end
    -- print(ret);
    return ret;
end

bba.isFunction = function(callback)
    return type(callback) == "function";
end

bba.trace = function()
    if DUMP_TRACE then
        local traceback = string.split(debug.traceback("", 2), "\n");
        bba.log(traceback);
    end
end

bba.dump = function(node)
    if node then 
        local size = node:getContentSize();
        local box = node:getCascadeBoundingBox();
        local ap = node:getAnchorPoint();
        local x, y = node:getPosition();
        bba.log("size=(%s, %s), box=((%s, %s), (%s, %s)), anchorPoint=(%s, %s), position=(%s, %s)", 
            size.width, size.height, box.origin.x, box.origin.y, box.size.width, box.size.height,
            ap.x, ap.y, x, y);
    end
end

bba.drawBox = function(rect)
    if DEBUG then
        local newRect = cc.rect(0, 0, rect.size.width, rect.size.height);
        local scene = display.getRunningScene();
        local box = display.newRect(newRect);
        box:setLineColor(ccc4f(1, 0, 0, 1));
        box:setFill(true);
        box:addTo(scene, 30000);
        box:setPosition(cc.p(rect.size.width/2 + rect.origin.x, rect.size.height/2 + rect.origin.y));
    end
end

bba.printSearchPath = function()
    local paths = CCFileUtils:sharedFileUtils():getSearchPathArray();
    for i = 0, paths:count() -1 do
        local path = tolua.cast(paths:objectAtIndex(i), 'CCString'):getCString();
        print(path);
    end
end

bba.logf = function(str, name)
    if DEBUG then
        name = name or 'log';
        local path = device.writablePath .. name .. '.log';
        io.writefile(path, tostring(str));
    end
end

bba.loadf = function(name)
    if DEBUG then
        name = name or 'log';
        local path = device.writablePath .. name .. '.log';
        return io.readfile(path);
    end
end

bba.printTable = function (t)
    if DEBUG_LOG then
        local info = debug.getinfo(2)
        local luaFileName = string.match(info.short_src, "%a+%.lua") or ""
        print("--[" .. luaFileName .. ":" .. info.currentline .. "]--")
        local p = require("base.utils.PrintTabel");
        p.printTable(t)
    end
end

return bba
