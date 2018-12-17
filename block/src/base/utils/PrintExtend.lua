local function split(str, flag)
    local tab = {}
    while true do
        local n = string.find(str, flag)
        if n then
            table.insert(tab, string.sub(str, 1, n-1))
            str = string.sub(str, n+1, #str) 
        else
            table.insert(tab, str)
            break
        end
    end
    return tab
end

function print1( ... )
    local traceback = split(debug.traceback("", 2), "\n");
    local s1 = traceback[3]
    if s1 then 
        s1 = string.gsub(s1, "<.*\"]:", "<row:")
        s1 = string.gsub(s1, "%b[\"", "[\"")
    end
    print(s1 .. "\n", ...)
end

function print2( ... )
    local traceback = split(debug.traceback("", 2), "\n");
    local s1 = traceback[3]
    if s1 then 
        s1 = string.sub(s1, 1, string.find(s1, ": in"))
        s1 = split(s1, "/")
        s1 = string.gsub(s1[#s1], "\"]", "")
    end
    print(s1, ...)
end