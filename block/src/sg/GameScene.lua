local LayerBase = require("sg/LayerBase")
local GateData = require("sg/GateData")
local Block = require("sg/Block")
local GameMap = require("sg/GameMap")
local TopBar = require("sg/TopBar")
local EndWin = require("sg/EndWin")

local GameScene = class("GameScene",LayerBase)

function GameScene.show()
    local layer = GameScene.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end

function GameScene:ctor()
    self.super.ctor(self)

    -- UITools.addSpriteFrames(IMG_PATH .. "game")
    -- UITools.addSpriteFrames(IMG_PATH .. "block")
    -- UITools.addSpriteFrames(IMG_PATH .. "shadow")

    self.blockScale = 0.6;
    self.disx = 20
    if BA.IS_IPHONEX then
        self.disx = 50
    end

    print("GameScene ctor---")
    self._blocks = {};
    -- self._tipCount = {};
    local bg = display.newSprite(CONFIG.R.bg)
    bg:pos(display.cx,display.cy);
    self:addChild(bg);
    if BA.IS_IPHONEX then
        bg:setScaleX(1.22)
    end

    local data = GateData.new():getData(CONFIG.gate);
    local gameMap = GameMap.new(data.map, 2);
    gameMap:pos(0,0)
    self:addChild(gameMap,10);
    self._gameMap = gameMap

    --- 触发完成检查
    EventManager:getInstance():add("newOne",self.mapHandler,self);
    self:createBlocks(data.blocks);
    -- 添加主页按钮
    local btn_gate = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_gate1,
        callback = self.buttonHandler,
        delegate = self,
        tag = "gate",
    })
    btn_gate:addTo(self)

    local capx = 70
    if BA.IS_IPHONEX then
        capx = 90
    end

    btn_gate:pos(left(capx),top(capx))

    -- 当前关卡
    local gateNum = CCLabelBMFont:create(tonumber(CONFIG.gate),CONFIG.R.num2_fnt);
    gateNum:addTo(self)
    gateNum:setAnchorPoint(ccp(0.5,1))
    gateNum:pos(display.cx , display.height - 30)

    local topBar = TopBar.new();
    topBar:addTo(self)
    topBar:pos(right(100), top(40));
    self._topBar = topBar;

    local btn_setting = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_setting1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "setting",
    })
    btn_setting:addTo(self)
    btn_setting:pos(left(capx),60);

    local btn_restart = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_restart1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "restart",
    })
    btn_restart:addTo(self);
    btn_restart:pos(right(capx),capx);

    self:registerScriptTouchHandler(function(event,x,y) 
        -- print(event)
        if event == "began" then
            -- 判断点击某一个块
            return self:onTouchBegan(x,y)
        elseif event == "moved" then
            self:onTouchMoved(x,y)
        elseif event == "ended" then
            self:onTouchEnded(x,y)
        end
    end,false,-127,true) 
    self:setTouchEnabled(true);

    self:registerScriptHandler(handler(self,self.onNodeEvent));

end

function GameScene:onNodeEvent(event)
    if event == "exit" then
        EventManager:getInstance():remove("newOne", self);
    end
end
 
function GameScene:addMap(gate)
    local data = GateData.new():getData(gate);
    local gameMap = GameMap.new(data.map);
    gameMap:pos(0,-150)
    self:addChild(gameMap,10);
    self._gameMap = gameMap

    self:createBlocks(data.blocks);
end

