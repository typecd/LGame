local RunLayer = require("sg/RunLayer")
local GameTimer = require("sg/GameTimer")
local Achievement = require("sg/Achievement")


local RunScene = class("RunScene",function()
    return CCScene:create()
end)

function RunScene.show()
    local scene = RunScene.new()
    CCDirector:sharedDirector():replaceScene(scene)
end

function RunScene:ctor()
    self.rebirthed = false --- 买活状态
    self.totalTime = 0
    self.getCoin = 0  --- 一局获得到金币数
    self.layerArr = {}
    -- 结束控制
    -- 重新开始
    -- 计时器(距离)
    
    local labelTime = display.newTTFLabel({
        text = "",
        size = 64,
        color = ccc3(0,0,0),
        align = kCCTextAlignmentRight,
    })
    labelTime:addTo(self,10)
    labelTime:setAnchorPoint(ccp(1,1))
    labelTime:pos(display.width-30,display.height-20)
    self.labelTime = labelTime

    local btn_pause = display.newButton({
        normal = IMG_PATH.. "pause.png",
        callback = self.onPause,
        delegate = self,
        priority = -128,
    })
    btn_pause:addTo(self,10)
    btn_pause:pos(50,display.height-50)
    self.btn_pause = btn_pause

    -- local labelCoin = display.newTTFLabel({
    --     text = "x0",
    --     size = 64,
    --     color = ccc3(0,0,0),
    --     align = kCCTextAlignmentRight,
    -- })
    -- labelCoin:addTo(self,10)
    -- labelCoin:setAnchorPoint(ccp(0,1))
    -- labelCoin:pos(display.width-400,display.height-20)
    -- self.labelCoin = labelCoin

    self:registerScriptHandler(handler(self,self.onNodeEvent))

    -- local p1 = CCParticleSystemQuad:create("Particles/SmallSun.plist")
    -- local smoke = CCParticleSystemQuad:create(IMG_PATH .. "smoke.plist")
    -- smoke:addTo(self,10)
    -- smoke:pos(display.cx,50)

end


function RunScene:onNodeEvent(event)
    if event == "enter" then
        local build = RunLayer.new("name_1",self)
        build:addTo(self)
        build:pos(0,50)
        table.insert(self.layerArr,build)
        
        local build2 = RunLayer.new("name_2",self)
        build2:addTo(self)
        build2:pos(0,(display.size.height+50)/2)
        table.insert(self.layerArr,build2)

        self.countTimeScheduler = scheduler.scheduleGlobal(handler(self,self.countTime),0)

    elseif event =="exit" then

    end
end


function RunScene:onGameOver()

    self.btn_pause:hideAndBan(false)
    -- 停止計時
    if self.countTimeScheduler then
        scheduler.unscheduleGlobal(self.countTimeScheduler)
        self.countTimeScheduler = nil
    end

    for k,v in ipairs(self.layerArr) do
        v:stopGame()
    end

    if self.totalTime > 10 and not self.rebirthed then
        self:showRebirth()
        return 
    end

    if self.continueLayer then
        self.continueLayer:removeFromParentAndCleanup(true)
        self.continueLayer = nil
    end
    
    self:runAction(transition.sequence({
        CCDelayTime:create(0.5),
        CCCallFuncN:create(
            function(node)
                node:showOverView()
            end
        )
    }))
    -- self:showOverView()
    
end


