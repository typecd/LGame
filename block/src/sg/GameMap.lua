local GameMap = class("GameMap",function() 
    return display.newNode()
end)

--[[ type{
    1: 小图
    2: 大图 
}]]
function GameMap:ctor(mapData,type)
    self._map = {};
    self._items = {};
    self._blocks = {};
    self._itemWidth = 50;
    

    for k,v in ipairs(mapData) do 
        local newLine = {};
        for j = 1, #v do 
            local d = v[j];
            if d == 1 then
                d = -1;
            end
            table.insert(newLine, d);
        end
        table.insert(self._map, newLine);
    end

    local row = #mapData;
    local col = #mapData[1];
    for i = 1,row do 
        local rowLine = mapData[i];
        table.insert(rowLine,0);
        table.insert(rowLine,1,0);
        if i == row then
            local rowLine0 = {};
            local rowLineLast = {};
            for j=1,col+2 do 
                table.insert(rowLine0,0);
                table.insert(rowLineLast,0);
            end
            table.insert(mapData,rowLineLast);
            table.insert(mapData,1,rowLine0);
        end 
    end
    self._mapData = mapData;
    local allRow = row+2;
    local allCol = col+2;
    if type == 1 then
        self._startX =  0 - ((col - 1) / 2 + 0.5) * self._itemWidth - 100;
        self._startY = 180;
    elseif type == 2 then
        self._startX =  display.cx 
        self._startY =  display.cy + self._itemWidth * allRow/2 + 50;
    end
    


    for i = 1,allRow do
        local rowLine_2 = self._mapData[i];
        for j=1,allCol do 
            local a_1 = rowLine_2[j];
            if a_1 == 1 or a_1 == 2 then
                local name = CONFIG.R.block_bg;
                if a_1 == 2 then
                    name = CONFIG.R.holder;
                end
                local p = self:getPos(i,j);
                local item = display.newSprite(name);
                item:setAnchorPoint(ccp(0,0));
                item:setPosition(p);
                item["row"] = i;
                item["col"] = j;
                item:addTo(self)
                table.insert(self._items,item);
            end
        end
    end
    for i = 1,allRow do 
        local prev = 0;
        local lastAdd = 0;   ---- 原值 -1；
        for j = 1,allCol do 
            local a = self._mapData[i][j];
            if prev ~= a and prev*a == 0 then
                local index = j;
                if prev == 0 then
                    index = j-1;
                end
                if index ~= lastAdd then
                    self:handlerBlank(i,index,2);
                    lastAdd = index;
                end
            end
            prev = a;
        end
    end

    for j = 1,allCol do 
        local prev = 0;
        local lastAdd = 0;
        for i = 1,allRow do 
            local a = self._mapData[i][j];
            if prev ~= a and prev*a == 0 then
                local index = i;
                if prev == 0 then
                    index = i-1;
                end
                if index ~= lastAdd then
                    self:handlerBlank(index,j,1);
                    lastAdd = index;
                end
            end
            prev = a;
        end
    end

end



function GameMap:getPos(row,col)

    local x = col * self._itemWidth + self._startX;
    local y = self._startY - row * self._itemWidth;
    return ccp(x,y)
end


function GameMap:handlerBlank(row,col,type)
    
    local allRow = #self._mapData;
    local allCol = #self._mapData[1];
    if type == 1 then
        if row ~= allRow and self._mapData[row + 1][col] ~= 0 then
            self:addWrap(row,col,"top");
            if col == 1 or self._mapData[row + 1][col-1] == 0 then
                self:addWrap(row,col,"top_left");
            end
            if col == allCol or self._mapData[row + 1][col + 1] == 0 then
                self:addWrap(row,col,"top_right");
            end
            if col ~= 1 and self._mapData[row][col - 1] ~= 0 and self._mapData[row + 1][col-1] ~= 0 then
                self:addWrap(row,col,"bottom_left2");
            end
            if col ~= allCol and self._mapData[row][col+1] ~= 0 and self._mapData[row+1][col+1] ~= 0 then
                self:addWrap(row,col,"bottom_right2");
            end
        end 

        if  row ~= 1 and self._mapData[row - 1][col] ~= 0  then
            self:addWrap(row,col,"bottom");
            if col == 1 or self._mapData[row - 1][col - 1] == 0 then
                self:addWrap(row,col,"bottom_left");
            end
            if col == allCol or self._mapData[row - 1][col + 1] == 0 then
                self:addWrap(row,col,"bottom_right");
            end
            if col ~= 1 and self._mapData[row][col-1] ~=0 and self._mapData[row - 1][col - 1] ~= 0 then 
                self:addWrap(row,col,"top_left2");
            end
            if col ~= allCol and self._mapData[row][col+1] ~= 0 and self._mapData[row - 1][col+1] ~= 0 then
                self:addWrap(row,col,"top_right2");
            end
        end
    elseif type == 2 then
        if col ~= allCol and self._mapData[row][col+1] ~= 0 then
            self:addWrap(row,col,"left");
        end
        if col ~= 1 and self._mapData[row][col-1] ~= 0 then
            self:addWrap(row,col,"right");
        end
    end