function GameScene:createBlocks(blocks) 

    CONFIG.shuffle(blocks);
    local groups = {};
    local gridCount = 0;
    -- bba.printTable(blocks)
    while(#blocks > 0) do
        local re = self:getGroup(blocks,gridCount)
        table.insert(groups, re)
        gridCount = gridCount + re[#re].colGrids;
    end
    -- bba.printTable(groups);
    self:genBlocks(groups);
    print("line 94")
end

function GameScene:getGroup(blocks,gridCount)
    local colGrids = 0;
    for i = 1,#blocks do 
        colGrids = colGrids + blocks[i].colGrids;
    end
    if gridCount + colGrids <= 14 then
        print(debug.getinfo(1).currentline)
        return {table.remove(blocks,1)};
    end

    local copyBlocks = CONFIG.copyArr(blocks);
    table.sort(copyBlocks,function(a,b)
        if a.rowGrids == b.rowGrids then
            return b.colGrids < a.colGrids;
        end
        return a.rowGrids < b.rowGrids
    end)

    local re = {};
    local short = copyBlocks[1];
    if short.rowGrids == 1 then
        local has = false;
        local b1 = short;
        for i = 2,#copyBlocks do 
            local b2 = copyBlocks[i];
            if b2.rowGrids > 1 then
                break;
            end
            if b2.colGrids == b1.colGrids then 
                table.insert(re,b1)
                table.insert(re,b2)
                has = true;
                break;
            end
            b1 = b2;
        end
        if not has and #copyBlocks > 1 then
            table.insert(re,short);
            local second = copyBlocks[2];
            if second.rowGrids == 1 then
                if second.colGrids > short.colGrids then
                    table.insert(re,second);
                else
                    table.insert(re,1,second);
                end
            end
        end
    else
        table.insert(re,short)
    end

    local bottomCols = re[#re].colGrids;
    local upCols = 0;
    local hasRows = short.rowGrids;
    if #re == 2 then
        hasRows = 2;
    end

    for i = #copyBlocks, 1, -1 do 
        local b = copyBlocks[i];
        if not table.indexof(re, b) then
            local beenCols = b.colGrids + upCols;
            if ((upCols == 0 and bottomCols >= beenCols) or bottomCols >= beenCols) and b.rowGrids + hasRows <= 6  then
                table.insert(re,1,b);
                upCols = upCols + b.colGrids;
                if #re >= 3 then
                    break;
                end
                if bottomCols - upCols <= 1 then
                    break;
                end
            end
        end
    end

    for i = 1, #re do 
        local b = re[i];
        table.removebyvalue(blocks,b);
    end

    return re;
end


function GameScene:genBlocks(groups)
    -- bba.printTable(groups)
    local blockLayer = display.newNode() 
    local maxHeight = 0;
    local gs = {};
    local x = 0;

    for k,v in ipairs(groups) do 
        local gc = self:createGroup(v);
        if gc:getContentSize().height > maxHeight then
            maxHeight = gc:getContentSize().height;
        end
        gc:setPositionX(x);
        blockLayer:addChild(gc);
        table.insert(gs,gc);
        x = x + gc:getContentSize().width + 30;
    end
    

    
    blockLayer:setScale(self.blockScale)
    -- local shape = display.newColorLayer(ccc4(0,0,0,100));
    -- shape:setContentSize(CCSize(200,200))
    -- shape:pos(display.cx,display.cy);
    -- self:addChild(shape,1)
    -- blockLayer:ignoreAnchorPointForPosition(false)
    -- blockLayer:setAnchorPoint(ccp(0.5,0))
    self._blockLayer = blockLayer;
    self:addChild(blockLayer,2)
    
    blockLayer:pos(self.disx,display.cy - maxHeight / 2);
end


-- 创建一组
function GameScene:createGroup(group)
    -- bba.printTable(group)
    local layer = display.newLayer();

    local bottom = self:createBlock(group[#group]);
    layer:addChild(bottom);
    layer:setContentSize(bottom:getContentSize())
    local capy = 15
    if #group == 2 then
        local b = self:createBlock(group[1]);
        b:setPositionY(bottom.height + capy)
        layer:addChild(b);
        layer:setContentSize(CCSize( b.width > bottom.width and b.width or bottom.width ,b.height + bottom.height + capy))
    elseif #group == 3 then 
        local block1 = self:createBlock(group[1]);
        local block2 = self:createBlock(group[2]);
        local b1Size = block1:getContentSize();
        local b2Size = block2:getContentSize();
        if group[2].rowGrids == 1 and group[3].rowGrids == 1 and (group[1].colGrids + group[2].colGrids > group[3].colGrids) then
            block2:setPositionY(bottom.height + 10 );
            block1:setPositionY(bottom.height + 10 + block2.height + 10)
            layer:setContentSize(CCSize(math.max(bottom.width,block1.width,block2.width),bottom.height + block1.height + block2.height + 20))
        else
            local cap = 15;
            if (group[1].colGrids + group[2].colGrids) == group[3].colGrids then
                cap = 5;
            end
            block2:setPositionX(b1Size.width + cap);
            
            local sw = b1Size.width + b2Size.width + cap
            local width = sw > bottom.width and sw or bottom.width

            local height = 0
            if b1Size.height > b2Size.height then
                block2:setPositionY(b1Size.height - b2Size.height + bottom.height + capy );
                block1:setPositionY(bottom.height + capy)
                height = b1Size.height
            elseif b2Size.height > b1Size.height then
                block1:setPositionY(b2Size.height - b1Size.height + bottom.height + capy);
                block2:setPositionY(bottom.height + capy)
                height = b2Size.height
            else
                block2:setPositionY(bottom.height + capy);
                block1:setPositionY(bottom.height + capy)
                height = b1Size.height
            end

            
            layer:setContentSize(CCSize(width, bottom.height + capy + height))
        end
        
        layer:addChild(block1)
        layer:addChild(block2)

    end

    return layer;

end


function GameScene:createBlock(stru)

    local block = Block.new(stru.type,stru.index);
    block.rightRow = stru.row;
    block.rightCol = stru.col;
    block:showShadow();   

    table.insert(self._blocks,block);
    return block;

end


function GameScene:checkComplete()
    -- 判断是否每一个都可见
    for k,v in ipairs(self._blocks) do 
        if not v:isHide() then
            return;
        end
    end

    print("pass ",CONFIG.gate)

    -- 判断提示使用次数
    local starCount = 3;

    CONFIG.passGate(CONFIG.gate,starCount)

    self._topBar:updateScore();

    -- 线上结算界面
    self:addChild(EndWin.new(starCount),20);
end


function GameScene:buttonHandler(data)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if data == "gate" then

        print("gate touch")
        self:remove();
    elseif data == "setting" then
        CONFIG.changeScene("settingLayer");
    elseif data == "restart" then
        CONFIG.changeScene("gameScene",self);
    end

end

function GameScene:remove()
    
    CONFIG.changeScene("gateScene",self);
end

function GameScene:mapHandler() 
    self:checkComplete()
end



function GameScene:onTouchBegan(touchx,touchy)

    -- 原始块
    for k, v in ipairs(self._blocks) do 
        local lp = v._bitmap:convertToNodeSpace(ccp(touchx,touchy))
        if not v:isHide() and v._bitmap:boundingBox():containsPoint(lp) then
            
            local bitSize = v._bitmap:getContentSize();
            local row = math.ceil((bitSize.height - lp.y) / 50);   -- y越大row越小
            local col = math.ceil(lp.x / 50);

            if v:map()[row][col] == 1 then

                local block =  v:copyBlock()
                local x, y = v:getParent():getPosition()
                local dis = 40
                if BA.IS_IPHONEX then
                    dis = 90
                end 
                local worldpos = v._bitmap:convertToWorldSpace(ccp(x,y))
                local p = ccp((worldpos.x - dis) * self.blockScale, worldpos.y)
                
                block:pos(p.x,p.y)

                self.offx = touchx - p.x;
                self.offy = touchy - p.y;

                self._gameMap:addChild(block)
                v:hide()
                self._currentOriginPos = p
                self._moveBlock = block; 
                return true;
            end
        end
    end
    
    

    -- 已放置的块
    for k, v in ipairs(self._gameMap._blocks) do 
        local lp = v._bitmap:convertToNodeSpace(ccp(touchx,touchy))
        if v._bitmap:boundingBox():containsPoint(lp) then
            
            local bitSize = v._bitmap:getContentSize();
            local row = math.ceil((bitSize.height - lp.y) / 50);   -- y越大row越小
            local col = math.ceil(lp.x / 50);

            if v:map()[row][col] == 1 then
               
                local x, y = v:originBlock():getParent():getPosition()
                local dis = 40
                if BA.IS_IPHONEX then
                    dis = 90
                end 
                local p = ccp((x + dis) * self.blockScale, self._blockLayer:getPositionY())
                
                self.offx = touchx - v:getPositionX();
                self.offy = touchy - v:getPositionY();

                self._currentOriginPos = p;
                self._moveBlock = v;
                print("zorder ",self._moveBlock:getZOrder())
                self._moveBlock:setZOrder(1); 
                return true;
            end
        end
    end

    return false;

end


function GameScene:onTouchMoved(x,y)

    local cx = x - self.offx;
    local cy = y - self.offy;
    self._moveBlock:pos(cx,cy);

end

function GameScene:onTouchEnded(x,y)

    local canPut = self._gameMap:checkBlock(self._moveBlock);
    self._moveBlock:setZOrder(0);
    print("canPut",canPut)
    if not canPut then
        local t =  math.sqrt(math.pow(self._currentOriginPos.x - x, 2) + math.pow(self._currentOriginPos.y - y, 2))/5000
        local seq = transition.sequence({transition.spawn({
            CCMoveTo:create(t,self._currentOriginPos),
            CCScaleTo:create(t,self.blockScale),
            -- CCCallFuncN:create(function(node) 
                
            -- end)
        }),
        CCCallFuncN:create(function(node)
            node:removeFromParentAndCleanup(true)
            node:originBlock():show()
        end)
        })
        self._moveBlock:runAction(seq)
        self._moveBlock = nil;
    end
end


return GameScene
