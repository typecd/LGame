local BlockData = class("BlockData");

function BlockData:getInstance()
    if BlockData.instance == nil then
        BlockData.instance = BlockData.new()
    end
    return BlockData.instance
end

function BlockData:ctor()
    self._datas = {};
    self._cache = {};
    self:init();
end

function BlockData:init()

    local list = {};
    table.insert(list,"1,1,1");
    table.insert(list,"111,1");
    table.insert(list,"10,11,1");
    table.insert(list,"110,011");
    table.insert(list,"01,01,11,01");
    table.insert(list,"0011,111");
    table.insert(list,"010,11,011");
    table.insert(self._datas,{type = 1,list = list});

    list = {};
    table.insert(list,"01,01,11");
    table.insert(list,"0010,1111");
    table.insert(list,"01,11,1,1");
    table.insert(list,"111,01,01");
    table.insert(list,"110,1,111");
    table.insert(list,"100,111,01");
    table.insert(list,"011,11,1");
    table.insert(self._datas,{type = 2,list = list});

    list  = {};
    table.insert(list,"111,001");
    table.insert(list,"01,11,01,01");
    table.insert(list,"1100,0111");
    table.insert(list,"100,111,1");
    table.insert(list,"010,011,11");
    table.insert(list,"001,101,111");
    table.insert(list,"100,110,011");
    table.insert(self._datas,{type = 3,list = list});

    list  = {};
    table.insert(list,"1,1,1,1,1");
    table.insert(list,"111,001,001");
    table.insert(list,"011,11");
    table.insert(list,"100,111");
    table.insert(list,"01,01,11,01,01");
    table.insert(list,"11,01,11");
    table.insert(list,"100,101,111");
    table.insert(self._datas,{type = 4,list = list});

    list  = {};
    table.insert(list,"11111");
    table.insert(list,"01,11");
    table.insert(list,"111,1,1");
    table.insert(list,"10,11,01");
    table.insert(list,"11111,001");
    table.insert(list,"111,101");
    table.insert(list,"011,001,111");
    table.insert(self._datas,{type = 5,list = list});


    list  = {};
    table.insert(list,"11,11");
    table.insert(list,"11");
    table.insert(list,"10,11");
    table.insert(list,"01,11,01");
    table.insert(list,"0111,11");
    table.insert(list,"110,011,010");
    table.insert(self._datas,{type = 6,list = list});


    list  = {};
    table.insert(list,"11,1,1");
    table.insert(list,"001,001,111");
    table.insert(list,"00100,11111");
    table.insert(list,"1111,01");
    table.insert(list,"111,001,011");
    table.insert(list,"010,111,001");
    table.insert(self._datas,{type = 7,list = list});


    list  = {};
    table.insert(list,"1111");
    table.insert(list,"11,1");
    table.insert(list,"010,111");
    table.insert(list,"01,11,1");
    table.insert(list,"101,111");
    table.insert(list,"10,1,11,01");
    table.insert(list,"111,1,11");
    table.insert(self._datas,{type = 8,list = list});


    list  = {};
    table.insert(list,"1,1,1,1");
    table.insert(list,"11,01");
    table.insert(list,"100,1,111");
    table.insert(list,"10,1,11,1,1");
    table.insert(list,"11,1,11");
    table.insert(list,"111,101,001");
    table.insert(self._datas,{type = 9,list = list});


    list  = {};
    table.insert(list,"001,111");
    table.insert(list,"001,111,001");
    table.insert(list,"1110,0011");
    table.insert(list,"111,101,1");
    table.insert(list,"011,11,01");
    table.insert(list,"110,011,001");
    table.insert(self._datas,{type = 10,list = list});

    list  = {};
    table.insert(list,"1,1");
    table.insert(list,"11,01,01");
    table.insert(list,"111,01");
    table.insert(list,"0100,1111");
    table.insert(list,"1111,001");
    table.insert(list,"10,11,01,01")
    table.insert(list,"001,111,01");
    table.insert(self._datas,{type = 11,list = list});


    list  = {};
    table.insert(list,"1");
    table.insert(list,"10,1,11");
    table.insert(list,"010,01,111");
    table.insert(list,"01,01,11,1");
    table.insert(list,"010,111,01");
    table.insert(list,"010,111,1");
    table.insert(list,"001,011,11");
    table.insert(self._datas,{type = 12,list = list});

    list  = {};
    table.insert(list,"111");
    table.insert(list,"10,11,1,1");
    table.insert(list,"10,1,11,1");
    table.insert(self._datas,{type = 100,list = list});
end


function BlockData:getBlockData(type,index)

    local name = type .."_".. index;
    for k,v in ipairs(self._cache) do 
        if v.name == name then 
            -- print("exit ",name)
            return v.map;
        end
    end

    local data = "";
    for k,v in ipairs(self._datas) do 
        if v.type == type then
            data = v.list[index];
            break;
        end
    end
    print("data -- ",data )
    if not data then
        return nil
    end

    local arr = string.split(data,","); --- {10,1,11,1}
    -- bba.printTable(arr)
    local len = string.len(arr[1]); 
    local map = {};
    for k,v in ipairs(arr) do 
        
        local mapRow = {};
        for j=1,len do ---111 len=3 #v=3
            if j > #v then 
                table.insert(mapRow,0);
            else
                table.insert(mapRow,tonumber(string.sub(v,j,j)))
            end
        end
        table.insert(map,mapRow);
    end
    -- bba.printTable(map)
    table.insert(self._cache,{name = name,map = map});
    return map;
end


return BlockData