local Achievement = class("Achievement",function() 
    return CCLayerColor:create(ccc4(255,130,84,255))
end)

--- 成就

local tconfig = {
    GSV_HIGHT = 400, -- sv的可视高度
    GSV_WIDTH = 500, -- sv的可视宽度
    GITEM_H = 100,    -- 条目 高
    GITEM_W = 500,   -- 条目 宽
    GITEM_COLS = 1,  -- 条目列数(sv有几列)
    GITEM_PADDING_TOP = 2, -- item上下间距  
}

local pos_right_up = {
    ccp(display.width - 250,display.height - 90),
    ccp(display.width - 90,display.height - 90),
}

function Achievement.show()

    local layer = Achievement.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)

end

function Achievement:ctor()

    -- 时间成就  和 跳跃成就  金币成就

    local title = display.newSprite(IMG_PATH .. "record.png")
    title:addTo(self)
    title:pos(display.cx,display.height - title:getContentSize().height/2)
    -- 时间系   运动系     财富系  3个listView
    self.btnArr = {}
    self.btnActions = {}

    local btn_time = display.newButton({
        normal = IMG_PATH.."item_bg.png",
        label = "時間系",
        labelSize = 32,
        callback = function()
            self:btnMove(1)
            print("時間係")
            local history = CCUserDefault:sharedUserDefault():getStringForKey("best_time")
            history = history == "" and 0 or tonumber(history)
            self:createTimeView(CONFIG.TIME_DATA,history)
        end, 
    })
    btn_time:addTo(self)
    btn_time:pos(display.cx - 300,display.cy)
    table.insert(self.btnArr,btn_time)

    local btn_sport = display.newButton({
        normal = IMG_PATH.."item_bg.png",
        labelSize = 32,
        label = "運動系",
        callback = function()
            self:btnMove(2)
            local history = CCUserDefault:sharedUserDefault():getIntegerForKey("best_sport")
            print("運動係",history)
            self:createTimeView(CONFIG.SPORT_DATA,history)
        end, 
    })
    btn_sport:addTo(self)
    btn_sport:pos(display.cx ,display.cy)
    table.insert(self.btnArr,btn_sport)

    local btn_money = display.newButton({
        normal = IMG_PATH.."item_bg.png",
        label = "財富系",
        labelSize = 32,
        callback = function()
            self:btnMove(3)
            print("財富係")
            
            local history = CCUserDefault:sharedUserDefault():getIntegerForKey("best_money")
            self:createTimeView(CONFIG.WEALTH_DATA,history)
        end, 
    })
    btn_money:addTo(self)
    btn_money:pos(display.cx + 300,display.cy)
    table.insert(self.btnArr,btn_money)
    
    -- self:createSportView()
    -- self:createMoneyView()

    local btn_back = display.newButton({
        normal = IMG_PATH .. "back.png",
        callback = self.onBack,
        delegate = self,
    })
    btn_back:addTo(self)
    btn_back:pos(display.width -50,btn_back:getContentSize().height/2+20)

    self:registerScriptTouchHandler(function(event,x,y)
        if event == "began" then
            return true;
        end
    end,false,-127,true)
    self:setTouchEnabled(true)
end

function Achievement:createTimeView(data,history)
    self.showType = 1;
    local scrollview = CCScrollView:create(CCSize(tconfig.GSV_WIDTH,tconfig.GSV_HIGHT));
    scrollview:setDirection(1); --- 垂直
    local cnts = 6 
    local rows = 6;  -- 向上取整 行数
    local shight = rows * (tconfig.GITEM_H+tconfig.GITEM_PADDING_TOP); 
    if shight < tconfig.GSV_HIGHT then
        shight = tconfig.GSV_HIGHT;
    end
    scrollview:setContentSize(CCSize(tconfig.GSV_WIDTH,shight)); --- 滚动区域大小 通过 item总数 item的size cols 计算大小 
    scrollview:setClippingToBounds(true);
    scrollview:setBounceable(true)
    scrollview:setTouchPriority(-128); --- 点击在按钮上 scrollView也可以滑动
    scrollview:setContentOffset(ccp(0,tconfig.GSV_HIGHT - shight)); --- 设置最大偏移
    scrollview:addTo(self);
    scrollview:pos(display.cx - tconfig.GSV_WIDTH /2 , 60)
    
    self.scrollview = scrollview

    
    for k,v in ipairs(data) do 
        local node = CCNode:create()
        node:setContentSize(CCSize(tconfig.GITEM_W,tconfig.GITEM_H))
        node:pos(0,shight - tconfig.GITEM_H*k)

        local title = display.newTTFLabel({
            text = v.name,
            size = 38,
            color = ccc3(0,0,0),
            align = kCCTextAlignmentCenter,
        })
        title:addTo(node)
        title:setAnchorPoint(ccp(0,0))
        title:pos(0,50)

        -- 奖励
        local txt = "獎勵$"..v.reward
        if history >= v.target then
            txt = "已完成"
        end

        local reward = display.newTTFLabel({
            text = txt,
            size = 38,
            color = ccc3(0,0,0),
            align = kCCTextAlignmentCenter,
        })
        reward:addTo(node)
        reward:setAnchorPoint(ccp(1,0))
        reward:pos(tconfig.GITEM_W,50)

        local line = display.newScale9Sprite(IMG_PATH .. "black.png",0,45,CCSize(tconfig.GITEM_W,5))
        line:setAnchorPoint(ccp(0,0))
        line:addTo(node)

        local disc =  display.newTTFLabel({
            text = v.disc,
            size = 24,
            color = ccc3(0,0,0),
            align = kCCTextAlignmentCenter,
        })
        disc:addTo(node)
        disc:setAnchorPoint(ccp(0.5,0))
        disc:pos(tconfig.GITEM_W/2,10)

        scrollview:addChild(node)

    end

end


function Achievement:btnMove(tag)
    SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
    -- 移動左下角
    local touch = self.btnArr[tag]
    local move = CCMoveTo:create(0.3,ccp(90,90))
    move:retain();
    touch:runAction(move)
    touch:setTouchEnabled(false)
    -- table.insert(self.btnActions,tag,move)
    self.btnActions[tag] = move
    local i = 1 
    for k,v in ipairs(self.btnArr) do 
        if k ~= tag then 
            local move = CCMoveTo:create(0.3,pos_right_up[i])
            move:retain();
            -- table.insert(self.btnActions,k,move)    
            self.btnActions[k] = move        
            v:runAction(move)
            v:setTouchEnabled(false)
            i = i + 1
        end
    end
end


function Achievement:onBack(tag)
    SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
    if self.showType == 1 then
        -- 按钮反向运动
        for k,v in ipairs(self.btnArr) do 
            v:runAction(self.btnActions[k]:reverse())
            self.btnActions[k]:release()
            v:setTouchEnabled(true)
        end
        -- 移除scrollView
        self.scrollview:removeFromParentAndCleanup(true)
        self.showType = 0
        self.btnActions = {}
    else
        self:removeFromParentAndCleanup(true)
    end

end

return Achievement
