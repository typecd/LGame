local RunScene = require("sg/RunScene")
local Achievement = require("sg/Achievement")
local Hero = require("sg/Hero")
local Role = require("sg/Role")

local HallScene = class("HallScene",function() 
    return display.newColorLayer(ccc4(255,255,255,255))
end)

function HallScene.show()
    local layer = HallScene.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end

function HallScene:ctor() 
    
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    self:showUI()
    self.heroSchedu = scheduler.performWithDelayGlobal(handler(self,self.createHero), 1)  

    self:registerScriptHandler(handler(self,self.onNodeEvent))
    EventManager:getInstance():add("UPDATE_CURRENCY",self.onLocalEvent,self)
end

function HallScene:showUI()
    -- 极限
    local title = display.newSprite(IMG_PATH .. "title.png")
    title:addTo(self)
    title:setAnchorPoint(ccp(0.5,1))
    title:pos(display.cx,display.height - 15)

    local labelCoin = display.newTTFLabel({
        text = "$"..PLUGIN_INS.UserInfo.CURRENCY,
        size = 32,
        color = ccc3(0,0,0),
        align = kCCTextAlignmentRight,
    })
    labelCoin:addTo(self)
    labelCoin:setAnchorPoint(ccp(0,1))
    labelCoin:pos(20,display.height - 20)
    self.labelCoin = labelCoin;

    local shop = display.newButton({
        normal = IMG_PATH .. "shop.png",
        callback = function() 
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            PLUGIN_INS.IapSG:showUI()
        end
    })
    shop:addTo(self)
    shop:pos(display.width - 80,display.height - 50)
    -- 
    local plant = display.newScale9Sprite(IMG_PATH .. "black.png",display.cx,100,CCSize(display.size.width,8))
    plant:addTo(self)

    --- obs
    local obs1 = display.newScale9Sprite(IMG_PATH .. "black.png",180,99,CCSize(30,40))
    obs1:setAnchorPoint(ccp(0,0))
    obs1:addTo(self)
    -- local obs2 = display.newScale9Sprite(IMG_PATH .. "black.png",500,99,CCSize(30,50))
    -- obs2:setAnchorPoint(ccp(0,0))
    -- obs2:addTo(self)

    local obs3 = display.newScale9Sprite(IMG_PATH .. "black.png",display.cx,99,CCSize(30,60))
    obs3:setAnchorPoint(ccp(0,0))
    obs3:addTo(self)
    local obs4 = display.newScale9Sprite(IMG_PATH .. "black.png",display.width - 220,99,CCSize(30,100))
    obs4:setAnchorPoint(ccp(0,0))
    obs4:addTo(self)

    -- center 
    local btnStart = display.newButton({
        normal = IMG_PATH .. "start.png",
        callback = function()
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            RunScene.show()
        end,
    })
    btnStart:addTo(self)
    btnStart:pos(display.cx,display.cy)

    -- 


    --- buttom
    local btnAch = display.newButton({
        normal = IMG_PATH .. "record.png",
        callback = function()
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            Achievement.show()
        end,
    })
    btnAch:setScale(0.5)
    btnAch:addTo(self)
    btnAch:pos(80,50)

    local btnRole = display.newButton({
        normal = IMG_PATH .. "role.png",
        callback = function() 
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            Role.show()
        end,
    })
    btnRole:setScale(0.5)
    btnRole:addTo(self)
    btnRole:pos(display.width - 80,50)

end


function HallScene:createHero(dt)
    local hy = 103
    local hero = Hero.new(math.random(1,CONFIG.Hero_Count),ccp(-30,hy))
    hero:addTo(self)
    hero:run()
    local speed = 250
    local move = CCMoveTo:create(150/speed,ccp(120,hy))  -- 60
    local jump = CCJumpTo:create(0.5,ccp(240,hy),120,1)
    local move2 = CCMoveTo:create((display.cx - 300)/speed ,ccp(display.cx-60,hy))
    local jump2 = CCJumpTo:create(0.5,ccp(display.cx + 60,hy),120,1)
    local move3 = CCMoveTo:create((display.width - 280 - display.cx - 60 )/speed,ccp(display.width - 280,hy))
    local jump3 = CCJumpTo:create(0.5,ccp(display.width - 150,hy),120,1)
    local move4 = CCMoveTo:create(170/speed,ccp(display.width + 20,hy))

    hero:runAction(transition.sequence({
        move,jump,move2,jump2,move3,jump3,move4,
        CCCallFuncN:create(function(node) 
            node:removeFromParentAndCleanup(true)
        end)
    }))

    self.heroSchedu = scheduler.performWithDelayGlobal(handler(self,self.createHero), math.random(2,5))
end

function HallScene:onNodeEvent(event)
    if event == "exit" then
        scheduler.unscheduleGlobal(self.heroSchedu)
        EventManager:getInstance():remove("UPDATE_CURRENCY",self)
    end
end


function HallScene:onLocalEvent(event,count)
    if event == "UPDATE_CURRENCY" then
        self.labelCoin:setString("$"..PLUGIN_INS.UserInfo:getUserInfoByKey("CURRENCY"))
    end
end



return  HallScene