local LayerBase = require("sg/LayerBase")
local BackGroud = require("sg/BackGroud")

local GameMap = require("sg/GameMap")
local GameScene = require("sg/GameScene")
local TopBar = require("sg/TopBar")
local UnlockLayer = require("sg/UnlockLayer")

local GateScene = class("GateScene",LayerBase)



function GateScene.show()
    local layer = GateScene:new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)

end

function GateScene:ctor()   
    GateScene.super.ctor(self)
    BackGroud.new(self)

    self._pageSize = 12;
    self._page = 1;
    
    local btn_left = display.newButton({
        normal = CONFIG.R.gate_left,
        delegate = self,
        callback = self.onButton,
        tag = 1;
    })
    btn_left:addTo(self,1)
    local capx = 40
    if BA.IS_IPHONEX then
        capx = 90
    end
    btn_left:pos(capx,display.cy)
    self.btn_left = btn_left

    local btn_right = display.newButton({
        normal = CONFIG.R.gate_right,
        delegate = self,
        callback = self.onButton,
        tag = 2,
    })
    btn_right:addTo(self, 1)
    btn_right:pos(display.width - capx, display.cy);
    self.btn_right = btn_right


    self._totalPage = math.ceil(CONFIG.gateData:getLength() / self._pageSize)
    self._maxPassGate = CONFIG.getMaxPassGate()
    self._page = math.ceil(CONFIG.gate / self._pageSize)

    -- print( "line 56", self._totalPage, self._maxPassGate, self._page  );

    self:showPageFlag();

    local list = self:getPageData(self._page);

    local layer = self:createPageContent(list);
    layer:pos((display.width - 772)/2 + 89, 0);
    self._pageNode = display.newNode();
    self:add(self._pageNode);

    self._pageNode:add(layer);
    self._curView = layer;
    -- topBar
    local topBar = TopBar.new();
    topBar:addTo(self)
    topBar:pos(right(100), top(40));


    local btn_home = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_home1,
        delegate = self,
        callback = self.onButton,
        tag = 3,
    })
    btn_home:addTo(self)
    if not BA.IS_IPHONEX then
        capx = capx + 30
    end
    btn_home:pos(left(capx),top(capx));

    local btn_charge = display.newButton({
        normal = CONFIG.R.btn_shop,
        pressed = CONFIG.R.btn_shop,
        delegate = self,
        callback = self.onButton,
        tag = 4,
    })
    btn_charge:addTo(self,1);
    btn_charge:pos(right(100),60);

    -- local key_bg = display.newSprite(CONFIG.R.score_bg);
    local key_bg = display.newButton({
        normal = CONFIG.R.score_bg,
        pressed = CONFIG.R.score_bg,
        callback = function()
            Toast:showToast("鑰匙用於解鎖關卡,每一關需要5把鑰匙");
        end,
    })
    key_bg:addTo(self,1);
    key_bg:pos(right(100),top(130));

    local key = display.newSprite(CONFIG.R.key);
    key:addTo(key_bg);
    key:pos(-40,0);

    local label = CCLabelBMFont:create(PLUGIN_INS.UserInfo.CURRENCY, CONFIG.R.num1_fnt);
    key_bg:add(label);
    label:pos(20,0);
    self.scoreLabel = label;
    label:scale(0.8);
    
    -- 设置
    local btn_setting = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_setting1,
        delegate = self,
        callback = self.onButton,
        tag = 5,
    })
    btn_setting:addTo(self);
    btn_setting:pos(left(capx),60);


    EventManager:getInstance():add("UPDATE_CURRENCY",self.onEvent,self);

    self:registerScriptHandler(function(event)
        if event == "exit" then
            EventManager:getInstance():remove("UPDATE_CURRENCY",self);
            print("remove event");
        end 
    end)
end


function GateScene:getPageData(page)
    local len = CONFIG.gateData:getLength();
    local startIndex = (page - 1) * self._pageSize + 1;
    local endIndex = startIndex + self._pageSize - 1;
    if endIndex >= len then
        endIndex = len ;
    end

    local list = {};

    for i = startIndex, endIndex do 
        local score = 0;
        local lock = true;
        if i <= self._maxPassGate + 1 then
            lock = false;
            local passGate = CONFIG.getPassGate(i);
            if passGate then
                score = passGate.score;
            end
        end
        local item = {
            gate = i,
            score = score,
            lock = lock,
        }
        table.insert(list,item);
    end
    return list;

end