end


function GameMap:addWrap(row,col,type)
    local p = self:getPos(row,col);
    local x = p.x;
    local y = p.y;
    local cap = 1;
    local cap2  = 15;
    local half = 25;
    local bitmap ;
    if type == "top" then
        bitmap = display.newSprite(CONFIG.R.wrap_top);
        x = x + half;
        y = y + bitmap:getContentSize().height/2;

    elseif type == "bottom" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom);
        x = x + half;
        y = y + half * 2 - 8;
    elseif type == "left" then
        bitmap = display.newSprite(CONFIG.R.wrap_left);
        x = x + self._itemWidth - 8;
        y = y + half;
    elseif type == "right" then
        bitmap = display.newSprite(CONFIG.R.wrap_right);
        x = x + 8;
        y = y + half;
    elseif type == "top_left" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_left);
        x = x - 4;
        y = y + 4;
    elseif type == "top_right" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_right);
        x = x + 4 + half * 2 ;
        y = y + 4 ;
    elseif type == "bottom_left" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_left);
        x = x - 4 ;
        y = y + half * 2 - 4;
    elseif type == "bottom_right" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_right);
        x = x + half * 2 + 4;
        y = y + half * 2 - 4;
    elseif type == "top_left2" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_left2);
        x = x + half - 14;
        y = y + half + 14;
    elseif type == "top_right2" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_right2);
        x = x + half * 2 - 11;
        y = y + half * 2 - 11;
    elseif type == "bottom_left2" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_left2);
        x = x + half - 14;
        y = y + half - 14;
    elseif type == "bottom_right2" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_right2);
        x =x + half * 2 - 11;
        y =y + half - 14;
    end
    bitmap:pos(x,y);
    self:addChild(bitmap);
end

function GameMap:passGate() 
    print("无内容")
end

function GameMap:checkBlock(block) 

    local hit = false;
    local p = ccp(block:getPosition());
    p = self:convertToNodeSpace(p)

    p.x = p.x - self._startX;
    p.y = self._startY - p.y - block.height;
    -- bba.printTable(block:map())

    local row = CONFIG.round(p.y / self._itemWidth);
    local col = CONFIG.round(p.x / self._itemWidth) - 1;
    local row2 = row + #block:map() - 1;
    local col2 = col + #block:map()[1] - 1;

    if row >= 1 and row2 <= #self._map and col >= 1 and col2 <= #self._map[1] then
        hit = true;
    end 

    self:changeMap(block, 2)
    local canPut = false;
    if hit then
        block.row = row;
        block.col = col;
        if self:checkCanPut(block) then
            canPut = true;
            block:setPositionX((col + 1) * self._itemWidth + self._startX );
            block:setPositionY(self._startY - row * self._itemWidth - block.height);
            self:changeMap(block, 1);
            if not table.indexof(self._blocks, block) then
                table.insert(self._blocks, block);
                EventManager:getInstance():dispatch("newOne");
            end

            CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_block_drop_mp3,false)
        end
    end

    if not canPut then
        table.removebyvalue(self._blocks, block); 
    end

    return canPut;
end


function GameMap:changeMap(block, type)
    local index = table.indexof(self._blocks, block)
    if type == 2 and not index then
        return;
    end

    local map = block:map();
    local row = block.row;
    local col = block.col;
    for i = 1, #map do 
        local rowLine = map[i];
        for j = 1, #rowLine do 
            local d = rowLine[j];
            if d == 1 then
                local value = 1;
                if type == 2 then
                    value = -1;
                end
                self._map[row + i - 1][col + j - 1] = value;
            end
        end
    end
end


function GameMap:checkCanPut(block) 
    local allRow = #self._map;
    local allCol = #self._map[1];
    local map = block:map();
    local row = block.row;
    local col = block.col;

    if (#map + row - 1 > allRow) or (#map[1] + col - 1 > allCol) then
        return false;
    end

    for i, v in ipairs(map) do 
        for j, d in ipairs(v) do 
            if d == 1 then
                local d2 = self._map[row + i - 1][col + j - 1];
                if d2 ~= -1 then
                    return false;
                end
            end
        end
    end

    return true;
end


return GameMap;