function RunScene:showOverView()    
    self.labelTime:setVisible(false)
    -- self.labelCoin:setVisible(false)
    self.btn_pause:hideAndBan(false)
    -- 255,130,84
    local layer = display.newColorLayer(ccc4(255,130,84,255))
    layer:addTo(self)
    
    local iphoneX = 0

    if BA.IS_IPHONEX then
        iphoneX = 30
    end

    local labelTips = display.newTTFLabel({
        text = "tips:點擊角色所在的區域,對應角色會起跳.碰撞帶有$黑色的圓形會增加$數量",
        size = 24,
        color = ccc3(0,0,0)
    })
    labelTips:addTo(layer)
    labelTips:setAnchorPoint(ccp(0.5,1))
    labelTips:pos(display.cx,display.height - 30)

    local btn_restart = display.newButton({
        normal = IMG_PATH.."restart.png",
        callback=function()
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            layer:removeFromParentAndCleanup(true)
            self:reStart()
        end,
    })
    btn_restart:addTo(layer)
    btn_restart:pos(display.size.width-btn_restart:getContentSize().width/2-iphoneX,display.cy)


    local btn_record = display.newButton({
        normal = IMG_PATH.."record.png",
        callback = function(dele,data)
            -- dele:removeChildByTag(100,true)
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            if data and not tolua.isnull(data) then 
                data:removeFromParentAndCleanup(true)
            end
            -- 顯示成就
            Achievement.show()
        end,
        delegate = btn_record,
    })
    btn_record:addTo(layer)
    btn_record:pos(btn_record:getContentSize().width/2+iphoneX,display.cy)

    local btn_back = display.newButton({
        normal = IMG_PATH .. "back.png",
        callback = function() 
            print("返回")
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            PLUGIN_INS.backHall()
        end,
    })
    btn_back:addTo(layer)
    btn_back:pos(display.cx,btn_back:getContentSize().height/2+20)

    local line = display.newScale9Sprite(IMG_PATH.."black.png",display.cx,display.cy,CCSize(300,8))
    line:addTo(layer)

    local labelCurr = display.newTTFLabel({
        text = string.format('%0.3f"',self.totalTime),
        size = 64,
        color = ccc3(0,0,0),
        align = kCCTextAlignmentCenter,
    })
    labelCurr:setAnchorPoint(ccp(0.5,0))
    labelCurr:addTo(layer)
    labelCurr:pos(display.cx,display.cy+10)

    -- 统计最佳
    local history = CCUserDefault:sharedUserDefault():getStringForKey("best_time")
    history = history == "" and "0" or history
    local achArr = {}
    if self.totalTime > tonumber(history) then
        CCUserDefault:sharedUserDefault():setStringForKey("best_time",string.format('%0.3f',self.totalTime))
        -- 已获得成就序号
        local got = CCUserDefault:sharedUserDefault():getIntegerForKey("time_got")
        for k,v in ipairs(CONFIG.TIME_DATA) do
            if k > got and self.totalTime > v.target then
                table.insert(achArr,v)
                PLUGIN_INS.UserInfo:setUserInfoByKey({
                    CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + v.reward
                })
                CCUserDefault:sharedUserDefault():setIntegerForKey("time_got",k)
            end
        end
    end


    local labelBest = display.newTTFLabel({
        text = "歷史:"..history..'"',
        size = 38,
        color = ccc3(0,0,0),
        align = kCCTextAlignmentCenter,
    })
    labelBest:setAnchorPoint(ccp(0.5,1))
    labelBest:addTo(layer)
    labelBest:pos(display.cx,display.cy-20)

    local sportCount = 0
    for k,v in ipairs(self.layerArr) do 
        sportCount = sportCount + v.obstacleCount
    end

    print("越过障碍",sportCount)

    history = CCUserDefault:sharedUserDefault():getIntegerForKey("best_sport")
    if sportCount > history then
        CCUserDefault:sharedUserDefault():setIntegerForKey("best_sport",sportCount)
        local got = CCUserDefault:sharedUserDefault():getIntegerForKey("sport_got")
        for k,v in ipairs(CONFIG.SPORT_DATA) do
            if k > got and sportCount > v.target then
                table.insert(achArr,v)
                PLUGIN_INS.UserInfo:setUserInfoByKey({
                    CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + v.reward
                })
                CCUserDefault:sharedUserDefault():setIntegerForKey("sport_got",k)
            end
        end
    end

    --- 金幣數量
    history = CCUserDefault:sharedUserDefault():getIntegerForKey("best_money")
    if self.getCoin > history then
        CCUserDefault:sharedUserDefault():setIntegerForKey("best_money",self.getCoin)

        local got = CCUserDefault:sharedUserDefault():getIntegerForKey("money_got")
        for k,v in ipairs(CONFIG.WEALTH_DATA) do
            if k > got and self.getCoin > v.target then
                table.insert(achArr,v)
                PLUGIN_INS.UserInfo:setUserInfoByKey({
                    CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + v.reward
                })
                CCUserDefault:sharedUserDefault():setIntegerForKey("money_got",k)
            end
        end
    end
    if self.getCoin > 0 then
        PLUGIN_INS.UserInfo:setUserInfoByKey({
            CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + self.getCoin
        })
    end

    if #achArr > 0 then 
        local redIcon = display.newSprite(IMG_PATH .. "red.png")
        redIcon:addTo(btn_record)
        redIcon:pos(108,45)
        btn_record:setUserData(redIcon)
        for k,v in ipairs(achArr) do 
            Toast:showToast("達成成就: "..v.name.." ,獎勵$"..v.reward)
        end
    end

