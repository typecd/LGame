function cc.Node:x(v)
    if v ~= nil then
        self:setPositionX(v);
        return self
    end
    return self:getPositionX();
end

function cc.Node:y(v)
    if v ~= nil then
        self:setPositionY(v);
        return self
    end
    return self:getPositionY();
end

function cc.Node:size(size)
    if size ~= nil then
        self:setContentSize(size);
        return self;
    end
    return self:getContentSize();
end

function cc.Node:left()
    local x = self:getPositionX();
    local ax = self:getAnchorPoint().x;
    -- local w = self:getCascadeBoundingBox().size.width;
    local w = self:getContentSize().width;
    local ret = x - ax * w;
    return ret;
end

function cc.Node:right()
    local x = self:getPositionX();
    local ax = self:getAnchorPoint().x;
    -- local w = self:getCascadeBoundingBox().size.width;
    local w = self:getContentSize().width;
    local ret = x + (1 - ax) * w;
    return ret;
end

function cc.Node:top()
    local y = self:getPositionY();
    local ay = self:getAnchorPoint().y;
    local h = self:getCascadeBoundingBox().size.height;
    local ret = y + (1 - ay) * h;
    return ret;
end

function cc.Node:bottom()
    local y = self:getPositionY();
    local ay = self:getAnchorPoint().y;
    local h = self:getCascadeBoundingBox().size.height;
    local ret = y - ay * h;
    return ret;
end

function cc.Node:cx()
    local x = self:getPositionX();
    local ax = self:getAnchorPoint().x;
    local w = self:getCascadeBoundingBox().size.width;
    local ret = x + (0.5 - ax) * w;
    return ret;
end

function cc.Node:cy()
    local y = self:getPositionY();
    local ay = self:getAnchorPoint().y;
    local h = self:getCascadeBoundingBox().size.height;
    local ret = y + (0.5 - ay) * h;
    return ret;
end

function cc.Node:dump()
    -- local size = self:getContentSize();
    -- local box = self:getCascadeBoundingBox();
    -- local ap = self:getAnchorPoint();
    -- local x, y = self:getPosition();
    -- bba.log("size=(%s, %s), box=((%s, %s), (%s, %s)), anchorPoint=(%s, %s), position=(%s, %s) , left=%s, right=%s, top=%s, bottom=%s, cx=%s, cy=%s", 
    --     size.width, size.height, box.origin.x, box.origin.y, box.size.width, box.size.height,
    --     ap.x, ap.y, x, y, self:left(), self:right(), self:top(), self:bottom(), self:cx(), self:cy());
end

function cc.Node:setChildrenTouchEnabled(enabled)
    local children = tolua.cast(self:getChildren(),"CCArray");
    if children then
        for i = 1,children:count() do
            local child = cc.Node.extend(tolua.cast(children:objectAtIndex(i - 1),"CCNode"));
            child:setTouchEnabled(enabled);
            child:setChildrenTouchEnabled(enabled);
        end
    end
end


function table.reverse(t)
    local r = {};
    local i = 1;
    for j = #t, 1, -1 do
        r[i] = t[j];
        i = i + 1;
    end
    
    return r;
end

function table.merge(t1, t2, recur)
    if (not t2) or type(t2) ~= 'table' then 
        return t1;
    end
    if not recur then
        for k, v in pairs(t2) do
            t1[k] = v;
        end
    else
        if table.nums(t2) == 0 then
            t1 = {};
        else
            for k, v in pairs(t2) do
                if (type(v) == "table") and (type(t1[k] or false) == "table") then
                    t1[k] = table.merge(t1[k], t2[k], true);
                else
                    t1[k] = v;
                end
            end
        end
    end
    return t1;
end

function table.compare( t1, t2 )
   for k, v in pairs( t1 ) do
       if ( type(v) == "table" and type(t2[k]) == "table" ) then
           if ( not table.compare( v, t2[k] ) ) then return false end
       else
           if ( v ~= t2[k] ) then return false end
       end
   end
   for k, v in pairs( t2 ) do
       if ( type(v) == "table" and type(t1[k]) == "table" ) then
           if ( not table.compare( v, t1[k] ) ) then return false end
       else
           if ( v ~= t1[k] ) then return false end
       end
   end
   return true;