function GateScene:createPageContent(list)
    local layer = display.newNode();
    local rowCount = 4;
    local cap = 20;

    for k, item in ipairs(list) do 
        local row = math.floor((k - 1) / rowCount) + 1;
        local col = (k - 1) % rowCount + 1;  -- 1 2 3 0 1 2 
        -- bba.printTable(item);
        local gate = self:createItem(item.gate, item.score, item.lock);
        gate:pos((col - 1) * (178 + cap) , (rowCount - row) * (178 + cap) - 89);
        layer:add(gate);
        if CONFIG.gate == item.gate then
            local sp = display.newSprite(CONFIG.R.gate_frame);
            sp:pos((col - 1) * (178 + cap) , (rowCount - row) * (178 + cap) - 89);
            sp:addTo(layer);
        end
    end
    return layer;
end


function GateScene:createItem(gate, score, lock)

    local name = CONFIG.R.gate_pad_pass;
    if lock then
        name = CONFIG.R.gate_pad_lock;
    end

    local btn = display.newButton({
        normal = name,
        pressed = name,
        delegate = self,
        tag = gate,
        callback = self.onItemHandler,
    })
    
    local map = GameMap.new(CONFIG.gateData:getData(gate).map, 1);
    map:scale(0.25);
    btn:add(map);

    if lock then
        btn:setTouchEnabled(false);
        local l = display.newSprite(CONFIG.R.gate_lock);
        l:addTo(btn);
        l:pos(44, -44); 
    else
        btn.gate = gate;
        if not table.indexof(CONFIG.unlockedGates,gate) then  --- 可以进入，但未解锁
            local l = display.newSprite(CONFIG.R.gate_lock);
            l:addTo(btn);
            l:pos(44, -44);
        else
            for i = 1, 3 do 
                local name = CONFIG.R.star2;
                if score >= i then
                    name = CONFIG.R.star;
                end 
                local star = display.newSprite(name);
                star:scale(0.8);
                star:pos(-40 + 35 * (i - 1), -55);
                btn:add(star);
            end
        end
    end

    local atlas = CCLabelBMFont:create(gate, CONFIG.R.num1_fnt);
    btn:add(atlas);
    atlas:pos(0, 60);
    atlas:scale(0.8);


    return btn;
end

function GateScene:prevPage()
    if self._sliding then
        return;
    end

    self._sliding = true;
    self:gotoPage(self._page - 1);
end

function GateScene:nextPage()
    if self._sliding then
        return;
    end

    self._sliding = true;
    self:gotoPage(self._page + 1);
end


function GateScene:gotoPage(page)

    local x1 = - display.width - 89;
    local x2 = display.width ;
    if page == self._page + 1 then
        x1 = -x1;
        x2 = -x2;
    end

    local list = self:getPageData(page);
    local layer = self:createPageContent(list);
    layer:pos(x1,0);
    self._pageNode:add(layer);

    local seq = transition.sequence({
        CCMoveTo:create(0.1,ccp(x2,0));
        CCCallFuncN:create(function(node)
            node:removeFromParentAndCleanup(true);
            local act = transition.sequence({
                CCMoveTo:create(0.1,ccp((display.width - 772)/2 + 89, 0 )),
                CCCallFuncN:create(function(node2)
                    self._sliding = false;
                    self._curView = node2;
                 end)
            })
            layer:runAction(act);
        end)
    })

    self._curView:runAction(seq)

    self._page = page;
    self:showPageFlag();

end


function GateScene:onItemHandler(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3, false);
    if table.indexof(CONFIG.unlockedGates,tag) then
        CONFIG.gate = tag;
        CONFIG.changeScene("gameScene",self);
    else
        UnlockLayer.show(self,tag);
    end
end


function GateScene:showPageFlag()
    self.btn_right:hideAndBan(true);
    self.btn_left:hideAndBan(true);
    if self._page == 1 then
        self.btn_left:hideAndBan(false);
    end
    if self._page >= self._totalPage then
        self.btn_right:hideAndBan(false);
    end
end


function GateScene:onButton(tag) 
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == 1 then
        self:prevPage();
    elseif tag == 2 then
        self:nextPage();
    elseif tag == 3 then
        CONFIG.changeScene("startScene",self);
    elseif tag == 4 then
        print("充值");
        PLUGIN_INS.IapSG:showUI()
    elseif tag == 5 then
        CONFIG.changeScene("settingLayer");
    end
end


function GateScene:onEvent(event,data)
    self.scoreLabel:setString(data);
end

return GateScene