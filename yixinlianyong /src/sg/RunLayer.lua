
local Hero = require("sg/Hero")
local Obstacle = require("sg/Obstacle")

local RunLayer = class("RunLayer",function() 
    return CCLayerColor:create(ccc4(255,255,255,255))
end)


local Hero_Pos = ccp(200,4)
-- local Hero_Size = CCSize(20,40)
local jump_hight = 60

RunLayer.Hero_Pos = Hero_Pos

function RunLayer:ctor(name,parent)
    self.parent = parent
    self.name = name
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))

    self.obstacleArr = { } --- 所有障碍物
    self.coinArr = {}   -- 金币

    self.speed = 500 -- 移动速度

    self.obstacleCount = 0 -- 越過障碍物数量
    self.createTimes = 0 -- 产生金币次数

    self:setContentSize(CCSize(display.size.width,400))


    self:initUI()
    local function onNodeEvent(event)
        if event =="enter" then
            self:onEnter()
        elseif event =="exit" then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function RunLayer:initUI()
    local plant = display.newScale9Sprite(IMG_PATH .. "black.png",display.cx,0,CCSize(display.size.width,8))
    plant:addTo(self)

    local hero_index = CCUserDefault:sharedUserDefault():getIntegerForKey("hero_index")
    if hero_index == 0 then
        hero_index = 1 
    end

    local hero = Hero.new(hero_index,Hero_Pos)
    hero:addTo(self)

    self.hero = hero
    self.hero_size = hero:getContentSize()
    
end

function RunLayer:startGame()
    -- 开启计时器
    self.obsScheduler = scheduler.performWithDelayGlobal(handler(self,self.updateObstacle), 0.5)  
    self.collisionScheduler = scheduler.scheduleGlobal(handler(self,self.updateCollision),0)
    self.coinScheduler = scheduler.scheduleGlobal(handler(self,self.updateCoin),3)

    self.hero:run()
    self:setTouchEnabled(true)
    self.obstacleCount = 0
    self.createTimes = 0
    
end


function RunLayer:stopGame()
    print("发生碰撞")
    scheduler.unscheduleGlobal(self.obsScheduler)
    scheduler.unscheduleGlobal(self.collisionScheduler)
    scheduler.unscheduleGlobal(self.coinScheduler)

    self.obsScheduler = nil
    self.collisionScheduler = nil
    self.coinScheduler = nil

    -- hero
    self.hero:stop(true)
    -- obstacle
    for k,v in ipairs(self.obstacleArr) do
        v:stopAllActions()
    end

    for k,v in ipairs(self.coinArr) do
        v:stopAllActions()
    end

    self:setTouchEnabled(false)
end

function RunLayer:cleanTable()
    for k,v in ipairs(self.obstacleArr) do
        if not tolua.isnull(v) then
            v:removeFromParentAndCleanup(true)
        end
    end
    for k,v in ipairs(self.coinArr) do 
        v:removeFromParentAndCleanup(true)
    end

    self.currObstacle = nil
    self.obstacleArr = {}
    self.coinArr = {}

    self.hero:standOriginPos()
    
end

function RunLayer:onEnter()
    print("RunLayer onEnter")
    self:registerScriptTouchHandler(handler(self,self.onTouch),false,-127,true)    
    self:startGame()
end


function RunLayer:onExit()
    print("RunLayer onExit")

end

function RunLayer:updateObstacle(dt)

    local size = CCSize( math.random(10,40), math.random(20,100) )
    local dis = math.random(300,700)
    if not self.currObstacle  then
        self:createObstacle(self.speed,size)
    end
    if display.size.width - self.currObstacle:getPositionX() >= dis then
        self:createObstacle(self.speed,size)
    end

    -- 发生碰撞后 停止此计时器
    self.obsScheduler = scheduler.performWithDelayGlobal(handler(self,self.updateObstacle), 0.05)  
end

function RunLayer:updateCollision(dt)

    -- 碰撞金币
    local coin = self.coinArr[1]
    if coin then
        print("coin ---")
        if self.hero:boundingBox():intersectsRect(coin:boundingBox()) then
            SoundUtil.playEffect(CONFIG.Touch_Music,"hit_coin",false)
            table.remove(self.coinArr)  -- 同时最多存在一个
            coin:removeFromParentAndCleanup(true)
            -- parent ui金币数量加一个
            self.parent:addCoin()
        end
    end

    -- hero 闪烁
    if self.hero.isBlinking then
        return
    end
    -- 比较第一个障碍物 与 hero 的位置
    local obstacle = self.obstacleArr[1]
    if not obstacle  then
        return
    end
    if tolua.isnull(obstacle) then
        table.remove(self.obstacleArr,1)
        print("c++对象已经被删除")
        return 
    end
    local px = obstacle:getPositionX() 
    if px > Hero_Pos.x + self.hero_size.width then
        return 
    end    
    if px + obstacle:getContentSize().width < Hero_Pos.x  then
        -- 统计跳过障碍物
        if not obstacle._isCounted then
            self.obstacleCount = self.obstacleCount + 1
            -- 标记 下次不再统计
            obstacle._isCounted =  true
        end
        return
    end

    if self.hero:boundingBox():intersectsRect(obstacle:boundingBox()) then
        self.parent:onGameOver()
        SoundUtil.playEffect(CONFIG.Touch_Music,"dead_"..self.hero.type,false)
    end