end


function RunScene:reStart()
    for k,v in ipairs(self.layerArr) do
        v:cleanTable()
        v:startGame()
    end
    self.totalTime = 0
    self.getCoin = 0
    -- self.labelCoin:setString("x0")

    self.countTimeScheduler = scheduler.scheduleGlobal(handler(self,self.countTime),0)
    self.labelTime:setVisible(true)
    -- self.labelCoin:setVisible(true)
    self.rebirthed = false
    self.btn_pause:hideAndBan(true)
end


function RunScene:countTime(dt)
    -- 計時器
    self.totalTime = (self.totalTime + dt)
    self.labelTime:setString(string.format('%0.3f"',self.totalTime))
end


--[[
    买活
]]
function RunScene:showRebirth()
    local layer = display.newColorLayer(ccc4(0,0,0,0))
    layer:addTo(self)
    layer:registerScriptTouchHandler(function(event,x,y)
        if event == "began" then
            return true
        end
    end,false,-127,true)
    layer:setTouchEnabled(true)

    -- 
    local tipsLabel = display.newTTFLabel({
        text = "花費$200復活",
        size = 64,
        color = ccc3(0,0,0),

    })
    tipsLabel:setAnchorPoint(ccp(0.5,0.5))
    tipsLabel:addTo(layer)
    tipsLabel:pos(display.cx,display.cy+200)
    self.rebirthed = true

    local btn_yes = display.newButton({
        normal = IMG_PATH .. "yes.png",
        callback = function() 
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            if PLUGIN_INS.UserInfo.CURRENCY >= 200 then

                print("买活")
                local function gameContinue()
                    self.btn_pause:hideAndBan(true)
                    for k,v in ipairs(self.layerArr) do 
                        v:rebirth()
                    end
                    self.countTimeScheduler = scheduler.scheduleGlobal(handler(self,self.countTime),0)
                end
                -- 倒计时3秒
                GameTimer.show(3,1,gameContinue)
                -- hero 闪烁
                layer:removeFromParentAndCleanup(true)
            else
                Toast:showToast("金幣不足.")
            end
        end,
    })
    btn_yes:addTo(layer)
    btn_yes:pos(display.cx+150,display.cy-120)

    local btn_No = display.newButton({
        normal = IMG_PATH .. "no.png",
        callback = function() 
            print("退出")
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            layer:removeFromParentAndCleanup(true)
            self:showOverView()
        end,
    })
    btn_No:addTo(layer)
    btn_No:pos(display.cx-150,display.cy-120)


end

function RunScene:onPause()
    SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
    self.btn_pause:hideAndBan(false)
    self:showPauseView()

    for k,v in ipairs(self.layerArr) do 
        v:onPause()
    end
    -- 计时器暂停
    if self.countTimeScheduler then
        scheduler.unscheduleGlobal(self.countTimeScheduler)
        self.countTimeScheduler = nil
    end

end

function RunScene:onResume()
    self.btn_pause:hideAndBan(true)
    for k,v in ipairs(self.layerArr) do 
        v:onResume()
    end
    self.countTimeScheduler = scheduler.scheduleGlobal(handler(self,self.countTime),0)
    
end

function RunScene:showPauseView()

    print("show PauseView")
    local layer = display.newLayer()
    layer:addTo(self,10)

    local sprite = display.newSprite(IMG_PATH .. "jixu.png")
    sprite:addTo(layer)
    sprite:pos(display.cx,display.cy+150)

    local btn_resume = display.newButton({
        normal = IMG_PATH .. "go.png",
        callback = function() 
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            -- self:onResume()
            GameTimer.show(3,1,handler(self,self.onResume))
            layer:removeFromParentAndCleanup(true)
            self.continueLayer = nil
        end, 
    })
    btn_resume:addTo(layer)
    btn_resume:pos(display.cx,display.cy-20)
    self.continueLayer = layer

    local btn_back = display.newButton({
        normal = IMG_PATH .. "back.png",
        callback = function() 
            print("返回")
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            PLUGIN_INS.backHall()
        
        end,
    })
    btn_back:addTo(layer)
    btn_back:pos(display.cx,display.cy - 220)

end


function RunScene:addCoin()
    self.getCoin = self.getCoin + 1
    -- self.labelCoin:setString("x"..self.getCoin)
end


return RunScene