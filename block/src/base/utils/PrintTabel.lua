
local print = print
local pairs = pairs
local table = table
local tostring = tostring
local type = type
local getmetatable = getmetatable
local debug = debug
local type = type
local string = string

module(...)

-- 格式化输出table
local encode_value = nil
local tableCache = {}
local function encode_table(writer, table, indent)
    indent = indent or ""
    if #indent > 20 then
        return
    end
    writer:write("{ --" .. tostring(table) .. "\n")
    do
        local indent = indent .. "\t"
        for k, v in pairs(table) do
            writer:write(indent)
            writer:write("[")
            encode_value(writer, k, indent)
            writer:write("] = ")
            encode_value(writer, v, indent)
            writer:write(",\n")
        end
        -- local mt = getmetatable(table)
        -- if mt then
        --     writer:write(indent)
        --     writer:write("[")
        --     encode_value(writer, 'metatable', indent)
        --     writer:write("] = ")
        --     encode_value(writer, mt, indent)
        --     writer:write(",\n")
        -- end
    end

    writer:write(indent)
    writer:write("}")
end

encode_value = function (writer, value, indent)
    local t = type(value)
    if t == "table" then
        if tableCache[value] then
        writer:write(tostring(value))
        else
            tableCache[value] = true
            encode_table(writer, value, indent)
        end
    elseif t == "string" then
        writer:write(string.format("%q", value))
    elseif t == "function" then
        local info = debug.getinfo(value)
        writer:write('function ' .. info.short_src .. ' ' .. info.linedefined)
    else
        writer:write(tostring(value))
    end
end

--------------------------------
-- @prototype printTable(table t)
-- @description 格式化输出table
-- @function printTable
-- @param {table} t
-- @return {void}
function printTable(t)
    tableCache = {}
    local info = debug.getinfo(2)
    local luaFileName = string.match(info.short_src, "%a+%.lua") or ""

    local writer = {}

    writer.write = function(self, s)
        table.insert(self, s)
    end
    writer:write('\n')
    encode_value(writer, t)
    print("[" .. luaFileName .. ":" .. info.currentline .. "]", table.concat(writer))
end