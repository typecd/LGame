require("sg/config")
require("baseEx/EventManager")
PLUGIN_INS = {}
-- [PLUGIN UserInfo START]
local UserInfo = require("module/UserInfo/UserInfo")
PLUGIN_INS.UserInfo = UserInfo.register()
-- [PLUGIN UserInfo END]
-- [PLUGIN IapSG START]
local IapSG = require("module/IapSG/IapSG")
PLUGIN_INS.IapSG = IapSG.register()
-- [PLUGIN IapSG END]

local HallScene = require("sg/HallScene")

local ReviewLayer = class('ReviewLayer',function()
    return CCLayer:create()
end);

PLUGIN_INS.backHall = function() 
    local sceneGame = CCScene:create()
    local reviewLayer = ReviewLayer.create()
    sceneGame:addChild(reviewLayer);
    CCDirector:sharedDirector():replaceScene(sceneGame)
end


function ReviewLayer.create()
    return ReviewLayer.new()
end

function ReviewLayer:ctor()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
     self:scheduleUpdateWithPriorityLua(function(dt)
        self:update(dt)
    end, 0)
    self:registerScriptHandler(function(tag)
        self:onNodeEvent(tag)
    end)
    -- EventEngine只用来响应金币购买成功的事件
    -- 小游戏使用EventManager
    EventEngine.register(self, self._onEventNotify);
end

function ReviewLayer:onNodeEvent(event)
    if "enter" == event then
        self:_onEnter()
    elseif "exit" == event then
        self:unscheduleUpdate()
        self:_onExit()
    end
end

function ReviewLayer:_onEventNotify(event, data)
    if event and event == EventName.UPDATE_GOLD then
        self:_onGoldCharged(data);
    end
end

function ReviewLayer:_onEnter()
    -- game start
    bba.log("遊戲成功運行") 
    HallScene.show()
    -- local h_t = import("sg/Hero").new()
    -- h_t:addTo(self,20)
    -- h_t:pos(display.cx,250)
end


function ReviewLayer:_onExit()
    -- game end
    print("ReviewLayer exit")
    EventEngine.unregister(self)
end


function ReviewLayer:update(dt)
    
end


function ReviewLayer:_onGoldCharged(count)
    -- game charged
    -- 平台充值成功的回调(data花费的钱，count获得的数量)
    bba.log(string.format("花费获得%d",count))
    PLUGIN_INS.UserInfo:setUserInfoByKey({
        CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + count
    })
end


function ReviewLayer:_createResolutionLayer()
    local origin = CCDirector:sharedDirector():getVisibleOrigin();
    --背景颜色可以随自己喜欢来修改，预设是半透明的绿色
    local width = CONFIG.WIN_SIZE.width;
    local height = CONFIG.WIN_SIZE.height;
    local resolutionLayer = CCLayerColor:create(ccc4(0, 255, 0, 128), width, height);
    resolutionLayer:setScale(1 / CONFIG.SCREEN_FACTOR);
    resolutionLayer:setAnchorPoint(0, 0);
    resolutionLayer:setPosition(ccp(origin.x, origin.y));
    return resolutionLayer;
end


return ReviewLayer