end



-- 金币
function RunLayer:updateCoin(dt)
    self.createTimes = self.createTimes + 1
    local seed = math.random(1,100) 
    if seed <= self.createTimes then
        print(" 生产金币 ")
        local coin = Obstacle.new(2)
        local move = transition.sequence({
            CCMoveTo:create(display.size.width/self.speed,ccp(-30,120)),
            CCCallFuncN:create(function(node) 
                table.remove(self.coinArr,1)
                node:removeFromParentAndCleanup(true)
            end),
        })
        coin:runAction(move)
        table.insert(self.coinArr,coin)
        coin:addTo(self)
    end
end



-- 创建障碍物
function RunLayer:createObstacle(speed,size)
    local obstacle = Obstacle.new(1,size) 
    obstacle:addTo(self)
    local move = transition.sequence({
        CCMoveTo:create(display.size.width/speed,ccp(-30,4)),
        CCCallFuncN:create(function(node) 
            table.remove(self.obstacleArr,1)
            node:removeFromParentAndCleanup(true)
        end),
    })
    obstacle:runAction(move)
    self.currObstacle = obstacle
    table.insert(self.obstacleArr,obstacle)
end

function RunLayer:onTouch(event,x,y)

    if event == "began" then
        local pos = ccp(x,y)
        -- print(x,y)
        if not self:boundingBox():containsPoint(pos) then
            -- print(" run layer return false ",self.name)
            return false
        end

        self:heroJump()
        return true
    elseif event == "ended" then
        
    end
end


function RunLayer:heroJump()
    
    self.hero:jump()

end


function RunLayer:rebirth()

    self.hero:blink()
    -- self.isJumping = false
    -- self.isSecJumping = false
    
    self.hero:standOriginPos()

    local obs = table.remove(self.obstacleArr,1)
    obs:removeFromParentAndCleanup(true)
    -- 当前的障碍物继续移动
    for k,v in ipairs(self.obstacleArr) do
        local move = transition.sequence({
            CCMoveTo:create(v:getPositionX()/self.speed,ccp(-40,4)),
            CCCallFuncN:create(function(node) 
                table.remove(self.obstacleArr,1)
                node:removeFromParentAndCleanup(true)
            end),
        })
        v:runAction(move)
    end

    for k,v in ipairs(self.coinArr) do 
        local move = transition.sequence({
            CCMoveTo:create(v:getPositionX()/self.speed,ccp(-40,120)),
            CCCallFuncN:create(function(node) 
                table.remove(self.coinArr,1)
                node:removeFromParentAndCleanup(true)
            end),
        })
        v:runAction(move)
    end

    -- 发生碰撞后 停止此计时器
    self.obsScheduler = scheduler.performWithDelayGlobal(handler(self,self.updateObstacle), 0.05)  
    self.collisionScheduler = scheduler.scheduleGlobal(handler(self,self.updateCollision),0)
    self.coinScheduler = scheduler.scheduleGlobal(handler(self,self.updateCoin),3)
    -- hero执行帧动画
    self.hero:run()
    self:setTouchEnabled(true)
end


function RunLayer:onPause()
    self:setTouchEnabled(false)
    -- hero暂停动作 obst暂停
    local actManager = CCDirector:sharedDirector():getActionManager()
    actManager:pauseTarget(self.hero)

    for k,v in ipairs(self.obstacleArr) do 
        if not tolua.isnull(v) then
            actManager:pauseTarget(v)
        end 
    end

    for k,v in ipairs(self.coinArr) do
        actManager:pauseTarget(v)
    end

    -- 暂停碰撞
    scheduler.unscheduleGlobal(self.obsScheduler)
    scheduler.unscheduleGlobal(self.collisionScheduler)
    scheduler.unscheduleGlobal(self.coinScheduler)
    self.obsScheduler = nil
    self.collisionScheduler = nil
    self.coinScheduler = nil
end


function RunLayer:onResume()
    self:setTouchEnabled(true)
    local actManager = CCDirector:sharedDirector():getActionManager()
    actManager:resumeTarget(self.hero)

    for k,v in ipairs(self.obstacleArr) do 
        if not tolua.isnull(v) then
            actManager:resumeTarget(v)
        end 
    end

    for k,v in ipairs(self.coinArr) do 
        actManager:resumeTarget(v)
    end

    self.obsScheduler = scheduler.performWithDelayGlobal(handler(self,self.updateObstacle), 0.05)  
    self.collisionScheduler = scheduler.scheduleGlobal(handler(self,self.updateCollision),0)
    self.coinScheduler = scheduler.scheduleGlobal(handler(self,self.updateCoin),3)

end


return RunLayer 