end

function math.range(v, min, max)
    if v < min then return min end;
    if v > max then return max end;
    return v;
end

function table.sortData(t, sort)
    if type(t) ~= 'table' or type(sort) ~= 'function' then
        return t;
    end
    
    local keys = table.keys(t);
    table.sort(keys, sort);
    local ret = {}
    for _, k in pairs(keys) do
        ret[#ret + 1] = t[k];
    end
    return keys, ret;
end

function table.find(t, item)
    return table.keyOfItem(t, item) ~= nil
end

function table.keyOfItem(t, item)
    for k,v in pairs(t) do
        if v == item then return k end
    end
    return nil
end

function isEmptyString(str)
    if not str then 
        return true;
    end
    if type(str) == 'string' and str == '' then
        return true;
    end
    return false;
end

function isEmptyTable(t)
    if not t then 
        return true;
    end

    if type(t) == 'table' and table.nums(t) == 0 then
        return true;
    end
    return false;
end

-- function bin2hex(bin)
--     local t = {}
--     for i = 1, string.len(bin) do
--         local c = string.byte(bin, i, i)
--         t[#t + 1] = string.format("%02x", c)
--     end
--     return table.concat(t, " ")
-- end

function bin2hex(s)
    local s = string.gsub(s, "(.)", function (x) 
        return string.format("%02X ",string.byte(x)) 
    end);
    return s;
end

local h2b = {
    ["0"] = 0,
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["A"] = 10,
    ["B"] = 11,
    ["C"] = 12,
    ["D"] = 13,
    ["E"] = 14,
    ["F"] = 15
}

function hex2bin( hexstr )
    local s = string.gsub(hexstr, "(.)(.)%s", function (h, l)
        return string.char(h2b[h]*16+h2b[l]);
    end);
    return s;
end

-- function aesEncrypt(plaintext, key)
--     return AesUtil:encryptWithKey(plaintext, key);
-- end

-- function aesDecrypt(ciphertext, key)
--     return AesUtil:decryptWithKey(ciphertext, key);
-- end

-- function xxtEncrypt(plaintext, key)
--     return crypto.encryptXXTEA(plaintext, key);
-- end

-- function xxtDecrypt(ciphertext, key)
--     return crypto.decryptXXTEA(ciphertext, key);
-- end

function base64Encode(plaintext)
    -- return crypto.encodeBase64(plaintext);
    return basexx.to_base64(plaintext);
end

function base64Decode(ciphertext)
    -- return crypto.decodeBase64(ciphertext);
    return basexx.from_base64(ciphertext);
end

local function urlencodeChar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

function urlencode(str)
    -- convert line endings
    str = string.gsub(tostring(str), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    str = string.gsub(str, "([^%w%.%- ])", urlencodeChar)
    -- convert spaces to "+" symbols
    return string.gsub(str, " ", "+")
end

function urldecode(str)
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)", function(h) return string.char(checknumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function md5(input)
    -- return crypto.md5(input);
    return MD5Util.sumhexa(input);
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function choose(obj, a, b)
    if obj then 
        return a;
    else
        return b;
    end
end

function timezone()
    local rt = math.floor((os.time()%86400)/3600)
    local lt = os.date("*t", os.time()).hour
    return "GMT+"..lt - rt;
end

function format2hour(num)
    local n = tonumber(num) --bugly # 4083423 number expected, got cdata
    local h = math.floor(n/3600);
    local m = math.floor(n%3600/60);
    local s = n%60;

    if h < 10 then h = "0" .. h end 
    if m < 10 then m = "0" .. m end 
    if s < 10 then s = "0" .. s end 

    local str = h.. ":" .. m .. ":" .. s;
    return str;
end 

function formatUrl(url)
    return string.format("%s?uid=%d&token=%s&uuid=%s", url, AccountEngine.getUID(), AccountEngine.getToken(), LocalTools.getUUID());
end

function log(...)
    if DEBUG then 
        print(...)
    end
end

function logBugly(str)
end
